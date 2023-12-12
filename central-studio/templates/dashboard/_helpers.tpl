{{/*
    通用应用标签
*/}}
{{- define "dashboard.labels" -}}
{{ include "global.labels" . }}
{{- end }}

{{/*
    应用选择标签
*/}}
{{- define "dashboard.selectorLabels" -}}
app.kubernetes.io/name: {{ .Values.dashboard.name }}
{{ include "global.selectorLabels" . }}
{{- end }}