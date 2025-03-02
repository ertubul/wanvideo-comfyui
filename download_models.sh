#!/bin/bash

# Model klasörlerini oluştur
mkdir -p /workspace/ComfyUI/models/diffusion_models
mkdir -p /workspace/ComfyUI/models/text_encoders
mkdir -p /workspace/ComfyUI/models/vae
mkdir -p /workspace/ComfyUI/models/frame_interpolation

# Eğer model dosyaları zaten varsa tekrar indirme - diffusion modelleri
if [ -f "/workspace/ComfyUI/models/diffusion_models/Wan2_1-I2V-14B-720P_fp8_e4m3fn.safetensors" ] && \
   [ -f "/workspace/ComfyUI/models/diffusion_models/Wan2_1-I2V-14B-480P_fp8_e4m3fn.safetensors" ] && \
   [ -f "/workspace/ComfyUI/models/text_encoders/umt5-xxl-enc-bf16.safetensors" ] && \
   [ -f "/workspace/ComfyUI/models/text_encoders/open-clip-xlm-roberta-large-vit-huge-14_visual_fp16.safetensors" ] && \
   [ -f "/workspace/ComfyUI/models/vae/Wan2_1_VAE_bf16.safetensors" ] && \
   [ -f "/workspace/ComfyUI/models/frame_interpolation/film_net_fp32.pt" ]; then
    echo "Tüm model dosyaları zaten mevcut. İndirme atlanıyor."
    exit 0
fi

echo "Model dosyaları indiriliyor..."

# WanVideo 720P Modeli indir
WANVIDEO_720P_URL="https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/Wan2_1-I2V-14B-720P_fp8_e4m3fn.safetensors"
echo "720p model indiriliyor..."
wget -c -O "/workspace/ComfyUI/models/diffusion_models/Wan2_1-I2V-14B-720P_fp8_e4m3fn.safetensors" "$WANVIDEO_720P_URL" || echo "WanVideo 720p model indirilemedi"

# WanVideo 480P Modeli indir
WANVIDEO_480P_URL="https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/Wan2_1-I2V-14B-480P_fp8_e4m3fn.safetensors"
echo "480p model indiriliyor..."
wget -c -O "/workspace/ComfyUI/models/diffusion_models/Wan2_1-I2V-14B-480P_fp8_e4m3fn.safetensors" "$WANVIDEO_480P_URL" || echo "WanVideo 480p model indirilemedi"

# T5 Text Encoder modelini indir
T5_MODEL_URL="https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/umt5-xxl-enc-bf16.safetensors"
echo "T5 text encoder indiriliyor..."
wget -c -O "/workspace/ComfyUI/models/text_encoders/umt5-xxl-enc-bf16.safetensors" "$T5_MODEL_URL" || echo "UMT5 model indirilemedi"

# CLIP Text Encoder modelini indir
CLIP_MODEL_URL="https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/open-clip-xlm-roberta-large-vit-huge-14_visual_fp16.safetensors"
echo "CLIP text encoder indiriliyor..."
wget -c -O "/workspace/ComfyUI/models/text_encoders/open-clip-xlm-roberta-large-vit-huge-14_visual_fp16.safetensors" "$CLIP_MODEL_URL" || echo "CLIP model indirilemedi"

# VAE modelini indir
VAE_MODEL_URL="https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/Wan2_1_VAE_bf16.safetensors"
echo "VAE model indiriliyor..."
wget -c -O "/workspace/ComfyUI/models/vae/Wan2_1_VAE_bf16.safetensors" "$VAE_MODEL_URL" || echo "VAE model indirilemedi"

# FILM VFI modelini indir
FILM_MODEL_URL="https://huggingface.co/nguu/film-pytorch/resolve/887b2c42bebcb323baf6c3b6d59304135699b575/film_net_fp32.pt"
echo "FILM frame interpolation model indiriliyor..."
wget -c -O "/workspace/ComfyUI/models/frame_interpolation/film_net_fp32.pt" "$FILM_MODEL_URL" || echo "FILM model indirilemedi"

# Modellerin WanVideo tarafından beklenen dizinlere sembolik linklerini oluştur
echo "Sembolik linkler oluşturuluyor..."
mkdir -p /workspace/ComfyUI/models/wan2_1
mkdir -p /workspace/ComfyUI/models/umt5
mkdir -p /workspace/ComfyUI/models/clip_vision

# 720p model için link oluştur (varsayılan)
ln -sf /workspace/ComfyUI/models/diffusion_models/Wan2_1-I2V-14B-720P_fp8_e4m3fn.safetensors /workspace/ComfyUI/models/wan2_1/Wan2_1-I2V-14B-720P_fp8_e4m3fn.safetensors
# 480p model için link oluştur
ln -sf /workspace/ComfyUI/models/diffusion_models/Wan2_1-I2V-14B-480P_fp8_e4m3fn.safetensors /workspace/ComfyUI/models/wan2_1/Wan2_1-I2V-14B-480P_fp8_e4m3fn.safetensors
# T5 için link oluştur
ln -sf /workspace/ComfyUI/models/text_encoders/umt5-xxl-enc-bf16.safetensors /workspace/ComfyUI/models/umt5/umt5-xxl-enc-bf16.safetensors
# CLIP için link oluştur (dikkat: dosya adı değişti, link eski adı kullanmalı)
ln -sf /workspace/ComfyUI/models/text_encoders/open-clip-xlm-roberta-large-vit-huge-14_visual_fp16.safetensors /workspace/ComfyUI/models/clip_vision/open-clip-xlm-roberta-large-vit-huge-14_fp16.safetensors

echo "Tüm model dosyaları indirildi ve sembolik linkler oluşturuldu!"