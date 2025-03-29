# Generate docker image for frontend
# Use an official Nginx runtime as the base image for static file hosting
# and an entrypoint script to dynamically replace the API URL in config.json at runtime.
FROM nginx:alpine

# We'll need 'sed' for the runtime substitution
RUN apk add --no-cache bash

# Set container's work directory to the default Nginx web root directory
WORKDIR /usr/share/nginx/html

# Copy all frontend files (HTML, JavaScript, CSS, etc.)
COPY . .

# Copy an entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Expose port 80, which Nginx will listen on
EXPOSE 80
ENTRYPOINT ["/entrypoint.sh"]
# Start Nginx when the container is run
CMD ["nginx", "-g", "daemon off;"]
