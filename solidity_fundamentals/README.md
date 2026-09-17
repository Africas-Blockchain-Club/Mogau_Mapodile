# Solidity Fundamentals

A collection of Solidity fundamentals completed as part of my Web3 development learning.

## Concepts Covered

This activity demonstrates:

- Smart contracts
- State variables
- Constructors
- Functions
- Structs
- Mappings
- Inheritance
- Modifiers
- Access control
- Events
- Contract-to-contract interaction
- Input validation
- Basic smart contract security
- Automated smart contract testing

## Contracts

### Parent / Child

Demonstrates Solidity inheritance.

### Parent_f / Child_f

Demonstrates communication between deployed smart contracts.

### School / StudentSystem

Uses structs and mappings to manage student records while restricting modifications to an administrator.

### AdminControl

Implements basic role-based access using an administrator and an `onlyAdmin` modifier.

### WTC

Stores student formative and summative assessment results.

### ABC

Stores members and their blockchain development level.

Supported levels:

- beginner
- junior
- senior

### WTCABCLink

Links the WTC and ABC contracts and retrieves information from both contracts for a shared student/member ID.

## Security

The contracts include basic defensive practices such as:

- Access control
- Input validation
- Zero-address validation
- Contract address validation
- Duplicate record prevention
- Score range validation
- Record existence checks
- Events for important state changes

## Testing

Tests are written using Foundry.

Run:

```bash
forge test