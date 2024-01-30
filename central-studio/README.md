# Central Studio
## 概述
&emsp;&emsp;使用本 Chart 可以快速将 Central Studio[[链接](https://central-x.com/studio/)]部署到 Kubernetes 集群中。

&emsp;&emsp;由于 Central Studio 内部有多个微服务组件，为了简化部署，在初始启动时会自动初始化很多内置的参数，包括通信服务名等等。这些内置参数没办法动态获取服务名，因此没办法在单个命名空间下部署多套 Central Studio。

## 容器部署规范
&emsp;&emsp;本部署包遵循以下部署规范：

- 分散部署：当应用支持 `HPA` 时，多个实例会尽量分散部署到不同的节点上，以保证应用的可用性。
- 隔离部署：应用只调度与对应命名空间的节点（`node.kubernetes.io/namespace=<namespace>`）上，保证各环境（生产环境、预发布环境等）节点隔离。
- 支持探针：支持启动探针（`startupProbe`）与存活探针（`livenessProbe`），保证应用一直处于可用状态。
- 支持维护状态：当维护状态（`maintenance`）属性值为 true 时，即进入维护状态。当进入维护状态时，`HPA` 将会失效，所有的 `Deployment` 和 `StatefulSet` 的 `replicas` 将被设置 0。

## 组件依赖
### 数据库
&emsp;&emsp;Central Studio 依赖数据库组件，因此需要提前在 Kubernetes 集群中或在外部独立部署数据库。

&emsp;&emsp;如果想要快速部署测试环境，可以使用 Helm 在 Kubernetes 快速搭建个 MySql 数据库[[链接](https://hub.docker.com/r/centralx/helm-mysql)]。

## 部署
### 创建配置文件
&emsp;&emsp;创建配置文件 `central-studio.yaml`，将 `values.yaml` 中的内容复制到该文件中。删除其余无用的配置，保留需要修改的内容，如下：

```yaml
##################################################################
# 全局配置
##################################################################
global:
  # 维护状态
  # 当进入维护状态时，hpa 将会失效，所有的 Deployment 和 StatefulSet 的 replicas 将被设置 0
  maintenance: false
  # 通用配置文件，里面的内容会挂载到 /application/config 目录下
  # 不要将不通用的配置写到这里
  config:
    application.yaml: |
      logging:
        config: classpath:logback-http.xml
      spring:
        datasource:
          name: master
          driver-class-name: com.mysql.cj.jdbc.Driver
          url: jdbc:mysql://mysql:3306/centralx?useUnicode=true&characterEncoding=utf8&useSSL=false&allowPublicKeyRetrieval=true
          username: root
          password: <password>
```

> 以上内容只列出了部分配置，具体配置请参考 `values.yaml` 文件。

### 部署应用
&emsp;&emsp;使用 helm 执行以下命令，完成部署：

```bash
# 使用 central-studio.yaml 指定的参数部署
$ helm install <release-name> oci://registry-1.docker.io/centralx/central-studio -f central-studio.yaml
```

## 使用
&emsp;&emsp;Chart 包在完成部署操作后，会创建一个监听域名 `studio.<namespace>.cluster.k8s` 的 Ingress 资源，该 Ingress 会将所有请求转发到网关。运维人员需要自行在外部通过 Nginx 等方式将请求转发到集群内部，如：

```nginx
# 集群 Ingress 流量入口
upstream ingress {
    server ingress1.cluster.k8s;
    server ingress2.cluster.k8s;
}

# 端口监听
server {
    listen 8001;

    location / {
        proxy_pass             http://ingress;
        proxy_redirect         default;
        client_max_body_size   1000m;

        # 传递代理信息
        proxy_set_header   Host                studio.<namespace>.cluster.k8s;
        proxy_set_header   X-Real-IP           $remote_addr;                 # 用户真实 IP
        proxy_set_header   X-Forwarded-Host    $http_host;                   # 用户访问服务器的真实域名
        proxy_set_header   X-Forwarded-Port    $server_port;                 # 用户访问服务器的真实端口
        proxy_set_header   X-Forwarded-Proto   $scheme;                      # 用户访问服务器的真实协议
        proxy_set_header   X-Forwarded-For     $proxy_add_x_forwarded_for;   # 反向代理路径

        # WebSocket 支持
        proxy_http_version      1.1;
        proxy_set_header        Upgrade      $http_upgrade;
        proxy_set_header        Connection   'upgrade';
        proxy_connect_timeout   60s;
        proxy_read_timeout      60s;
        proxy_send_timeout      60s;
    }
}
```
