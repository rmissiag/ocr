#!/bin/bash

BROWSER="firefox"  # Altere para outro se preferir
# Habilitar modo "strict" para tratar erros
set -euo pipefail

# Caminho temporário para salvar a captura de tela
TEMP_IMAGE=`mktemp /tmp/gnome_tesseract_XXXXXX.png`
TEMP_TEXT=`mktemp /tmp/gnome_tesseract_XXXXXX.txt`

# Função para limpar o arquivo temporário ao encerrar o script
cleanup() {
    rm -f "${TEMP_IMAGE}" "${TEMP_TEXT}"
}
trap cleanup EXIT

# Capturar a área de seleção da tela usando gnome-screenshot
gnome-screenshot -a -f "${TEMP_IMAGE}"

# Verificar se a captura foi bem-sucedida
if [ -f "${TEMP_IMAGE}" ]; then
    # Executar o tesseract com detecção de texto em português (reconhece também inglês).
    tesseract -l por "${TEMP_IMAGE}" stdout > "${TEMP_TEXT}"

    # Abrir o navegador com o txt gerado
    "${BROWSER}" --new-tab file:///${TEMP_TEXT}
    sleep 3
else
    echo "Erro: Falha ao capturar a tela." >&2
    exit 1
fi

