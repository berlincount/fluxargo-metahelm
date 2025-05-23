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

{{- define "fluxargo-metahelm.namespace.name" -}}
{{-   default .Release.Name .Values.namespace.name }}
{{- end }}

{{- define "fluxargo-metahelm.repo.name" -}}
{{-   default .Release.Name .Values.repo.name }}
{{- end }}

{{- define "fluxargo-metahelm.repo.chart" -}}
{{-   default .Release.Name .Values.repo.chart }}
{{- end }}

{{- define "fluxargo-metahelm.namespace.argocd" -}}
{{-   default "argocd" .Values.namespace.argocd }}
{{- end }}

{{- define "fluxargo-metahelm.namespace.flux" -}}
{{-   default "flux-system" .Values.namespace.flux }}
{{- end }}

{{- define "fluxargo-metahelm.repo.namespace" -}}
{{-   default "flux-system" .Values.repo.namespace }}
{{- end }}

{{- define "fluxargo-metahelm.argocd_apiversion_application" -}}
{{-   default "v1alpha1" .Values.global.argocd_apiversion_application }}
{{- end }}
{{- define "fluxargo-metahelm.flux_apiversion_helmrelease" -}}
{{-   default "v2beta2" .Values.global.flux_apiversion_helmrelease }}
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
namespace: {{ include "fluxargo-metahelm.namespace.name" . }}
{{- end }}

{{- define "fluxargo-metahelm.argocd_helmurl" -}}
{{-   if not .Values.repo.url -}}
{{-     fail "values needs to define repo.url" }}
{{-   else }}
{{-     .Values.repo.url | trimPrefix "oci://" -}}
{{-   end }}
{{- end }}

{{- define "fluxargo-metahelm.argocd_source" -}}
source:
{{-   if eq .Values.repo.type "gitrepo" }}
  repoURL: {{ .Values.repo.url }}
  path: {{ include "fluxargo-metahelm.repo.chart" . }}
  targetRevision: {{ .Values.repo.revision | quote }}
{{-   else if eq .Values.repo.type "helmrepo" }}
  chart: {{ include "fluxargo-metahelm.repo.chart" . }}
  repoURL: {{ include "fluxargo-metahelm.argocd_helmurl" . }}
  targetRevision: {{ .Values.repo.revision | quote }}
{{-   else if or (eq .Values.repo.type "ocirepo") (not .Values.repo.type) }}
  # FIXME: OCI support in Argo CD is a bit more complicated
  chart: {{ include "fluxargo-metahelm.repo.chart" . }}
  repoURL: {{ include "fluxargo-metahelm.argocd_helmurl" . }}
{{-     if .Values.repo.revision }}
  targetRevision: {{ .Values.repo.revision | quote }}
{{-     end }}
{{-   end }}
  helm:
    releaseName: {{ include "fluxargo-metahelm.argocd_releasename" . }}
{{-   if .Values.values }}
    valuesObject:
{{-     toYaml .Values.values | nindent 6 }}
{{-   else if .Values.valuesFrom }}
    # FIXME: external valuesFrom broken just now. oops.
{{-   else }}
{{-   end }}
{{- end }}

{{- define "fluxargo-metahelm.flux_chart" -}}
chart:
  spec:
{{-   if eq .Values.repo.type "gitrepo" }}
    chart: {{ include "fluxargo-metahelm.repo.chart" . }}
    sourceRef:
      kind: GitRepository
      name: {{ include "fluxargo-metahelm.repo.name" . }}
{{-   else if eq .Values.repo.type "helmrepo" }}
    chart: {{ include "fluxargo-metahelm.repo.chart" . }}
    version: {{ .Values.repo.revision | quote }}
    sourceRef:
      kind: HelmRepository
      name: {{ include "fluxargo-metahelm.repo.name" . }}
{{-   else if or (eq .Values.repo.type "ocirepo") (not .Values.repo.type) }}
    chartRef:
      kind: OCIRepository
      name: {{ include "fluxargo-metahelm.repo.name" . }}
{{-   else }}
{{-   end }}
{{-   if .Values.repo.interval }}
    interval: {{ .Values.repo.interval }}
{{-   end }}
{{- end }}

{{- define "fluxargo-metahelm.flux_values" -}}
{{-   if .Values.values -}}
values:
{{-     toYaml .Values.values | nindent 2 }}
{{-   else if .Values.valuesFrom -}}
valuesFrom:
{{-     toYaml .Values.valuesFrom | nindent 2 }}
{{-   end }}
{{- end }}

{{- define "fluxargo-metahelm.flux_release_interval" -}}
{{-   default "10m" .Values.flux_release_interval }}
{{- end }}

{{- define "fluxargo-metahelm.flux_release_suspend" -}}
{{-   default "false" "false" }}
{{- end }}

{{- define "fluxargo-metahelm.flux_interval" -}}
{{-   default "10m" .Values.repo.flux_interval }}
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
