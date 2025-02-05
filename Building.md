# Building SIF  
## A guide for building a SIF image to run via Singularity on the NEU cluster.  

### Prerequisites  
Before proceeding, ensure you have the following:  
- A local machine with **Docker installed**.  
- A **Docker Hub account**. You need to log in to Docker Hub on your machine.  
- Access to the **NEU Discovery Cluster** with Singularity.  

### Steps  

#### **Step 1: Clone the Valle Repository**  
If you haven’t already, clone the **VALL-E** repository:  
```bash
git clone https://github.com/lifeiteng/vall-e.git
cd vall-e
```

#### **Step 2: Build and Push the Docker Image**  
Luckily, the **VALL-E** repository provides a `Dockerfile` that we can use to build the image directly.  
Run the following commands to build and push the image to **your Docker Hub account**:  
```bash
cd docker
docker build -t your_dockerhub_username/vall-e .
docker push your_dockerhub_username/vall-e
```
Replace `your_dockerhub_username` with your actual **Docker Hub username**.  

#### **Step 3: SSH into the NEU Discovery Cluster**  
Connect to the **NEU Discovery Cluster** and request an **interactive CPU node session**.  
Using a compute node instead of login node will speed up the build process.  
```bash
ssh your_username@discovery.neu.edu
srun --constraint=ib -p short --pty /bin/bash
```

#### **Step 4: Load the Singularity Module**  
Once logged in, load the Singularity module:  
```bash
module load singularity/3.5.3
```

#### **Step 5: Convert the Docker Image to a SIF File**  
Use **Singularity** to build a SIF file from the Docker image:  
```bash
singularity build vall-e.sif docker://your_dockerhub_username/vall-e
```
This command pulls the image from **Docker Hub** and converts it into a `.sif` file, which can be run using Singularity on the cluster.

