{{/*
    当前组件实例的名字
*/}}
{{- define "cloudbeaver.name" -}}
{{- printf "cloudbeaver-%s" (include "global.identity" .) }}
{{- end }}

{{/*
    组件标签
*/}}
{{- define "cloudbeaver.componentLabels" -}}
app.kubernetes.io/name: {{ include "cloudbeaver.name" . }}
{{- end }}

{{/*
    通用应用标签
*/}}
{{- define "cloudbeaver.labels" -}}
{{ include "global.labels" . }}
{{ include "cloudbeaver.componentLabels" . }}
{{- end }}

{{/*
    应用选择标签
*/}}
{{- define "cloudbeaver.selectorLabels" -}}
{{ include "cloudbeaver.componentLabels" . }}
{{ include "global.selectorLabels" . }}
{{- end }}