{{/*
Common labels
*/}}
{{- define "cloudbeaver.labels" -}}
helm.sh/chart: {{ include "mysql.chart" . }}
{{ include "cloudbeaver.selectorLabels" . }}
app.kubernetes.io/version: {{ .Values.cloudbeaver.image.tag | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "cloudbeaver.selectorLabels" -}}
app.kubernetes.io/name: mysql-cloudbeaver
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/part-of: {{ .Chart.Name }}
{{- end }}