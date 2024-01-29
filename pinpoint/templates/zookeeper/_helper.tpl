{{/*
    当前组件实例的名字
*/}}
{{- define "zookeeper.name" -}}
{{- printf "pinpoint-zookeeper-%s" (include "global.identity" .) }}
{{- end }}

{{/*
    组件标签
*/}}
{{- define "zookeeper.componentLabels" -}}
app.kubernetes.io/name: {{ include "zookeeper.name" . }}
{{- end }}

{{/*
    通用应用标签
*/}}
{{- define "zookeeper.labels" -}}
{{ include "global.labels" . }}
{{ include "zookeeper.componentLabels" . }}
{{- end }}

{{/*
    应用选择标签
*/}}
{{- define "zookeeper.selectorLabels" -}}
{{ include "zookeeper.componentLabels" . }}
{{ include "global.selectorLabels" . }}
{{- end }}