{{/*
    组件标签
*/}}
{{- define "identity.componentLabels" -}}
app.kubernetes.io/name: {{ .Values.identity.name }}
{{- end }}

{{/*
    通用应用标签
*/}}
{{- define "identity.labels" -}}
{{ include "global.labels" . }}
{{ include "identity.componentLabels" . }}
{{- end }}

{{/*
    应用选择标签
*/}}
{{- define "identity.selectorLabels" -}}
{{ include "identity.componentLabels" . }}
{{ include "global.selectorLabels" . }}
{{- end }}