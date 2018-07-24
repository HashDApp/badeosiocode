/**
 *  @badeosiocode
 */

#include <eosiolib/eosio.hpp>
#include <eosio.token/eosio.token.hpp>

using namespace eosio;

namespace hashdapp {

    class badeosiocode : public eosio::contract {
        public:
            badeosiocode(account_name self):
                contract(self)
                {
                }

            /// @abi action
            void hi( account_name user );
    };

}
