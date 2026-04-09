{{/*
Chart name + release name, truncated to DNS-1123 length.
*/}}
{{- define "app.fullname" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels applied to every resource.
*/}}
{{- define "app.labels" -}}
app.kubernetes.io/name: {{ include "app.fullname" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version }}
{{- end -}}

{{/*
Selector labels — must be immutable across releases for Deployment selectors.
*/}}
{{- define "app.selectorLabels" -}}
app.kubernetes.io/name: {{ include "app.fullname" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}
