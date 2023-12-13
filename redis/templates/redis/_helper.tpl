{{/*
    当前组件实例的名字
*/}}
{{- define "redis.name" -}}
{{- printf "redis-%s" (include "global.identity" .) }}
{{- end }}

{{/*
    组件标签
*/}}
{{- define "redis.componentLabels" -}}
app.kubernetes.io/name: {{ include "redis.name" . }}
{{- end }}

{{/*
    通用应用标签
*/}}
{{- define "redis.labels" -}}
{{ include "global.labels" . }}
{{ include "redis.componentLabels" . }}
{{- end }}

{{/*
    应用选择标签
*/}}
{{- define "redis.selectorLabels" -}}
{{ include "redis.componentLabels" . }}
{{ include "global.selectorLabels" . }}
{{- end }}