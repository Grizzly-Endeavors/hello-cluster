# app-deploy-template

Template for applications deployed to the grizzly-endeavors homelab
Kubernetes cluster via Flux. See
[ADR-020](https://github.com/grizzly-endeavors/lab-iac/blob/master/docs/decisions/020-app-delivery-model.md)
for the delivery model.

## What you get

```
.
├── .github/workflows/
│   ├── register.yaml   # one-time: workflow_dispatch to onboard with Flux
│   └── deploy.yaml     # every push to main: build image + bump tag
├── deploy/
│   ├── Chart.yaml
│   ├── values.yaml     # tag bumped automatically by deploy.yaml
│   └── templates/
│       ├── _helpers.tpl
│       ├── deployment.yaml
│       ├── service.yaml
│       └── ingress.yaml
├── Dockerfile          # replace with your app
└── README.md           # replace with your app's readme
```

## Bootstrap a new app

```bash
gh repo create grizzly-endeavors/<new-app> \
  --template grizzly-endeavors/app-deploy-template \
  --public
```

Then from the new repo's **Actions** tab, run the **Register with Flux**
workflow (`workflow_dispatch`) and fill in:
- `app_name` — short DNS-1123 name (e.g. `landing-page`)
- `namespace` — Kubernetes namespace (usually same as `app_name`)
- `ingress_host` — optional hostname for the Ingress
- `auto_merge` — leave `true` to auto-merge the onboarding PR

That opens a PR on `lab-iac` adding `kubernetes/apps/<app_name>/`. Once
the PR merges, Flux begins reconciling your `deploy/` dir within about
a minute. From then on, every push to `main` triggers `deploy.yaml`,
which builds the image, pushes to GHCR, bumps the tag in
`deploy/values.yaml`, and commits back. Flux sees the commit and
reconciles — no further manual steps.

## Customizing

- **`Dockerfile`** — replace with your app's actual container build.
- **`deploy/values.yaml`** — tune resources, probes, ingress, env vars.
- **`deploy/templates/`** — edit the Helm templates if you need extra
  resources (ConfigMaps, Secrets, CronJobs, etc).
- **`.github/workflows/deploy.yaml`** — add test steps, build args,
  cache config, or multiple-arch builds as needed.

The `deploy/values.yaml` image defaults to public `nginx:1.25-alpine`,
so a freshly-created repo deploys end-to-end with no changes. On your
first `git push`, the `deploy.yaml` workflow builds your actual image
and replaces the default.

## Prerequisites

The org-level GitHub Actions secrets `FLUX_OPS_APP_ID` and
`FLUX_OPS_APP_PRIVATE_KEY` must be set — these power the
`register-app.yaml` reusable workflow in `lab-iac`. They are already
set at the org level; nothing to do per-repo.
