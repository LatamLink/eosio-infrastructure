# groups
We can create groups for different nodes, for example group b1 for a group of boots

# 1 add groups

**empty validator group**
```bash
cleos-lacchain push action eosio netaddgroup '["v1",[]]' -p eosio@active
```
**group with one member**
```bash
cleos-lacchain push action eosio netaddgroup '["b1", ["boot-ar"]]' -p eosio@active
```
```bash
cleos-lacchain push action eosio netaddgroup '["b2", []]' -p eosio@active
```
```bash
cleos-lacchain push action eosio netaddgroup '["w1", []]' -p eosio@active
```
```bash
cleos-lacchain push action eosio netaddgroup '["o1", []]' -p eosio@active
```

# 2 set node to group or groups
```bash
  cleos push action eosio netsetgroup '["validator1", ["v1","v2"]]' -p eosio@active
```

# 3 checking

```bash
cleos-lacchain get table eosio eosio netgroup
```


