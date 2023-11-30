{{/*
Common labels
*/}}
{{- define "logging.labels" -}}
{{ include "studio.labels" . }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "logging.selectorLabels" -}}
app.kubernetes.io/name: {{ .Values.logging.name }}
{{ include "studio.selectorLabels" . }}
{{- end }}