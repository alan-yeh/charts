# MySql
## 概述
&emsp;&emsp;本 Helm Chart 主要用于在集群里部署 MySql 数据库。同时，为了方便运维，本 Chart 还包含了网页版 CloudBeaver，可以直接在浏览器上运维 MySql 数据库。

&emsp;&emsp;本部署包支持在同一命名空间里部署多个 MySql 实例。本部署包不支持 MySql 集群、高可用。同时需要注意，将 MySql 部署在 Kubernetes 集群中作为生产用途时，需要注意存储是否支持高性能 IO，否则数据库极容易变成应用的性能瓶颈。

## 容器部署规范
&emsp;&emsp;本部署包遵循以下部署规范：

- 分散部署：当应用支持 `HPA` 时，多个实例会尽量分散部署到不同的节点上，以保证应用的可用性。
- 隔离部署：应用只调度与对应命名空间的节点（`node.kubernetes.io/namespace=<namespace>`）上，保证各环境（生产环境、预发布环境等）节点隔离。
- 支持探针：支持启动探针（`startupProbe`）与存活探针（`livenessProbe`），保证应用一直处于可用状态。
- 支持维护状态：当维护状态（`maintenance`）属性值为 true 时，即进入维护状态。当进入维护状态时，`HPA` 将会失效，所有的 `Deployment` 和 `StatefulSet` 的 `replicas` 将被设置 0。

## 组件依赖
&emsp;&emsp;本系统不依赖外部组件。

## 部署
### 创建配置文件
&emsp;&emsp;创建配置文件 `mysql.yaml`，将 `values.yaml` 中的内容复制到该文件中。删除其余无用的配置，保留需要修改的内容，如下：

```yaml
####################################################################
# 全局配置
####################################################################
# 维护状态
# 当进入维护状态时，hpa 将会失效，所有的 Deployment 和 StatefulSet 的 replicas 将被设置 0
maintenance: false

# 存储配置
pvc:
  storageClassName: permanent
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 100Gi

####################################################################
# MySql 配置
####################################################################
mysql:
  # 应用资源限制
  resources:
    limits:
      cpu: 1000m
      memory: 2Gi
# MySql 配置
config:
  # root 用户的密码
  password: <root-password>
```

### 部署应用
&emsp;&emsp;使用 helm 执行以下命令，完成部署：

```bash
# 使用 mysql.yaml 指定的参数部署
$ helm install <release-name> oci://registry-1.docker.io/centralx/helm-mysql -f mysql.yaml
```

## 使用
### 访问数据库
&emsp;&emsp;部署完毕后，内部的业务系统就可以通过 `<release-name>:3306` 连接到 MySql 实例，如以下 Spring 的配置：

```yaml
spring:
  datasource:
    name: master
    driver-class-name: com.mysql.cj.jdbc.Driver
    url: jdbc:mysql://<release-name>:3306/centralx?useUnicode=true&characterEncoding=utf8&useSSL=false&allowPublicKeyRetrieval=true
    username: root
    password: <root-password>
```

### 运维数据库
&emsp;&emsp;如果启用了 cloudbeaver 的话，Chart 包会创建一个监听域名 `<release-name>.<namespace>.cluster.k8s` 的 Ingress 资源。运维人员需要自行在外部通过 Nginx 等方式将请求转发到集群内部，如：

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
        proxy_set_header   Host                <release-name>.<namespace>.cluster.k8s;
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