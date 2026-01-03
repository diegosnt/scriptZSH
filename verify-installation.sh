#!/bin/bash

# Script de verificación de instalación de zsh, oh-my-zsh y fuentes

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  Verificación de instalación${NC}"
echo -e "${BLUE}========================================${NC}\n"

# Contador de problemas
ISSUES=0

# Verificar zsh
echo -e "${YELLOW}Verificando zsh...${NC}"
if command -v zsh &> /dev/null; then
    ZSH_VER=$(zsh --version)
    echo -e "${GREEN}✓ zsh instalado: $ZSH_VER${NC}"
else
    echo -e "${RED}✗ zsh no está instalado${NC}"
    ((ISSUES++))
fi
echo

# Verificar oh-my-zsh
echo -e "${YELLOW}Verificando oh-my-zsh...${NC}"
if [ -d "$HOME/.oh-my-zsh" ]; then
    echo -e "${GREEN}✓ oh-my-zsh instalado en: $HOME/.oh-my-zsh${NC}"
else
    echo -e "${RED}✗ oh-my-zsh no está instalado${NC}"
    ((ISSUES++))
fi
echo

# Verificar plugins
echo -e "${YELLOW}Verificando plugins...${NC}"
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

plugins=(
    "zsh-autosuggestions"
    "zsh-syntax-highlighting"
    "zsh-completions"
)

for plugin in "${plugins[@]}"; do
    if [ -d "$ZSH_CUSTOM/plugins/$plugin" ]; then
        echo -e "${GREEN}✓ $plugin instalado${NC}"
    else
        echo -e "${RED}✗ $plugin no está instalado${NC}"
        ((ISSUES++))
    fi
done
echo

# Verificar tema powerlevel10k
echo -e "${YELLOW}Verificando tema powerlevel10k...${NC}"
if [ -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
    echo -e "${GREEN}✓ powerlevel10k instalado${NC}"
else
    echo -e "${YELLOW}⚠ powerlevel10k no está instalado (opcional)${NC}"
fi
echo

# Verificar fuentes
echo -e "${YELLOW}Verificando fuentes con soporte de iconos...${NC}"
if command -v fc-list &> /dev/null; then
    if fc-list | grep -qi "meslo.*nf\|nerd"; then
        echo -e "${GREEN}✓ Fuentes Nerd Fonts detectadas${NC}"
        echo -e "${BLUE}Fuentes encontradas:${NC}"
        fc-list | grep -i "meslo.*nf\|nerd" | cut -d: -f2 | sort -u | head -5
    elif fc-list | grep -qi "powerline"; then
        echo -e "${YELLOW}⚠ Solo se encontraron fuentes Powerline (funcionan, pero Nerd Fonts es mejor)${NC}"
    else
        echo -e "${RED}✗ No se detectaron fuentes con soporte de iconos${NC}"
        echo -e "${YELLOW}Ejecuta el script de instalación para instalar las fuentes${NC}"
        ((ISSUES++))
    fi
else
    echo -e "${RED}✗ fontconfig no está instalado${NC}"
    ((ISSUES++))
fi
echo

# Verificar .zshrc
echo -e "${YELLOW}Verificando .zshrc...${NC}"
if [ -f "$HOME/.zshrc" ]; then
    echo -e "${GREEN}✓ .zshrc existe${NC}"

    # Verificar plugins en .zshrc
    if grep -q "plugins=" "$HOME/.zshrc"; then
        echo -e "${GREEN}✓ Plugins configurados en .zshrc${NC}"
        echo -e "${BLUE}Plugins activos:${NC}"
        grep "^plugins=" "$HOME/.zshrc"
    else
        echo -e "${YELLOW}⚠ No se encontró configuración de plugins en .zshrc${NC}"
    fi

    # Verificar tema
    if grep -q "ZSH_THEME=" "$HOME/.zshrc"; then
        THEME=$(grep "^ZSH_THEME=" "$HOME/.zshrc" | cut -d'"' -f2)
        echo -e "${BLUE}Tema configurado: ${GREEN}$THEME${NC}"
    fi
else
    echo -e "${RED}✗ .zshrc no existe${NC}"
    ((ISSUES++))
fi
echo

# Verificar shell por defecto
echo -e "${YELLOW}Verificando shell por defecto...${NC}"
CURRENT_SHELL=$(echo $SHELL)
if [[ "$CURRENT_SHELL" == *"zsh"* ]]; then
    echo -e "${GREEN}✓ zsh es tu shell por defecto: $CURRENT_SHELL${NC}"
else
    echo -e "${YELLOW}⚠ Tu shell actual es: $CURRENT_SHELL${NC}"
    echo -e "${YELLOW}Cambiando shell por defecto a zsh...${NC}"

    # Cambiar shell automáticamente
    ZSH_PATH=$(which zsh)
    if chsh -s "$ZSH_PATH"; then
        echo -e "${GREEN}✓ Shell cambiado a zsh${NC}"
        echo -e "${YELLOW}Por favor, cierra sesión y vuelve a entrar para aplicar los cambios${NC}"
    else
        echo -e "${RED}✗ Error al cambiar el shell${NC}"
        echo -e "${YELLOW}Intenta manualmente con: chsh -s $ZSH_PATH${NC}"
    fi
fi
echo

# Test de visualización de iconos
echo -e "${YELLOW}Test de visualización de iconos...${NC}"
echo -e "${BLUE}Si ves iconos correctamente, tu fuente está bien configurada:${NC}"
echo -e "   \ue0b0 \u00b1 \ue0a0 \u27a6 \u2718 \u26a1 \u2699"
echo -e "${BLUE}Si ves cuadrados o símbolos raros, necesitas configurar la fuente en tu terminal${NC}"
echo -e "${BLUE}Consulta FONTS_GUIDE.md para instrucciones detalladas${NC}"
echo

# Resumen
echo -e "${BLUE}========================================${NC}"
if [ $ISSUES -eq 0 ]; then
    echo -e "${GREEN}✓ Todo está correctamente instalado${NC}"
    echo -e "${GREEN}========================================${NC}\n"
    echo -e "${BLUE}Próximos pasos:${NC}"
    echo -e "1. Configura tu terminal para usar la fuente ${GREEN}MesloLGS NF${NC}"
    echo -e "2. Ejecuta ${GREEN}zsh${NC} para iniciar zsh"
    echo -e "3. Si instalaste powerlevel10k, sigue el asistente de configuración"
    echo -e "\nPara más información sobre configuración de fuentes:"
    echo -e "${YELLOW}cat FONTS_GUIDE.md${NC}\n"
else
    echo -e "${YELLOW}⚠ Se encontraron $ISSUES problema(s)${NC}"
    echo -e "${YELLOW}========================================${NC}\n"
    echo -e "Ejecuta el script de instalación nuevamente para resolver los problemas:"
    echo -e "${GREEN}./install-zsh.sh${NC}\n"
fi
