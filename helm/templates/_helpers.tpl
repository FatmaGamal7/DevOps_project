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
