#!/bin/bash
# DAM Fan Controls Setup Script v0.2.7
# This script provides a menu for installing, uninstalling, or reinstalling the Div Acer Manager Fan Controls

# Check if running as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run this setup with sudo privileges"
  exit 1
fi

# Save the installer and uninstaller scripts
cat > ./install.sh << 'INSTALLSCRIPT'
#!/bin/bash
# Div Acer Manager Fan Controls Installer
# This script installs the Daemon, Drivers, and GUI application

# Exit on error
set -e

# Check if running as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run this installer with sudo privileges"
  exit 1
fi

# Define installation locations
INSTALL_DIR="/opt/dam-fan-controls"
BIN_DIR="/usr/local/bin"
SERVICE_DIR="/etc/systemd/system"
DESKTOP_DIR="/usr/share/applications"
ICON_DIR="/usr/share/icons/hicolor"
APP_ICON_NAME="dam-fan-controls"

# Ask about desktop icon
read -p "Would you like to create a desktop icon? (y/n): " CREATE_DESKTOP_ICON

# Create installation directories
echo "Creating installation directories..."
mkdir -p "$INSTALL_DIR"
mkdir -p "$INSTALL_DIR/NitroDrivers"

# Handle icon installation
if [ -f "./fan-control-icon.png" ]; then
  echo "Installing custom icon..."
  
  # Create multiple resolution directories for the icon
  mkdir -p "$ICON_DIR/16x16/apps"
  mkdir -p "$ICON_DIR/24x24/apps"
  mkdir -p "$ICON_DIR/32x32/apps"
  mkdir -p "$ICON_DIR/48x48/apps"
  mkdir -p "$ICON_DIR/64x64/apps"
  mkdir -p "$ICON_DIR/128x128/apps"
  mkdir -p "$ICON_DIR/256x256/apps"
  
  # Copy the same icon to all resolution directories
  # In a production environment, you might want to resize for each directory
  for size in 16x16 24x24 32x32 48x48 64x64 128x128 256x256; do
    cp "./fan-control-icon.png" "$ICON_DIR/$size/apps/$APP_ICON_NAME.png"
    chmod 644 "$ICON_DIR/$size/apps/$APP_ICON_NAME.png"
  done
  
  # Also install in the main app directory for direct access
  mkdir -p "$INSTALL_DIR/icons"
  cp "./fan-control-icon.png" "$INSTALL_DIR/icons/$APP_ICON_NAME.png"
  chmod 644 "$INSTALL_DIR/icons/$APP_ICON_NAME.png"
  
  ICON_PATH="$APP_ICON_NAME"
else
  echo "Custom icon not found, using system icon..."
  ICON_PATH="utilities-system-monitor"
fi

