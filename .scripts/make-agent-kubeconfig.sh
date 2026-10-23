#!/usr/bin/env bash
# scripts/make-agent-kubeconfig.sh
set -euo pipefail

NS=kube-system
SA=agent-readonly
DURATION="${DURATION:-24h}"
OUT="${OUT:-$HOME/.kube-agent/config}"
SERVER="${SERVER:-https://10.69.1.80:6443}"

CA=$(kubectl config view --minify --raw \
      -o jsonpath='{.clusters[0].cluster.certificate-authority-data}')
TOKEN=$(kubectl create token "$SA" -n "$NS" --duration "$DURATION")

mkdir -p "$(dirname "$OUT")"
umask 077
cat > "$OUT" <<EOF
apiVersion: v1
kind: Config
clusters:
  - name: k3s
    cluster:
      server: ${SERVER}
      certificate-authority-data: ${CA}
users:
  - name: agent-readonly
    user:
      token: ${TOKEN}
contexts:
  - name: k3s-readonly
    context:
      cluster: k3s
      user: agent-readonly
current-context: k3s-readonly
EOF

echo "Wrote $OUT (token valid for $DURATION)"