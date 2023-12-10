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