{{/*
Common labels
*/}}
{{- define "provider.labels" -}}
{{ include "studio.labels" . }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "provider.selectorLabels" -}}
app.kubernetes.io/name: {{ .Values.provider.name }}
{{ include "studio.selectorLabels" . }}
{{- end }}