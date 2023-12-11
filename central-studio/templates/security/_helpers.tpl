{{/*
    当前组件实例的名字
*/}}
{{- define "security.name" -}}
{{- printf "%s-%s" .Values.security.name (include "global.identity" .) }}
{{- end }}

{{/*
    通用应用标签
*/}}
{{- define "security.labels" -}}
{{ include "global.labels" . }}
{{- end }}

{{/*
    应用选择标签
*/}}
{{- define "security.selectorLabels" -}}
app.kubernetes.io/name: {{ include "security.name" . }}
{{ include "global.selectorLabels" . }}
{{- end }}