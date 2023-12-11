{{/*
    当前组件实例的名字
*/}}
{{- define "logging.name" -}}
{{- printf "%s-%s" .Values.logging.name (include "global.identity" .) }}
{{- end }}

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
app.kubernetes.io/name: {{ include "logging.name" . }}
{{ include "global.selectorLabels" . }}
{{- end }}