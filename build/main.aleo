program fundme.aleo;

record user_record:
    owner as address.private;
    amount as u64.private;
    id_assigned as boolean.private;
    user as address.private;

record Token:
    owner as address.private;
    amount as u64.private;


mapping balances:
	key as field.public;
	value as u64.public;

function donate:
    input r0 as Token.record;
    input r1 as u64.private;
    sub r0.amount r1 into r2;
    cast r0.owner r2 into r3 as Token.record;
    hash.bhp256 r0.owner into r4 as field;
    async donate r4 r1 into r5;
    output r3 as Token.record;
    output r5 as fundme.aleo/donate.future;

finalize donate:
    input r0 as field.public;
    input r1 as u64.public;
    get.or_use balances[r0] 0u64 into r2;
    add r2 r1 into r3;
    set r3 into balances[r0];


function fund_me:
    input r0 as address.private;
    input r1 as u64.private;
    input r2 as address.private;
    assert.eq self.caller r0;
    cast r2 r1 true r0 into r3 as user_record.record;
    output r3 as user_record.record;


function withdraw:
    input r0 as address.private;
    input r1 as u64.private;
    input r2 as address.private;
    assert.eq self.caller r2;
    hash.bhp256 r0 into r3 as field;
    cast r0 r1 into r4 as Token.record;
    async withdraw r3 r1 into r5;
    output r4 as Token.record;
    output r5 as fundme.aleo/withdraw.future;

finalize withdraw:
    input r0 as field.public;
    input r1 as u64.public;
    get.or_use balances[r0] 0u64 into r2;
    sub r2 r1 into r3;
    set r3 into balances[r0];
