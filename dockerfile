FROM nvidia/cuda:11.8.0-cudnn8-devel-ubuntu22.04

# Gereksiz etkileşimleri önlemek için ortam değişkenleri
ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1
ENV PIP_NO_CACHE_DIR=1

# Gerekli paketleri kur
RUN apt-get update && apt-get install -y \
    python3.10 \
    python3.10-venv \
    python3-pip \
    git \
    wget \
    curl \
    ffmpeg \
    libgl1-mesa-glx \
    libglib2.0-0 \
    python3-opencv \
    nodejs \
    npm \
    vim \
    nano \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Çalışma dizinini oluştur
WORKDIR /workspace

# ComfyUI'yi kur
RUN git clone https://github.com/comfyanonymous/ComfyUI.git
WORKDIR /workspace/ComfyUI
RUN pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118
RUN pip3 install -r requirements.txt

# Gerekli eklentileri kur
RUN cd /workspace/ComfyUI/custom_nodes && \
    git clone https://github.com/kijai/ComfyUI-WanVideoWrapper.git && \
    git clone https://github.com/kijai/ComfyUI-KJNodes.git && \
    git clone https://github.com/Fannovel16/ComfyUI-Video-Helpers-Suite.git && \
    git clone https://github.com/Fannovel16/ComfyUI-Frame-Interpolation.git && \
    git clone https://github.com/ltdrdata/ComfyUI-Manager.git comfyui-manager

# Jupyter ve VS Code eklentisini kur
RUN pip3 install jupyter jupyterlab jupyter-server-proxy 
RUN pip3 install jupyter-vscode-proxy

# VS Code için code-server kur
RUN curl -fsSL https://code-server.dev/install.sh | sh

# ComfyUI için Jupyter kernel oluştur
RUN python3 -m ipykernel install --user --name comfyui --display-name "ComfyUI Python Environment"

# Model klasörlerini oluştur
RUN mkdir -p /workspace/ComfyUI/models/diffusion_models
RUN mkdir -p /workspace/ComfyUI/models/text_encoders
RUN mkdir -p /workspace/ComfyUI/models/vae
RUN mkdir -p /workspace/ComfyUI/models/frame_interpolation
RUN mkdir -p /workspace/ComfyUI/models/wan2_1
RUN mkdir -p /workspace/ComfyUI/models/umt5
RUN mkdir -p /workspace/ComfyUI/models/clip_vision

# Model dosyalarını indir
# Örnek script, modelleri indirecek. İndirme URL'lerini gerçekleriyle değiştirmeniz gerekecek.
COPY download_models.sh /workspace/download_models.sh
RUN chmod +x /workspace/download_models.sh

# Her eklentinin özel gereksinimlerini kur
RUN cd /workspace/ComfyUI/custom_nodes/ComfyUI-WanVideoWrapper && pip3 install -r requirements.txt
RUN cd /workspace/ComfyUI/custom_nodes/ComfyUI-Video-Helpers-Suite && pip3 install -r requirements.txt
RUN cd /workspace/ComfyUI/custom_nodes/ComfyUI-Frame-Interpolation && pip3 install -r requirements.txt

# Başlangıç betiğini oluştur ve kopyala
COPY start.sh /workspace/start.sh
RUN chmod +x /workspace/start.sh

# Hizmet sunucusunu çalıştır ve portları aç
EXPOSE 8188 8888 8080

# Başlangıç betiğini çalıştır
ENTRYPOINT ["/bin/bash", "/workspace/start.sh"]
