This repository uses GitHub Actions workflows to:

- Build and push a multi-arch container image to GHCR on pushes to main
- Calculate a semantic version from conventional commits
- Tag and create GitHub releases
- Update the Kubernetes manifests under `k8s/` to use the newly built image tag

Notes for maintainers:
- Ensure GHCR permissions are enabled for this repository (Settings → Actions → General → Workflow permissions)
- If you fork, the image name will be `ghcr.io/<your-namespace>/<your-repo>` automatically
- Update `k8s/ingress.yaml` host and TLS secret to your domain
