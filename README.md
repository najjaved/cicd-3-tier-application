# CI-CD Workflow with Github Actions for a 3-tier Application
Deploy a 3-tier application (frontend UI, .NET API, PostgreSQL database) on an Amazon EC2 instance using Docker containers, implement continuous integration (CI) and continuous delivery (CD) pipelines with GitHub Actions and Docker Hub.  
Integrate SonarQube for code quality analysis.

The sample 3-Tier Web Application has following structure.

```.
├── api
│   ├── Basic3Tier.Core
│   ├── Basic3Tier.Infrastructure
│   ├── Basic3TierAPI
│   ├── Tests
│   └── Dockerfile
├── ui
│   ├── Dockerfile
│   ├── index.html
│   ├── main.js
│   └── config
│       └── config.json
└── docker-compose.yml
```

## Running via Docker locally (Optional Testing/Validation)

Before deploying to AWS, you can test everything locally by running three containers: PostgreSQL, the .NET API, and the UI.

1. Creating a Docker network:

```bash
    docker network create my3tier
```

2. Running the database:

```bash
    docker run -d --name my-db --network my3tier -p 5432:5432 \
        -e POSTGRES_DB=basic3tier \
        -e POSTGRES_USER=postgres \
        -e POSTGRES_PASSWORD=admin123 \
        postgres
```

3. Building and Running the api:

```bash
    docker build -t <your-name>/api:latest api/ 

    docker run -d --name my-api --network my3tier -p 5000:80 \
        -e ConnectionStrings__Basic3Tier="Host=my-db;Port=5432;Database=basic3tier;Username=postgres;Password=admin123" \
        <your-name>/api
```

4. Building and Running the front-end:

```bash
     docker build -t <your-name>/ui:latest ui/ 
     docker run -p 8085:80 <your-name>/ui
```

## Setting up EC2 Instance
On AWS, launch an Ubuntu (or Amazon Linux) EC2 instance. 
Ensure:
- Docker installed and running. (For Ubuntu, install with ```sudo apt-get update && sudo apt-get install -y docker.io```, then ```sudo systemctl start docker``` and ```sudo usermod -aG docker ubuntu```.
-  Instance 's security group allows inbound traffic on:
    - Port 80 (HTTP)
    - Port 5000 (for API, if you intend to access it externally)
    - Port 5432 (if you need to access PostgreSQL externally; usually you do not)
    - Poer 22 (SSH)
- You can SSH into EC2 instance using EC2 key pair

## Continuous Integration (CI) Pipeline
Create a GitHub Actions pipeline to:

- Check out the repository code
- Build th code
- Run unit tests
- Log in to Docker Hub
- Build Docker images for the UI and API
- Push the images to Docker Hub </br>
**Important**: In your GitHub repository settings, add DOCKERHUB_USERNAME and DOCKERHUB_TOKEN as secrets.

## Continuous Delivery (CD) Pipeline
Set up a second GitHub Actions workflow that triggers after the CI Pipeline completes successfully. This workflow will:

- SSH into the EC2 instance
- Pull the latest Docker images from Docker Hub
- Stop/remove existing containers (if any), then run them again
</br>
**GitHub Secrets**: EC2_HOST - the public IP or DNS of your EC2 instance & EC2_PRIVATE_KEY - contents of your private SSH key

## Code Analysis with SonarQube
Add a separate workflow (or can integrate in the CI Pipeline) for code qaulity analysis.
</br>
**GitHub Secrets**: SONAR_TOKEN & SONAR_HOST_URL </br>
***Your SonarQube dashboard shows results of the analyzed project.***

## Verification
Once your pipelines complete successfully:
- SSH into your EC2 instance and run ```sudo docker ps``` to confirm that ```my3tier-db```, ```my3tier-api```, and ```my3tier-ui``` containers are running.
- Open your browser to http://<EC2_PUBLIC_IP>. You should see the UI (on port 80) calling the API (on port 5000), which in turn communicates with PostgreSQL