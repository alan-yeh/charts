{{/*
    当前组件实例的名字
*/}}
{{- define "mysql.name" -}}
{{- printf "pinpoint-mysql-%s" (include "global.identity" .) }}
{{- end }}

{{/*
    组件标签
*/}}
{{- define "mysql.componentLabels" -}}
app.kubernetes.io/name: {{ include "mysql.name" . }}
{{- end }}

{{/*
    通用应用标签
*/}}
{{- define "mysql.labels" -}}
{{ include "global.labels" . }}
{{ include "mysql.componentLabels" . }}
{{- end }}

{{/*
    应用选择标签
*/}}
{{- define "mysql.selectorLabels" -}}
{{ include "mysql.componentLabels" . }}
{{ include "global.selectorLabels" . }}
{{- end }}