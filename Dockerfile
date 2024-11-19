# Use an official Ubuntu base image
FROM ubuntu:20.04

# Set the working directory inside the container
WORKDIR /app

# Set DEBIAN_FRONTEND to noninteractive to skip tzdata prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install build-essential, tzdata (to avoid the interactive prompt), wget, and dependencies for Crow
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    g++ \
    wget \
    tzdata \
    git \
    && rm -rf /var/lib/apt/lists/*

# Install Crow web framework dependencies
RUN git clone --branch master https://github.com/CrowCpp/Crow.git /app/crow && \
    cd /app/crow && \
    mkdir build && cd build && \
    cmake .. && \
    make && \
    make install

# Set the timezone (you can replace "UTC" with your preferred timezone, e.g., "Europe/London")
RUN echo "UTC" > /etc/timezone && dpkg-reconfigure -f noninteractive tzdata

# Copy the C++ source code into the container
COPY . /app

# Ensure that calculator.cpp is in the working directory before trying to compile
RUN ls -al /app

# Build the C++ application (using calculator.cpp instead of main.cpp)
RUN g++ -o calculator calculator.cpp -I/app/crow/include -L/app/crow/build && \
    ldconfig

# Expose the port your app will listen on (in this case, port 18080)
EXPOSE 18080

# Command to run your application (adjust if necessary)
CMD ["./calculator"]

