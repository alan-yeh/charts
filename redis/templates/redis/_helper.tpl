{{/*
    当前组件实例的名字
*/}}
{{- define "redis.name" -}}
{{- printf "redis-%s" (include "global.identity" .) }}
{{- end }}

{{/*
    通用应用标签
*/}}
{{- define "redis.labels" -}}
{{ include "global.labels" . }}
{{- end }}

{{/*
    应用选择标签
*/}}
{{- define "redis.selectorLabels" -}}
app.kubernetes.io/name: {{ include "redis.name" . }}
{{ include "global.selectorLabels" . }}
{{- end }}