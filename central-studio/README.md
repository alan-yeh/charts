# Central Studio
## 概述
&emsp;&emsp;使用本 Chart 可以快速将 Central Studio[[链接](https://central-x.com/studio/)]部署到 Kubernetes 集群中。

&emsp;&emsp;由于 Central Studio 内部有多个微服务组件，为了简化部署，在初始启动时会自动初始化很多内置的参数，包括通信服务名等等。这些内置参数没办法动态获取服务名，因此没办法在单个命名空间下部署多套 Central Studio。

## 组件依赖
### 数据库
&emsp;&emsp;Central Studio 依赖数据库组件，因此需要提前在 Kubernetes 集群中或在外部独立部署数据库。

&emsp;&emsp;如果想要快速部署测试环境，可以使用 Helm 在 Kubernetes 快速搭建个 MySql 数据库[[链接](../mysql)]。

## 部署
### 创建配置文件
&emsp;&emsp;创建配置文件 `central-studio.yaml`，将 `values.yaml` 中的内容复制到该文件中。删除其余无用的配置，保留需要修改的内容，如下：

```yaml
global:
  # 资源限制
  resources:
    # 镜像资源限制
    limits:
      cpu: 500m
      memory: 512Mi
  # Jvm 资源限制
  jvm:
    xms: 256m
    xmx: 256m
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
          password: databasepwd
```

### 部署应用
&emsp;&emsp;使用 helm 执行以下命令，完成部署：

```bash
# 使用 central-studio.yaml 指定的参数部署
$ helm install <release-name> . -f central-studio.yaml
```

## 使用
&emsp;&emsp;Chart 包在完成部署操作后，会创建一个监听域名 `studio.<namespace>.cluster.k8s` 的 Ingress 资源，该 Ingress 会将所有请求转发到网关。运维人员需要自行在外部通过 Nginx 等方式将请求转发到集群内部。