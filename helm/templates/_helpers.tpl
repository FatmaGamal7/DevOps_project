{{- define "hello-app.name" -}}
{{ .Chart.Name }}
{{- end }}

{{- define "hello-app.fullname" -}}
{{ printf "%s-%s" .Release.Name .Chart.Name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "hello-app.labels" -}}
app.kubernetes.io/name: {{ include "hello-app.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "hello-app.selectorLabels" -}}
app.kubernetes.io/name: {{ include "hello-app.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}
