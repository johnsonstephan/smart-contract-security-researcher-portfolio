# Formal Verification for Integer Overflow Detection

This project is a smart contract that demonstrates an integer overflow scenario using Manticore. The contract utilizes basic conditional checks to identify overflow situations. We will use formal verification to prove that the contract is not secure given an overflow scenario.

## Table of Contents

1. [Introduction](#Introduction)
2. [Users](#Users)
3. [Development](#Development)
4. [Testing](#Testing)
5. [Built With](#BuiltWith)
6. [Files](#Files)

### <a name="Introduction"></a>Introduction

This project is a single smart contract that demonstrates an integer overflow scenario.

1. `FormalVerificationOverflow.sol`: The contract which contains the integer overflow vulnerability.

### <a name="Users"></a>Users

1. Contract Caller: Anyone who can call the `processInput` function.

### <a name="Development"></a>Development

#### 3.1. <a name='FormalVerificationOverflow.sol'></a>FormalVerificationOverflow.sol

The `FormalVerificationOverflow.sol` contract is developed with the following core functionality:

- Initialization of the contract.
- Checking for potential integer overflow when processing input.

### <a name='Testing'></a>Testing

#### 4.1. <a name='Formal Verification with Manticore'></a>Formal Verification with Manticore

Use Manticore to test the contract for integer overflow.

From the command line, we run the following command:

```bash
manticore FormalVerificationOverflow.sol
```

Following, Manicore will execute the contract as it explores all possible paths in the contract. If Manticore detects a potential vulnerability, it will create test cases. In this example, Manticore will create test cases that indicate an integer overflow. We can use the generated test cases to reproduce the vulnerability -- using the concrete input values that lead to the overflow.

In our case, we will see that the integer overflow occurs in the following line:

```bash
int couldOverflow = inputValue + 1;
```

For an overflow to occur, inputValue needs to be the maximum value for an int data type in Solidity. When we add 1 to this value, it wraps around and causes an overflow.

Manticore uses symbolic execution and maintains a symbolic state of the blockchain, including the contract's storage, the message call arguments, and the return data. When Manticore encounters the addition operation, it checks whether the result can exceed the bounds of the int data type. As it can, Manticore flags this as a potential overflow vulnerability.

#### 4.1. <a name='Mitigating the Vulnerability'></a>Mitigating the Vulnerability

Use SafeMath: The OpenZeppelin library provides a SafeMath library for arithmetic operations that automatically checks for overflows and reverts the transaction if one occurs.

```solidity
using SafeMath for int;
```

And, we could modify the addition operation to:

```solidity
int couldOverflow = inputValue.add(1);
```

Formal verification tools like Manticore are powerful in detecting vulnerabilities in smart contracts. They use mathematical methods to ensure the correctness of the code and can be a useful part of the smart contract development and auditing process.

### <a name="BuiltWith"></a>Built With

- Solidity: Contract-oriented, high-level language used for implementing smart contracts
- Manticore: Symbolic execution tool for analysis of binaries and smart contracts

### <a name="Files"></a>Files

- [`FormalVerificationOverflow`](./FormalVerificationOverflow.sol): The contract with contains the integer overflow vulnerability
