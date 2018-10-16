# Tùy vào dự án của bạn sẽ thay đổi Ruby version của mình
FROM ruby:2.5.0

# Install các package cần thiết
RUN apt-get install gulp

WORKDIR /gaomedia

COPY package.json /gaomedia/package.json

RUN npm install
ADD . /gaomedia/

EXPOSE 8000