#!/bin/bash

# Script de instalación de zsh y oh-my-zsh
# Detecta automáticamente la distribución de Linux

set -e

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  Instalador de zsh y oh-my-zsh${NC}"
echo -e "${GREEN}========================================${NC}\n"

# Detectar distribución de Linux
detect_distro() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        OS=$ID
        VER=$VERSION_ID
        echo -e "${YELLOW}Distribución detectada: $PRETTY_NAME${NC}\n"
    else
        echo -e "${RED}No se pudo detectar la distribución de Linux${NC}"
        exit 1
    fi
}

# Instalar zsh según la distribución
install_zsh() {
    echo -e "${GREEN}Instalando zsh...${NC}"

    case $OS in
        ubuntu|debian|linuxmint|pop)
            sudo apt update
            sudo apt install -y zsh curl git
            ;;
        fedora|rhel|centos)
            sudo dnf install -y zsh curl git
            ;;
        arch|manjaro)
            sudo pacman -Sy --noconfirm zsh curl git
            ;;
        opensuse|opensuse-leap|opensuse-tumbleweed)
            sudo zypper install -y zsh curl git
            ;;
        alpine)
            sudo apk add zsh curl git
            ;;
        *)
            echo -e "${RED}Distribución no soportada: $OS${NC}"
            echo -e "${YELLOW}Por favor, instala zsh manualmente${NC}"
            exit 1
            ;;
    esac

    echo -e "${GREEN}✓ zsh instalado correctamente${NC}\n"
}

# Verificar si zsh ya está instalado
check_zsh() {
    if command -v zsh &> /dev/null; then
        ZSH_VERSION=$(zsh --version)
        echo -e "${GREEN}✓ zsh ya está instalado: $ZSH_VERSION${NC}\n"
        return 0
    else
        return 1
    fi
}

# Verificar e instalar fuentes necesarias
install_fonts() {
    echo -e "${GREEN}========================================${NC}"
    echo -e "${GREEN}  Verificando fuentes${NC}"
    echo -e "${GREEN}========================================${NC}\n"

    echo -e "${YELLOW}Las fuentes con soporte de iconos son necesarias para:${NC}"
    echo -e "  • Powerlevel10k theme"
    echo -e "  • Iconos y símbolos especiales en oh-my-zsh"
    echo -e "  • Mejor experiencia visual\n"

    # Verificar si existen fuentes Nerd Fonts o Powerline
    FONTS_DIR="$HOME/.local/share/fonts"
    SYSTEM_FONTS_DIR="/usr/share/fonts"
    HAS_NERD_FONTS=false

    if fc-list | grep -i "nerd\|powerline\|meslo" &> /dev/null; then
        echo -e "${GREEN}✓ Se detectaron fuentes con soporte de iconos instaladas${NC}\n"
        HAS_NERD_FONTS=true
    else
        echo -e "${YELLOW}⚠ No se detectaron fuentes con soporte de iconos${NC}\n"
    fi

    # Preguntar si desea instalar fuentes
    if [ "$HAS_NERD_FONTS" = false ]; then
        echo -e "${YELLOW}Se recomienda instalar fuentes para aprovechar todas las características${NC}"
        read -p "¿Deseas instalar fuentes con soporte de iconos? (s/n): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Ss]$ ]]; then
            echo -e "${YELLOW}Continuando sin instalar fuentes...${NC}\n"
            return 0
        fi
    else
        read -p "¿Deseas instalar fuentes adicionales recomendadas? (s/n): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Ss]$ ]]; then
            echo -e "${GREEN}Continuando con las fuentes actuales${NC}\n"
            return 0
        fi
    fi

    echo -e "\n${GREEN}Instalando fuentes...${NC}\n"

    # Instalar fuentes según la distribución
    case $OS in
        ubuntu|debian|linuxmint|pop)
            echo -e "${YELLOW}Instalando fonts-powerline y fontconfig...${NC}"
            sudo apt install -y fonts-powerline fontconfig
            ;;
        fedora|rhel|centos)
            echo -e "${YELLOW}Instalando powerline-fonts y fontconfig...${NC}"
            sudo dnf install -y powerline-fonts fontconfig
            ;;
        arch|manjaro)
            echo -e "${YELLOW}Instalando powerline-fonts y fontconfig...${NC}"
            sudo pacman -S --noconfirm --needed powerline-fonts fontconfig
            ;;
        opensuse|opensuse-leap|opensuse-tumbleweed)
            echo -e "${YELLOW}Instalando powerline-fonts y fontconfig...${NC}"
            sudo zypper install -y powerline-fonts fontconfig
            ;;
        alpine)
            echo -e "${YELLOW}Instalando fontconfig...${NC}"
            sudo apk add fontconfig
            ;;
    esac

    # Instalar MesloLGS NF (recomendada por powerlevel10k)
    echo -e "\n${YELLOW}Instalando MesloLGS NF (recomendada para powerlevel10k)...${NC}"

    mkdir -p "$FONTS_DIR"

    MESLO_FONTS=(
        "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf"
        "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf"
        "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf"
        "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf"
    )

    for font_url in "${MESLO_FONTS[@]}"; do
        font_name=$(basename "$font_url" | sed 's/%20/ /g')
        if [ ! -f "$FONTS_DIR/$font_name" ]; then
            echo -e "  Descargando: $font_name"
            curl -fsSL "$font_url" -o "$FONTS_DIR/$font_name"
        else
            echo -e "${GREEN}  ✓ $font_name ya existe${NC}"
        fi
    done

    # Actualizar caché de fuentes
    echo -e "\n${YELLOW}Actualizando caché de fuentes...${NC}"
    fc-cache -f -v &> /dev/null

    echo -e "${GREEN}✓ Fuentes instaladas correctamente${NC}\n"

    echo -e "${YELLOW}========================================${NC}"
    echo -e "${YELLOW}  IMPORTANTE: Configuración del terminal${NC}"
    echo -e "${YELLOW}========================================${NC}"
    echo -e "Para ver los iconos correctamente, configura tu terminal para usar:"
    echo -e "  ${GREEN}• MesloLGS NF${NC} (recomendada)"
    echo -e "  ${GREEN}• Cualquier Nerd Font${NC}"
    echo -e "\nEn la mayoría de terminales:"
    echo -e "  1. Preferencias → Perfil → Fuente"
    echo -e "  2. Selecciona 'MesloLGS NF Regular'"
    echo -e "${YELLOW}========================================${NC}\n"

    read -p "Presiona ENTER para continuar..."
    echo
}

