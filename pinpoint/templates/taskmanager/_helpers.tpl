{{/*
    当前组件实例的名字
*/}}
{{- define "taskmanager.name" -}}
{{- printf "pinpoint-taskmanager-%s" (include "global.identity" .) }}
{{- end }}

{{/*
    组件标签
*/}}
{{- define "taskmanager.componentLabels" -}}
app.kubernetes.io/name: {{ include "taskmanager.name" . }}
{{- end }}

{{/*
    通用应用标签
*/}}
{{- define "taskmanager.labels" -}}
{{ include "global.labels" . }}
{{ include "taskmanager.componentLabels" . }}
{{- end }}

{{/*
    应用选择标签
*/}}
{{- define "taskmanager.selectorLabels" -}}
{{ include "taskmanager.componentLabels" . }}
{{ include "global.selectorLabels" . }}
{{- end }}