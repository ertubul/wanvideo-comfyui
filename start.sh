#!/bin/bash

# Modelleri indir
cd /workspace && ./download_models.sh

# JupyterLab ve VS Code'u arka planda başlat
jupyter lab --allow-root --ip=0.0.0.0 --port=8888 --ServerApp.token='' --no-browser &
code-server --bind-addr 0.0.0.0:8080 --auth none --disable-telemetry &

# ComfyUI'yi başlat
cd /workspace/ComfyUI && python3 main.py --listen 0.0.0.0 --port 8188