FROM node:8.12.0-alpine

ARG IMAGE_NAME=gcr.io/camundatest-223313/hello-world:latest
ENV NODE_ENV=test
ENV CI=true

WORKDIR /usr/src/app

COPY package.json ./
COPY yarn.lock ./
RUN yarn install
RUN yarn global add serve

COPY . .
RUN sed -i '' -e  "s,IMAGE_NAME,${IMAGE_NAME}," k8s/*.yaml
RUN npm run test

ENV NODE_ENV=production
RUN npm run build

ENV PORT=3000
EXPOSE 3000
CMD ["serve", "-s", "build"]
