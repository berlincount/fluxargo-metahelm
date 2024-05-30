{{- define "repo.flux_apiversion_gitrepository" -}}
{{-   default "v1" .Values.global.flux_apiversion_gitrepository }}
{{- end }}
{{- define "repo.flux_apiversion_helmrepository" -}}
{{-   default "v1beta2" .Values.global.flux_apiversion_helmrepository }}
{{- end }}
{{- define "repo.flux_apiversion_ocirepository" -}}
{{-   default "v1beta2" .Values.global.flux_apiversion_ocirepository }}
{{- end }}

{{- define "repo.namespace" -}}
{{-   default "flux-system" .Values.namespace }}
{{- end }}

{{- define "repo.interval" -}}
{{-   default "10m" .Values.interval }}
{{- end }}

{{- define "repo.flux_interval" -}}
{{-   default "10m" .Values.flux_interval }}
{{- end }}

{{- define "repo.labels" -}}
helm.sh/chart: {{ include "repo.chart" . }}
{{-   if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{-   end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "repo.chart" -}}
{{-   printf "%s-%s" "fluxargo-metahelm-repo" .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "repo.name" -}}
{{-   default .Release.Name .Values.name }}
{{- end }}

{{- define "repo.flux_ocireftype" -}}
{{-   if and (not .Values.reftype) (ne .Values.revision "latest") -}}
{{-     fail "value for .Values.reftype needs to be given if revision is not 'latest'" -}}
{{-   else -}}
{{-     if and (and (ne .Values.reftype "tag") (ne .Values.reftype "semver")) (ne .Values.reftype "digest") -}}
{{-       fail "value for OCI .Values.reftype has to be tag/semver/digest" -}}
{{-     end -}}
{{-     default "branch" .Values.reftype -}}
{{-   end -}}
{{- end }}

{{- define "repo.flux_gitreftype" -}}
{{-   if and (not .Values.reftype) (and (ne .Values.revision "master") (ne .Values.revision "main")) -}}
{{-     fail "value for .Values.reftype needs to be given if revision is not 'master' or 'main'" -}}
{{-   else -}}
{{-     if and (and (and (ne .Values.reftype "branch") (ne .Values.reftype "tag")) (and (ne .Values.reftype "semver") (ne .Values.reftype "name")) (ne .Values.reftype "commit")) -}}
{{-       fail "value for git .Values.reftype has to be branch/tag/semver/name/commit" -}}
{{-     end -}}
{{-     default "branch" .Values.reftype -}}
{{-   end -}}
{{- end }}

