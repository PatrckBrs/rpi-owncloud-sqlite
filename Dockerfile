# Pull base image
FROM resin/rpi-raspbian:latest

RUN apt-get -y update && apt-get install -y fortunes

CMD /usr/games/fortune -a | cowsay
