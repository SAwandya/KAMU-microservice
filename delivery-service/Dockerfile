# Use an official Node runtime as the base image
FROM node:18-alpine

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY src/ ./src/

# Expose the port the app runs on
#EXPOSE 5000
EXPOSE 3003

# Define the command to run the app
CMD ["node", "src/server.js"]