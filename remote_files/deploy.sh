cd /minitwit

# Set by continous-deployment, pulled from GH secrets
export DATABASE_URL=$1
export NR_LICENSE_KEY=$2
export MINITWIT_VERSION=$3

docker stack deploy -c docker-compose.yml minitwit