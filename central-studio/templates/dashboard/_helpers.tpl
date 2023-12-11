{{/*
    当前组件实例的名字
*/}}
{{- define "dashboard.name" -}}
{{- printf "%s-%s" .Values.dashboard.name (include "global.identity" .) }}
{{- end }}

{{/*
    通用应用标签
*/}}
{{- define "dashboard.labels" -}}
{{ include "global.labels" . }}
{{- end }}

{{/*
    应用选择标签
*/}}
{{- define "dashboard.selectorLabels" -}}
app.kubernetes.io/name: {{ include "dashboard.name" . }}
{{ include "global.selectorLabels" . }}
{{- end }}