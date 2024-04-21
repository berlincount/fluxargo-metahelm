{{- define "fluxargo-metahelm.argocd_name" -}}
{{- default .Release.Name .Values.argocd_name }}
{{- end }}

{{- define "fluxargo-metahelm.flux_name" -}}
{{- default .Release.Name .Values.flux_name }}
{{- end }}

{{- define "fluxargo-metahelm.argocd_releasename" -}}
{{- default .Release.Name .Values.argocd_releasename }}
{{- end }}

{{- define "fluxargo-metahelm.flux_releasename" -}}
{{- default .Release.Name .Values.flux_releasename }}
{{- end }}

{{- define "fluxargo-metahelm.namespace" -}}
{{- default .Release.Name .Values.namespace }}
{{- end }}

{{- define "fluxargo-metahelm.argocd_namespace" -}}
{{- default "argo-cd" .Values.argocd_namespace }}
{{- end }}

{{- define "fluxargo-metahelm.flux_namespace" -}}
{{- default "flux-system" .Values.flux_namespace }}
{{- end }}

{{- define "fluxargo-metahelm.argocd_project" -}}
{{- default "default" .Values.argocd_project }}
{{- end }}

{{- define "fluxargo-metahelm.argocd_destination" -}}
{{- if .Values.argocd_destination -}}
server: {{ .Values.argocd_destination }}
{{- else -}}
name: in-cluster
{{- end }}
namespace: {{ include "fluxargo-metahelm.namespace" . }}
{{- end }}

{{- define "fluxargo-metahelm.argocd_source" -}}
source:
{{- if eq .Values.sourcetype "gitrepo" }}
  repoURL: {{ .Values.sourceurl }}
  path: {{ .Values.sourcechart }}
  targetRevision: {{ .Values.sourcerevision }}
{{- else if eq .Values.sourcetype "helmrepo" }}
  chart: {{ .Values.sourcechart }}
  repoURL: {{ .Values.sourceurl }}
  targetRevision: {{ .Values.sourcerevision }}
{{- end }}
  helm:
    releaseName: {{ include "fluxargo-metahelm.argocd_releasename" . }}
{{- if .Values.values }}
    valuesObject:
{{- toYaml .Values.values | nindent 6 }}
{{- end }}
{{- end }}

{{- define "fluxargo-metahelm.flux_chart" -}}
chart:
  spec:
{{- if eq .Values.sourcetype "gitrepo" }}
    chart: {{ .Values.sourcechart }}
    sourceRef:
      kind: GitRepository
      name: {{ .Values.sourcerepo }}
{{- else if eq .Values.sourcetype "helmrepo" }}
    chart: {{ .Values.sourcechart }}
    version: {{ .Values.sourcerevision }}
{{- if .Values.sourceversion }}
    version: {{ .Values.sourceversion }}
{{- end }}
    sourceRef:
      kind: HelmRepository
      name: {{ .Values.sourcerepo }}
{{- end }}
{{- if .Values.sourceinterval }}
    interval: {{ .Values.sourceinterval }}
{{- end }}
{{- end }}

{{- define "fluxargo-metahelm.flux_values" -}}
{{- if .Values.values -}}
values:
{{- toYaml .Values.values | nindent 2 }}
{{- end }}
{{- end }}

{{- define "fluxargo-metahelm.flux_interval" -}}
{{- default "10m" .Values.flux_interval }}
{{- end }}

{{- define "fluxargo-metahelm.flux_timeout" -}}
{{- default "5m" .Values.flux_timeout }}
{{- end }}

{{- define "fluxargo-metahelm.flux_suspend" -}}
{{- default "false" "false" }}
{{- end }}

{{- define "fluxargo-metahelm.labels" -}}
helm.sh/chart: {{ include "fluxargo-metahelm.chart" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "fluxargo-metahelm.values" -}}
TODO_values:
  this:
    is: it
{{- end }}

{{- define "fluxargo-metahelm.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}
