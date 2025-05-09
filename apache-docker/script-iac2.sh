#!/bin/bash

RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
BLUE="\033[1;34m"
NC="\033[0m"

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[OK]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[AVISO]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERRO]${NC} $1"
    exit 1
}

if [ "$EUID" -ne 0 ]; then
    log_error "Este script precisa ser executado como root!"
fi

log_info "Atualizando o sistema..."
apt update && apt upgrade -y && apt autoremove -y && apt autoclean -y || log_error "Falha ao atualizar o sistema."

log_info "Instalando Apache e Unzip..."
apt install -y apache2 unzip || log_error "Falha ao instalar apache2 ou unzip."

if ! command -v wget &> /dev/null; then
    log_warn "wget não encontrado. Instalando..."
    apt install -y wget || log_error "Falha ao instalar wget."
else
    log_success "wget já está instalado."
fi

cd /tmp || log_error "Falha ao acessar /tmp."
log_info "Baixando arquivos do site..."
wget -q https://github.com/denilsonbonatti/linux-site-dio/archive/refs/heads/main.zip || log_error "Falha no download."

log_info "Descompactando arquivos..."
unzip -o main.zip || log_error "Falha ao descompactar."

log_info "Copiando arquivos para /var/www/html/..."
rm -rf /var/www/html/*
cp -R linux-site-dio-main/* /var/www/html/ || log_error "Erro ao copiar arquivos."

log_success "Site provisionado com sucesso!"
log_info "Se você criou uma imagem com nome personalizado (ex: 'servidor-web-iac'), execute: 'docker run -d -p 8080:80 --name site-iac servidor-web-iac'"
log_info "Em seguida, acesse o site no navegador: http://localhost:8080"