# Instalar oh-my-zsh
install_oh_my_zsh() {
    echo -e "${GREEN}Instalando oh-my-zsh...${NC}"

    if [ -d "$HOME/.oh-my-zsh" ]; then
        echo -e "${YELLOW}oh-my-zsh ya está instalado${NC}"
        read -p "¿Deseas reinstalarlo? (s/n): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Ss]$ ]]; then
            rm -rf "$HOME/.oh-my-zsh"
        else
            echo -e "${YELLOW}Omitiendo instalación de oh-my-zsh${NC}\n"
            return 0
        fi
    fi

    # Instalar oh-my-zsh sin cambiar el shell automáticamente
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

    echo -e "${GREEN}✓ oh-my-zsh instalado correctamente${NC}\n"
}

# Instalar plugins populares
install_plugins() {
    echo -e "${GREEN}Instalando plugins populares de zsh...${NC}\n"

    ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

    # zsh-autosuggestions
    if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
        echo -e "${YELLOW}Instalando zsh-autosuggestions...${NC}"
        git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
        echo -e "${GREEN}✓ zsh-autosuggestions instalado${NC}\n"
    else
        echo -e "${GREEN}✓ zsh-autosuggestions ya está instalado${NC}\n"
    fi

    # zsh-syntax-highlighting
    if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
        echo -e "${YELLOW}Instalando zsh-syntax-highlighting...${NC}"
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
        echo -e "${GREEN}✓ zsh-syntax-highlighting instalado${NC}\n"
    else
        echo -e "${GREEN}✓ zsh-syntax-highlighting ya está instalado${NC}\n"
    fi

    # zsh-completions
    if [ ! -d "$ZSH_CUSTOM/plugins/zsh-completions" ]; then
        echo -e "${YELLOW}Instalando zsh-completions...${NC}"
        git clone https://github.com/zsh-users/zsh-completions "$ZSH_CUSTOM/plugins/zsh-completions"
        echo -e "${GREEN}✓ zsh-completions instalado${NC}\n"
    else
        echo -e "${GREEN}✓ zsh-completions ya está instalado${NC}\n"
    fi

    # powerlevel10k theme
    if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
        echo -e "${YELLOW}Instalando tema powerlevel10k...${NC}"
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
        echo -e "${GREEN}✓ powerlevel10k instalado${NC}\n"
    else
        echo -e "${GREEN}✓ powerlevel10k ya está instalado${NC}\n"
    fi
}

