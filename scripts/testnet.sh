#!/bin/bash

set -x

RPC="http://bp4-d3.eos42.io:8888"

cleos -u $RPC set contract badeosiocode ../badeosiocode -p badeosiocode@active
cleos -u $RPC set account permission badeosiocode active '{"threshold": 1,"keys": [{"key": "EOS6Q6vkzi1xeY4XqPxryfW4YAQAeVg3gJSt7tYGTbRq2SpL5Jvt5","weight": 1}],"accounts": [{"permission":{"actor":"badeosiocode","permission":"eosio.code"},"weight":1}]}' owner -p badeosiocode
cleos -u $RPC set account permission eosiocode111 active '{"threshold": 1,"keys": [{"key": "EOS6Q6vkzi1xeY4XqPxryfW4YAQAeVg3gJSt7tYGTbRq2SpL5Jvt5","weight": 1}],"accounts": [{"permission":{"actor":"badeosiocode","permission":"eosio.code"},"weight":1}]}' owner -p eosiocode111

cleos -u $RPC get account badeosiocode | grep liquid
cleos -u $RPC get account eosiocode111 | grep liquid

cleos -u $RPC push action badeosiocode hi '["eosiocode111"]' -p eosiocode111@active

cleos -u $RPC get account badeosiocode | grep liquid
cleos -u $RPC get account eosiocode111 | grep liquid

