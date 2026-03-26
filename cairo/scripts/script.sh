#!/usr/bin/env bash
# cairo — Cairo / StarkNet Smart Contract Reference
# Powered by BytesAgain | bytesagain.com | hello@bytesagain.com
set -euo pipefail

VERSION="2.0.1"

cmd_syntax() {
    cat <<'EOF'
═══════════════════════════════════════════════════
  Cairo Language Syntax Reference
═══════════════════════════════════════════════════

【Variables & Mutability】
  let x = 5;                  // immutable by default
  let mut x = 5;              // mutable
  x = 10;                     // OK, x is mut
  let x: felt252 = 100;       // explicit type annotation
  const MAX: u32 = 1000;      // compile-time constant

【Functions】
  fn add(a: felt252, b: felt252) -> felt252 {
      a + b       // last expression = return value (no semicolon)
  }

  fn greet() {                // no return value
      println!("Hello");
  }

  fn multi_return() -> (u32, u32) {
      (10, 20)
  }

【Control Flow】
  // if-else (expression-based, returns value)
  let max = if a > b { a } else { b };

  // match (exhaustive pattern matching)
  match color {
      Color::Red => println!("red"),
      Color::Blue => println!("blue"),
      _ => println!("other"),
  }

  // loop
  loop {
      if count >= 10 { break; }
      count += 1;
  };

【Ownership & References (Cairo-specific)】
  // Cairo uses a linear type system (like Rust, stricter)
  fn consume(arr: Array<u32>) { ... }   // takes ownership
  fn borrow(ref arr: Array<u32>) { ... } // mutable reference
  fn snapshot(arr: @Array<u32>) { ... }  // immutable snapshot

  let mut arr = ArrayTrait::new();
  arr.append(1);
  let snap = @arr;           // snapshot (read-only view)
  let len = snap.len();      // OK

【Modules & Imports】
  mod my_module;              // declare module (file: my_module.cairo)

  use core::traits::Into;
  use starknet::ContractAddress;
  use super::MyStruct;

【Traits & Implementations】
  trait Shape<T> {
      fn area(self: @T) -> u256;
  }

  impl RectangleShape of Shape<Rectangle> {
      fn area(self: @Rectangle) -> u256 {
          (*self.width) * (*self.height)
      }
  }

【Attributes (common)】
  #[contract]                 // mark a module as a contract
  #[external(v0)]             // public external function
  #[constructor]              // constructor function
  #[event]                    // event struct
  #[derive(Drop, Serde)]     // auto-derive traits
  #[abi(embed_v0)]            // embed interface impl
  #[storage]                  // storage struct

【Macros】
  println!("value: {}", x);   // debug printing
  assert(x > 0, 'x must > 0'); // assertion with felt short string
  array![1, 2, 3]             // array literal

📖 More skills: bytesagain.com
EOF
}

