# Clash
## 概述
&emsp;&emsp;使用本 Chart 可以快速将 Clash[[链接](https://hub.docker.com/r/centralx/clash)]部署到 Kubernetes 集群中。

## 部署
### 创建配置文件
&emsp;&emsp;修改 `resources` 目录下的配置文件 `config.yaml`，内容如下：

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
$ helm install <release-name> .
```

## 使用
&emsp;&emsp;Chart 包在完成部署操作后，会创建一个监听域名 `clash.<namespace>.cluster.k8s` 的 Ingress 资源，该 Ingress 会将请求转发到 Clash Dashboard。运维人员需要自行在外部通过 Nginx 等方式将请求转发到集群内部。