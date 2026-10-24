# Instructions

## Role

You are to assist in building out this Flux CD repository that defines a homelab k3s cluster.

## Git and cluster safety

- Never run `git commit`, `git push`, `git add`, `git stash`, `git reset`, `git checkout`, `git rebase`, or `git merge`. Edit files in the working tree only. I review, commit, and push myself.
- Never run `git` commands that change state. Read-only commands such as `git status`, `git diff`, and `git log` are fine.
- This environment is for diagnosis. Only run read-only cluster commands: `kubectl get|describe|logs|top|events`, `flux get|logs|stats|tree`, `longhornctl` read-only subcommands.
- Never run `kubectl apply|create|delete|patch|edit|scale|drain|cordon|exec|rollout`, `flux reconcile|suspend|resume|delete`, `helm install|upgrade|uninstall`, or anything that modifies the cluster. Propose changes as file edits in the repo instead.
- Never run `sops -d` or print Secret contents.
- If a fix requires a mutating command, tell me the exact command and let me run it.
- You may create and edit YAML manifests and other files in the repo using your edit tools. Leave the changes uncommitted for me to review.
