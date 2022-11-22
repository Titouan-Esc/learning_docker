# Image node alpine
FROM node:alpine
# Place in folder app
WORKDIR /app
# Copy the current folder and paste
COPY . .
#  Run npm install
RUN npm install
# Update env path for all bin in node_modules
ENV PATH=$PATH:/app/node_modules/.bin
# Run command in terminal
CMD ["nodemon", "app.js"]