cmd_types() {
    cat <<'EOF'
═══════════════════════════════════════════════════
  Cairo Type System
═══════════════════════════════════════════════════

【Primitive Types】
  felt252       Field element (0 to P-1, P ≈ 2^251 + 17·2^192 + 1)
  bool          true / false
  u8            Unsigned 8-bit   (0 to 255)
  u16           Unsigned 16-bit  (0 to 65535)
  u32           Unsigned 32-bit  (0 to 4,294,967,295)
  u64           Unsigned 64-bit
  u128          Unsigned 128-bit
  u256          Unsigned 256-bit (two felt252 limbs)
  i8..i128      Signed integers
  usize         Alias for u32

【Type Size on StarkNet】
  felt252       1 storage slot
  u256          2 storage slots (high + low)
  ContractAddress  1 slot (felt252 wrapper)
  bool          1 slot

【Struct】
  #[derive(Drop, Serde, starknet::Store)]
  struct Position {
      x: u128,
      y: u128,
  }

  let pos = Position { x: 10, y: 20 };
  let x_val = pos.x;

【Enum】
  #[derive(Drop, Serde)]
  enum Direction {
      North,
      South,
      East: u128,     // variant with data
      West: u128,
  }

  let d = Direction::North;
  match d {
      Direction::North => ...,
      Direction::South => ...,
      Direction::East(val) => ...,
      Direction::West(val) => ...,
  }

【Option & Result】
  use core::option::OptionTrait;

  let some_val: Option<u32> = Option::Some(42);
  let none_val: Option<u32> = Option::None;

  // unwrap
  let x = some_val.unwrap();        // panics if None
  let x = some_val.unwrap_or(0);    // default fallback

【Array】
  use core::array::ArrayTrait;

  let mut arr = ArrayTrait::new();
  arr.append(1_u32);
  arr.append(2_u32);
  let len = arr.len();              // 2
  let first = *arr.at(0);           // 1 (snapshot deref)

  // Span (immutable view of array)
  let span = arr.span();

【Dict (Felt252Dict)】
  use core::dict::Felt252DictTrait;

  let mut dict = Default::default();
  dict.insert('key', 100);
  let val = dict.get('key');        // 100

  // ⚠️ Dict is non-squashable without explicit handling
  dict.squash();                    // must call at end

【ByteArray (strings)】
  let name: ByteArray = "Hello StarkNet";
  let short: felt252 = 'hi';        // short string (≤31 chars)

【ContractAddress】
  use starknet::ContractAddress;
  use starknet::contract_address_const;

  let addr: ContractAddress = contract_address_const::<0x123>();

【Type Conversions】
  let a: u8 = 10;
  let b: u16 = a.into();            // upcast with Into trait
  let c: u8 = b.try_into().unwrap(); // downcast with TryInto

📖 More skills: bytesagain.com
EOF
}

cmd_storage() {
    cat <<'EOF'
═══════════════════════════════════════════════════
  Cairo / StarkNet Storage Patterns
═══════════════════════════════════════════════════

【Basic Storage Declaration】
  #[storage]
  struct Storage {
      owner: ContractAddress,
      balance: u256,
      counter: u128,
      is_paused: bool,
  }

【Reading Storage】
  fn get_owner(self: @ContractState) -> ContractAddress {
      self.owner.read()
  }

【Writing Storage】
  fn set_owner(ref self: ContractState, new_owner: ContractAddress) {
      self.owner.write(new_owner);
  }

【Storage with Map (LegacyMap)】
  #[storage]
  struct Storage {
      balances: LegacyMap::<ContractAddress, u256>,
      allowances: LegacyMap::<(ContractAddress, ContractAddress), u256>,
  }

  // Read/write map
  let bal = self.balances.read(account);
  self.balances.write(account, new_balance);

  // Nested key (tuple)
  let allowance = self.allowances.read((owner, spender));

【Storage Address Computation】
  // Single variable: sn_keccak(variable_name)
  // Map entry: h(sn_keccak(variable_name), key)
  // Nested map: h(h(sn_keccak(variable_name), key1), key2)
  //
  // h = pedersen hash for LegacyMap
  // This is how StarkNet locates storage slots

【Custom Struct in Storage】
  #[derive(Drop, Serde, starknet::Store)]
  struct UserInfo {
      balance: u256,
      last_updated: u64,
      is_active: bool,
  }

  #[storage]
  struct Storage {
      users: LegacyMap::<ContractAddress, UserInfo>,
  }

  // Requires starknet::Store derive on the struct

【Storage Best Practices】
  ✅ Use u256 for token amounts (ERC-20 standard)
  ✅ Use ContractAddress for addresses (not felt252)
  ✅ Pack related booleans into a single felt252 bitmask
  ✅ Minimize storage writes (most expensive operation)
  ❌ Don't store large arrays (use events for logs)
  ❌ Don't use felt252 for addresses in new code

【Storage Slots & Gas Cost】
  • Storage read:  ~100 gas units
  • Storage write: ~5,000 gas units (initial)
  • Storage write: ~2,500 gas units (update existing)
  • Each felt252 = 1 slot, u256 = 2 slots

📖 More skills: bytesagain.com
EOF
}

