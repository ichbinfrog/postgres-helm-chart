# Vulnerability assessment tool database

The vulnerability assessment tool database is a postgresql database used to store a CVEs, constructs, ...

## Prerequisites

-   Kubernetes 1.9 with Beta APIs enabled
-   Persistent volume provisionner support in underlying infrastructure

## Introduction

This chart bootstraps a HA [Postgresql](https://www.postgresql.org/) cluster deployment on a Kubernetes cluster comprising of a:
-   Postgres master statefulset
-   Postgres slave statefulset
-   Pgpool statefulset

## Installing the chart

To install the chart with the release name `release`:

```console
$ helm install my-release .
```

The command deploys the database subchart of the vulnerability-assessment-tool-core chart v0.1.1 chart
on the Kubernetes cluster in the default configuration. The configuration section lists
the parameters that can be configured during installation.

## Uninstalling the chart

To uninstall/delete the `release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration
Initialisation scripts can be add in the `files/` folder and must be executable inside a shell since it's encapsulated in one.
The following table lists the configurable parameters of the database chart and their default values.
As values in this chart are quite highly nested, this table is split into two parts for easy readability

### .Values.postgres

| Parameter | Description | Default |
| --- | --- | --- |
| metrics.enabled | Enables prometheus exporter | `true` |
| debug | Postgres logging level (see [postgres docs](https://www.postgresql.org/docs/11/runtime-config-logging.html) | `WARNING` |
| image.initContainer.pullPolicy | To avoid cluster going out of sync `Always` is recommended if the image is subject to constant changes | `IfNotPresent` |
| image.initContainer.name | Postgresql init container image name (used for pg_basebackup) | `postgres` |
| image.initContainer.tag | Image tag for desired initcontainer image version | `11.5-alpine` |
| image.initContainer.securityContext | Postgresql init container securityContext. This container requires root execution because it needs to fix permissions on the PVC (using chown on the set `pgdata` directory) | runAsUser: `0`<br>privileged: `true` |
| image.mainContainer.pullPolicy | As Postgres images are stable, `IfNotPresent` is the recommended pullPolicy in this case | `IfNotPresent` |
| image.mainContainer.name | Postgres main container (actual database) image name | `postgres` |
| image.mainContainer.tag | The vulnerability database functions with any postgres 11.x version (with version 12.x to be tested soon) | `11.5` |
| image.mainContainer.securityContext | Postgresql's default container UID is 999 and requires reading to the root file system to properly operate | runAsUser: `999`<br>runAsGroup: `999`<br>privileged:`False`<br>readOnlyRootFilesystem:`False` |
| image.exporterContainer.pullPolicy | Since this image is maintained by a small group of individuals, image drift is possible, `Always` is recommended in production | `IfNotPresent` |
| image.exporterContainer.name | See [source code](https://github.com/wrouesnel/postgres_exporter) | `wrouesnel/postgres_exporter` |
| image.exporterContainer.tag | Latest image tag as of this chart release | `v0.5.1` |
| master.updateStrategy |  | `RollingUpdate` |
| master.terminationGracePeriodSeconds | Sets the amount of time k8s allows for the database to gracefully shutdown, this window allows for Postgresql to launch `pg_ctl stop fast` | `10` |
| master.livenessProbe.enabled | readinessProbe configuration to be tuned to latency and performance of the cluster at hand | enabled: `true`<br>initialDelaySeconds: `60`<br>periodSeconds: `5`<br>timeoutSeconds: `3`<br>failureThreshold: `20` |
| master.readinessProbe.enabled | readinessProbe configuration to be tuned to latency and performance of the cluster at hand | enabled: `true`<br>initialDelaySeconds: `5`<br>periodSeconds: `5`<br>timeoutSeconds: `3`<br>failureThreshold: `3` |
| master.pvcMountPath | Set with $PG_DATA | `/var/lib/postgresql/data` |
| master.accessModes | PVC accessMode, if you want fault tolerance for the master statefulset, it is a possibility to set an nfs with `ReadWriteMany` in addition with failover | `ReadWriteOnce` |
| master.requests.storage | Storage size requests, 10Gi is the minimum requirement | `10Gi` |
| slave.backoffDuration | delay between probe attempts to wait for master node | `10` |
| slave.updateStrategy |  | `RollingUpdate` |
| slave.terminationGracePeriodSeconds | Sets the amount of time k8s allows for the database to gracefully shutdown, this window allows for Postgresql to launch `pg_ctl stop fast | `10` |  |
| slave.livenessProbe.enabled | readinessProbe configuration to be tuned to latency and performance of the cluster at hand | enabled: `true`<br>initialDelaySeconds: `60`<br>periodSeconds: `5`<br>timeoutSeconds: `3`<br>failureThreshold: `20` |
| slave.readinessProbe.enabled | readinessProbe configuration to be tuned to latency and performance of the cluster at hand | enabled: `true`<br>initialDelaySeconds: `50`<br>periodSeconds: `5`<br>timeoutSeconds: `3`<br>failureThreshold: `3` |
| slave.pvcMountPath | Set with $PG_DATA | `/var/lib/postgresql/data` |
| slave.accessModes | `ReadWriteOnce` is recommended here for the low cost and the fact that fault tolerance comes from the replication | `ReadWriteOnce` |
| slave.requests.storage | recommended to be ~= Master storage requests due to streaming replication | `10Gi` |

**Note**: The postgresql init script can be customized [here](templates/postgres/mountedConfigMap/yaml)

### .Values.pgpool

| Parameter | Description | Default |
| --- | --- | --- |
| name | Used to determine prefix for pgpool objects in kubernetes | `pgpool` |
| debug | Sets pgpool log level to DEBUG if `true` (see [pgpool docs](https://www.pgpool.net/docs/latest/en/html/runtime-config-logging.html)) | `False` |
| replicas | The optimal number of instances should be around `master replicas + slave replicas` (see [benchmark](../../docs/BenchmarkResults.md)) | `3` |
| updateStrategy |  | `RollingUpdate` |
| loadBalanceMode | Used to set distributing select queries per node. See [pgpool lb docs](https://www.pgpool.net/docs/latest/en/html/runtime-config-load-balancing.html) | `true` |
| failOverOnBackendError |  | `False` |
| numInitChildren | Number of processes that pgpool preforks. This parameter can only be modified on launch so its recommended to anticipate for high usage | `100` |
| maxPool | Maximum number of cached open connection pgpool has to the PostgreSQL instance | `10` |
| clientIdleLimit | Kills inactif client after `clientIdleLimit` seconds | `920` |
| connectionLifeTime | Sets the lifespan of a cached connection in seconds. This is set to avoid the default `0` which never kills/renews connections | `500` |
| terminationGracePeriodSeconds | Allows for pgpool to gracefully terminate its connections | `15` |
| useWatchDog | Sets the `use_watchdog` configuration (see [pgpool watchdog docs](https://www.pgpool.net/docs/latest/en/html/example-cluster.html)) | `true` |
| watchDog.interval |  | `15` |
| healthCheck | Postgresql connection health checks. The default timeout value makes sure that during initialisation, the pgpool statefulset doesn't go into a CrashLoop | timeout: `0`<br>period: `30`<br>maxRetries: `5`<br>retryDelay: `5` |
| image.pullPolicy | Image maintained by company so drift shouldn't be an issue | `IfNotPresent` |
| image.name |  | `crunchydata/crunchy-pgpool` |
| image.tag |  | `centos7-11.4-2.4.1` |
| image.securityContext | Shares the postgres UID | runAsUser: `999`<br>runAsGroup: `999`<br>privileged: `False`<br>readOnlyRootFilesystem: `False` |
| image.readinessProbe |  | enabled: `true`<br>initialDelaySeconds: `35`<br>periodSeconds: `10`<br>timeoutSeconds: `10`<br>failureThreshold: `3` |
| image.livenessProbe |  | enabled: `true`<br>initialDelaySeconds: `35`<br>periodSeconds: `30`<br>timeoutSeconds: `10`<br>failureThreshold: `3` |

Specify each parameter using the --set key=value\[,key=value\] argument to helm install. For example,

```sh
$ helm install --name my-release \
  --set postgres.image.mainContainer.pullPolicy=Always .
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```sh
$ helm install --name my-release -f values.yaml .
```

## Production configuration

This chart includes a `values_production.yaml` file where you can find some parameters oriented to production configuration in comparison to the regular `values.yaml`.

```sh
$ helm install --name my-release -f values_adv.yaml .
```

These values can be configured as follows:

| Parameter | Description | Default |
| --- | --- | --- |
| postgres.master.resources | Corner stone of infrastructure so high performance is required | requests:<br>&emsp;memory:`15Gi`<br>&emsp;cpu: `15`<br>limit:<br>&emsp;memory: `22Gi`<br>&emsp;cpu: `22` |
| postgres.slave.resources | As these are replicas their demands are lower than that of the master db | requests:<br>&emsp;memory:`8Gi`<br>&emsp;cpu: `8`<br>limit:<br>&emsp;memory: `15Gi`<br>&emsp;cpu: `15` |
| pgpool.image.resources | Pgpool does not consume a whole lot of resources | requests:<br>&emsp;memory:`1Gi`<br>&emsp;cpu: `1000m`<br>limit:<br>&emsp;memory: `2Gi`<br>&emsp;cpu: `2000m` |
| postgres.masterAntiAffinity | Makes pods (from master statefulset and slave) avoid sharing nodes with master. If set to `{}` disables this option | soft: `true`<br>weight: `100` |
| postgres.slaveAntiAffinity | Makes pods (from master statefulset and slave) avoid sharing nodes with slave. If set to `{}` disables this option | soft: `true`<br>weight: `50` |

-   Disabling metrics:

```diff
- postgres.metrics.enabled: False
+ postgres.metrics.enabled: true
```

-   Disabling probres:

```diff
- postgres.master.livenessProbe.enabled: true
- postgres.master.readinessProbe.enabled: true
+ postgres.master.livenessProbe.enabled: False
+ postgres.master.readinessProbe.enabled: False
```
