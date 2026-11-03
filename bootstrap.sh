#!/bin/bash

# ==============================================================================
# Bootstrap script to create a docker compose tooling for Nuxeo Enhanced Viewer.
# ==============================================================================

NPNEV_REPO="https://github.com/nuxeo-sandbox/nuxeo-presales-nev"
DOCKER_PRIVATE="docker-arender.packages.nuxeo.com"
PROJECT_DIR="nuxeo-presales-nev"
NEV_VERSION_DEFAULT="2026.2.0"

# Check for commands used in this script
CHECKS=()
command -v git >/dev/null || CHECKS+=("git")
command -v docker >/dev/null || CHECKS+=("docker")
command -v make >/dev/null || CHECKS+=("make")
command -v uuidgen >/dev/null || CHECKS+=("uuidgen")

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

# Allow use of a different branch, useful for testing, default is `main`.

# Allow passing NPNEV branch as a param.
NPNEV_BRANCH=${NPNEV_BRANCH:-main}

# Allow use of a different branch with a flag.
while getopts b: flag
do
  case "${flag}" in
    b) NPNEV_BRANCH=${OPTARG};;
  esac
done

# ==============================================================================
# User inputs
# ==============================================================================

# NEV Version
# ===========
NEV_VERSION="${NEV_VERSION:-}"
if [ -z "${NEV_VERSION}" ]
then
  read -p "NEV Version [${NEV_VERSION_DEFAULT}]: " NEV_VERSION
  NEV_VERSION=${NEV_VERSION:-${NEV_VERSION_DEFAULT}}
fi

# Nuxeo URL
# =========
# Required, loop until we get a value.
NUXEO_URL="${NUXEO_URL:-}"
while [ -z "${NUXEO_URL}" ]
do
  read -p "Nuxeo Application URL (e.g. https://my-demo.cloud.nuxeo.com/nuxeo): " NUXEO_URL
done

# OAUTH2 secret
# =============
DEFAULT_TOKEN=$(uuidgen)
NUXEO_SECRET="${NUXEO_SECRET:-}"
if [ -z "${NUXEO_SECRET}" ]
then
  read -p "OAUTH2 secret [${DEFAULT_TOKEN}]: " NUXEO_SECRET
  NUXEO_SECRET=${NUXEO_SECRET:-${DEFAULT_TOKEN}}
fi

# We don't want to run this script on existing folders...
if [ -e ${PROJECT_DIR} ]
then
  echo "Hmm, the directory ${PWD}/${PROJECT_DIR} already exists.  I'm going to exit and let you sort that out."
  exit 3
fi

# ==============================================================================
# Credentials
# ==============================================================================

# Login to private repo
# ======================
# Check to see if user already has saved credentials
grep -q ${DOCKER_PRIVATE} ${HOME}/.docker/config.json 2>/dev/null
FOUND=$?
if [[ "${FOUND}" != "0" ]]
then
  echo
  echo "Logging in to ${DOCKER_PRIVATE}:"
  docker login ${DOCKER_PRIVATE}
  DOCKER_LOGIN_OK=$?
  if [[ "${DOCKER_LOGIN_OK}" != "0" ]]
  then
    echo "Unable to complete docker login"
    exit 1
  fi
fi

# ==============================================================================
# Summarize
# ==============================================================================

echo
echo "NEV version:            ${NEV_VERSION}"
echo "Nuxeo Application URL:  ${NUXEO_URL}"
echo "OAUTH2 secret:          ${NUXEO_SECRET}"
echo "NPNEV Branch:           ${NPNEV_BRANCH}"

echo
echo "Here's what will happen next:"
echo
echo "* Scaffold a folder for your stack"
echo "* Pull docker images"

echo
read -p "Ready? (y|n) [y]: " response
response=${response:-y}
if [[ "$response" != "y" ]]
then
  exit 0
fi

echo
echo "Please wait, getting things ready..."

# ==============================================================================
# Do the things
# ==============================================================================

# Clone NPNEV to scaffold project folder...
echo
echo "================================================================================"
echo "Scaffolding stack folder..."
echo "================================================================================"
echo
git clone -b ${NPNEV_BRANCH} ${NPNEV_REPO} ${PROJECT_DIR}

# Generate .env file
cat << EOF > ${PROJECT_DIR}/.env
ENV_NEV_VERSION=${NEV_VERSION}
ENV_NUXEO_URL=${NUXEO_URL}
ENV_NUXEO_SECRET=${NUXEO_SECRET}
EOF

# Run everything in project dir
cd ${PROJECT_DIR}

# Pull images
echo
echo "================================================================================"
echo "Pulling Docker images..."
echo "================================================================================"
echo
docker compose pull

echo
echo "================================================================================"
echo "Installation complete."
echo "================================================================================"

echo
echo "Don't forget to add the OAuth2 secret (${NUXEO_SECRET}) to"
echo "your Nuxeo Server configuration. To start your stack:"
echo
echo "cd ${PROJECT_DIR} && docker compose up -d"
echo
