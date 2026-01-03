# Guía de Configuración de Fuentes

Esta guía te ayudará a configurar las fuentes instaladas por el script en diferentes terminales.

## Verificar que las fuentes están instaladas

```bash
# Buscar fuentes Nerd Fonts o Powerline
fc-list | grep -i "meslo\|nerd\|powerline"

# Listar todas las fuentes MesloLGS
fc-list | grep "MesloLGS"
```

Si ves resultados, las fuentes están correctamente instaladas.

## Configuración por Terminal

### GNOME Terminal (Ubuntu, Fedora, etc.)

1. Abre GNOME Terminal
2. Menú → Preferencias (o `Ctrl + ,`)
3. Selecciona tu perfil (usualmente "Unnamed" o "Default")
4. Pestaña "Texto"
5. Marca "Fuente personalizada"
6. Haz clic en el botón de fuente
7. Busca y selecciona **"MesloLGS NF Regular"**
8. Tamaño recomendado: 11-12

### Konsole (KDE)

1. Abre Konsole
2. Configuración → Editar perfil actual
3. Pestaña "Apariencia"
4. Haz clic en "Elegir..." junto a Fuente
5. Selecciona **"MesloLGS NF"**
6. Estilo: Regular
7. Tamaño: 11-12
8. Aplicar → Aceptar

### Alacritty

Edita el archivo de configuración: `~/.config/alacritty/alacritty.yml`

```yaml
font:
  normal:
    family: "MesloLGS NF"
    style: Regular
  bold:
    family: "MesloLGS NF"
    style: Bold
  italic:
    family: "MesloLGS NF"
    style: Italic
  bold_italic:
    family: "MesloLGS NF"
    style: Bold Italic
  size: 11.0
```

Si usas el formato TOML (`alacritty.toml`):

```toml
[font]
size = 11.0

[font.normal]
family = "MesloLGS NF"
style = "Regular"

[font.bold]
family = "MesloLGS NF"
style = "Bold"

[font.italic]
family = "MesloLGS NF"
style = "Italic"

[font.bold_italic]
family = "MesloLGS NF"
style = "Bold Italic"
```

### Kitty

Edita el archivo de configuración: `~/.config/kitty/kitty.conf`

```conf
# Fuente principal
font_family      MesloLGS NF Regular
bold_font        MesloLGS NF Bold
italic_font      MesloLGS NF Italic
bold_italic_font MesloLGS NF Bold Italic

# Tamaño de fuente
font_size 11.0

# Ajustes adicionales para mejor renderizado
disable_ligatures never
```

### Tilix

1. Abre Tilix
2. Preferencias (o `Ctrl + ,`)
3. Perfil → Predeterminado (o tu perfil activo)
4. Pestaña "Apariencia"
5. Fuente personalizada → Activar
6. Selecciona **"MesloLGS NF Regular"**
7. Tamaño: 11

### Terminator

1. Abre Terminator
2. Clic derecho → Preferencias
3. Pestaña "Perfiles"
4. En "General"
5. Desmarca "Usar fuente del sistema"
6. Selecciona **"MesloLGS NF Regular 11"**

### XFCE Terminal

1. Abre XFCE Terminal
2. Editar → Preferencias
3. Pestaña "Apariencia"
4. Fuente: Selecciona **"MesloLGS NF Regular"**
5. Tamaño: 11

### Hyper

Edita el archivo de configuración: `~/.hyper.js`

```javascript
module.exports = {
  config: {
    // otras configuraciones...
    fontFamily: '"MesloLGS NF", monospace',
    fontSize: 11,
  }
}
```

### VS Code Terminal Integrada

Edita la configuración de VS Code (`Ctrl + ,` o `Cmd + ,`):

```json
{
  "terminal.integrated.fontFamily": "MesloLGS NF",
  "terminal.integrated.fontSize": 11
}
```

O directamente en `settings.json`:

```json
{
  "terminal.integrated.fontFamily": "'MesloLGS NF', monospace",
  "terminal.integrated.fontSize": 11,
  "terminal.integrated.lineHeight": 1.2
}
```

## Solución de Problemas

### Los iconos siguen sin verse

1. **Verifica que la fuente esté instalada:**
   ```bash
   fc-list | grep "MesloLGS NF"
   ```

2. **Recarga el caché de fuentes:**
   ```bash
   fc-cache -f -v
   ```

3. **Cierra completamente el terminal y ábrelo de nuevo** (no solo una nueva pestaña)

4. **Verifica que el terminal esté usando la fuente correcta:**
   - En la mayoría de terminales puedes verificar esto en Preferencias → Fuente

### Los símbolos se ven cortados o desalineados

1. **Ajusta el line-height** (altura de línea) en la configuración de tu terminal
   - Para Alacritty: añade `line_height: 1.2` en la configuración de font
   - Para Kitty: añade `adjust_line_height 110%`

2. **Prueba con un tamaño de fuente diferente** (11, 12, o 13)

### Actualizar las fuentes manualmente

Si necesitas reinstalar o actualizar las fuentes MesloLGS NF:

```bash
# Crear directorio de fuentes si no existe
mkdir -p ~/.local/share/fonts

# Descargar fuentes
cd ~/.local/share/fonts
curl -fsSLO https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
curl -fsSLO https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf
curl -fsSLO https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
curl -fsSLO https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf

# Actualizar caché
fc-cache -f -v
```

## Otras Fuentes Nerd Fonts Recomendadas

Si MesloLGS NF no es de tu agrado, puedes instalar otras Nerd Fonts:

```bash
# FiraCode Nerd Font
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/FiraCode.zip
unzip FiraCode.zip
rm FiraCode.zip
fc-cache -f -v

# JetBrainsMono Nerd Font
cd ~/.local/share/fonts
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/JetBrainsMono.zip
unzip JetBrainsMono.zip
rm JetBrainsMono.zip
fc-cache -f -v
```

## Probar que las fuentes funcionan

Ejecuta este comando para ver si los iconos se muestran correctamente:

```bash
echo -e "\ue0b0 \u00b1 \ue0a0 \u27a6 \u2718 \u26a1 \u2699"
```

Deberías ver símbolos gráficos. Si ves cuadrados o símbolos raros, la fuente no está configurada correctamente.

## Recursos Adicionales

- [Repositorio oficial de MesloLGS NF](https://github.com/romkatv/powerlevel10k#fonts)
- [Nerd Fonts - Fuentes populares con iconos](https://www.nerdfonts.com/)
- [Powerline Fonts](https://github.com/powerline/fonts)
