# Stage 1: Build the React application
FROM node:14-alpine as build
WORKDIR /app

# Copy package files and install dependencies
COPY package*.json ./
RUN npm install

# Copy the rest of the app’s source code and build the app
COPY . .
RUN npm run build

# Stage 2: Serve the app using Nginx
FROM nginx:stable-alpine
# Remove default Nginx static assets, if desired
RUN rm -rf /usr/share/nginx/html/*
# Copy built files from the build stage
COPY --from=build /app/build /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
