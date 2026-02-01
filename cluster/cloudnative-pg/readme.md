# Install the cnpg kubectl plugin

```bash
curl -sSfL \
  https://github.com/EnterpriseDB/kubectl-cnp/raw/main/install.sh | \
  sudo sh -s -- -b /usr/local/bin
```

# Adding the barman-cloud-plugin to a cnpg cluster

```yaml
  plugins:
      - name: barman-cloud.cloudnative-pg.io
        isWALArchiver: true
        parameters:
          barmanObjectName: cnpg-minio-store-appname
```

# Create a manual backup of a cloudnative-pg cluster.

```bash
kubectl cnpg backup \
appname-cnpg-cluster \
-n app \
--method=plugin \
--plugin-name=barman-cloud.cloudnative-pg.io
```