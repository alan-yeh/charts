{{- define "xunlei.fullname" -}}
{{- printf .Release.Name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "xunlei.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}


{{/*
Common labels
*/}}
{{- define "xunlei.labels" -}}
helm.sh/chart: {{ include "xunlei.chart" . }}
{{ include "xunlei.selectorLabels" . }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service | quote }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "xunlei.selectorLabels" -}}
app.kubernetes.io/name: {{ .Chart.Name | quote }}
app.kubernetes.io/instance: {{ .Release.Name | quote }}
{{- end }}