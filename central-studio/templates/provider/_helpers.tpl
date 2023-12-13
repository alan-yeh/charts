{{/*
    组件标签
*/}}
{{- define "provider.componentLabels" -}}
app.kubernetes.io/name: {{ .Values.provider.name }}
{{- end }}

{{/*
    通用应用标签
*/}}
{{- define "provider.labels" -}}
{{ include "global.labels" . }}
{{ include "provider.componentLabels" . }}
{{- end }}

{{/*
    应用选择标签
*/}}
{{- define "provider.selectorLabels" -}}
{{ include "provider.componentLabels" . }}
{{ include "global.selectorLabels" . }}
{{- end }}