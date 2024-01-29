{{/*
    当前组件实例的名字
*/}}
{{- define "collector.name" -}}
{{- printf "pinpoint-collector-%s" (include "global.identity" .) }}
{{- end }}

{{/*
    组件标签
*/}}
{{- define "collector.componentLabels" -}}
app.kubernetes.io/name: {{ include "collector.name" . }}
{{- end }}

{{/*
    通用应用标签
*/}}
{{- define "collector.labels" -}}
{{ include "global.labels" . }}
{{ include "collector.componentLabels" . }}
{{- end }}

{{/*
    应用选择标签
*/}}
{{- define "collector.selectorLabels" -}}
{{ include "collector.componentLabels" . }}
{{ include "global.selectorLabels" . }}
{{- end }}