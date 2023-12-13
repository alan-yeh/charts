{{/*
    组件标签
*/}}
{{- define "multicast.componentLabels" -}}
app.kubernetes.io/name: {{ .Values.multicast.name }}
{{- end }}

{{/*
    通用应用标签
*/}}
{{- define "multicast.labels" -}}
{{ include "global.labels" . }}
{{ include "multicast.componentLabels" . }}
{{- end }}

{{/*
    应用选择标签
*/}}
{{- define "multicast.selectorLabels" -}}
{{ include "multicast.componentLabels" . }}
{{ include "global.selectorLabels" . }}
{{- end }}