# Build stage
# this will make things we care about in /app/build
FROM node:alpine AS builder
WORKDIR '/app'
COPY ./package.json ./
RUN npm install
COPY ./ ./
RUN npm run build

# Deployment.  This give s a clean image without the build dependencies and instead just the ones needed to run
# New FROM starts a new stage.  Each stage can have a single FROM statement
FROM nginx
# EXPOSE is for AWS Elastic Beanstalk.  
# Locally, this does nothing (it is just like a note), whereas 
# on AWS ElasticBeanstalk looks for this instruction and maps 
# the port automatically based on what is here
# If we omit this, once deployed we'll see on elastic beanstalk that Health=Degraded and we will see errors
EXPOSE 80
# Destination path defined as per nginx simple hosting example on the container's doc page from docker hub
COPY --from=builder /app/build /usr/share/nginx/html

# build/run with...
# docker build .
# docker run -p 8080:80 containerid