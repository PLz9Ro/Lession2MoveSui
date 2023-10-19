module object01::PhucLam{
    use sui::object::{Self,UID};
    use sui::tx_context::{Self,TxContext};  
    use sui::transfer;

    //khi khoi tao UID luon phai co Ability phai them haskey 
    struct Bank has key{
        // move k co string (chi co trong framwork)
        id: UID,
        name:vector<u8>,
        balance:u128,// number - insign integer : so nguyen khong am 
        accounts: vector<Account>
    }

    struct Account has key , store{
        id: UID,
        name: vector<u8>,
        balance: u128
    }

    struct Pool has key{
        id: UID,
        balance :u128,
    }

    fun init (ctx: &mut TxContext){
        let bank = create_bank(ctx);
        let pool = Pool{
            id: object::new(ctx),
            balance :0,
        };
        let pool2 = Pool{
            id: object::new(ctx),
            balance :0,
        };
    
        transfer::share_object(pool);//share_object laf ham khong co ng so huu - ai cx co the vao dc
        transfer::freeze_object(pool2);//freeze_object cung giong nhu share nhung chi co the view va k the tuong tac
        transfer::transfer( bank , tx_context::sender(ctx)); // ham chi hoat dong khi vi ng khoi tao goi den ham sender
    }

    public fun create_bank(ctx: &mut TxContext): Bank {
        Bank {
            id: object::new(ctx),
            name: b"VBI Bank",
            balance: 1_000_000_000_000,
            accounts: vector[],
        }
    }

    public entry fun create_account(_: &Bank ,name: vector<u8> , ctx: &mut TxContext ){
        let account = Account{
            id: object::new(ctx),
            name,
            balance: 0,
        };

        transfer::transfer(account, tx_context::sender(ctx));
    }
}