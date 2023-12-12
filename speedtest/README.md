# SpeedTest
## 概述
&emsp;&emsp;本 Helm Chart 主要用于在集群里部署 SpeedTest，可以用于做网速质量测试。

## 修改配置
&emsp;&emsp;大部份配置的说明已经在 `values.yaml` 里有说明了。

## 部署
&emsp;&emsp;使用 helm 执行以下命令，完成部署：

```bash
$ helm install <release-name> .
```

&emsp;&emsp;注意，本 Chart 不支持在单个命名空间部署两个实例。