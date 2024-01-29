{{/*
    当前组件实例的名字
*/}}
{{- define "jobmanager.name" -}}
{{- printf "pinpoint-jobmanager-%s" (include "global.identity" .) }}
{{- end }}

{{/*
    组件标签
*/}}
{{- define "jobmanager.componentLabels" -}}
app.kubernetes.io/name: {{ include "jobmanager.name" . }}
{{- end }}

{{/*
    通用应用标签
*/}}
{{- define "jobmanager.labels" -}}
{{ include "global.labels" . }}
{{ include "jobmanager.componentLabels" . }}
{{- end }}

{{/*
    应用选择标签
*/}}
{{- define "jobmanager.selectorLabels" -}}
{{ include "jobmanager.componentLabels" . }}
{{ include "global.selectorLabels" . }}
{{- end }}