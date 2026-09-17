# Docker container for tabular data predictions

A GPU-enabled environment for tabular predictions with TabICL, including its
fine-tuning and SHAP extras.

## Container environment

The Dockerfile uses `pytorch/pytorch:2.13.0-cuda13.0-cudnn9-runtime` as its
runtime base. It specifies Python 3.12, PyTorch 2.13.0 with CUDA 13.0, and
cuDNN 9. This is a runtime image; it does not include the CUDA development
toolkit.

The following packages are installed into the base Python environment:

| Package | Version | Extras |
| --- | --- | --- |
| `tabicl` | `2.1.1` | `finetune`, `shap` |
| `matplotlib` | `3.11.1` | |
| `pandas` | `2.3.3` | |

`uv` and `uvx` are copied from `ghcr.io/astral-sh/uv:latest`. Package installation
uses `uv pip install --system --break-system-packages` to reuse the base
image's CUDA-enabled PyTorch environment.

The working directory is `/work`. Python bytecode generation is disabled,
Python output is unbuffered, and uv uses no cache and copies files when linking.
`HF_HOME` is commented out in the Dockerfile, so the image does not explicitly
set a Hugging Face cache location.

## Build

From the directory containing the Dockerfile:

```bash
docker build -t docker-tabular:latest .
```

## Run

GPU access requires a host with a compatible NVIDIA driver and Docker GPU
support configured through the NVIDIA Container Toolkit.

Start an interactive shell:

```bash
docker run -it --rm --gpus all docker-tabular:latest bash
```

Mount the current directory at `/work` to access local scripts and data and
retain output files on the host:

```bash
docker run -it --rm --gpus all \
  -v "$PWD:/work" \
  docker-tabular:latest bash
```

To run a local script directly, replace `predict.py` with your script name:

```bash
docker run --rm --gpus all \
  -v "$PWD:/work" \
  docker-tabular:latest python predict.py
```

The Dockerfile does not copy application code or data into the image or define
a custom entrypoint or command.

## Use with a Galaxy tool

With Planemo installed on the host and a `tabular-prediction.xml` tool definition
that references the appropriate container image, run:

```bash
planemo serve --docker_run_extra_arguments "--gpus all" --docker tabular-prediction.xml
```

Planemo and the tool XML are not included in this repository or installed by
this Dockerfile.
