{{- define "nexus.fullname" -}}
{{- printf .Release.Name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "nexus.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}


{{/*
Common labels
*/}}
{{- define "nexus.labels" -}}
helm.sh/chart: {{ include "nexus.chart" . }}
{{ include "nexus.selectorLabels" . }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service | quote }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "nexus.selectorLabels" -}}
app.kubernetes.io/name: {{ .Chart.Name | quote }}
app.kubernetes.io/instance: {{ .Release.Name | quote }}
{{- end }}