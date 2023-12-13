# Nexus3
## 概述
&emsp;&emsp;使用本 Chart 可以快速将 Nexus3[[链接](https://www.sonatype.com/products/sonatype-nexus-repository)]部署到 Kubernetes 集群中。

&emsp;&emsp;Nexus3 是一个功能强大的包管理工具，支持托管 Maven、Docker 镜像、Yum 包、Npm 包等等。一般情况下不会在同一个命名空间下部署多套服务。因此在制作本 Chart 包时，不支持在同一个命名空间里部署多个 Nexus3 实例。

## 组件依赖
&emsp;&emsp;本系统不依赖外部组件。

## 部署
### 创建配置文件
&emsp;&emsp;创建配置文件 `nexus3.yaml`，将 `values.yaml` 中的内容复制到该文件中。删除其余无用的配置，保留需要修改的内容，如下：

```yaml
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
```

> &emsp;&emsp;Nexus3 在创建 Docker 镜像仓库的时候，会额外监听端口。因此上面的配置是将这个 Nexus3 额外监听的端口暴露到 Ingress 中，这样外部 Nginx 在转发时，可以将对应的流量转发到 Docker 镜像仓库地址。

### 部署应用
&emsp;&emsp;使用 helm 执行以下命令，完成部署：

```bash
# 使用 nexus3.yaml 指定的参数部署
$ helm install <release-name> . -f nexus3.yaml
```

## 使用
&emsp;&emsp;Chart 包在完成部署操作后，会创建一个监听域名 `nexus3.<namespace>.cluster.k8s` 的 Ingress 资源，该 Ingress 会将所有请求转发到 Nexus3 的主页。运维人员需要自行在外部通过 Nginx 等方式将请求转发到集群内部。
