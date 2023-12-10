{{/*
Common labels
*/}}
{{- define "insight.labels" -}}
helm.sh/chart: {{ include "redis.chart" . }}
{{ include "insight.selectorLabels" . }}
app.kubernetes.io/version: {{ .Values.insight.image.tag | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "insight.selectorLabels" -}}
app.kubernetes.io/name: redis-insight
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}