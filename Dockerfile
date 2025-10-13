name: CICD

on:
push:
branches: [main]

jobs:
build:
runs-on: ubuntu-latest
steps:
- name: Checkout source
uses: actions/checkout@v3
- name: Login to Docker Hub
run: docker login -u ${{ secrets.DOCKER_USERNAME }} -p ${{ secrets.DOCKER_PASSWORD }}
- name: Build Docker image
run: docker build -t ali769/webproject:latest .
- name: Publish image to Docker Hub
run: docker push ali769/webproject:latest

deploy:
needs: build
runs-on: self-hosted  # Runs on AWS EC2 instance
steps:
- name: Login to Docker Hub
run: docker login -u ${{ secrets.DOCKER_USERNAME }} -p ${{ secrets.DOCKER_PASSWORD }}
- name: Pull image from Docker Hub
run: docker pull ali769/webproject:latest
- name: Delete old container (if exists)
run: docker rm -f web-app-container || true
- name: Run Docker container
run: docker run -d -p 8080:80 --name web-app-container ali769/webproject:latest