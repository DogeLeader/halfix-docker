# Use an official Node.js image as a base
FROM node:latest

# Set environment variables for Emscripten
ENV EMSDK /emsdk
ENV PATH "$EMSDK:$PATH"

# Install required packages
RUN apt-get update && apt-get install -y \
    build-essential \
    zlib1g-dev \
    libsdl2-dev \
    git \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Install Emscripten
RUN git clone https://github.com/emscripten-core/emsdk.git $EMSDK && \
    cd $EMSDK && \
    ./emsdk install latest && \
    ./emsdk activate latest

# Clone the Halfix emulator repository
RUN git clone https://github.com/nepx/halfix.git /halfix

# Set the working directory
WORKDIR /halfix

# Build the Halfix emulator
RUN node makefile.js release

# Expose the port for the HTTP server
EXPOSE 8080

# Install http-server globally
RUN npm install -g http-server

# Command to run the HTTP server
CMD ["http-server", "-p", "8080"]
