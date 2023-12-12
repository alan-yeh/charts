{{/*
    通用应用标签
*/}}
{{- define "gateway.labels" -}}
{{ include "global.labels" . }}
{{- end }}

{{/*
    应用选择标签
*/}}
{{- define "gateway.selectorLabels" -}}
app.kubernetes.io/name: {{ .Values.gateway.name }}
{{ include "global.selectorLabels" . }}
{{- end }}