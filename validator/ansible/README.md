# Install EOSIO node using EOS Detroit's nodesuite

## Manually adjusting config files:

To set up a LACChain EOSIO node using ansible, please follow the following steps:

* Clone the EOS Detroit's Ansible scripts:

```bash
git clone https://github.com/eosdetroit/nodesuite
cd nodesuite
```

* Create a firt set up environment:

```bash
python3 nodesuite_cli.py setup
```

* Select EOS, dev, and No.

* Modify ```inventories/eos.yml``` with your node's IP address, ssh key, user, and API URL.

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

* In progress....
