FROM ghcr.io/astral-sh/uv:latest AS uv

# Runtime-only image: Python 3.12, PyTorch 2.13.0+cu130, CUDA 13.0, cuDNN 9.
FROM pytorch/pytorch:2.13.0-cuda13.0-cudnn9-runtime

COPY --from=uv /uv /uvx /usr/local/bin/

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    UV_NO_CACHE=1 \
    UV_LINK_MODE=copy \
    HF_HOME=/work/.cache/huggingface

WORKDIR /work

# Install into the base environment so uv recognizes and reuses its CUDA Torch
# instead of resolving a second multi-gigabyte Torch wheel into a venv.
RUN uv pip install --system --break-system-packages tabicl==2.1.1 matplotlib==3.11.1 pandas==3.0.5 \
    && python -c "import torch; from tabicl import TabICLClassifier, TabICLRegressor; assert torch.__version__ == '2.13.0+cu130'; assert torch.version.cuda == '13.0'"

CMD ["python"]
