FROM ubuntu:latest
RUN apt-get update -y
RUN export DEBIAN_FRONTEND=noninteractive && apt-get install -y apache2
RUN echo "[INFO] Hi This is Prepared by Kul" >> /var/www/html/kul.html
