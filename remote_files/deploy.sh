cd /minitwit

# Set by continous-deployment, pulled from GH secrets
export DATABASE_URL=$1
export NR_LICENSE_KEY=$2

docker compose -f docker-compose.yml pull
docker compose -f docker-compose.yml up -d
