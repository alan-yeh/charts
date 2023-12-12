{{/*
    通用应用标签
*/}}
{{- define "storage.labels" -}}
{{ include "global.labels" . }}
{{- end }}

{{/*
    应用选择标签
*/}}
{{- define "storage.selectorLabels" -}}
app.kubernetes.io/name: {{ .Values.storage.name }}
{{ include "global.selectorLabels" . }}
{{- end }}