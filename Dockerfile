FROM --platform=linux/amd64 python:3.9-slim as builder

# Install git
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    git \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory in the container
WORKDIR /app

# Get the latest version of Moriarty-Project from GitHub and install it
RUN git clone https://github.com/AzizKpln/Moriarty-Project.git /app 

# Install the dependencies
RUN pip install -r requirements.txt

# Run the install script
RUN bash install.sh

# Create a new stage for the runner
FROM builder as runner

# Copy the built application from the builder stage
COPY --from=builder /app /app

# Expose the port that the application listens on
EXPOSE 8080

# Run the application
CMD ["python", "/app/run.py"]