{{/*
    组件标签
*/}}
{{- define "dashboard.componentLabels" -}}
app.kubernetes.io/name: {{ .Values.dashboard.name }}
{{- end }}

{{/*
    通用应用标签
*/}}
{{- define "dashboard.labels" -}}
{{ include "global.labels" . }}
{{ include "dashboard.componentLabels" . }}
{{- end }}

{{/*
    应用选择标签
*/}}
{{- define "dashboard.selectorLabels" -}}
{{ include "dashboard.componentLabels" . }}
{{ include "global.selectorLabels" . }}
{{- end }}