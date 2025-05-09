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

log_info "Criando diretórios..."

mkdir -p /publico
mkdir -p /adm
mkdir -p /ven
mkdir -p /sec
log_success "Diretórios criados."

log_info "Criando grupos de usuários..."

getent group GRP_ADM || groupadd GRP_ADM
getent group GRP_VEN || groupadd GRP_VEN
getent group GRP_SEC || groupadd GRP_SEC
log_success "Grupos criados (ou já existentes)."

log_info "Criando usuários..."

create_user() {
  local USERNAME=$1
  local GROUP=$2

  if id "$USERNAME" &>/dev/null; then
    log_warn "Usuário $USERNAME já existe. Pulando..."
  else
    useradd "$USERNAME" -m -s /bin/bash -p "$(openssl passwd -6 Mudar123)" -g "$GROUP"
    passwd -e "$USERNAME"
    log_success "Usuário $USERNAME criado e adicionado ao grupo $GROUP."
  fi
}

create_user carlos GRP_ADM
create_user maria GRP_ADM
create_user joao GRP_ADM

create_user debora GRP_VEN
create_user sebastiana GRP_VEN
create_user roberto GRP_VEN

create_user josefina GRP_SEC
create_user amanda GRP_SEC
create_user rogerio GRP_SEC

log_info "Especificando permissões dos diretórios..."

chown root:GRP_ADM /adm
chown root:GRP_VEN /ven
chown root:GRP_SEC /sec

chmod 770 /adm
chmod 770 /ven
chmod 770 /sec
chmod 777 /publico

log_success "Permissões definidas com sucesso."

log_success "Script finalizado com sucesso!"

