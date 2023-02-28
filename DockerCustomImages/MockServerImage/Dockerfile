FROM node:15 

WORKDIR /app 

COPY package*.json ./

RUN npm install

COPY . . 
 

EXPOSE 8282

CMD [ "npm", "run", "server" ]