#!/bin/bash

# Configuration
LOCAL_DIR="./my-static-site/"  # Local directory with your site files
REMOTE_USER="vkenjo"           # Your server username
REMOTE_HOST="167.172.87.127"   # Your server IP
REMOTE_DIR="/var/www/my-static-site/"

# Optional: path to a private key to use for SSH (leave empty to use default keys/ssh-agent)
SSH_KEY="${SSH_KEY:-}"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Starting deployment...${NC}"

# Check if local directory exists
if [ ! -d "$LOCAL_DIR" ]; then
    echo -e "${RED}Error: Local directory $LOCAL_DIR does not exist!${NC}"
    exit 1
fi

# Sync files to server
echo -e "${YELLOW}Syncing files to server...${NC}"

# If SSH_KEY is set and the file exists, pass it to rsync's ssh command
RSYNC_SSH_ARGS=()
if [ -n "$SSH_KEY" ] && [ -f "$SSH_KEY" ]; then
    echo -e "${YELLOW}Using SSH key: $SSH_KEY${NC}"
    RSYNC_SSH_ARGS=( -e "ssh -i $SSH_KEY -o IdentitiesOnly=yes" )
fi

rsync "${RSYNC_SSH_ARGS[@]}" -avz --delete \
    --exclude='.git' \
    --exclude='node_modules' \
    --exclude='.DS_Store' \
    --exclude='deploy.sh' \
    "$LOCAL_DIR" "$REMOTE_USER@$REMOTE_HOST:$REMOTE_DIR"

# Check if rsync was successful
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Deployment successful!${NC}"
    echo -e "${GREEN}Your site is now live at: http://$REMOTE_HOST${NC}"
else
    echo -e "${RED}✗ Deployment failed!${NC}"
    exit 1
fi