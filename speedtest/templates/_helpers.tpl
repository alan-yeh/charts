{{/*
    当前实例的唯一标识
*/}}
{{- define "global.identity" -}}
{{- printf "%s" .Release.Name | sha1sum | trunc 5 }}
{{- end }}

{{/*
    当前实例的名字
*/}}
{{- define "global.name" -}}
{{- printf "%s" .Chart.Name }}
{{- end }}

{{/*
   当前包的名字和版本号
*/}}
{{- define "global.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
    当前实例的通用标签
*/}}
{{- define "global.labels" -}}
helm.sh/chart: {{ include "global.chart" . }}
{{ include "global.selectorLabels" . }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service | quote }}
{{- end }}

{{/*
    当前实例的选择标签
*/}}
{{- define "global.selectorLabels" -}}
app.kubernetes.io/name: {{ include "global.name" . }}
app.kubernetes.io/instance: {{ .Release.Name | quote }}
{{- end }}