{{/*
    当前组件实例的名字
*/}}
{{- define "storage.name" -}}
{{- printf "%s-%s" .Values.storage.name (include "global.identity" .) }}
{{- end }}

{{/*
    通用应用标签
*/}}
{{- define "storage.labels" -}}
{{ include "global.labels" . }}
{{- end }}

{{/*
    应用选择标签
*/}}
{{- define "storage.selectorLabels" -}}
app.kubernetes.io/name: {{ include "storage.name" . }}
{{ include "global.selectorLabels" . }}
{{- end }}