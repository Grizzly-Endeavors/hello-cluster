{{/*
Full name for the app. For single-release templates like this one,
just use Release.Name — Flux's HelmRelease sets releaseName to the
app name at onboarding time.
*/}}
{{- define "app.fullname" -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels applied to every resource.
The `helm.sh/chart` label is sanitized: when Flux loads a chart from a
GitRepository, helm-controller appends `+<commit-sha>` to the chart
version. `+` is invalid in k8s labels, so replace with `_`.
*/}}
{{- define "app.labels" -}}
app.kubernetes.io/name: {{ include "app.fullname" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
helm.sh/chart: {{ printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end -}}

{{/*
Selector labels — must be immutable across releases for Deployment selectors.
*/}}
{{- define "app.selectorLabels" -}}
app.kubernetes.io/name: {{ include "app.fullname" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}
