#!/bin/bash

NPNEV_REPO="https://github.com/nuxeo-sandbox/nuxeo-presales-nev"
DOCKER_PRIVATE="docker-arender.packages.nuxeo.com"
PROJECT_DIR="nuxeo-presales-nev"

# Check for commands used in this script
CHECKS=()
command -v git >/dev/null || CHECKS+=("git")
command -v docker >/dev/null || CHECKS+=("docker")

if [ $CHECKS ]
then
  echo "Please install the following programs for your platform:"
  echo ${CHECKS[@]}
  exit 1
fi

docker info >/dev/null
RUNNING=$?
if [ "${RUNNING}" != "0" ]
then
  echo "Docker does not appear to be running, please start Docker."
  exit 2
fi

# Directions for setup
cat << EOM
 _____ _____ _____
|   | |   __|  |  |
| | | |   __|  |  |
|_|___|_____|\___/

NEV Docker Compose Bootstrap

Requirements:

* Sonatype User Token credentials (https://packages.nuxeo.com/#user/usertoken)

EOM

# Set NEV version
NEV_VERSION="${NEV_VERSION:-}"
if [ -z "${NEV_VERSION}" ]
then
  echo -n "NEV Version: [2.2.0] "
  read NEV_VERSION
fi
if [ -z "${NEV_VERSION}" ]
then
  NEV_VERSION="2.2.0"
fi

# Set Nuxeo URL
NUXEO_URL="${NUXEO_URL:-}"
while [ -z "${NUXEO_URL}" ]
do
  echo -n "Nuxeo Application URL (e.g. https://my-demo.cloud.nuxeo.com/nuxeo): "
  read NUXEO_URL
done

# Set Token
DEFAULT_TOKEN=`uuidgen`
NUXEO_SECRET="${NUXEO_SECRET:-}"
if [ -z "${NUXEO_SECRET}" ]
then
  echo -n "OAUTH2 secret: [${DEFAULT_TOKEN}] "
  read NUXEO_SECRET
fi
if [ -z "${NUXEO_SECRET}" ]
then
  NUXEO_SECRET=${DEFAULT_TOKEN}
fi

echo ""
echo "Ok, getting things ready..."

# Login to private repo
echo ""
echo "Logging in to ${DOCKER_PRIVATE}:"
docker login ${DOCKER_PRIVATE}
EXEC=$?
if [[ "${EXEC}" != "0" ]]
then
  echo "Unable to complete docker login :-("
  exit 1
fi

# Clone NPNEV repo
echo ""
echo "Cloning configuration..."
git clone ${NPNEV_REPO} ${PROJECT_DIR}
echo ""

# Generate .env file
cat << EOF > ${PROJECT_DIR}/.env
NEV_VERSION=${NEV_VERSION}
NUXEO_URL=${NUXEO_URL}
NUXEO_SECRET=${NUXEO_SECRET}
EOF

# Run everything in PROJECT_DIR dir
cd ${PROJECT_DIR}

# Pull images
echo "Pulling Docker images..."
docker-compose pull
echo ""

# Finish up...
echo "=========================================================================="
echo "DONE! Don't forget to update your Nuxeo Server configuration:"
echo ""
echo "* Install 'nuxeo-arender' plugin (check https://doc.nuxeo.com/nxdoc/nuxeo-enhanced-viewer-release-notes/ for correct version)"
echo "* Update Nuxeo conf file(s):"
echo ""
echo "arender.server.previewer.host=<previewer_url>"
echo "nuxeo.arender.oauth2.client.create=true"
echo "nuxeo.arender.oauth2.client.id=arender"
echo "nuxeo.arender.oauth2.client.secret=${NUXEO_SECRET}"
echo "nuxeo.arender.oauth2.client.redirectURI=/login/oauth2/code/nuxeo"

# Display startup instructions
if [ -e notes.txt ]
then
  echo ""
  cat notes.txt
fi