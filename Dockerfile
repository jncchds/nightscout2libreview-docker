# Stage 1: Cloning and building the project
FROM node:18-alpine as builder

# Set working directory
WORKDIR /app

# Install git to clone the repository
RUN apk add --no-cache git

# Clone the GitHub repository and install dependencies
RUN git clone https://github.com/NicoAAPS/nightscout-to-libreview.git . \
    && npm install --production

# Stage 2: Final container
FROM node:18-alpine

# Set working directory
WORKDIR /app

# Copy the built project from the builder stage
COPY --from=builder /app /app

# Copy the config generation script
COPY create-config.sh /usr/local/bin/create-config.sh
RUN chmod +x /usr/local/bin/create-config.sh

# Set default environment variables (can be overridden by docker-compose.yml)
ENV HARDWARE_DESCRIPTOR=Model
ENV OS_VERSION=28
ENV HARDWARE_NAME=Asus
ENV LIBRE_RESET_DEVICE=false

# Run the config generation script and start the Node.js app
CMD ["sh", "-c", "/usr/local/bin/create-config.sh && node ."]
