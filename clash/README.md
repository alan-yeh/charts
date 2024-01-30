# Clash
## 概述
&emsp;&emsp;使用本 Chart 可以快速将 Clash[[链接](https://hub.docker.com/r/centralx/clash)]部署到 Kubernetes 集群中。

&emsp;&emsp;Clash 是一个功能强大的网络规则代理工具。一般情况下不会在同一个命名空间下部署多套服务。因此在制作本 Chart 包时，不支持在同一个命名空间里部署多个 Clash 实例。

## 容器部署规范
&emsp;&emsp;本部署包遵循以下部署规范：

- 分散部署：当应用支持 `HPA` 时，多个实例会尽量分散部署到不同的节点上，以保证应用的可用性。
- 隔离部署：应用只调度与对应命名空间的节点（`node.kubernetes.io/namespace=<namespace>`）上，保证各环境（生产环境、预发布环境等）节点隔离。
- 支持探针：支持启动探针（`startupProbe`）与存活探针（`livenessProbe`），保证应用一直处于可用状态。
- 支持维护状态：当维护状态（`maintenance`）属性值为 true 时，即进入维护状态。当进入维护状态时，`HPA` 将会失效，所有的 `Deployment` 和 `StatefulSet` 的 `replicas` 将被设置 0。

## 组件依赖
&emsp;&emsp;本系统不依赖外部组件。

## 部署
### 下载部署包
&emsp;&emsp;由于需要修改规则文件 `config.yaml`，因此需要将 Chart 包下载到本地进行修改。

```bash
$ helm pull oci://registry-1.docker.io/centralx/helm-clash --version <version>
```

### 创建配置文件
&emsp;&emsp;解压 `helm-clash-<version>.tgz` 文件后，修改 `resources` 目录下的 `config.yaml` 配置文件，内容如下：

```yaml
mixed-port: 7890
allow-lan: true
bind-address: '*'
mode: rule
log-level: info
external-controller: '127.0.0.1:9090'
dns:
  enable: true
  # 其它配置
proxies:
  # 其它配置
proxy-groups:
  # 其它配置
rules:
  # 其它配置
```

### 部署应用
&emsp;&emsp;使用 helm 执行以下命令，完成部署：

```bash
$ helm install <release-name> ./helm-clash
```

## 使用
### 访问 Clash Dashboard
&emsp;&emsp;Chart 包在完成部署操作后，会创建一个监听域名 `clash.<namespace>.cluster.k8s` 的 Ingress 资源，该 Ingress 会将请求转发到 Clash Dashboard。运维人员需要自行在外部通过 Nginx 等方式将请求转发到集群内部，如：

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
        proxy_set_header   Host                clash.<namespace>.cluster.k8s;
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

### 使用代理
&emsp;&emsp;如果其它 Pod 需要使用 Clash 代理，可以使用 `env` 指定 `http_proxy`、`https_proxy`、`all_proxy` 环境变量，如：

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: ubuntu
spec:
  containers:
    - name: ubuntu
      image: ubuntu
      env:
        - name: http_proxy
          value: http://clash:7890
        - name: https_proxy
          value: http://clash:7890
        - name: all_proxy
          value: socks5://clash:7890
        - name: no_proxy
          value: 127.0.0.1,localhost
```

&emsp;&emsp;容器内的应用如果要使用代理，则由具体由应用配置决定，如 Gradle 配置代理的方式为修改 `gradle.properties` 文件，内容如下：

```yaml
systemProp.http.proxyHost=clash
systemProp.http.proxyPort=7890
systemProp.http.nonProxyHost=127.0.0.1,localhost

systemProp.https.proxyHost=clash
systemProp.https.proxyPort=7890
systemProp.https.nonProxyHost=127.0.0.1,localhost
```