cmd_events() {
    cat <<'EOF'
═══════════════════════════════════════════════════
  Cairo / StarkNet Events
═══════════════════════════════════════════════════

【Event Declaration】
  #[event]
  #[derive(Drop, starknet::Event)]
  enum Event {
      Transfer: Transfer,
      Approval: Approval,
      OwnershipTransferred: OwnershipTransferred,
  }

  #[derive(Drop, starknet::Event)]
  struct Transfer {
      #[key]
      from: ContractAddress,
      #[key]
      to: ContractAddress,
      value: u256,
  }

  #[derive(Drop, starknet::Event)]
  struct Approval {
      #[key]
      owner: ContractAddress,
      #[key]
      spender: ContractAddress,
      value: u256,
  }

【Emitting Events】
  #[abi(embed_v0)]
  impl MyContract of IMyContract<ContractState> {
      fn transfer(ref self: ContractState, to: ContractAddress, amount: u256) {
          let caller = get_caller_address();
          // ... transfer logic ...

          self.emit(Transfer {
              from: caller,
              to: to,
              value: amount,
          });
      }
  }

【#[key] Attribute — Indexed Fields】
  // Fields marked with #[key] are indexed (like Solidity indexed)
  // They appear in the "keys" array of the event
  // Non-key fields appear in the "data" array
  //
  // Keys: searchable, filterable by indexers
  // Data: not directly filterable, but stored on-chain
  //
  // Max 3 keys recommended (similar to Solidity's 3 indexed limit)

【Flat Events (alternative)】
  #[event]
  #[derive(Drop, starknet::Event)]
  enum Event {
      #[flat]
      OwnableEvent: ownable_component::Event,
      Transfer: Transfer,
  }
  // #[flat] merges component events into main event enum

【Event Patterns】
  // ERC-20 standard events
  Transfer(from, to, value)
  Approval(owner, spender, value)

  // Access control events
  OwnershipTransferred(previous, new_owner)
  RoleGranted(role, account, sender)
  RoleRevoked(role, account, sender)

  // Lifecycle events
  Paused(account)
  Unpaused(account)
  Upgraded(class_hash)

【Listening to Events (off-chain)】
  // Events are stored in transaction receipts
  // Use starknet.js, starknet.py, or Apibara for indexing
  //
  // Event key[0] = sn_keccak(event_name)
  // Event key[1..] = indexed fields
  // Event data[] = non-indexed fields

📖 More skills: bytesagain.com
EOF
}

cmd_template() {
    local template="${1:-}"

    if [ -z "$template" ]; then
        cat <<'EOF'
═══════════════════════════════════════════════════
  Cairo Contract Templates
═══════════════════════════════════════════════════

Available templates:
  erc20        ERC-20 fungible token contract
  ownable      Ownable access control pattern
  counter      Simple counter (good starter)
  erc721       ERC-721 NFT contract skeleton

Usage:
  bash scripts/script.sh template erc20
  bash scripts/script.sh template ownable

📖 More skills: bytesagain.com
EOF
        return 0
    fi

    case "$template" in
        erc20)
            cat <<'EOF'
═══════════════════════════════════════════════════
  ERC-20 Token Contract Template
═══════════════════════════════════════════════════

use starknet::ContractAddress;

