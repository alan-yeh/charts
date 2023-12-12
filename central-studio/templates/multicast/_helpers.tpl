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
app.kubernetes.io/name: {{ .Values.multicast.name }}
{{ include "global.selectorLabels" . }}
{{- end }}