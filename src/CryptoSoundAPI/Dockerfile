FROM public.ecr.aws/docker/library/node:15.14.0-alpine
RUN apt-get -y update
WORKDIR /app
COPY package.json /app
RUN npm install
COPY . /app
EXPOSE 80
EXPOSE 443
ENTRYPOINT [ "node", "api.js" ]