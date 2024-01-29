{{/*
    当前组件实例的名字
*/}}
{{- define "hbase.name" -}}
{{- printf "pinpoint-hbase-%s" (include "global.identity" .) }}
{{- end }}

{{/*
    组件标签
*/}}
{{- define "hbase.componentLabels" -}}
app.kubernetes.io/name: {{ include "hbase.name" . }}
{{- end }}

{{/*
    通用应用标签
*/}}
{{- define "hbase.labels" -}}
{{ include "global.labels" . }}
{{ include "hbase.componentLabels" . }}
{{- end }}

{{/*
    应用选择标签
*/}}
{{- define "hbase.selectorLabels" -}}
{{ include "hbase.componentLabels" . }}
{{ include "global.selectorLabels" . }}
{{- end }}