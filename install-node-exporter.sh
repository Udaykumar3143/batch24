#!/bin/bash

# Define Node Exporter version
VERSION="1.8.1"

# Create a user for node_exporter
echo "Creating node_exporter user..."
useradd --no-create-home --shell /bin/false node_exporter

# Download node_exporter
echo "Downloading Node Exporter..."
cd /tmp
wget https://github.com/prometheus/node_exporter/releases/download/v$VERSION/node_exporter-$VERSION.linux-amd64.tar.gz

# Extract and install
echo "Extracting and installing..."
tar xvf node_exporter-$VERSION.linux-amd64.tar.gz
cp node_exporter-$VERSION.linux-amd64/node_exporter /usr/local/bin/

# Set permissions
echo "Setting permissions..."
chown node_exporter:node_exporter /usr/local/bin/node_exporter

# Create systemd service file
echo "Creating systemd service..."
cat <<EOF > /etc/systemd/system/node_exporter.service
[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=default.target
EOF

# Reload systemd and start the service
echo "Starting Node Exporter..."
systemctl daemon-reload
systemctl start node_exporter
systemctl enable node_exporter

echo "Node Exporter installation complete. Check status using: systemctl status node_exporter"
