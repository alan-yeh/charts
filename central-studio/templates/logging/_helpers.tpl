{{/*
    通用应用标签
*/}}
{{- define "logging.labels" -}}
{{ include "global.labels" . }}
{{- end }}

{{/*
    应用选择标签
*/}}
{{- define "logging.selectorLabels" -}}
app.kubernetes.io/name: {{ .Values.logging.name }}
{{ include "global.selectorLabels" . }}
{{- end }}