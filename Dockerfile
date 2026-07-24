FROM pytorch/pytorch:2.6.0-cuda12.4-cudnn9-runtime

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1

RUN pip install --no-cache-dir \
    llama-index==0.14.18 \
    llama-index-embeddings-huggingface==0.7.0 \
    llama-index-readers-json==0.5.0 \
    llama-index-readers-file==0.6.0


FROM pytorch/pytorch:2.2.2-cuda12.1-cudnn8-runtime

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    libgl1-mesa-glx \
    libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

# Optional: non-root user (comment out if not needed)
# RUN useradd -ms /bin/bash appuser
# USER appuser
# WORKDIR /home/appuser

WORKDIR /workspace

RUN pip install --no-cache-dir huggingface_hub==0.32.4 doclayout-yolo==0.0.4 opencv-python==4.11.0.86 geojson==3.2.0 shapely==2.1.1
RUN python -c "import doclayout_yolo"



# Base image with PyTorch + CUDA 12.1 + cuDNN 8 runtime
FROM pytorch/pytorch:2.2.2-cuda12.1-cudnn8-runtime

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# Use a non-root user for security (optional)
RUN useradd -ms /bin/bash appuser
USER appuser
WORKDIR /home/appuser

# Install your tool from PyPI or any other way ...
RUN pip install --no-cache-dir doclayout-yolo==0.0.4