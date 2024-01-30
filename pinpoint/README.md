# Pinpoint
## 概述
&emsp;&emsp;本 Helm Chart 主要用于在集群里部署 Pinpoint。Pinpoint 是一个使用 Java 编写的应用性能管理（Application Performance Management，APM）工具，用于在大规模分布式系统中收集、监控应用运行情况。

&emsp;&emsp;一般情况下，一个命名空间一般只需要一个性能监控系统，因此在制作本 Chart 包时，不支持在同一个命名空间里部署多个 Pinpoint 实例。

## 容器部署规范
&emsp;&emsp;本部署包遵循以下部署规范：

- 分散部署：当应用支持 `HPA` 时，多个实例会尽量分散部署到不同的节点上，以保证应用的可用性。
- 隔离部署：应用只调度与对应命名空间的节点（`node.kubernetes.io/namespace=<namespace>`）上，保证各环境（生产环境、预发布环境等）节点隔离。
- 支持探针：支持启动探针（`startupProbe`）与存活探针（`livenessProbe`），保证应用一直处于可用状态。
- 支持维护状态：当维护状态（`maintenance`）属性值为 true 时，即进入维护状态。当进入维护状态时，`HPA` 将会失效，所有的 `Deployment` 和 `StatefulSet` 的 `replicas` 将被设置 0。

## 组件依赖
&emsp;&emsp;本系统不依赖外部组件。为了保证应用方便部署，本 Chart 包内部已内置了 MySql、HBase、ZooKeeper 等组件，如果不希望使用内置的组件，可以自行改造本 Chart 包。

## 部署
### 创建配置文件
&emsp;&emsp;创建配置文件 `pinpoint.yaml`，将 `values.yaml` 中的内容复制到该文件中。删除其余无用的配置，保留需要修改的内容，如下：

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
```

> 以上内容只列出了部分配置，具体配置请参考 `values.yaml` 文件。

### 部署应用
&emsp;&emsp;使用 helm 执行以下命令，完成部署：

```bash
# 使用 pinpoint.yaml 指定的参数部署
$ helm install <release-name> oci://registry-1.docker.io/centralx/helm-mysql -f pinpoint.yaml
```

## 使用
### 访问 Pinpoint Web
&emsp;&emsp;Chart 包在完成部署操作后，会创建一个监听域名 `pinpoint.<namespace>.cluster.k8s` 的 Ingress 资源，该 Ingress 会将相关请求转发到 Pinpoint Web 应用。运维人员需要自行在外部通过 Nginx 等方式将请求转发到集群内部，如：

```yaml
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
        proxy_set_header   Host                pinpoint.<namespace>.cluster.k8s;
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

### 应用监听
&emsp;&emsp;在部署 Pod 时，需要使用 Pinpoint 提供的相关 agent 监控应用，如下：

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: spring-application
spec:
  initContainers:
    - name: install-pinpoint-agent
      image: "centralx/install-pinpoint-java-agent:<version>"
      imagePullPolicy: Always
      volumeMounts:
        - mountPath: plugin-volume
          name: /opt/java/agents
  containers:
    - name: application
      image: "application:latest"
      imagePullPolicy: Always
      command:
        - "java"
        - "-jar"
      args:
        - "-javaagent:./plugins/pinpoint/pinpoint-bootstrap.jar"
        - "-Dpinpoint.agentName=$(POD_NAME)"
        - "-Dpinpoint.applicationName=$(APPLICATION_NAME)"
        - "-Dpinpoint.profiler.profiles.active=release"
        - "-Dprofiler.transport.grpc.collector.ip=pinpoint-collector"
        - "-Dprofiler.collector.ip=pinpoint-collector"
      env:
      - name: POD_NAME
        valueFrom:
          fieldRef:
            fieldPath: metadata.name
      - name: APPLICATION_NAME
        valueFrom:
          fieldRef:
            fieldPath: metadata.labels['app.kubernetes.io/name']
      volumeMounts:
        - name: plugin-volume
          mountPath: /workspace/plugins
  volumes:
    - name: plugin-volume
      emptyDir: {}
```

> 以上用到了 `centralx/install-pinpoint-java-agent` 镜像，请参考该镜像说明[[链接](https://hub.docker.com/r/centralx/install-pinpoint-java-agent)]。