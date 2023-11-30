{{/*
Common labels
*/}}
{{- define "security.labels" -}}
{{ include "studio.labels" . }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "security.selectorLabels" -}}
app.kubernetes.io/name: {{ .Values.security.name }}
{{ include "studio.selectorLabels" . }}
{{- end }}