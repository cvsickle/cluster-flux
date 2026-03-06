# Flux CD Deployment

This repository is a Flux CD deployment for a k3s cluster, running on three Beelink Mini PC's. One k3s server node and one k3s worker node on each host. If you're reading this, and you're not the owner of this particular cluster, you really shouldn't try to use this repository directly. Feel free to reference the deployment strategy and specifics, but don't try to use them unless you know what you're doing.

- Github: [https://github.com/cvsickle/cluster-ansible](https://github.com/cvsickle/cluster-ansible)
- Codeberg: [https://codeberg.org/cvsickle/cluster-flux](https://codeberg.org/cvsickle/cluster-flux)

# Repository Structure

```bash
 ├── apps             # Apps Folder:
 │   ├── application1 # All top-level applications
 │   ├── application2 # running in the cluster are
 │   └── application3 # defined in this folder.
 |
 ├── cluster                    # Cluster Folder:
 │   ├── cluster-apps           # Kustomization
 │   ├── cluster-infrastructure # Kustomization
 │   ├── flux-system            # Flux Kustomization - NO TOUCHY
 │   └── update-automation      # Flux Update Automations
 |
 └── infrastructure # Infrastructure Folder:
     ├── service1   # Core services required for the cluster
     ├── service2   # to operate are defined in this folder.
     └── service3   # Storage, Ingress, Databases, etc.
```

# Reconciliation

### Watch the Flux Kustomizations

```bash
flux get kustomizations --watch
```

### Reconcile any changes

```bash
# Apps
flux reconcile kustomization cluster-apps --with-source

# Cluster
flux reconcile kustomization flux-system --with-source

# Infrastructure
flux reconcile kustomization cluster-infrastructure --with-source
```

# Local Machine Setup

### Install kubectl

```bash
cd ~
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
```

### Install flux

The command below will install flux on a **local device** to manage the cluster. This should **NOT** be installed on the cluster.

```bash
curl -s https://fluxcd.io/install.sh | sudo bash
# verify
flux check --pre
```

### Install helm

Helm also needs to be installed on a **local device** to properly manage the cluster.

```bash
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
# remove the script when install is complete
rm get_helm.sh
```

# Create a GitHub Token

The token needs to have **repo** access. I had to create it as a classic token.

[https://github.com/settings/tokens](https://github.com/settings/tokens)

# Bootstrap the Cluster

The command below will install Flux on the cluster and reference the repository.

```bash
flux bootstrap github \
  --components-extra=image-reflector-controller,image-automation-controller \
  --owner=cvsickle \
  --repository=cluster-flux \
  --branch=main \
  --path=cluster \
  --personal \
  --token-auth
# verify
flux check
# double verify
kubectl get pods -n flux-system
```

# Misc. Commands

### Get Helm Chart Versions

```bash
helm search repo <reponame>/<chartname> --versions
```

# Helpful Things

- [TechnoTim](https://technotim.live/posts/flux-devops-gitops/)'s Demo of Flux ([video](https://www.youtube.com/watch?v=PFLimPh5-wo))
- [freelens](https://github.com/freelensapp/freelens) - a helpful UI for Kubernetes
- [k9s](https://k9scli.io/topics/install/) - a CLI UI for Kubernetes
- Using [Sealed Secrets](https://fluxcd.io/flux/guides/sealed-secrets/) in Flux.