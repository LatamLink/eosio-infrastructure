FROM node:14.2.0

RUN apt-get update && apt-get install -y build-essential

WORKDIR /app
RUN git clone https://github.com/eoscostarica/eosio-explorer
WORKDIR /app/eosio-explorer

COPY env-config.js public/env-config.js

RUN yarn install
RUN yarn run react-app-rewired build

CMD ["./scripts/start_gui.sh"]
