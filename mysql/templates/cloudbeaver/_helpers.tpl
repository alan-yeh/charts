{{/*
    当前组件实例的名字
*/}}
{{- define "cloudbeaver.name" -}}
{{- printf "cloudbeaver-%s" (include "global.identity" .) }}
{{- end }}

{{/*
    通用应用标签
*/}}
{{- define "cloudbeaver.labels" -}}
{{ include "global.labels" . }}
{{- end }}

{{/*
    应用选择标签
*/}}
{{- define "cloudbeaver.selectorLabels" -}}
app.kubernetes.io/name: {{ include "cloudbeaver.name" . }}
{{ include "global.selectorLabels" . }}
{{- end }}