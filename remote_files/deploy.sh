cd /minitwit

export DATABASE_URL=$1 # Set by continous-deployment, pulled from GH secrets

docker compose -f docker-compose.yml pull
docker compose -f docker-compose.yml up -d