#[starknet::interface]
trait IERC20<TContractState> {
    fn name(self: @TContractState) -> ByteArray;
    fn symbol(self: @TContractState) -> ByteArray;
    fn decimals(self: @TContractState) -> u8;
    fn total_supply(self: @TContractState) -> u256;
    fn balance_of(self: @TContractState, account: ContractAddress) -> u256;
    fn allowance(self: @TContractState, owner: ContractAddress, spender: ContractAddress) -> u256;
    fn transfer(ref self: TContractState, recipient: ContractAddress, amount: u256) -> bool;
    fn transfer_from(
        ref self: TContractState,
        sender: ContractAddress,
        recipient: ContractAddress,
        amount: u256
    ) -> bool;
    fn approve(ref self: TContractState, spender: ContractAddress, amount: u256) -> bool;
}

#[starknet::contract]
mod ERC20 {
    use starknet::{ContractAddress, get_caller_address, contract_address_const};
    use core::num::traits::Zero;

    #[storage]
    struct Storage {
        name: ByteArray,
        symbol: ByteArray,
        decimals: u8,
        total_supply: u256,
        balances: LegacyMap::<ContractAddress, u256>,
        allowances: LegacyMap::<(ContractAddress, ContractAddress), u256>,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        Transfer: Transfer,
        Approval: Approval,
    }

    #[derive(Drop, starknet::Event)]
    struct Transfer {
        #[key]
        from: ContractAddress,
        #[key]
        to: ContractAddress,
        value: u256,
    }

    #[derive(Drop, starknet::Event)]
    struct Approval {
        #[key]
        owner: ContractAddress,
        #[key]
        spender: ContractAddress,
        value: u256,
    }

    #[constructor]
    fn constructor(
        ref self: ContractState,
        name: ByteArray,
        symbol: ByteArray,
        initial_supply: u256,
        recipient: ContractAddress,
    ) {
        self.name.write(name);
        self.symbol.write(symbol);
        self.decimals.write(18);
        self._mint(recipient, initial_supply);
    }

    #[abi(embed_v0)]
    impl ERC20Impl of super::IERC20<ContractState> {
        fn name(self: @ContractState) -> ByteArray { self.name.read() }
        fn symbol(self: @ContractState) -> ByteArray { self.symbol.read() }
        fn decimals(self: @ContractState) -> u8 { self.decimals.read() }
        fn total_supply(self: @ContractState) -> u256 { self.total_supply.read() }
        fn balance_of(self: @ContractState, account: ContractAddress) -> u256 {
            self.balances.read(account)
        }
        // ... (transfer, approve, transfer_from implementations)
    }
}

// Full implementation requires _mint, _burn, _transfer internal functions
// See OpenZeppelin Cairo Contracts for production-ready code:
// https://github.com/OpenZeppelin/cairo-contracts

📖 More skills: bytesagain.com
EOF
            ;;
        ownable)
            cat <<'EOF'
═══════════════════════════════════════════════════
  Ownable Contract Template
═══════════════════════════════════════════════════

use starknet::ContractAddress;

#[starknet::interface]
trait IOwnable<TContractState> {
    fn owner(self: @TContractState) -> ContractAddress;
    fn transfer_ownership(ref self: TContractState, new_owner: ContractAddress);
    fn renounce_ownership(ref self: TContractState);
}

#[starknet::contract]
mod OwnableContract {
    use starknet::{ContractAddress, get_caller_address, contract_address_const};
    use core::num::traits::Zero;

    #[storage]
    struct Storage {
        owner: ContractAddress,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        OwnershipTransferred: OwnershipTransferred,
    }

    #[derive(Drop, starknet::Event)]
    struct OwnershipTransferred {
        #[key]
        previous_owner: ContractAddress,
        #[key]
        new_owner: ContractAddress,
    }

    #[constructor]
    fn constructor(ref self: ContractState, owner: ContractAddress) {
        self.owner.write(owner);
        self.emit(OwnershipTransferred {
            previous_owner: contract_address_const::<0>(),
            new_owner: owner,
        });
    }

    #[abi(embed_v0)]
    impl OwnableImpl of super::IOwnable<ContractState> {
        fn owner(self: @ContractState) -> ContractAddress {
            self.owner.read()
        }

