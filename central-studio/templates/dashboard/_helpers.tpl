{{/*
Common labels
*/}}
{{- define "dashboard.labels" -}}
{{ include "studio.labels" . }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "dashboard.selectorLabels" -}}
app.kubernetes.io/name: {{ .Values.dashboard.name }}
{{ include "studio.selectorLabels" . }}
{{- end }}