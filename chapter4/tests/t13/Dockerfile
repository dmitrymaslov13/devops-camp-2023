ARG NODE_IMAGE_VERSION=16-alpine

FROM --platform=$BUILDPLATFORM node:$NODE_IMAGE_VERSION

WORKDIR /app

RUN apk add git
RUN git clone https://github.com/udaltsovra/flatris .
RUN yarn install && yarn build

EXPOSE 3000
ENTRYPOINT ["yarn", "start"]
