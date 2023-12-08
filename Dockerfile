# Stage 1: Build stage
FROM node:lts as builder

WORKDIR /app

# Copy only the package files to leverage Docker cache
COPY package.json ./
COPY package-lock.json ./

# Install all dependencies (including dev)
RUN npm install

# Copy the rest of the app source
COPY . .

# Build your app (if necessary)
# RUN npm run build

# Stage 2: Production stage
FROM node:lts-alpine

WORKDIR /app

# Copy only necessary files from the previous stage
COPY --from=builder /app . 

# Expose the port that the app will run on
EXPOSE 3000

# Define environment variable for MongoDB connection
ENV MONGO_URL "mongodb://mongo:27017/tasks"

# Command to run the application
CMD ["node", "index.js"]
