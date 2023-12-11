{{/*
    当前组件实例的名字
*/}}
{{- define "mysql.name" -}}
{{- printf "mysql-%s" (include "global.identity" .) }}
{{- end }}

{{/*
    通用应用标签
*/}}
{{- define "mysql.labels" -}}
{{ include "global.labels" . }}
{{- end }}

{{/*
    应用选择标签
*/}}
{{- define "mysql.selectorLabels" -}}
app.kubernetes.io/name: {{ include "mysql.name" . }}
{{ include "global.selectorLabels" . }}
{{- end }}