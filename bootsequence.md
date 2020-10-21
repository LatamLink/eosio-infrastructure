# LACCHAIN BOOT SEQUENCE 

## 1 start a nodeos endpoint
TODO 

## 2 activate  PREACTIVATE_FEATURE 
Adds privileged intrinsic to enable a contract to pre-activate a protocol feature specified by its digest

```bash
curl -X POST http://127.0.0.1:8888/v1/producer/schedule_protocol_feature_activations -d '{"protocol    _features_to_activate": ["0ec7e080177b2c02b278d5088611686b49d739925a92d9bfcacd7fc6b74053bd"]}'
```
## 3 set contract eosio.boot

```bash
cleos-lacchain set contract eosio build/contracts/eosio.boot -p eosio
```

## 4 activate rest of the features

```bash
cleos-lacchain push action eosio activate '["1a99a59d87e06e09ec5b028a9cbb7749b4a5ad8819004365d02dc4379a8b7241"]' -p eosio
cleos-lacchain push action eosio activate '["2652f5f96006294109b3dd0bbde63693f55324af452b799ee137a81a905eed25"]' -p eosio
cleos-lacchain push action eosio activate '["299dcb6af692324b899b39f16d5a530a33062804e41f09dc97e9f156b4476707"]' -p eosio
cleos-lacchain push action eosio activate '["ef43112c6543b88db2283a2e077278c315ae2c84719a8b25f25cc88565fbea99"]' -p eosio
cleos-lacchain push action eosio activate '["4a90c00d55454dc5b059055ca213579c6ea856967712a56017487886a4d4cc0f"]' -p eosio
cleos-lacchain push action eosio activate '["4e7bf348da00a945489b2a681749eb56f5de00b900014e137ddae39f48f69d67"]' -p eosio
cleos-lacchain push action eosio activate '["4fca8bd82bbd181e714e283f83e1b45d95ca5af40fb89ad3977b653c448f78c2"]' -p eosio
cleos-lacchain push action eosio activate '["68dcaa34c0517d19666e6b33add67351d8c5f69e999ca1e37931bc410a297428"]' -p eosio
cleos-lacchain push action eosio activate '["8ba52fe7a3956c5cd3a656a3174b931d3bb2abb45578befc59f283ecd816a405"]' -p eosio
cleos-lacchain push action eosio activate '["ad9e3d8f650687709fd68f4b90b41f7d825a365b02c23a636cef88ac2ac00c43"]' -p eosio
cleos-lacchain push action eosio activate '["e0fb64b1085cc5538970158d05a009c24e276fb94e1a0bf6a528b48fbc4ff526"]' -p eosio
cleos-lacchain push action eosio activate '["f0af56d2c5a48d60a4a5b5c903edfb7db3a736a94ed589d0b797df33ff9d3e1d"]' -p eosio

```

## 5 create msig and token accounts
```bash
cleos-lacchain create account eosio eosio.msig EOS7qcJthkbpufbdCoXWZGYoQYSSzZgn18YfFJmjMp7atbg1JqpQv
cleos-lacchain create account eosio eosio.token EOS8bZ6qQ124uaMZtomu1CUMPpXyaRVyT8HFQ67DEHnEwaed7f9YM
```

## 6 add writer account and abi

```bash
cleos-lacchain push action eosio newaccount \
'{
    "creator" : "eosio",
    "name" : "writer",
    "active" : {
        "threshold":1,
        "keys":[],
        "accounts":[{"weight":1, "permission" :{"actor":"eosio", "permission":"active"}}],
        "waits":[]
    },
    "owner" : {
        "threshold":1,
        "keys":[],
        "accounts":[{"weight":1, "permission":{"actor":"eosio", "permission":"active"}}],
        "waits":[]
    }
}' -p eosio

```

**writer.abi**

```bash
{
    "____comment": "This file was generated with eosio-abigen. DO NOT EDIT ",
    "version": "eosio::abi/1.1",
    "types": [],
    "structs": [
        {
            "name": "run",
            "base": "",
            "fields": []
        }
    ],
    "actions": [
        {
            "name": "run",
            "type": "run",
            "ricardian_contract": ""
        }
    ],
    "tables": [],
    "ricardian_clauses": [],
    "variants": []
}
```

```bash
cleos-lacchain set abi writer writer.abi -p writer@owner

```

## 7 set token and msig contracts
```bash
cleos-lacchain set contract eosio.token eosio.token/
cleos-lacchain set contract eosio.msig eosio.msig/
```

## 8 set lacchain-system
```bash
cleos-lacchain set contract eosio contracts/build/contracts/lacchain.system -p eosio
```

## 9 set privs of msig account
```bash
  cleos push action eosio setpriv  '["eosio.msig", 1]' -p eosio@active

```

## 10 create writer access permission

```bash
cleos-lacchain set account permission writer access \
'{
    "threshold":1,
    "keys":[],
    "accounts":[{"weight":1, "permission" :{"actor":"eosio", "permission":"active"}}],
    "waits":[]
}' owner -p writer@owner
```

## 11 set 0 resources to writer account
```bash
cleos-lacchain push action eosio setalimits '["writer", 10485760, 0, 0]' -p eosio
```

## 12 create boot validators entity
```bash
cleos-lacchain push action eosio addentity '["latamlink", 1, 'EOS8ThTgXb7wgaRLiPP8hFAcwnBqrQCYgb1kTf9Jk7K933ELGifXg']' -p eosio@active
```
## 13 add boot validators

add as many as needed, currently lacchain testnet have 3 validators costarica, argentina, iadb.v1
```bash
cleos-lacchain push action eosio addvalidator \
    '{
    "entity": "latamlink",
    "name": "validator1",
    "validator_authority": [
      "block_signing_authority_v0",
      {
        "threshold": 1,
        "keys": [{
          "key": "EOS5hLiffucJGRBfHACDGMa4h2gc5t43hJC3mJq5NqN9BfArhEcva",
          "weight": 1
        }]
      }
    ]
  }' -p latamlink@active
```

## 14 set schedule for validators
```bash
cleos-lacchain push action eosio ^Ctschedule '[["ar1","ar2","cr1","iadb.v1"]]' -p eosio
```

## 15 create comitee accounts
```bash
cleos-lacchain create account eosio b1 EOS5hLiffucJGRBfHACDGMa4h2gc5t43hJC3mJq5NqN9BfArhEcva
cleos-lacchain create account eosio iadb EOS8ThTgXb7wgaRLiPP8hFAcwnBqrQCYgb1kTf9Jk7K933ELGifXg
```

## 16 change active and owner permission of eosio to comite
```bash

cleos-lacchain set account permission eosio active \
'{
    "threshold":2,
    "keys":[],
    "accounts":[
        {"weight":1, "permission" :{"actor":"b1", "permission":"active"}},
        {"weight":1, "permission" :{"actor":"iadb", "permission":"active"}}
    ],
    "waits":[]
}' owner -p eosio@owner

```

```bash
cleos-lacchain set account permission eosio owner \
'{
    "threshold":2,
    "keys":[],
    "accounts":[
        {"weight":1, "permission" :{"actor":"b1", "permission":"owner"}},
        {"weight":1, "permission" :{"actor":"iadb", "permission":"owner"}}
    ],
    "waits":[]
}' -p eosio@owner

```