# Copy files
echo "Copying files..."
# Copy daemon and drivers
cp -r ./Daemon/NitroDrivers/* "$INSTALL_DIR/NitroDrivers/"
cp ./Daemon/DAMFC_daemon "$INSTALL_DIR/"
chmod +x "$INSTALL_DIR/DAMFC_daemon"

# Copy GUI application
cp ./DAM-FC "$BIN_DIR/"
chmod +x "$BIN_DIR/DAM-FC"

# Compile drivers if needed
echo "Compiling drivers..."
cd "$INSTALL_DIR/NitroDrivers"
make
cd -

# Create systemd service file for daemon
echo "Creating systemd service..."
cat > "$SERVICE_DIR/dam-fan-controls-daemon.service" << EOF
[Unit]
Description=Div Acer Manager Fan Controls Daemon Service
After=network.target

[Service]
Type=simple
ExecStart=$INSTALL_DIR/DAMFC_daemon
WorkingDirectory=$INSTALL_DIR
Restart=on-failure
User=root

[Install]
WantedBy=multi-user.target
EOF

# Create desktop entry for GUI with proper environment setup
echo "Creating application launcher..."
cat > "$DESKTOP_DIR/dam-fan-controls.desktop" << EOF
[Desktop Entry]
Name=DAM Fan Controls
Comment=Div Acer Manager Fan Controls GUI Application
Exec=sh -c 'export DOTNET_BUNDLE_EXTRACT_BASE_DIR="\$HOME/.cache/damfc_extract"; mkdir -p "\$HOME/.cache/damfc_extract"; exec $BIN_DIR/DAM-FC'
Icon=$ICON_PATH
Terminal=false
Type=Application
Categories=System;Utility;Settings;HardwareSettings;
StartupNotify=true
EOF

# Create desktop icon if requested
if [[ "$CREATE_DESKTOP_ICON" =~ ^[Yy]$ ]]; then
  echo "Creating desktop icon..."
  # Get all user home directories
  for USER_HOME in /home/*; do
    if [ -d "$USER_HOME" ]; then
      USERNAME=$(basename "$USER_HOME")
      DESKTOP_PATH="$USER_HOME/Desktop"
      
      # Create Desktop directory if it doesn't exist
      if [ ! -d "$DESKTOP_PATH" ]; then
        mkdir -p "$DESKTOP_PATH"
        chown "$USERNAME:$USERNAME" "$DESKTOP_PATH"
      fi
      
      # Create desktop shortcut with the same environment setup
      cat > "$DESKTOP_PATH/dam-fan-controls.desktop" << EOF
[Desktop Entry]
Name=DAM Fan Controls
Comment=Div Acer Manager Fan Controls GUI Application
Exec=sh -c 'export DOTNET_BUNDLE_EXTRACT_BASE_DIR="\$HOME/.cache/damfc_extract"; mkdir -p "\$HOME/.cache/damfc_extract"; exec $BIN_DIR/DAM-FC'
Icon=$ICON_PATH
Terminal=false
Type=Application
Categories=System;Utility;
StartupNotify=true
EOF
      
      chown "$USERNAME:$USERNAME" "$DESKTOP_PATH/dam-fan-controls.desktop"
      chmod +x "$DESKTOP_PATH/dam-fan-controls.desktop"
      
      echo "Desktop icon created for user $USERNAME"
    fi
  done
fi

# Set proper permissions
echo "Setting permissions..."
chmod -R 755 "$INSTALL_DIR"
chmod 644 "$SERVICE_DIR/dam-fan-controls-daemon.service"
chmod 644 "$DESKTOP_DIR/dam-fan-controls.desktop"

# Add to KDE menu if KDE is detected
if command -v kbuildsycoca5 >/dev/null 2>&1 || command -v kbuildsycoca6 >/dev/null 2>&1; then
  echo "KDE detected, updating KDE menu..."
  if command -v kbuildsycoca5 >/dev/null 2>&1; then
    # For KDE Plasma 5
    kbuildsycoca5 >/dev/null 2>&1 || true
  elif command -v kbuildsycoca6 >/dev/null 2>&1; then
    # For KDE Plasma 6
    kbuildsycoca6 >/dev/null 2>&1 || true
  fi
fi

# Enable and start the service
echo "Enabling and starting the service..."
systemctl daemon-reload
systemctl enable dam-fan-controls-daemon.service
systemctl start dam-fan-controls-daemon.service

# Update icon cache
echo "Updating icon cache..."
if command -v gtk-update-icon-cache >/dev/null 2>&1; then
  gtk-update-icon-cache -f -t "$ICON_DIR" >/dev/null 2>&1 || true
fi

if command -v update-desktop-database >/dev/null 2>&1; then
  update-desktop-database "$DESKTOP_DIR" >/dev/null 2>&1 || true
fi

echo "Installation complete! The DAM Fan Controls daemon is now running as a service."
echo "You can launch the GUI application from your applications menu or by running 'DAM-FC'"
INSTALLSCRIPT

cat > ./uninstall.sh << 'UNINSTALLSCRIPT'
#!/bin/bash
# Div Acer Manager Fan Controls Uninstaller
# This script removes the Daemon, Drivers, and GUI application

# Exit on error
set -e

# Check if running as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run this uninstaller with sudo privileges"
  exit 1
fi

# Define installation locations
INSTALL_DIR="/opt/dam-fan-controls"
BIN_DIR="/usr/local/bin"
SERVICE_DIR="/etc/systemd/system"
DESKTOP_DIR="/usr/share/applications"
ICON_DIR="/usr/share/icons/hicolor"
APP_ICON_NAME="dam-fan-controls"

echo "Stopping and disabling service..."
systemctl stop dam-fan-controls-daemon.service || true
systemctl disable dam-fan-controls-daemon.service || true
systemctl daemon-reload

echo "Removing service file..."
rm -f "$SERVICE_DIR/dam-fan-controls-daemon.service"

echo "Removing installed files..."
rm -f "$BIN_DIR/DAM-FC"
rm -f "$DESKTOP_DIR/dam-fan-controls.desktop"
rm -rf "$INSTALL_DIR"

# Remove desktop icons from all user homes
echo "Removing desktop icons..."
for USER_HOME in /home/*; do
  if [ -d "$USER_HOME" ]; then
    DESKTOP_ICON="$USER_HOME/Desktop/dam-fan-controls.desktop"
    if [ -f "$DESKTOP_ICON" ]; then
      rm -f "$DESKTOP_ICON"
      echo "Removed desktop icon for user $(basename "$USER_HOME")"
    fi
  fi
done

# Remove icons from all directories
echo "Removing icons..."
for size in 16x16 24x24 32x32 48x48 64x64 128x128 256x256; do
  rm -f "$ICON_DIR/$size/apps/$APP_ICON_NAME.png"
done

# Update KDE menu if KDE is detected
if command -v kbuildsycoca5 >/dev/null 2>&1 || command -v kbuildsycoca6 >/dev/null 2>&1; then
  echo "KDE detected, updating KDE menu..."
  if command -v kbuildsycoca5 >/dev/null 2>&1; then
    # For KDE Plasma 5
    kbuildsycoca5 >/dev/null 2>&1 || true
  elif command -v kbuildsycoca6 >/dev/null 2>&1; then
    # For KDE Plasma 6
    kbuildsycoca6 >/dev/null 2>&1 || true
  fi
fi

# Update icon cache
if command -v gtk-update-icon-cache >/dev/null 2>&1; then
  gtk-update-icon-cache -f -t "$ICON_DIR" >/dev/null 2>&1 || true
fi

if command -v update-desktop-database >/dev/null 2>&1; then
  update-desktop-database "$DESKTOP_DIR" >/dev/null 2>&1 || true
fi

echo "Uninstallation complete!"
UNINSTALLSCRIPT

cat > ./reinstall.sh << 'REINSTALLSCRIPT'
#!/bin/bash
# Div Acer Manager Fan Controls Reinstaller/Updater
# This script uninstalls the existing installation and then installs the latest version

# Exit on error
set -e

# Check if running as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run this reinstaller with sudo privileges"
  exit 1
fi

echo "=== DAM Fan Controls - Reinstall/Update ==="
echo "This will uninstall the current version and install the updated version."

# Run uninstall script first
echo "Step 1: Uninstalling current version..."
./uninstall.sh || { echo "Uninstallation failed. Aborting reinstall."; exit 1; }

# Then run the install script
echo
echo "Step 2: Installing new version..."
./install.sh || { echo "Installation failed."; exit 1; }

echo
echo "Reinstall/Update completed successfully!"
REINSTALLSCRIPT

chmod +x ./install.sh
chmod +x ./uninstall.sh
chmod +x ./reinstall.sh

# Check if the icon file exists or notify the user to create one
if [ ! -f "./fan-control-icon.png" ]; then
  echo "Note: Custom icon file 'fan-control-icon.png' not found."
  echo "Please place your custom icon as 'fan-control-icon.png' in the current directory"
  echo "before running the install script, or a default system icon will be used."
else
  # Check if the icon is in PNG format
  if command -v file >/dev/null 2>&1; then
    if ! file "./fan-control-icon.png" | grep -q "PNG image data"; then
      echo "Warning: Your icon file doesn't appear to be a PNG image."
      echo "For best compatibility, please use a PNG format icon."
    fi
  fi
fi

# Display menu
echo "=== DAM Fan Controls Setup ==="
echo "1. Install DAM Fan Controls"
echo "2. Uninstall DAM Fan Controls"
echo "3. Reinstall/Update DAM Fan Controls"
echo "4. Exit"
read -p "Select an option (1-4): " option

case $option in
  1)
    ./install.sh
    ;;
  2)
    ./uninstall.sh
    ;;
  3)
    ./reinstall.sh
    ;;
  4)
    echo "Exiting setup."
    exit 0
    ;;
  *)
    echo "Invalid option. Exiting."
    exit 1
    ;;
esac

# Clean up
rm -f ./install.sh
rm -f ./uninstall.sh
rm -f ./reinstall.sh
