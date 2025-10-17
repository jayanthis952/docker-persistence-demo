#!/bin/bash

# Step 0: Clean up old containers
docker rm -f demo_container 2>/dev/null

# Step 1: Prepare directories
cd ~/docker-persistence-demo
mkdir -p bind_data
mkdir -p data_volume   # optional, Docker will manage it

# Create initial bind mount file
echo "Hello from bind mount" > bind_data/bind_file.txt

# Step 2: Run container with bind mount and volume
docker run -d -p 8080:8080 \
  -v ~/docker-persistence-demo/bind_data:/bind_data \
  -v data_volume:/data_volume \
  --name demo_container \
  --user root \
  persistence_demo

# Wait a few seconds to ensure container starts
sleep 3

# Step 3: Write files inside container
docker exec demo_container bash -c "echo 'Hello bind mount' > /bind_data/test_bind.txt"
docker exec demo_container bash -c "echo 'Hello volume' > /data_volume/volume_file.txt"

# Step 4: List files inside container
echo -e "\nInside container /bind_data:"
docker exec demo_container ls -l /bind_data
echo -e "\nInside container /data_volume:"
docker exec demo_container ls -l /data_volume

# Step 5: Delete container
docker rm -f demo_container

# Step 6: Verify persistence

echo -e "\nBind mount on host (should persist):"
ls -l ~/docker-persistence-demo/bind_data
cat ~/docker-persistence-demo/bind_data/test_bind.txt

echo -e "\nDocker volume (persistent, inspect via temporary container):"
docker run --rm -it -v data_volume:/data_volume ubuntu bash -c "ls -l /data_volume && cat /data_volume/volume_file.txt"
