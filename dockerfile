FROM node:14
WORKDIR /app
COPY *.json ./
RUN npm install
RUN npm install --save-dev mocha supertest
COPY . .
EXPOSE 3000
CMD [ "node", "index.js"]