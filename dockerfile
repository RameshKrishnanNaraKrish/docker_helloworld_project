FROM ubuntu:latest as build
RUN apt-get update && \
apt-get install maven -y && \
apt-get install openjdk-17-jre-headless && \
apt-get install git -y
WORKDIR /app
RUN git clone https://github.com/bkrrajmali/helloworld.git
WORKDIR /app/helloworld/webapp
RUN mvn clean package


#Stage 1
FROM openjdk:11-jre-slim

# Set the working directory
WORKDIR /app

# Copy the built application from the build stage
COPY --from=build /app/helloworld/webapp/target/ /app/

CMD ["java", "-jar", "webapp.war"]

#Stage 2
FROM tomcat:latest

# Copy the built application from the build stage
COPY --from=build /app/helloworld/webapp/target/webapp.war webapps/

EXPOSE 8080
