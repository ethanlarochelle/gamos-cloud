# hash:sha256:1e4eea5ba7d44b16af28cffeeb833407ab47a0c22b6395c3a53bbbac11d768a0
FROM registry.codeocean.com/codeocean/miniconda3:4.5.11-python3.7-ubuntu18.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        awscli \
    && rm -rf /var/lib/apt/lists/*

RUN pip install -U --no-cache-dir \
    boto3 \
    numpy \
    pandas \
    scipy \
    squarify
