# DAM Fan Controls para Acer Nitro y Predator (Linux)

Suite de control de ventiladores y gestión térmica para laptops Acer Nitro y Predator en Linux.  
Incluye un controlador seguro basado en WMI, un daemon inteligente en segundo plano y una moderna interfaz gráfica basada en Avalonia.

**DAM Fan Controls** es una potente herramienta de gestión térmica para los laptops **Acer Nitro** y **Predator** más recientes que ejecutan Linux.  
Utiliza la interfaz WMI para proporcionar un **control dinámico de los ventiladores**, respaldado por un controlador seguro a nivel de kernel, un **daemon**, y una **interfaz gráfica moderna escrita en C# usando Avalonia UI**.

---

## 🔄 ¿Qué hay de nuevo?

Este proyecto es una reescritura completa y una continuación del anterior **AcerLinuxManager**.  
Aunque el original funcionaba, tenía varias limitaciones:

❌ Interfaz gráfica básica y torpe  
❌ Sin daemon en segundo plano – era necesario mantener la GUI abierta todo el tiempo  
❌ La GUI requería privilegios de root  
❌ Sin un sistema adecuado de instalación o configuración como servicio  

La nueva versión soluciona todo eso con:

✅ Una interfaz gráfica completamente rediseñada usando **C# y Avalonia**  
✅ Un mejor controlador de backend, con mayor seguridad  
✅ Un **daemon** en Python que se ejecuta independientemente en segundo plano  
✅ Limpia integración con **SystemD** – el daemon se inicia al arrancar el sistema, sin necesidad de contraseña  
✅ No es necesario mantener la GUI abierta  
✅ Mucha mejor **seguridad, rendimiento y estabilidad**

---

## 🧰 Funcionalidades

- ✅ Control manual y automático de la **velocidad del ventilador**
- ✅ Control dinámico e inteligente de ventiladores basado en la temperatura del sistema
- ✅ Interfaz gráfica moderna y rápida usando **Avalonia UI**
- ✅ Daemon limpio en segundo plano con comunicación entre procesos
- ✅ Compilación y carga automática de controladores al instalar
- ✅ Carga automática de controladores al iniciar el sistema mediante un servicio
- ✅ Guarda y restaura la configuración fácilmente
- ✅ Sistema de **registros para depuración** simple (`/var/log/acer_fan_control/`)
- ✅ Opciones limpias para descargar y limpiar el controlador

---

## 🧪 Compatibilidad

Este controlador solo funciona en **laptops Acer que usen la interfaz WMI** para el control de ventiladores.  
La mayoría de modelos **Nitro** y **Predator** de los últimos años están soportados.

---

## 📦 Instalación

1. Descarga la **carpeta**
2. Ejecuta el script de instalación en la Carpeta Descargas o Donwloads:

   ```bash
   sudo apt update
   sudo apt install lm-sensors fancontrol
   sudo apt install linux-headers-$(uname -r)
   cd bash_linuxmint
   cd instalador_ACER_NITRO_V15_ventiladores_drivers
   sudo ./SetupDrivers.sh
3. Elige la opción **1** para instalar.
4. Reiniciar Equipo
5. Luego de Reiniciar. Abrir en el menu Aplicaciones DAM Fan Controls
