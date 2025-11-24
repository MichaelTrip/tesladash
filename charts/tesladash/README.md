# TeslaDash Helm Chart

A lightweight Helm chart to deploy TeslaDash — a static NGINX site that provides a Tesla-friendly fullscreen portal.

## TL;DR

```bash
# From local source
helm upgrade --install tesladash ./charts/tesladash \
  --set image.repository=ghcr.io/michaeltrip/tesladash \
  --set image.tag=latest
```

Optionally, install from a GitHub Release asset (published by CI):
```bash
# Replace <tag> (e.g., v1.2.3) and <chartVersion> (e.g., 1.2.3)
CHART_URL="https://github.com/MichaelTrip/tesladash/releases/download/<tag>/tesladash-<chartVersion>.tgz"
helm upgrade --install tesladash "$CHART_URL" \
  --set image.repository=ghcr.io/michaeltrip/tesladash \
  --set image.tag=<tag>
```

## Installing the Chart

From local workspace:
```bash
helm upgrade --install tesladash ./charts/tesladash \
  --set image.repository=ghcr.io/michaeltrip/tesladash \
  --set image.tag=<version-or-latest>
```

Provide your own links.json at install time:
```bash
helm upgrade --install tesladash ./charts/tesladash \
  --set-file config.linksJson=./config/links.json \
  --set image.repository=ghcr.io/michaeltrip/tesladash \
  --set image.tag=<version>
```

Use an existing ConfigMap instead of embedding JSON:
```bash
kubectl create configmap my-links-config --from-file=links.json=./config/links.json
helm upgrade --install tesladash ./charts/tesladash \
  --set config.existingConfigMap=my-links-config \
  --set image.repository=ghcr.io/michaeltrip/tesladash \
  --set image.tag=<version>
```

Enable Ingress:
```bash
helm upgrade --install tesladash ./charts/tesladash \
  --set ingress.enabled=true \
  --set ingress.className=nginx \
  --set ingress.hosts[0].host=tesladash.example.com \
  --set ingress.hosts[0].paths[0].path=/ \
  --set ingress.hosts[0].paths[0].pathType=Prefix \
  --set ingress.tls[0].hosts[0]=tesladash.example.com \
  --set ingress.tls[0].secretName=tesladash-tls
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| replicaCount | int | `1` | Number of replicas |
| image.repository | string | `ghcr.io/michaeltrip/tesladash` | Container image repository |
| image.tag | string | `latest` | Image tag (CI will publish semver tags) |
| image.pullPolicy | string | `IfNotPresent` | Image pull policy |
| service.type | string | `ClusterIP` | Service type |
| service.port | int | `80` | Service port |
| ingress.enabled | bool | `false` | Enable ingress |
| ingress.className | string | `` | Ingress class name |
| ingress.annotations | object | `{}` | Extra ingress annotations |
| ingress.hosts | list | `[{host: tesladash.example.com, paths: [{path: "/", pathType: "Prefix"}]}]` | Ingress hosts |
| ingress.tls | list | `[]` | TLS configuration |
| config.existingConfigMap | string | `` | Use an existing ConfigMap containing links.json |
| config.mountPath | string | `/usr/share/nginx/html/config` | Mount path for links.json |
| config.linksJson | string | `` | Inline links.json content (overrides bundled default) |
| resources | object | `{}` | Pod resources |
| nodeSelector | object | `{}` | Node selector |
| tolerations | list | `[]` | Tolerations |
| affinity | object | `{}` | Affinity |

## Chart Packaging (CI)

On releases (push to main with conventional commits), the CI:
- Calculates semver (vX.Y.Z)
- Updates Chart.yaml `version` (X.Y.Z) and `appVersion` (vX.Y.Z)
- Packages the chart to `dist/` and uploads the `.tgz` artifact to the GitHub Release

You can also package locally:
```bash
helm lint charts/tesladash
helm package charts/tesladash --destination dist
ls dist
```
