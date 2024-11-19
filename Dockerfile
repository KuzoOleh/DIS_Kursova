# Use an official Ubuntu base image
FROM ubuntu:20.04

# Set the working directory inside the container
WORKDIR /app

# Set DEBIAN_FRONTEND to noninteractive to skip tzdata prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary dependencies (without building the app)
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    g++ \
    wget \
    tzdata \
    git \
    && rm -rf /var/lib/apt/lists/*

# Set the timezone (you can replace "UTC" with your preferred timezone, e.g., "Europe/London")
RUN echo "UTC" > /etc/timezone && dpkg-reconfigure -f noninteractive tzdata

# Copy the pre-built calculator binary and other necessary files (index.html, etc.) into the container
COPY ./build/calculator /app/calculator
COPY ./index.html /app/index.html

# Expose the port your app will listen on (in this case, port 18080)
EXPOSE 18080

# Command to run your application (adjust if necessary)
CMD ["./calculator"]

