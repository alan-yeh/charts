# Kubernetes Egress
## 概述
&emsp;&emsp;在生产环境中，为了保证应用在一个安全的环境下运行，减少数据泄露、服务器被攻击的风险，通常会通过网络策略将生产服务器集群与外部服务器进行网络隔离，只开放指定的服务器与外部服务器进行通讯。网络拓扑图如下：

![](./assets/topology.svg)

&emsp;&emsp;在上面这种网络拓扑结构下，我们可以通过将 Pod 调度到 `Node 5` 节点下，就可以让需要与外部通信通信的服务正常工作了。但是这样设计的话，所有需要和外部通信的服务都得要部署到这个节点上了，极容易造成资源不平衡。

&emsp;&emsp;为了解决这个问题，可以在 `Node 5` 这个节点上部署一个 Nginx 进行外部服务的反向代理，这样内部的服务就可以不用集中调度到 `Node 5` 下了。

&emsp;&emsp;基于以上理论，为了方便将外部业务系统快速封装成内部服务（Service），因此封装了 Egress。Egress 可以根据用户配置的路由信息，自动生成对应代理信息和 Kubernetes Service，后续集群内部的服务就可以通过 `http://<service-name>` 的方式访问外部网络。

## 使用

- **为出口节点添加标签**

&emsp;&emsp;由于只有指定点节才可以与外部业务系统通信，因此需要为这个节点添加标签，然后 Egress 通过节点选择器固定到这个节点上。推荐为这个节点添加 `cluster.k8s/egress: enabled` 标签：

```bash
# 为 node5.cluster.k8s 节点添加标签
$ kubectl label node node5.cluster.k8s cluster.k8s/egress=enabled
node/node5.cluster.k8s labed
```

- **修改配置文件**

&emsp;&emsp;修改 Egress 的 `values.yaml` 配置文件，修改 `routers` 节点，添加代理配置：

```yaml
# 代理路由
routers:
  - name: dashboard               # 服务名（必填）
    scheme: https                 # 以指定协议访问服务（必填）
    host: dashboard.cluster.k8s   # 以指定的 Host 名访问服务（选填）
    targets:                      # 服务地址列表（必填）
      - 10.10.20.21:443           # 服务的真实 IP 地址、端口。如果有多个，将会自动做负载均衡
      - 10.10.20.21:443
    options:                      # 代理选项
      connectTimeout: 60          # 连接超时时间，不填时默认 10s
      sendTimeout: 60             # 发送数据超时时间，不填时默认 10s
      readTimeout: 60             # 读取数据超时时间，不填时默认 10s
      clientMaxBodySize: 1024m    # 最大请求体大小，不填时默认 16m
  - name: nexus
    scheme: http
    host: mirror.cluster.k8s
    targets:
      - 10.10.20.0
```

- **部署 Charts**

&emsp;&emsp;修改 helm 部署

```bash
$ helm install egress .
```

- **调用外部服务**

&emsp;&emsp;Egress 会根据上面的路由配置中的 `routers.name` 生成 Kubernetes Service，因此现在就可以在集群内部通过 `http://dashboard` 或 `http://nexus` 的方式调用外部系统的接口了。