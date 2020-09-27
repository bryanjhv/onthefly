#!/bin/bash

# Verificar binarios requeridos
for bin in dirname readlink find basename s3cmd; do
	if ! hash $bin 2>/dev/null; then
		echo >&2 "ERROR: Comando '$bin' no existe."
		exit 1
	fi
done

# Entrar en la carpeta del script
cd "$(dirname "$(readlink -f "$0")")" || {
	echo >&2 "ERROR: No se pudo entrar a carpeta."
	exit 1
}

# Verificar argumentos pasados
if [[ $# -lt 1 ]]; then
	echo >&2 "ERROR: Parámetro NAMESPACE no especificado."
	exit 1
fi
NAMESPACE=$1
echo "INFO: Usando NAMESPACE '$NAMESPACE'."

# Ejecutar lógica principal
find . -type f -iname '*.mp4' -print0 |
	while read -rd $'\0' archivo; do
		echo "INFO: Subiendo '$archivo' a '$NAMESPACE'."
		s3cmd -q put "$archivo" "s3://$NAMESPACE/$(basename "$archivo")"
	done
