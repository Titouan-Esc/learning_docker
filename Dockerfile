# Image node alpine
FROM node:alpine
# Place in folder app
WORKDIR /app
# Twice so you don't have to order every time "npm install"
# Copy the current folder and paste
COPY ./package.json .
#  Run npm install
RUN npm install

COPY . .

# Update env path for all bin in node_modules
ENV PATH=$PATH:/app/node_modules/.bin
# Run command in terminal
CMD ["nodemon", "src/app.js"]