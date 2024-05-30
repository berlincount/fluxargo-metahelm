{{- define "namespace.name" -}}
{{-   default .Release.Name .Values.name }}
{{- end }}

{{- define "namespace.labels" -}}
helm.sh/chart: {{ include "namespace.chart" . }}
{{-   if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{-   end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "namespace.chart" -}}
{{-   printf "%s-%s" "fluxargo-metahelm-namespace" .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}
