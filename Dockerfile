# Use a minimal base image since no build tools are needed
FROM ubuntu:22.04

RUN apt-get update && apt-get install -y software-properties-common && \
    add-apt-repository ppa:ubuntu-toolchain-r/test && \
    apt-get update && apt-get install -y libstdc++6


# Set the working directory inside the container
WORKDIR /app

# Copy the pre-built binary and index.html into the container
COPY ./calculator /app/calculator
COPY ./index.html /app/index.html

# Expose the port your app will listen on
EXPOSE 18080

# Command to run your application
CMD ["./calculator"]

