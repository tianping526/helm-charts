{{/*
Expand the name of the chart.
*/}}
{{- define "eventbridge.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "eventbridge.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "eventbridge.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
EventBridge Service Common labels
*/}}
{{- define "eventbridge.serviceLabels" -}}
helm.sh/chart: {{ include "eventbridge.chart" . }}
{{ include "eventbridge.serviceSelectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
EventBridge Job Common labels
*/}}
{{- define "eventbridge.jobLabels" -}}
helm.sh/chart: {{ include "eventbridge.chart" . }}
{{ include "eventbridge.jobSelectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
EventBridge Service Selector labels
*/}}
{{- define "eventbridge.serviceSelectorLabels" -}}
app.kubernetes.io/name: {{ include "eventbridge.name" . }}-service
app.kubernetes.io/instance: {{ .Release.Name }}-service
{{- end }}

{{/*
EventBridge Job Selector labels
*/}}
{{- define "eventbridge.jobSelectorLabels" -}}
app.kubernetes.io/name: {{ include "eventbridge.name" . }}-job
app.kubernetes.io/instance: {{ .Release.Name }}-job
{{- end }}

{{/*
Create the name of the service account used by the EventBridge service
*/}}
{{- define "eventbridge.serviceServiceAccountName" -}}
{{- if .Values.ebService.serviceAccount.create }}
{{- default (printf "%s-service" (include "eventbridge.fullname" .)) .Values.ebService.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.ebService.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the name of the service account used by the EventBridge Job
*/}}
{{- define "eventbridge.jobServiceAccountName" -}}
{{- if .Values.ebJob.serviceAccount.create }}
{{- default (printf "%s-job" (include "eventbridge.fullname" .)) .Values.ebJob.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.ebJob.serviceAccount.name }}
{{- end }}
{{- end }}

{{/* Get PodDisruptionBudget API Version */}}
{{- define "eventbridge.pdb.apiVersion" -}}
  {{- if and (.Capabilities.APIVersions.Has "policy/v1") (semverCompare ">= 1.21-0" .Capabilities.KubeVersion.Version) -}}
      {{- print "policy/v1" -}}
  {{- else -}}
    {{- print "policy/v1beta1" -}}
  {{- end -}}
{{- end -}}