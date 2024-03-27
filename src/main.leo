// The 'fundme' program.
program fundme.aleo {
    mapping balances: field => u64;
    
    record user_record {
        owner: address;
        amount: u64;
        id_assigned: bool;
        user: address;
       
    }
   

record Token {
    owner: address,
    amount: u64,
    
}
 transition donate(token: Token, amount: u64) -> Token {
        let difference: u64 = token.amount - amount;

        let remaining: Token = Token {
            owner: token.owner,
            amount: difference,
        };
         let hash: field = BHP256::hash_to_field(token.owner);
         return remaining then finalize(hash, amount);


 }
 

 finalize donate(hash: field, amount: u64) {
        let current_amount: u64 = Mapping::get_or_use(balances, hash, 0u64);
        Mapping::set(balances, hash, current_amount + amount);
}
 
 transition fund_me ( user: address, amount: u64, this: address ) -> user_record {
        assert_eq(self.caller,user );
       
        return user_record {
            owner: this,
            amount: amount,
            id_assigned: true,
            user: user,
          };    
          
 }
   
    transition withdraw(recipient: address, total: u64, this:address) -> Token {
        assert_eq(self.caller, this);
        let hash: field = BHP256::hash_to_field(recipient);

        let token: Token = Token {
            owner: recipient,
            amount: total,
        };

        return token then finalize(hash, total);
    }

   
    finalize withdraw(hash: field, amount: u64) {
        let current_amount: u64 = Mapping::get_or_use(balances, hash, 0u64);
        Mapping::set(balances, hash, current_amount - amount);
    }
}
