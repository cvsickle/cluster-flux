# Flux CD Deployment

This repository is a Flux CD deployment for a k3s cluster, running on three Beelink Mini PC's. One k3s server node and one k3s worker node on each host. If you're reading this, and you're not the owner of this particular cluster, you really shouldn't try to use this repository directly. Feel free to reference the deployment strategy and specifics, but don't try to use them unless you know what you're doing.

- Github: [https://github.com/cvsickle/cluster-flux](https://github.com/cvsickle/cluster-flux)
- Codeberg: [https://codeberg.org/cvsickle/cluster-flux](https://codeberg.org/cvsickle/cluster-flux)
- Forgejo (Mirror): [https://git.cvsickle.com/cvsickle/cluster-flux](https://git.cvsickle.com/cvsickle/cluster-flux)

# Repository Structure

```bash
 ├── .devcontainer # Dev container definition
 |
 ├── .github       # GitHub actions
 |
 ├── .woodpecker   # Woodpecker CI actions
 |
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

### Redeploy a HelmRelease

```bash
flux reconcile helmrelease <helmrelease_name> -n <namespace> --with-source --force
```

# Local Machine Setup

This repo uses a dev container defined in the `.devcontainer` directory. The container contains all the tools required for interacting with the cluster.

- kubectl (with cnpg plugin)
- helm
- flux
- k9s
- longhornctl

Using the container requires 3 mounts.

- `~/.ssh` with a valid SSH key for the cluster hosts.
- `~/.kube` with a valid kube config for the cluster.
- `~/.gitconfig` with valid git credentials.

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