# Configurar .zshrc con los plugins
configure_zshrc() {
    echo -e "${GREEN}Configurando .zshrc...${NC}"

    ZSHRC="$HOME/.zshrc"

    if [ ! -f "$ZSHRC" ]; then
        echo -e "${RED}No se encontró .zshrc${NC}"
        return 1
    fi

    # Backup del .zshrc original
    cp "$ZSHRC" "$ZSHRC.backup.$(date +%Y%m%d_%H%M%S)"
    echo -e "${YELLOW}Backup creado: $ZSHRC.backup.$(date +%Y%m%d_%H%M%S)${NC}"

    # Actualizar plugins en .zshrc
    if grep -q "^plugins=" "$ZSHRC"; then
        sed -i 's/^plugins=.*/plugins=(git zsh-autosuggestions zsh-syntax-highlighting zsh-completions docker kubectl sudo colorize)/' "$ZSHRC"
        echo -e "${GREEN}✓ Plugins actualizados en .zshrc${NC}"
    fi

    # Agregar configuración para zsh-completions
    if ! grep -q "fpath+=\${ZSH_CUSTOM" "$ZSHRC"; then
        sed -i '/^source \$ZSH\/oh-my-zsh.sh/i \
# zsh-completions configuration\
fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src\
' "$ZSHRC"
        echo -e "${GREEN}✓ Configuración de zsh-completions agregada${NC}"
    fi

    # Preguntar si desea usar powerlevel10k
    echo
    read -p "¿Deseas usar el tema powerlevel10k? (s/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Ss]$ ]]; then
        sed -i 's/^ZSH_THEME=.*/ZSH_THEME="powerlevel10k\/powerlevel10k"/' "$ZSHRC"
        echo -e "${GREEN}✓ Tema powerlevel10k activado${NC}"
        echo -e "${YELLOW}Al iniciar zsh por primera vez, se ejecutará el asistente de configuración de powerlevel10k${NC}"
    fi

    echo -e "${GREEN}✓ Configuración completada${NC}\n"
}

# Cambiar shell por defecto a zsh
change_default_shell() {
    CURRENT_SHELL=$(echo $SHELL)
    ZSH_PATH=$(which zsh)

    if [ "$CURRENT_SHELL" = "$ZSH_PATH" ]; then
        echo -e "${GREEN}✓ zsh ya es tu shell por defecto${NC}\n"
    else
        echo -e "${YELLOW}Shell actual: $CURRENT_SHELL${NC}"
        echo -e "${YELLOW}Cambiando shell por defecto a zsh...${NC}"

        # Cambiar shell automáticamente
        if chsh -s "$ZSH_PATH"; then
            echo -e "${GREEN}✓ Shell cambiado a zsh${NC}"
            echo -e "${YELLOW}Por favor, cierra sesión y vuelve a entrar para aplicar los cambios${NC}\n"
        else
            echo -e "${RED}✗ Error al cambiar el shell${NC}"
            echo -e "${YELLOW}Intenta manualmente con: chsh -s $(which zsh)${NC}\n"
        fi
    fi
}

# Función principal
main() {
    detect_distro

    if ! check_zsh; then
        install_zsh
    fi

    install_fonts
    install_oh_my_zsh
    install_plugins
    configure_zshrc
    change_default_shell

    echo -e "${GREEN}========================================${NC}"
    echo -e "${GREEN}  ¡Instalación completada!${NC}"
    echo -e "${GREEN}========================================${NC}"
    echo -e "\n${YELLOW}Plugins instalados:${NC}"
    echo -e "  • zsh-autosuggestions (sugerencias basadas en el historial)"
    echo -e "  • zsh-syntax-highlighting (resaltado de sintaxis)"
    echo -e "  • zsh-completions (autocompletados adicionales)"
    echo -e "  • powerlevel10k (tema moderno y rápido)"
    echo -e "\n${YELLOW}Plugins adicionales activados:${NC}"
    echo -e "  • git, docker, kubectl, sudo, colorize"
    echo -e "\nPara empezar a usar zsh ejecuta: ${YELLOW}zsh${NC}"
    echo -e "O cierra sesión y vuelve a entrar si cambiaste el shell por defecto\n"
}

# Ejecutar script
main
