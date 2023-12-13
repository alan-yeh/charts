{{/*
    组件标签
*/}}
{{- define "security.componentLabels" -}}
app.kubernetes.io/name: {{ .Values.security.name }}
{{- end }}

{{/*
    通用应用标签
*/}}
{{- define "security.labels" -}}
{{ include "global.labels" . }}
{{ include "security.componentLabels" . }}
{{- end }}

{{/*
    应用选择标签
*/}}
{{- define "security.selectorLabels" -}}
{{ include "security.componentLabels" . }}
{{ include "global.selectorLabels" . }}
{{- end }}