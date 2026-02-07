{{- define "helm.name" -}}
{{ .Chart.Name }}
{{- end }}

{{- define "helm.fullname" -}}
{{ .Release.Name }}
{{- end }}

{{- define "helm.labels" -}}
app.kubernetes.io/name: {{ include "helm.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "helm.selectorLabels" -}}
app.kubernetes.io/name: {{ include "helm.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Return the full name of the app
*/}}
{{- define "hello-app.fullname" -}}
{{- printf "%s-%s" .Release.Name .Chart.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
