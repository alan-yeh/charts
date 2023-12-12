{{/*
    通用应用标签
*/}}
{{- define "provider.labels" -}}
{{ include "global.labels" . }}
{{- end }}

{{/*
    应用选择标签
*/}}
{{- define "provider.selectorLabels" -}}
app.kubernetes.io/name: {{ .Values.provider.name }}
{{ include "global.selectorLabels" . }}
{{- end }}