        fn transfer_ownership(ref self: ContractState, new_owner: ContractAddress) {
            self._assert_only_owner();
            assert(!new_owner.is_zero(), 'New owner is zero address');
            let previous = self.owner.read();
            self.owner.write(new_owner);
            self.emit(OwnershipTransferred {
                previous_owner: previous,
                new_owner: new_owner,
            });
        }

        fn renounce_ownership(ref self: ContractState) {
            self._assert_only_owner();
            let previous = self.owner.read();
            self.owner.write(contract_address_const::<0>());
            self.emit(OwnershipTransferred {
                previous_owner: previous,
                new_owner: contract_address_const::<0>(),
            });
        }
    }

    #[generate_trait]
    impl InternalImpl of InternalTrait {
        fn _assert_only_owner(self: @ContractState) {
            let caller = get_caller_address();
            let owner = self.owner.read();
            assert(caller == owner, 'Caller is not the owner');
        }
    }
}

📖 More skills: bytesagain.com
EOF
            ;;
        counter)
            cat <<'EOF'
═══════════════════════════════════════════════════
  Simple Counter Contract Template
═══════════════════════════════════════════════════

#[starknet::interface]
trait ICounter<TContractState> {
    fn get(self: @TContractState) -> u128;
    fn increment(ref self: TContractState);
    fn decrement(ref self: TContractState);
    fn reset(ref self: TContractState);
}

#[starknet::contract]
mod Counter {
    #[storage]
    struct Storage {
        counter: u128,
    }

    #[constructor]
    fn constructor(ref self: ContractState, initial_value: u128) {
        self.counter.write(initial_value);
    }

    #[abi(embed_v0)]
    impl CounterImpl of super::ICounter<ContractState> {
        fn get(self: @ContractState) -> u128 {
            self.counter.read()
        }

        fn increment(ref self: ContractState) {
            let current = self.counter.read();
            self.counter.write(current + 1);
        }

        fn decrement(ref self: ContractState) {
            let current = self.counter.read();
            assert(current > 0, 'Counter is already zero');
            self.counter.write(current - 1);
        }

        fn reset(ref self: ContractState) {
            self.counter.write(0);
        }
    }
}

// Test: scarb test
// Deploy: starkli deploy <class_hash> <initial_value>

📖 More skills: bytesagain.com
EOF
            ;;
        *)
            echo "❌ Unknown template: $template"
            echo "Available: erc20, ownable, counter, erc721"
            echo ""
            echo "📖 More skills: bytesagain.com"
            ;;
    esac
}

cmd_help() {
    cat <<EOF
Cairo v${VERSION} — StarkNet Smart Contract Reference

Commands:
  syntax           Core Cairo syntax (variables, functions, control flow)
  types            Type system (felt252, integers, structs, enums, arrays)
  storage          Storage patterns (variables, maps, structs, gas costs)
  events           Event declaration, emission, and indexing
  template [name]  Contract templates (erc20, ownable, counter)
  help             Show this help
  version          Show version

Usage:
  bash scripts/script.sh syntax
  bash scripts/script.sh types
  bash scripts/script.sh template erc20

Resources:
  Cairo Book:       https://book.cairo-lang.org
  StarkNet Docs:    https://docs.starknet.io
  OpenZeppelin:     https://github.com/OpenZeppelin/cairo-contracts
  Scarb (toolchain): https://docs.swmansion.com/scarb

Related skills:
  clawhub install blast
  clawhub install solidity
Browse all: bytesagain.com

Powered by BytesAgain | bytesagain.com
EOF
}

case "${1:-help}" in
    syntax)     cmd_syntax ;;
    types)      cmd_types ;;
    storage)    cmd_storage ;;
    events)     cmd_events ;;
    template)   shift; cmd_template "$@" ;;
    version)    echo "cairo v${VERSION}" ;;
    help|*)     cmd_help ;;
esac
