#!/bin/sh
# This script checks if API_URL is defined. If it is, it replaces http://localhost:5000/ in config.json with the value of $API_URL. 
# This is how we can dynamically update the UI to point to the correct API endpoint when deploying to different environments

# If the container was started with -e API_URL=...
if [ -n "$API_URL" ]; then
  echo "Replacing default API URL with $API_URL"
  sed -i "s|http://localhost:5000/|$API_URL|g" /usr/share/nginx/html/config/config.json
fi

# Finally, run whatever command was passed (nginx by default)
exec "$@"

