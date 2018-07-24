#!/bin/bash

set -x

cleos create account eosio badeosiocode EOS7ijWCBmoXBi3CgtK7DJxentZZeTkeUnaSDvyro9dq7Sd1C3dC4
cleos create account eosio eosiocode111 EOS7ijWCBmoXBi3CgtK7DJxentZZeTkeUnaSDvyro9dq7Sd1C3dC4
cleos create account eosio eosiocode112 EOS7ijWCBmoXBi3CgtK7DJxentZZeTkeUnaSDvyro9dq7Sd1C3dC4

cleos push action eosio.token issue '[ "badeosiocode", "100000000.0000 EOS", "memo" ]' -p eosio@active
cleos push action eosio.token issue '[ "eosiocode111", "100000000.0000 EOS", "memo" ]' -p eosio@active

cleos set contract badeosiocode ../badeosiocode -p badeosiocode@active
cleos set account permission badeosiocode active '{"threshold": 1,"keys": [{"key": "EOS7ijWCBmoXBi3CgtK7DJxentZZeTkeUnaSDvyro9dq7Sd1C3dC4","weight": 1}],"accounts": [{"permission":{"actor":"badeosiocode","permission":"eosio.code"},"weight":1}]}' owner -p badeosiocode
cleos set account permission eosiocode111 active '{"threshold": 1,"keys": [{"key": "EOS7ijWCBmoXBi3CgtK7DJxentZZeTkeUnaSDvyro9dq7Sd1C3dC4","weight": 1}],"accounts": [{"permission":{"actor":"badeosiocode","permission":"eosio.code"},"weight":1}]}' owner -p eosiocode111

cleos get account badeosiocode | grep liquid
cleos get account eosiocode111 | grep liquid

cleos push action badeosiocode hi '["eosiocode111"]' -p eosiocode111@active
cleos push action badeosiocode hi '["eosiocode112"]' -p eosiocode112@active

cleos get account badeosiocode | grep liquid
cleos get account eosiocode111 | grep liquid

