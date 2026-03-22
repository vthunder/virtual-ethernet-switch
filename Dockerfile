FROM node:20-slim

# Install wget and ICU for .NET runtime
RUN apt-get update && apt-get install -y wget curl libicu-dev ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Install .NET 8 runtime
RUN wget -q https://dot.net/v1/dotnet-install.sh && \
    chmod +x dotnet-install.sh && \
    ./dotnet-install.sh --runtime dotnet --version 8.0.125 --install-dir /opt/dotnet && \
    rm dotnet-install.sh

ENV DOTNET_ROOT=/opt/dotnet
ENV PATH=$PATH:/opt/dotnet

# Download WebOne 0.18.1 Linux x64 binary
RUN wget -q https://github.com/atauenis/webone/releases/download/v0.18.1/WebOne.0.18.1.linux-x64.zip \
    -O /tmp/webone.zip && \
    apt-get install -y unzip && \
    mkdir -p /app && \
    unzip -q /tmp/webone.zip -d /tmp/webone-extracted && \
    find /tmp/webone-extracted -name "webone" -type f -exec cp {} /app/webone \; && \
    chmod +x /app/webone && \
    rm -rf /tmp/webone.zip /tmp/webone-extracted

WORKDIR /app

# Copy Node app
COPY package*.json ./
RUN npm ci --omit=dev

COPY server.js ./
COPY webone-retro.conf ./
COPY start.sh ./
RUN chmod +x start.sh

EXPOSE 3001

CMD ["sh", "start.sh"]
