{{/*
    当前组件实例的名字
*/}}
{{- define "insight.name" -}}
{{- printf "insight-%s" (include "global.identity" .) }}
{{- end }}

{{/*
    组件标签
*/}}
{{- define "insight.componentLabels" -}}
app.kubernetes.io/name: {{ include "insight.name" . }}
{{- end }}

{{/*
    通用应用标签
*/}}
{{- define "insight.labels" -}}
{{ include "global.labels" . }}
{{ include "insight.componentLabels" . }}
{{- end }}

{{/*
    应用选择标签
*/}}
{{- define "insight.selectorLabels" -}}
{{ include "insight.componentLabels" . }}
{{ include "global.selectorLabels" . }}
{{- end }}