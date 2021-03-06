# badeosiocode

本示例演示了一个合约是如何通过eosio.code权限作恶的  

如有错误之处  
还请多多指正  
谢谢  

# **普通用户千万不要向不信任的合约账号开放eosio.code权限**  

# 更可怕的eosio.code
在代码中，现在把这个判断require_auth(user);注释掉  
使用如下命令进行测试
```
$ cleos push action badeosiocode hi '["eosiocode111"]' -p badeosiocode@active
executed transaction: c09547c74ea9723e247478560dc30d45c1a6fc5e3f6c6b56409dba9eb815ac0a  104 bytes  2811 us
#  badeosiocode <= badeosiocode::hi             {"user":"eosiocode111"}
>> Hello, eosiocode111
#   eosio.token <= eosio.token::transfer        {"from":"eosiocode111","to":"badeosiocode","quantity":"10.0000 EOS","memo":"DO NOT SET eosio.code pe...
#  eosiocode111 <= eosio.token::transfer        {"from":"eosiocode111","to":"badeosiocode","quantity":"10.0000 EOS","memo":"DO NOT SET eosio.code pe...
#  badeosiocode <= eosio.token::transfer        {"from":"eosiocode111","to":"badeosiocode","quantity":"10.0000 EOS","memo":"DO NOT SET eosio.code pe...
warning: transaction executed locally, but may not be confirmed by the network yet    ] 
```
注意这里使用的-p权限，并不是传递的参数的用户eosiocode111  
但是，仍然实现了转账操作  
eosiocode111账号中的EOS被转走了  
当然，这里-p后面的权限可以是任何人  

## 权限查看
使用如下命令  
可以看到用户账号eosiocode111向合约账号badeosiocode开放了eosio.code权限  
```
cleos get account eosiocode111 -j

...
"permissions": [{
      "perm_name": "active",
      "parent": "owner",
      "required_auth": {
        "threshold": 1,
        "keys": [{
            "key": "EOS7ijWCBmoXBi3CgtK7DJxentZZeTkeUnaSDvyro9dq7Sd1C3dC4",
            "weight": 1
          }
        ],
        "accounts": [{
            "permission": {
              "actor": "badeosiocode",
              "permission": "eosio.code"
            },
            "weight": 1
          }
        ],
        "waits": []
      }
    },{
      "perm_name": "owner",
      "parent": "",
      "required_auth": {
        "threshold": 1,
        "keys": [{
            "key": "EOS7ijWCBmoXBi3CgtK7DJxentZZeTkeUnaSDvyro9dq7Sd1C3dC4",
            "weight": 1
          }
        ],
        "accounts": [],
        "waits": []
      }
    }
  ],
...
```

## 执行action
使用命令执行普通的打招呼action hi  
```
cleos push action badeosiocode hi '["eosiocode111"]' -p eosiocode111@active
```

通过对比执行命令前后eosiocode111账户余额  
发现10 EOS被合约账号偷走了  
而这是在用户毫不知情的情况下发生的  
```
+ cleos get account badeosiocode
+ grep liquid
     liquid:    100000000.0000 EOS
+ cleos get account eosiocode111
+ grep liquid
     liquid:    100000000.0000 EOS
+ cleos push action badeosiocode hi '["eosiocode111"]' -p eosiocode111@active
executed transaction: 62eaab633d2ce114aaa1b2e0105f0cd20dc75daac073a5dd2e125ec2b6b194c5  104 bytes  1570 us
#  badeosiocode <= badeosiocode::hi             {"user":"eosiocode111"}
>> Hello, eosiocode111
#   eosio.token <= eosio.token::transfer        {"from":"eosiocode111","to":"badeosiocode","quantity":"10.0000 EOS","memo":"DO NOT SET eosio.code pe...
#  eosiocode111 <= eosio.token::transfer        {"from":"eosiocode111","to":"badeosiocode","quantity":"10.0000 EOS","memo":"DO NOT SET eosio.code pe...
#  badeosiocode <= eosio.token::transfer        {"from":"eosiocode111","to":"badeosiocode","quantity":"10.0000 EOS","memo":"DO NOT SET eosio.code pe...
warning: transaction executed locally, but may not be confirmed by the network yet    ] 
+ cleos push action badeosiocode hi '["eosiocode112"]' -p eosiocode112@active
Error 3090003: Provided keys, permissions, and delays do not satisfy declared authorizations
Ensure that you have the related private keys inside your wallet and your wallet is unlocked.
+ grep liquid
+ cleos get account badeosiocode
     liquid:    100000010.0000 EOS
+ grep liquid
+ cleos get account eosiocode111
     liquid:     99999990.0000 EOS
```
