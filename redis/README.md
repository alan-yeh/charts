# Redis
## 概述
&emsp;&emsp;使用本 Chart 可以快速将 Redis[[链接](https://redis.io)]部署到 Kubernetes 集群中。为了方便运维，本 Chart 还包含了 RedisInsight。

&emsp;&emsp;本 Chart 支持在同一个命名空间里部署多个 Redis 实例。但是本部署包不支持 Redis 集群、高可用、哨兵模式。同时需要注意，将 Redis 部署在 Kubernetes 集群中作为生产用途时，需要注意存储是否支持高性能 IO，否则数据库极容易变成应用的性能瓶颈。

## 组件依赖
&emsp;&emsp;本系统不依赖外部组件。

## 部署
### 创建配置文件
&emsp;&emsp;创建配置文件 `redis.yaml`，将 `values.yaml` 中的内容复制到该文件中。删除其余无用的配置，保留需要修改的内容，如下：

```yaml
redis:
  resources:
    limits:
      cpu: 2000m
      memory: 5Gi
  # 修改 redis.conf
  # https://raw.githubusercontent.com/redis/redis/7.0/redis.conf
  conf:
    redis.conf: |
      maxmemory 4096mb
      maxmemory-policy allkeys-lru
      requirepass <redis-password>
```

### 部署应用
&emsp;&emsp;使用 helm 执行以下命令，完成部署：

```bash
# 使用 redis.yaml 指定的参数部署
$ helm install <release-name> . -f redis.yaml
```

## 使用
### 访问数据库
&emsp;&emsp;部署完毕后，内部的业务系统就可以通过 `<release-name>:6379` 连接到 Redis 实例了。

### 运维数据库
&emsp;&emsp;如果启用了 Insight 的话，Chart 包会创建一个监听域名 `<release-name>.<namespace>.cluster.k8s` 的 Ingress 资源。运维人员需要自行在外部通过 Nginx 等方式将请求转发到集群内部，如：

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
        proxy_set_header   Host                <release-name>.<namespace>.cluster.k8s;
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
