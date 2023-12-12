{{/*
    通用应用标签
*/}}
{{- define "security.labels" -}}
{{ include "global.labels" . }}
{{- end }}

{{/*
    应用选择标签
*/}}
{{- define "security.selectorLabels" -}}
app.kubernetes.io/name: {{ .Values.security.name }}
{{ include "global.selectorLabels" . }}
{{- end }}