FROM node:16 as build

COPY package.json yarn.lock ./
RUN yarn

COPY tsconfig.json .
ADD @types ./@types/
ADD src ./src/

RUN yarn compile
RUN npm prune --production

FROM node:16-alpine
COPY --from=build ./build ./
COPY --from=build ./node_modules ./node_modules

CMD node /src