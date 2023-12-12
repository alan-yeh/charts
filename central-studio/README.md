# Central Studio
## 概述
&emsp;&emsp;使用本 Chart 可以快速将 Central Studio 部署到 Kubernetes 集群中。

## 修改配置
&emsp;&emsp;大部份配置的说明已经在 `values.yaml` 里有说明了。

## 部署
&emsp;&emsp;使用 helm 执行以下命令，完成部署：

```bash
$ helm install <release-name> .
```

&emsp;&emsp;部署后，Central Studio 会创建一个监听域名 `studio.<namespace>.cluster.k8s` 的 Ingress 资源，该 Ingress 会将所有请求转发到网关。