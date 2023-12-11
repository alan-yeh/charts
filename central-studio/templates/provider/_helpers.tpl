{{/*
    当前组件实例的名字
*/}}
{{- define "provider.name" -}}
{{- printf "%s-%s" .Values.provider.name (include "global.identity" .) }}
{{- end }}

{{/*
    通用应用标签
*/}}
{{- define "provider.labels" -}}
{{ include "global.labels" . }}
{{- end }}

{{/*
    应用选择标签
*/}}
{{- define "provider.selectorLabels" -}}
app.kubernetes.io/name: {{ include "provider.name" . }}
{{ include "global.selectorLabels" . }}
{{- end }}