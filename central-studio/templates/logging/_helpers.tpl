{{/*
    组件标签
*/}}
{{- define "logging.componentLabels" -}}
app.kubernetes.io/name: {{ .Values.logging.name }}
{{- end }}

{{/*
    通用应用标签
*/}}
{{- define "logging.labels" -}}
{{ include "global.labels" . }}
{{ include "logging.componentLabels" . }}
{{- end }}

{{/*
    应用选择标签
*/}}
{{- define "logging.selectorLabels" -}}
{{ include "logging.componentLabels" . }}
{{ include "global.selectorLabels" . }}
{{- end }}