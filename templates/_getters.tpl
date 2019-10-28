{{/*
  name : Gets name of current component
  contexts: [ . ]
  usage: {{ include "name" . }}
*/}}
{{- define "name" -}}
{{ .Release.Name }}-{{- default .Chart.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
  chart : Gets chart name of current component
  contexts: [ . ]
  usage: {{ include "chart" . }}
*/}}
{{- define "chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
  configMapName : config map name getter
  contexts: [ . ]
  usage: {{ include "configMapName" . }}
*/}}
{{- define "configMapName" -}}
{{- $name := include "name" . -}}
{{- printf "%s-config" $name -}}
{{- end -}}

{{/*
  cronJobName : cronJobName getter
  contexts: [ . ]
  usage: {{ include "cronJobName" . }}
*/}}
{{- define "cronJobName" -}}
{{- $name := include "name" . -}}
{{- printf "%s-cron-job" $name -}}
{{- end -}}

{{/*
  mountedConfigMapName : mounted config map name getter
  contexts: [ . ]
  usage: {{ include "mountedConfigMapName" . }}
*/}}
{{- define "mountedConfigMapName" -}}
{{- $name := include "name" . -}}
{{- printf "%s-mounted-config" $name -}}
{{- end -}}

{{/*
  envConfigMapName : env config map name getter
  contexts: [ . ]
  usage: {{ include "envConfigMapName" . }}
*/}}
{{- define "envConfigMapName" -}}
{{- $name := include "name" . -}}
{{- printf "%s-env-config" $name -}}
{{- end -}}


{{/*
  secretName : secret name getter
  contexts: [ . ]
  usage: {{ include "secretName" . }}
*/}}
{{- define "secretName" -}}
{{- $name := include "name" . -}}
{{- printf "%s-secret" $name -}}
{{- end -}}

{{/*
  deploymentName : Deployment name getter
  contexts: [ . ]
  usage: {{ include "deploymentName" . }}
*/}}
{{- define "deploymentName" -}}
{{- $name := include "name" . -}}
{{- printf "%s-deployment" $name -}}
{{- end -}}

{{/*
  daemonSetName : DaemonSet name getter
  contexts: [ . ]
  usage: {{ include "daemonSetName" . }}
*/}}
{{- define "daemonSetName" -}}
{{- $name := include "name" . -}}
{{- printf "%s-daemon-set" $name -}}
{{- end -}}

{{/*
  statefulSetName : Statefulset name getter
  contexts: [ . ]
  usage: {{ include "statefulSetName" . }}
*/}}
{{- define "statefulSetName" -}}
{{- $name := include "name" . -}}
{{- printf "%s-stateful-set" $name -}}
{{- end -}}

{{/*
  pvcName : patchlibanalyzer pvc name getter
  contexts: [ . ]
  usage: {{ include "pvcName" . }}
*/}}
{{- define "pvcName" -}}
{{- $name := include "name" . -}}
{{- printf "%s-volume-claim" $name -}}
{{- end -}}

{{/*
  pvName : patchlibanalyzer pv name getter
  contexts: [ . ]
  usage: {{ include "pvName" . }}
*/}}
{{- define "pvName" -}}
{{- $name := include "name" . -}}
{{- printf "%s-persistent-nfs-volume" $name -}}
{{- end -}}


{{/*
  serviceAccountName : serviceAccountName getter
  contexts: [ . ]
  usage: {{ include "serviceAccountName" . }}
*/}}
{{- define "serviceAccountName" -}}
{{- $name := include "name" . -}}
{{- printf "%s-service-account" $name -}}
{{- end -}}

{{/*
  roleName : role name  getter
  contexts: [ . ]
  usage: {{ include "roleName" . }}
*/}}
{{- define "roleName" -}}
{{- $name := include "name" . -}}
{{- printf "%s-role" $name -}}
{{- end -}}

{{/*
  roleBindingName : role binding name  getter
  contexts: [ . ]
  usage: {{ include "roleBindingName" . }}
*/}}
{{- define "roleBindingName" -}}
{{- $name := include "name" . -}}
{{- printf "%s-role-binding" $name -}}
{{- end -}}

{{/*
  clusterRoleName : cluster role name  getter
  contexts: [ . ]
  usage: {{ include "clusterRoleName" . }}
*/}}
{{- define "clusterRoleName" -}}
{{- $name := include "name" . -}}
{{- printf "%s-cluster-role" $name -}}
{{- end -}}

{{/*
  clusterRoleBindingName : cluster role binding name  getter
  contexts: [ . ]
  usage: {{ include "clusterRoleBindingName" . }}
*/}}
{{- define "clusterRoleBindingName" -}}
{{- $name := include "name" . -}}
{{- printf "%s-cluster-role-binding" $name -}}
{{- end -}}

{{/*
  podName : deployment pod name getter
  contexts: [ . ]
  usage: {{ include "podName" . }}
*/}}
{{- define "podName" -}}
{{- $name := include "name" . -}}
{{- printf "%s-pod" $name -}}
{{- end -}}

{{/*
  podDisruptionBudgetName : deployment podDisruptionBudget name getter
  contexts: [ . ]
  usage: {{ include "podDisruptionBudgetName" . }}
*/}}
{{- define "podDisruptionBudgetName" -}}
{{- $name := include "name" . -}}
{{- printf "%s-pod-disruption-budget" $name -}}
{{- end -}}

{{/*
  networkPolicyName : networkPolicyName getter
  contexts: [ . ]
  usage: {{ include "networkPolicyName" . }}
*/}}
{{- define "networkPolicyName" -}}
{{- $name := include "name" . -}}
{{- printf "%s-network-policy" $name -}}
{{- end -}}

{{/*
  horizontalPodAutoScalerName : horizontalPodAutoScalerName getter
  contexts: [ . ]
  usage: {{ include "horizontalPodAutoScalerName" . }}
*/}}
{{- define "horizontalPodAutoScalerName" -}}
{{- $name := include "name" . -}}
{{- printf "%s-horizontal-pod-auto-scaler" $name -}}
{{- end -}}

{{/*
  verticalPodAutoScaler : verticalPodAutoScaler getter
  contexts: [ . ]
  usage: {{ include "verticalPodAutoScaler" . }}
*/}}
{{- define "verticalPodAutoScaler" -}}
{{- $name := include "name" . -}}
{{- printf "%s-vertical-pod-auto-scaler" $name -}}
{{- end -}}

{{/*
  podSecurityPolicyName : podSecurityPolicyName getter
  contexts: [ . ]
  usage: {{ include "podSecurityPolicyName" . }}
*/}}
{{- define "podSecurityPolicyName" -}}
{{- $name := include "name" . -}}
{{- printf "%s-pod-security-policy" $name -}}
{{- end -}}

{{/*
  headlessServiceName : headlessServiceName getter
  contexts: [ . ]
  usage: {{ include "headlessServiceName" . }}
*/}}
{{- define "headlessServiceName" -}}
{{- $name := include "name" . -}}
{{- printf "%s-%s-headless-service" $name .Release.Name -}}
{{- end -}}

{{/*
  priorityClassName : priorityClassName getter
  contexts: [ . ]
  usage: {{ include "priorityClassName" . }}
*/}}
{{- define "priorityClassName" -}}
{{- $name := include "name" . -}}
{{- printf "%s-priority-class" $name -}}
{{- end -}}
