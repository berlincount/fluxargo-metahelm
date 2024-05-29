{{- define "fluxargo-metahelm.argocd_name" -}}
{{-   default .Release.Name .Values.argocd_name }}
{{- end }}

{{- define "fluxargo-metahelm.flux_name" -}}
{{-   default .Release.Name .Values.flux_name }}
{{- end }}

{{- define "fluxargo-metahelm.argocd_releasename" -}}
{{-   default .Release.Name .Values.argocd_releasename }}
{{- end }}

{{- define "fluxargo-metahelm.flux_releasename" -}}
{{-   default .Release.Name .Values.flux_releasename }}
{{- end }}

{{- define "fluxargo-metahelm.namespace" -}}
{{-   default .Release.Name .Values.namespace }}
{{- end }}

{{- define "fluxargo-metahelm.argocd_namespace" -}}
{{-   default "argocd" .Values.argocd_namespace }}
{{- end }}

{{- define "fluxargo-metahelm.flux_namespace" -}}
{{-   default "flux-system" .Values.flux_namespace }}
{{- end }}

{{- define "fluxargo-metahelm.flux_repo_namespace" -}}
{{-   default "flux-system" .Values.flux_repo_namespace }}
{{- end }}

{{- define "fluxargo-metahelm.argocd_apiversion_application" -}}
{{-   default "v1alpha1" .Values.argocd_apiversion_application }}
{{- end }}
{{- define "fluxargo-metahelm.flux_apiversion_gitrepository" -}}
{{-   default "v1" .Values.flux_apiversion_gitrepository }}
{{- end }}
{{- define "fluxargo-metahelm.flux_apiversion_helmrelease" -}}
{{-   default "v2beta2" .Values.flux_apiversion_helmrelease }}
{{- end }}
{{- define "fluxargo-metahelm.flux_apiversion_helmrepository" -}}
{{-   default "v1beta2" .Values.flux_apiversion_helmrepository }}
{{- end }}
{{- define "fluxargo-metahelm.flux_apiversion_ocirepository" -}}
{{-   default "v1beta2" .Values.flux_apiversion_ocirepository }}
{{- end }}

{{- define "fluxargo-metahelm.flux_repo_ocireftype" -}}
{{-   if and (not .Values.repo.reftype) (ne .Values.repo.revision "latest") -}}
{{-     fail "value for .Values.repo.reftype needs to be given if revision is not 'latest'" -}}
{{-   else -}}
{{-     if and (and (ne .Values.repo.reftype "tag") (ne .Values.repo.reftype "semver")) (ne .Values.repo.reftype "digest") -}}
{{-       fail "value for OCI .Values.repo.reftype has to be tag/semver/digest" -}}
{{-     end -}}
{{-     default "branch" .Values.repo.reftype -}}
{{-   end -}}
{{- end }}

{{- define "fluxargo-metahelm.flux_repo_gitreftype" -}}
{{-   if and (not .Values.repo.reftype) (and (ne .Values.repo.revision "master") (ne .Values.repo.revision "main")) -}}
{{-     fail "value for .Values.repo.reftype needs to be given if revision is not 'master' or 'main'" -}}
{{-   else -}}
{{-     if and (and (and (ne .Values.repo.reftype "branch") (ne .Values.repo.reftype "tag")) (and (ne .Values.repo.reftype "semver") (ne .Values.repo.reftype "name")) (ne .Values.repo.reftype "commit")) -}}
{{-       fail "value for git .Values.repo.reftype has to be branch/tag/semver/name/commit" -}}
{{-     end -}}
{{-     default "branch" .Values.repo.reftype -}}
{{-   end -}}
{{- end }}

{{- define "fluxargo-metahelm.argocd_project" -}}
{{-   default "default" .Values.argocd_project }}
{{- end }}

{{- define "fluxargo-metahelm.argocd_destination" -}}
{{-   if .Values.argocd_destination -}}
server: {{ .Values.argocd_destination }}
{{-   else -}}
name: in-cluster
{{-   end }}
namespace: {{ include "fluxargo-metahelm.namespace" . }}
{{- end }}

{{- define "flugargo-metahelm.argocd_helmurl" -}}
{{-   .Values.repo.url | trimPrefix "oci://" -}}
{{- end }}

{{- define "fluxargo-metahelm.argocd_source" -}}
source:
{{-   if eq .Values.repo.type "gitrepo" }}
  repoURL: {{ .Values.repo.url }}
  path: {{ .Values.repo.chart }}
  targetRevision: {{ .Values.repo.revision | quote }}
{{-   else if eq .Values.repo.type "helmrepo" }}
  chart: {{ .Values.repo.chart }}
  repoURL: {{ include "flugargo-metahelm.argocd_helmurl" . }}
  targetRevision: {{ .Values.repo.revision | quote }}
{{-   else if or (eq .Values.repo.type "ocirepo") (not .Values.repo.type) }}
  chart: {{ .Values.repo.chart }}
  repoURL: {{ include "flugargo-metahelm.argocd_helmurl" . }}
{{-     if .Values.repo.revision }}
  targetRevision: {{ .Values.repo.revision | quote }}
{{-     end }}
{{-   end }}
  helm:
    releaseName: {{ include "fluxargo-metahelm.argocd_releasename" . }}
{{-   if .Values.values }}
    valuesObject:
{{-     toYaml .Values.values | nindent 6 }}
{{-   end }}
{{- end }}

{{- define "fluxargo-metahelm.flux_chart" -}}
chart:
  spec:
{{-   if eq .Values.repo.type "gitrepo" }}
    chart: {{ .Values.repo.chart }}
    sourceRef:
      kind: GitRepository
      name: {{ .Values.repo.name }}
{{-   else if eq .Values.repo.type "helmrepo" }}
    chart: {{ .Values.repo.chart }}
    version: {{ .Values.repo.revision | quote }}
    sourceRef:
      kind: HelmRepository
      name: {{ .Values.repo.name }}
{{-   else if or (eq .Values.repo.type "ocirepo") (not .Values.repo.type) }}
    chartRef:
      kind: OCIRepository
      name: {{ .Values.repo.name }}
{{-   end }}
{{-   if .Values.repo.interval }}
    interval: {{ .Values.repo.interval }}
{{-   end }}
{{- end }}

{{- define "fluxargo-metahelm.flux_values" -}}
{{-   if .Values.values -}}
values:
{{-     toYaml .Values.values | nindent 2 }}
{{-   end }}
{{- end }}

{{- define "fluxargo-metahelm.flux_release_interval" -}}
{{-   default "10m" .Values.flux_release_interval }}
{{- end }}

{{- define "fluxargo-metahelm.flux_release_suspend" -}}
{{-   default "false" "false" }}
{{- end }}

{{- define "fluxargo-metahelm.flux_repo_interval" -}}
{{-   default "10m" .Values.flux_repo_interval }}
{{- end }}

{{- define "fluxargo-metahelm.labels" -}}
helm.sh/chart: {{ include "fluxargo-metahelm.chart" . }}
{{-   if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{-   end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "fluxargo-metahelm.values" -}}
TODO_values:
  this:
    is: it
{{- end }}

{{- define "fluxargo-metahelm.chart" -}}
{{-   printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}
