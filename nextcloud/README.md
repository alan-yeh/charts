# NextCloud
## 概述
&emsp;&emsp;使用本 Chart 可以快速将 Nextcloud[[链接](https://nextcloud.com)]部署到 Kubernetes 集群中。

&emsp;&emsp;NextCloud 是一个功能强大的文件共享服务器。一般情况下不会在同一个命名空间下部署多套服务。因此在制作本 Chart 包时，不支持在同一个命名空间里部署多个 Nextcloud 实例。

## 容器部署规范
&emsp;&emsp;本部署包遵循以下部署规范：

- 分散部署：当应用支持 `HPA` 时，多个实例会尽量分散部署到不同的节点上，以保证应用的可用性。
- 隔离部署：应用只调度与对应命名空间的节点（`node.kubernetes.io/namespace=<namespace>`）上，保证各环境（生产环境、预发布环境等）节点隔离。
- 支持探针：支持启动探针（`startupProbe`）与存活探针（`livenessProbe`），保证应用一直处于可用状态。
- 支持维护状态：当维护状态（`maintenance`）属性值为 true 时，即进入维护状态。当进入维护状态时，`HPA` 将会失效，所有的 `Deployment` 和 `StatefulSet` 的 `replicas` 将被设置 0。

## 组件依赖
### 数据库
&emsp;&emsp;Nextcloud 内置了一个 MySql 数据库，你也可以选择使用外置数据库。选择外置数据库时，需要提前在 Kubernetes 集群中或在外部独立部署数据库。

&emsp;&emsp;如果想要快速部署测试环境，可以使用 Helm 在 Kubernetes 快速搭建个 MySql 数据库[[链接](https://hub.docker.com/r/centralx/helm-mysql)]。

### Redis
&emsp;&emsp;Nextcloud 支持使用 Redis 作为缓存数据库，提升应用访问性能。

&emsp;&emsp;如果想要快速部署测试环境，可以使用 Helm 在 Kubernetes 快速搭建个 Redis 数据库[[链接](https://hub.docker.com/r/centralx/helm-redis)]。

## 部署
### 创建配置文件
&emsp;&emsp;创建配置文件 `nextcloud.yaml`，将 `values.yaml` 中的内容复制到该文件中。删除其余无用的配置，保留需要修改的内容，如下：

```yaml
# 应用配置
config:
  # MySql 配置
  mysql:
    host: mysql
    username: root
    password: <mysql-password>
    database: nextcloud
  # Redis 配置
  redis:
    host: redis
    port: 6379
    password: <redis-password>
  # 邮箱配置
  smtp:
    host: smtp.exmail.qq.com
    port: 465
    secure: ssl
    name: noreply@central-x.com
    password: <smtp-password>
    fromAddress: NextCloud
    domain: central-x.com
  # 内存配置
  php:
    memoryLimit: 4096M
    uploadLimit: 4096M
  # 代理配置
  proxy:
    trustedDomains:
      - nextcloud.central-x.com
      - nextcloud.prod.cluster.k8s
    trustedProxies:
      - 10.10.0.1/16
    overwrite:
      host: nextcloud.central-x.com
      protocol: https
```

### 部署应用
&emsp;&emsp;使用 helm 执行以下命令，完成部署：

```bash
# 使用 nextcloud.yaml 指定的参数部署
$ helm install <release-name> oci://registry-1.docker.io/centralx/helm-nextcloud -f nextcloud.yaml
```

## 使用
&emsp;&emsp;Chart 包在完成部署操作后，会创建一个监听域名 `nextcloud.<namespace>.cluster.k8s` 的 Ingress 资源，该 Ingress 会将所有请求转发到网关。运维人员需要自行在外部通过 Nginx 等方式将请求转发到集群内部，如：

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
        proxy_set_header   Host                nextcloud.<namespace>.cluster.k8s;
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