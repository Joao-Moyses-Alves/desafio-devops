{{/* Define um helper para gerar o nome completo do recurso */}}
{{- define "master-deployment.fullname" -}}
{{- if .Chart }}
{{- if .Release }}
{{- printf "%s-%s" .Release.Name .Chart.Name }}
{{- else }}
{{- printf "%s" .Chart.Name }}
{{- end }}
{{- else }}
{{- printf "default-name" }}
{{- end }}
{{- end }}


{{/* Define um helper para gerar o nome do Chart */}}
{{- define "master-deployment.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/* Define um helper para adicionar labels */}}
{{- define "master-deployment.labels" -}}
{{- with .Values.labels }}
  {{- range $key, $value := . }}
metadata:
  labels:
    {{ $key }}: {{ $value | quote }}
  {{- end }}
{{- end }}
{{- end }}
