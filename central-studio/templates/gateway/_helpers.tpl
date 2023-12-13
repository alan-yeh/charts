{{/*
    组件标签
*/}}
{{- define "gateway.componentLabels" -}}
app.kubernetes.io/name: {{ .Values.gateway.name }}
{{- end }}

{{/*
    通用应用标签
*/}}
{{- define "gateway.labels" -}}
{{ include "global.labels" . }}
{{ include "gateway.componentLabels" . }}
{{- end }}

{{/*
    应用选择标签
*/}}
{{- define "gateway.selectorLabels" -}}
{{ include "gateway.componentLabels" . }}
{{ include "global.selectorLabels" . }}
{{- end }}