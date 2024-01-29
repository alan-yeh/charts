{{/*
    当前组件实例的名字
*/}}
{{- define "web.name" -}}
{{- printf "pinpoint-web-%s" (include "global.identity" .) }}
{{- end }}

{{/*
    组件标签
*/}}
{{- define "web.componentLabels" -}}
app.kubernetes.io/name: {{ include "web.name" . }}
{{- end }}

{{/*
    通用应用标签
*/}}
{{- define "web.labels" -}}
{{ include "global.labels" . }}
{{ include "web.componentLabels" . }}
{{- end }}

{{/*
    应用选择标签
*/}}
{{- define "web.selectorLabels" -}}
{{ include "web.componentLabels" . }}
{{ include "global.selectorLabels" . }}
{{- end }}