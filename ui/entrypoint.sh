#!/bin/sh

# If the container was started with -e API_URL=...
if [ -n "$API_URL" ]; then
  echo "Replacing default API URL with $API_URL"
  sed -i "s|http://localhost:5000/|$API_URL|g" /usr/share/nginx/html/config/config.json
fi

# Finally, run whatever command was passed (nginx by default)
exec "$@"
