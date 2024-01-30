# Nexus3
## 概述
&emsp;&emsp;使用本 Chart 可以快速将 Nexus3[[链接](https://www.sonatype.com/products/sonatype-nexus-repository)]部署到 Kubernetes 集群中。

&emsp;&emsp;Nexus3 是一个功能强大的包管理工具，支持托管 Maven、Docker 镜像、Yum 包、Npm 包等等。一般情况下不会在同一个命名空间下部署多套服务。因此在制作本 Chart 包时，不支持在同一个命名空间里部署多个 Nexus3 实例。

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
&emsp;&emsp;创建配置文件 `nexus3.yaml`，将 `values.yaml` 中的内容复制到该文件中。删除其余无用的配置，保留需要修改的内容，如下：

```yaml
# 维护状态
# 当进入维护状态时，hpa 将会失效，所有的 Deployment 和 StatefulSet 的 replicas 将被设置 0
maintenance: false

# 应用资源限制
resources:
  limits:
    cpu: 4000m
  requests:
    cpu: 1000m
    
# 网络配置
service:
  # 暴露其它端口
  ports:
    # 示例，暴露 Docker 镜像仓库端口
    - name: docker-port
      port: 5000

# 流量入口
ingress:
  enabled: true
  annotations: {}
  className: "nginx"
  # 部署后，如果未指定 host，则默认监听 nexus3.<namespace>.cluster.k8s
  # nexus3.<namespace>.cluster.k8s 域名的流量将会转发到 nexus3 的首面
  host:
  # 示例，监听 Docker 镜像仓库端口
  rules:
    - host: docker.pre.cluster.k8s
      paths:
        - path: /v2
          target: docker-port

# 存储配置
pvc:
  storageClassName: permanent
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 100Gi
```

> &emsp;&emsp;Nexus3 在创建 Docker 镜像仓库的时候，会额外监听端口。因此上面的配置是将这个 Nexus3 额外监听的端口暴露到 Ingress 中，这样外部 Nginx 在转发时，可以将对应的流量转发到 Docker 镜像仓库地址。

### 部署应用
&emsp;&emsp;使用 helm 执行以下命令，完成部署：

```bash
# 使用 nexus3.yaml 指定的参数部署
$ helm install <release-name> oci://registry-1.docker.io/centralx/helm-nexus3 -f nexus3.yaml
```

## 使用
&emsp;&emsp;Chart 包在完成部署操作后，会创建一个监听域名 `nexus3.<namespace>.cluster.k8s` 的 Ingress 资源，该 Ingress 会将所有请求转发到 Nexus3 的主页。运维人员需要自行在外部通过 Nginx 等方式将请求转发到集群内部，如：

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
        proxy_set_header   Host                nexus3.<namespace>.cluster.k8s;
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
