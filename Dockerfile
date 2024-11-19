# Use an official Ubuntu base image
FROM ubuntu:20.04

# Set the working directory inside the container
WORKDIR /app

# Set DEBIAN_FRONTEND to noninteractive to skip tzdata prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install build-essential, tzdata (to avoid the interactive prompt), and other dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    g++ \
    wget \
    tzdata \
    && rm -rf /var/lib/apt/lists/*

# Set the timezone (you can replace "UTC" with your preferred timezone, e.g., "Europe/London")
RUN echo "UTC" > /etc/timezone && dpkg-reconfigure -f noninteractive tzdata

# Copy the C++ source code into the container
COPY . /app

# Build the C++ application (adjust this to your specific build commands)
RUN g++ -o calculator calculator.cpp # Adjust this command to suit your build setup, e.g., if you have a Makefile

# Expose the port your app will listen on (in this case, port 18080)
EXPOSE 18080

# Command to run your application (adjust if necessary)
CMD ["./calculator"]

