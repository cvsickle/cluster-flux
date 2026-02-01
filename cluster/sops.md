# SOPS

This cluster uses an AGE key to encrypt and decrypt secrets using SOPS.

# Common Commands

Create a normal Kubernetes secret.

```bash
kubectl create secret generic secret-name -n namespace \
--from-literal=secret-field=super_secret_value_goes_here \
--dry-run=client -o yaml > secret.yaml
```

Then, encrypt the secret using the public key.

```bash
sops --age=age1v59tukq0cvskn0ww9dwhh9z4ytgj03u599rtzs8xap83jtm8msssc9z8q7 \
--encrypt --encrypt-regex '^(data|stringData)$' --in-place secret.yaml
```

# Setup

First, install SOPS.

```bash
curl -LO https://github.com/getsops/sops/releases/download/v3.8.1/sops-v3.8.1.linux.amd64
chmod +x sops-v3.8.1.linux.amd64
sudo mv sops-v3.8.1.linux.amd64 /usr/local/bin/sops
```

Create an AGE key.

```bash
age-keygen -o age.agekey
```

Pass that key into the cluster. This contains the private key, so DO NOT commit this file to git.

```bash
cat age.agekey |
kubectl create secret generic sops-age \
--namespace=flux-system \
--from-file=age.agekey=/dev/stdin
```

Create a SOPS config in the cluster repository with the public key. This is safe to commit.

```yaml
# .sops.yaml
creation_rules:
  - path_regex: .*.yaml
    encrypted_regex: ^(data|stringData)$
    age: age1v59tukq0cvskn0ww9dwhh9z4ytgj03u599rtzs8xap83jtm8msssc9z8q7
```

Finally, add the decryption block to the main Kustomization on the repository. By default, this is found in `./cluster/flux-system/gotk-sync.yaml`

```yaml
  decryption:
    provider: sops
    secretRef:
      name: sops-age
```

Once these changes are committed, Flux will now use SOPS to decrypt your SOPS encrypted secrets.