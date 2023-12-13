{{/*
    组件标签
*/}}
{{- define "storage.componentLabels" -}}
app.kubernetes.io/name: {{ .Values.storage.name }}
{{- end }}

{{/*
    通用应用标签
*/}}
{{- define "storage.labels" -}}
{{ include "global.labels" . }}
{{ include "storage.componentLabels" . }}
{{- end }}

{{/*
    应用选择标签
*/}}
{{- define "storage.selectorLabels" -}}
{{ include "storage.componentLabels" . }}
{{ include "global.selectorLabels" . }}
{{- end }}