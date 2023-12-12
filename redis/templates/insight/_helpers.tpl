{{/*
    当前组件实例的名字
*/}}
{{- define "insight.name" -}}
{{- printf "insight-%s" (include "global.identity" .) }}
{{- end }}

{{/*
    通用应用标签
*/}}
{{- define "insight.labels" -}}
{{ include "global.labels" . }}
{{- end }}

{{/*
    应用选择标签
*/}}
{{- define "insight.selectorLabels" -}}
app.kubernetes.io/name: {{ include "insight.name" . }}
{{ include "global.selectorLabels" . }}
{{- end }}