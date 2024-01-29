{{/*
    当前组件实例的名字
*/}}
{{- define "batch.name" -}}
{{- printf "pinpoint-batch-%s" (include "global.identity" .) }}
{{- end }}

{{/*
    组件标签
*/}}
{{- define "batch.componentLabels" -}}
app.kubernetes.io/name: {{ include "batch.name" . }}
{{- end }}

{{/*
    通用应用标签
*/}}
{{- define "batch.labels" -}}
{{ include "global.labels" . }}
{{ include "batch.componentLabels" . }}
{{- end }}

{{/*
    应用选择标签
*/}}
{{- define "batch.selectorLabels" -}}
{{ include "batch.componentLabels" . }}
{{ include "global.selectorLabels" . }}
{{- end }}