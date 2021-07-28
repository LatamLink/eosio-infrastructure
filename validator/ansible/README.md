# Install EOSIO node using EOS Detroit's nodesuite

## Manually adjusting config files:

To set up a LACChain EOSIO node using ansible, please follow the following steps:

* Clone the EOS Detroit's Ansible scripts:

```bash
git clone https://github.com/eosdetroit/nodesuite
cd nodesuite
```

* Create a first set up environment:

```bash
python3 nodesuite_cli.py setup
```

* Select EOS, dev, and No.

* Modify ```inventories/eos.yml``` with your node's IP address, ssh key, user, and API URL.

* The default target OS configured in the `nodesuite` repository is `ubuntu-18.04_amd64`. You may change that
  in `group_vars/all` under the `package` parameter.

* Run the Ansible playbooks to install the required dependencies.

```bash
ansible-playbook -v initialize-eosio-genesis-node.yml -i inventories/eos.yml -e "target=dev" -e "testnet_name=''"
```

* Login to your node, adjust the following files according to your needs and start nodeos:

```bash
cd /opt/eosio/deploy/
sudo nano config.ini
sudo nano genesis.json
sudo nodeos --delete-all-blocks --genesis-json genesis.json --disable-replay-opts --config-dir ./ --data-dir data/
```

## Automatically generating the config files:

All the configuration files necessary for the set up of a LACChain node can be found under `data` directory.
Please follow the next steps to proceed with the installation:

* Clone the EOS Detroit's Ansible scripts (do it in a separated directory from the current one):

```bash
git clone https://github.com/eosdetroit/nodesuite
cd nodesuite
```

In the current EOSIO-infrastructure directory:

* Edit `data/inventories/lacchain.yml` with your node's IP address, ssh key, user, and API URL.

* In `data/stage_vars/lacchain/dev/vars.yml` modify `peer_pubkey` and `peer_privkey` with your peer keys.

* Copy all the required configuration files to the nodesuite directory:

```bash
./custom-nodesuite.sh <NODESUITE_PATH>
```

* Run the Ansible playbooks to install the required dependencies.

```bash
ansible-playbook -v initialize-eosio-genesis-node.yml -i inventories/lacchain.yml -e "target=dev" -e "testnet_name=''"
```

* Login to your node, check that `config.ini` is configured according to your needs:

```bash
cd /opt/eosio/deploy/
sudo nano config.ini
```

* If `nodeos` is not already running, start it:

```bash
sudo nodeos --delete-all-blocks --genesis-json genesis.json --disable-replay-opts --config-dir ./ --data-dir data/
```
