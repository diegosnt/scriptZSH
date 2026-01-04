# Instalador de zsh y oh-my-zsh

Script automatizado para instalar y configurar zsh con oh-my-zsh y los plugins más populares.

## Características

### Detección automática de distribución
- Ubuntu/Debian/Linux Mint/Pop!_OS/MX Linux
- Fedora/RHEL/CentOS
- Arch/Manjaro
- openSUSE
- Alpine Linux

### Instalación completa
- ✓ zsh (Z Shell)
- ✓ Fuentes con soporte de iconos (Nerd Fonts)
- ✓ oh-my-zsh (framework de configuración)
- ✓ Plugins populares
- ✓ Tema powerlevel10k (opcional)

## Fuentes con soporte de iconos

El script **verifica e instala automáticamente** las fuentes necesarias antes de instalar oh-my-zsh:

### Fuentes instaladas
- **Powerline Fonts**: Fuentes del sistema con soporte básico de iconos
- **MesloLGS NF**: Fuente Nerd Font recomendada por powerlevel10k
  - Regular, Bold, Italic, Bold Italic

### Detección inteligente
- ✓ Detecta si ya tienes fuentes Nerd Fonts o Powerline instaladas
- ✓ Pregunta antes de instalar si ya existen fuentes
- ✓ Instala automáticamente según tu distribución de Linux
- ✓ Descarga MesloLGS NF directamente del repositorio oficial de powerlevel10k

### Configuración del terminal
El script te recordará configurar tu terminal para usar las fuentes instaladas:
1. Abre las preferencias de tu terminal
2. Ve a Perfil → Fuente
3. Selecciona **MesloLGS NF Regular** (recomendada)

### Terminales soportados
- GNOME Terminal
- Konsole
- Alacritty
- Kitty
- iTerm2 (macOS)
- Windows Terminal
- Y la mayoría de terminales modernas

## Plugins incluidos

### Plugins principales
- **zsh-autosuggestions**: Sugerencias de comandos basadas en el historial
- **zsh-syntax-highlighting**: Resaltado de sintaxis en tiempo real
- **zsh-completions**: Autocompletados adicionales para múltiples comandos

### Plugins oh-my-zsh activados
- **git**: Alias y funciones para git
- **docker**: Autocompletado para Docker
- **kubectl**: Autocompletado para Kubernetes
- **sudo**: Doble ESC para agregar sudo al comando anterior
- **colorize**: Resaltado de sintaxis para archivos con cat

### Tema
- **powerlevel10k**: Tema moderno, rápido y altamente personalizable

## Archivos incluidos

- **install-zsh.sh**: Script principal de instalación
- **verify-installation.sh**: Verificador de instalación
- **FONTS_GUIDE.md**: Guía detallada de configuración de fuentes
- **README.md**: Este archivo

## Uso

### Instalación
```bash
chmod +x install-zsh.sh
./install-zsh.sh
```

### Verificar instalación
Después de instalar, puedes verificar que todo esté correcto:
```bash
./verify-installation.sh
```

Este script verificará:
- ✓ Instalación de zsh
- ✓ Instalación de oh-my-zsh
- ✓ Plugins instalados
- ✓ Fuentes con soporte de iconos
- ✓ Configuración del .zshrc
- ✓ Shell por defecto
- ✓ Test visual de iconos

### Proceso interactivo
El script te guiará paso a paso:
1. Detecta tu distribución de Linux
2. Instala zsh y dependencias
3. **Verifica e instala fuentes con soporte de iconos**
   - Detecta fuentes Nerd Fonts existentes
   - Instala Powerline Fonts y MesloLGS NF
   - Actualiza el caché de fuentes
   - Muestra instrucciones para configurar el terminal
4. Instala oh-my-zsh
5. Descarga e instala los plugins
6. Configura tu archivo .zshrc (crea backup automático)
7. Pregunta si deseas usar powerlevel10k
8. Pregunta si deseas cambiar zsh como shell por defecto

## Características de seguridad

- ✓ Crea backup automático del .zshrc antes de modificarlo
- ✓ Detecta instalaciones existentes
- ✓ Solicita confirmación para cambios importantes
- ✓ Instalación sin necesidad de cambiar shell automáticamente

## Post-instalación

### Primera ejecución
```bash
zsh
```

Si instalaste powerlevel10k, se ejecutará automáticamente el asistente de configuración.

### Personalización

El archivo de configuración está en `~/.zshrc`. Puedes editarlo para:
- Agregar más plugins
- Cambiar el tema
- Personalizar alias
- Ajustar configuraciones

### Restaurar configuración anterior
Si algo sale mal, puedes restaurar el backup:
```bash
cp ~/.zshrc.backup.YYYYMMDD_HHMMSS ~/.zshrc
```

## Plugins - Uso rápido

### zsh-autosuggestions
Escribe un comando y verás sugerencias en gris. Presiona `→` (flecha derecha) para aceptar.

### zsh-syntax-highlighting
Los comandos válidos aparecen en verde, los inválidos en rojo.

### sudo plugin
Presiona `ESC` dos veces para agregar `sudo` al inicio del comando actual.

### git aliases
```bash
gst    # git status
gaa    # git add --all
gcmsg  # git commit -m
gp     # git push
gl     # git pull
```

## Requisitos

- Sistema operativo Linux (distribuciones soportadas)
- Acceso a internet
- Permisos de sudo
- Dependencias (se instalan automáticamente):
  - curl, git
  - fontconfig (para gestión de fuentes)
  - fonts-powerline o powerline-fonts (según la distro)

## Solución de problemas

### El tema no se ve correctamente o aparecen símbolos raros
El script ya instala las fuentes necesarias, pero debes **configurar tu terminal**:

1. **Verifica que las fuentes estén instaladas:**
```bash
fc-list | grep -i "meslo\|nerd\|powerline"
```

2. **Configura tu terminal para usar MesloLGS NF:**
   - **GNOME Terminal**: Preferencias → Perfil → Texto → Fuente personalizada → MesloLGS NF Regular
   - **Konsole**: Configuración → Editar perfil actual → Apariencia → Fuente → MesloLGS NF Regular
   - **Alacritty**: Edita `~/.config/alacritty/alacritty.yml`:
     ```yaml
     font:
       normal:
         family: MesloLGS NF
     ```
   - **Kitty**: Edita `~/.config/kitty/kitty.conf`:
     ```
     font_family MesloLGS NF
     ```

3. **Si sigues teniendo problemas, reinstala las fuentes:**
```bash
# Elimina el caché
rm -rf ~/.cache/fontconfig

# Actualiza el caché
fc-cache -f -v
```

**Para instrucciones detalladas de configuración por terminal, consulta:**
```bash
cat FONTS_GUIDE.md
```

### Los colores no funcionan
Verifica que tu terminal soporte 256 colores:
```bash
echo $TERM
```

### Restaurar shell anterior
```bash
chsh -s /bin/bash
```

## Licencia

Este script es de uso libre y puede ser modificado según tus necesidades.
