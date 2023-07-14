
{{- define "egress.name" -}}
{{- .Chart.Name }}
{{- end }}

{{- define "egress.fullname" -}}
{{- printf "%s-egress" .Release.Name | trunc 63 | trimSuffix "-" }}
{{- end }}


{{- define "egress.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}


{{- define "egress.labels" -}}
helm.sh/chart: {{ include "egress.chart" . }}
{{ include "egress.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}


{{- define "egress.selectorLabels" -}}
app.kubernetes.io/name: {{ include "egress.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}
