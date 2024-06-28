FROM docker:20.10.8-dind

# Install dependencies
RUN apk add --no-cache curl

# Install kubectl for ARM64
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/arm64/kubectl" && \
    chmod +x kubectl && \
    mv kubectl /usr/local/bin/

# Install Kind for ARM64
RUN curl -Lo ./kind "https://kind.sigs.k8s.io/dl/v0.11.1/kind-linux-arm64" && \
    chmod +x ./kind && \
    mv ./kind /usr/local/bin/kind