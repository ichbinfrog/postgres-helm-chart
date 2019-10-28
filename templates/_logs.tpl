{{/*
  logFunctions : generic logging function
  contexts: [ . ]
  usage: {{ include "logFunctions" . }}
*/}}

{{- define "logFunctions" -}}
_log() {
  echo `date "+%Y:%m:%d-%H:%M:%S"` "[$CHART_NAME|$LOG_ORIGIN]" "$1": "$2"
}

_error() {
  _log "ERROR" "$1"
}

_info() {
  if [ -z $DEBUG ]; then
    _log "INFO" "$1"
  fi
}
{{- end -}}
