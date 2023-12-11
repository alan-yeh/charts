{{/*
    当前组件实例的名字
*/}}
{{- define "multicast.name" -}}
{{- printf "%s-%s" .Values.multicast.name (include "global.identity" .) }}
{{- end }}

{{/*
    通用应用标签
*/}}
{{- define "multicast.labels" -}}
{{ include "global.labels" . }}
{{- end }}

{{/*
    应用选择标签
*/}}
{{- define "multicast.selectorLabels" -}}
app.kubernetes.io/name: {{ include "multicast.name" . }}
{{ include "global.selectorLabels" . }}
{{- end }}