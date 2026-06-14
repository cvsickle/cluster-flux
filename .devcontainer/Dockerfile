FROM mcr.microsoft.com/devcontainers/base:ubuntu-24.04

ARG TARGETARCH=amd64

# ── Pinned Versions ──────────────────────────────────────────
ARG FLUX_VERSION=2.8.8
ARG KUBECTL_VERSION=1.36.1
ARG HELM_VERSION=4.2.0
ARG K9S_VERSION=0.51.0
ARG CNPG_VERSION=1.29.1
ARG LONGHORNCTL_VERSION=1.11.2
# ─────────────────────────────────────────────────────────────

RUN apt-get update && apt-get install -y \
    curl \
    wget \
    tar \
    unzip \
    ca-certificates \
    gnupg \
    bash-completion \
    && rm -rf /var/lib/apt/lists/*

# ── kubectl ──────────────────────────────────────────────────
RUN curl -fsSL \
    "https://dl.k8s.io/release/v${KUBECTL_VERSION}/bin/linux/${TARGETARCH}/kubectl" \
    -o /usr/local/bin/kubectl \
    && chmod +x /usr/local/bin/kubectl

# ── helm ─────────────────────────────────────────────────────
RUN curl -fsSL \
    "https://get.helm.sh/helm-v${HELM_VERSION}-linux-${TARGETARCH}.tar.gz" \
    | tar -xz --strip-components=1 -C /usr/local/bin "linux-${TARGETARCH}/helm"

# ── flux ─────────────────────────────────────────────────────
RUN curl -fsSL \
    "https://github.com/fluxcd/flux2/releases/download/v${FLUX_VERSION}/flux_${FLUX_VERSION}_linux_${TARGETARCH}.tar.gz" \
    | tar -xz -C /usr/local/bin flux \
    && chmod +x /usr/local/bin/flux

# ── k9s ──────────────────────────────────────────────────────
RUN curl -fsSL \
    "https://github.com/derailed/k9s/releases/download/v${K9S_VERSION}/k9s_Linux_${TARGETARCH}.tar.gz" \
    | tar -xz -C /usr/local/bin k9s \
    && chmod +x /usr/local/bin/k9s

# ── kubectl-cnpg plugin ───────────────────────────────────────
RUN curl -fsSL \
    "https://github.com/cloudnative-pg/cloudnative-pg/releases/download/v${CNPG_VERSION}/kubectl-cnpg_${CNPG_VERSION}_linux_x86_64.tar.gz" \
    | tar -xz -C /usr/local/bin kubectl-cnpg \
    && chmod +x /usr/local/bin/kubectl-cnpg

# ── longhornctl ──────────────────────────────────────────────
RUN curl -fsSL \
    "https://github.com/longhorn/cli/releases/download/v${LONGHORNCTL_VERSION}/longhornctl-linux-${TARGETARCH}" \
    -o /usr/local/bin/longhornctl \
    && chmod +x /usr/local/bin/longhornctl

# ── Shell Completions ─────────────────────────────────────────
RUN echo 'source <(kubectl completion bash)' >> /etc/bash.bashrc \
    && echo 'source <(flux completion bash)' >> /etc/bash.bashrc \
    && echo 'source <(helm completion bash)' >> /etc/bash.bashrc \
    && echo 'complete -F __start_kubectl k' >> /etc/bash.bashrc \
    && echo 'alias k=kubectl' >> /etc/bash.bashrc