# hash:sha256:b06bd4d80595f96405ed25909ea0807aec28ad771334fe94a009267b9a1c870f
FROM registry.codeocean.com/codeocean/miniconda3:4.5.11-python3.7-ubuntu18.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        awscli=1.14.44-1ubuntu1 \
    && rm -rf /var/lib/apt/lists/*

RUN conda install -y \
        conda==4.8.2 \
    && conda clean -ya

RUN pip install -U --no-cache-dir \
    boto3==1.11.16 \
    jupyterlab==1.2.6 \
    numpy==1.18.1 \
    pandas==1.0.1 \
    scipy==1.4.1 \
    squarify==0.4.3
