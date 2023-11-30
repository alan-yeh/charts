{{/*
Common labels
*/}}
{{- define "multicast.labels" -}}
{{ include "studio.labels" . }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "multicast.selectorLabels" -}}
app.kubernetes.io/name: {{ .Values.multicast.name }}
{{ include "studio.selectorLabels" . }}
{{- end }}