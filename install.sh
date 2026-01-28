#!/bin/bash

# --- CONFIGURAÇÃO ---
GITHUB_USER="cristofer-martins"
REPO_NAME="AD_status"
TAG_VERSION="v1.0.0" 

# Caminho do GLPI (ajuste se necessário, padrão é /var/www/html/glpi)
GLPI_PATH="/var/www/html/glpi"
PLUGIN_DIR="$GLPI_PATH/plugins"
# --------------------

echo "🔍 Verificando versão do GLPI..."

# Detecta a versão via console do GLPI
if [ ! -f "$GLPI_PATH/bin/console" ]; then
    echo "❌ Erro: GLPI não encontrado em $GLPI_PATH"
    exit 1
fi

# Extrai o número da versão
VERSION_FULL=$(php $GLPI_PATH/bin/console --version | awk '{print $2}')
MAJOR_VERSION=$(echo $VERSION_FULL | cut -d. -f1)

echo "✅ Versão detectada: $VERSION_FULL (Major: $MAJOR_VERSION)"

# Define qual arquivo baixar
if [ "$MAJOR_VERSION" -ge "11" ]; then
    FILE_NAME="adstatus_glpi11.zip"
    echo "🚀 Modo GLPI 11+ ativado. Baixando versão moderna (Twig)..."
elif [ "$MAJOR_VERSION" -eq "10" ]; then
    FILE_NAME="adstatus_glpi10.zip"
    echo "🔧 Modo GLPI 10 ativado. Baixando versão standard..."
else
    echo "⚠️ Versão não suportada ou muito antiga."
    exit 1
fi

# Monta a URL usando as variáveis do topo (Melhor prática)
URL="https://github.com/$GITHUB_USER/$REPO_NAME/releases/download/$TAG_VERSION/$FILE_NAME"

# Entra na pasta de plugins
cd $PLUGIN_DIR

# Download
echo "⬇️ Baixando $URL..."
wget -q --show-progress -O adstatus.zip "$URL"

if [ $? -ne 0 ]; then
    echo "❌ Erro no download. Verifique se o repo '$REPO_NAME' e a tag '$TAG_VERSION' existem."
    exit 1
fi

# Instalação
echo "📦 Extraindo..."
unzip -o adstatus.zip
rm adstatus.zip

# Permissões (Padrão www-data)
echo "🔒 Ajustando permissões..."
chown -R www-data:www-data "$PLUGIN_DIR/adstatus"

# Ativação via Console
echo "🔌 Instalando e Ativando plugin..."
php $GLPI_PATH/bin/console glpi:plugin:install -f adstatus
php $GLPI_PATH/bin/console glpi:plugin:activate adstatus

echo "✅ Sucesso! O plugin AD Status está rodando."