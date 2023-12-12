# Redis
## 概述
&emsp;&emsp;本 Helm Chart 主要用于在集群里部署 Redis 数据库。同时，为了方便运维，本 Chart 还包含了 RedisInsight。

&emsp;&emsp;本部署包不支持 Redis 集群、高可用、哨兵模式。同时需要注意，将 Redis 部署在 Kubernetes 集群中作为生产用途时，需要注意存储是否支持高性能 IO，否则数据库极容易变成应用的性能瓶颈。

## 修改配置
&emsp;&emsp;大部份配置的说明已经在 `values.yaml` 里有说明了。

## 部署
&emsp;&emsp;使用 helm 执行以下命令，完成部署：

```bash
$ helm install <release-name> .
```

&emsp;&emsp;部署完毕后，内部的业务系统就可以通过 `<release-name>:6379` 连接到 MySql 实例了。

&emsp;&emsp;同时，如果你还启用了 Insight 的话，那么还会创建一个监听域名 `<release-name>.<namespace>.cluster.k8s` 的 Ingress 资源。

&emsp;&emsp;本 Chart 支持在同一命令空间下部署多个实例。

```bash
# 部署第一个 Redis 实例，内部服务可以通过 redis1:6379 访问这个实例
$ helm install redis1 .

# 部署第二个 Redis 实例，内部服务可以通过 redis2:6379 访问这个实例
$ helm install redis2 .
```