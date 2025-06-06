# Use an official Node.js image
FROM node:18

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and install dependencies
COPY package.json package-lock.json ./
RUN npm install

# Copy the rest of the app files
COPY . .

# Expose port 3000
EXPOSE 3000

# Define the command to run the app
CMD ["node", "index.js"]