{{/*
Common labels
*/}}
{{- define "gateway.labels" -}}
{{ include "studio.labels" . }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "gateway.selectorLabels" -}}
app.kubernetes.io/name: {{ .Values.gateway.name }}
{{ include "studio.selectorLabels" . }}
{{- end }}