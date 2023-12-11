{{/*
    当前组件实例的名字
*/}}
{{- define "gateway.name" -}}
{{- printf "%s-%s" .Values.gateway.name (include "global.identity" .) }}
{{- end }}

{{/*
    通用应用标签
*/}}
{{- define "gateway.labels" -}}
{{ include "global.labels" . }}
{{- end }}

{{/*
    应用选择标签
*/}}
{{- define "gateway.selectorLabels" -}}
app.kubernetes.io/name: {{ include "gateway.name" . }}
{{ include "global.selectorLabels" . }}
{{- end }}