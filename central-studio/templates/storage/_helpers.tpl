{{/*
Common labels
*/}}
{{- define "storage.labels" -}}
{{ include "studio.labels" . }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "storage.selectorLabels" -}}
app.kubernetes.io/name: {{ .Values.storage.name }}
{{ include "studio.selectorLabels" . }}
{{- end }}