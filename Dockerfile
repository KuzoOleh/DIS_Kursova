# Use an official Ubuntu base image
FROM ubuntu:20.04

# Set the working directory inside the container
WORKDIR /app

# Install build-essential and other dependencies (adjust if you need more packages)
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    g++ \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Copy the C++ source code into the container
COPY . /app

# Build the C++ application (adjust this to your specific build commands)
RUN g++ -o calculator main.cpp # Adjust this command to suit your build setup, e.g., if you have a Makefile

# Expose the port your app will listen on (in this case, port 18080)
EXPOSE 18080

# Command to run your application (adjust if necessary)
CMD ["./calculator"]

