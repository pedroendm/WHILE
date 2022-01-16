# Denotational Semantics for the IMP (or WHILE) language

Implementation of the denotational semantics for a small imperative language, called IMP (or WHILE), in the literature.

The implementation is fully written in Haskell and with the tools Alex and Happy, for the lexer and parser, respectively.

Some design choices:
- The operators '+', '-' and '*' are left-associative.
- The operator '*' has an higher precedence than '+' and '-'  

- The operator ';' is right associative.

- '=', '<=', 'and', 'not', and 'else' are all non-associative.

# Source files
- Lexer.x: the description of the lexer
- Parser.y: the description of the parser
- Main.hs
- State.hs: definition of a state
- Interp.hs: implementation of the denotational semantics for the language

## Compilation process
Within the root folder (IMP/):
```bash
alex Lexer.x
happy Parser.y
ghc -o interp Main.hs
```

## Usage
```bash
./interp < tests/file.imp
```
, where *file.imp* is a program written in the IMP (or WHILE) language. 

## Tests
In the test folder, there are 4 testes:
- while_true_do_skip.imp -> Our first example in class.
- while_false_do_skip.imp -> Our first example in class.
- example_3_9.imp -> The example 3.9 on the notes "Denotational Semantics" of professor Sandra.
- factorial.imp -> Computes the factorial of the number n. The answer is in the variable acc.
- gcd.imp -> Computes the gcd of the numbers a and b. The answer is in the variable a.
- is_prime.imp -> Checks if the number n is prime or not. If the number is prime, then variable is_prime = 1, otherwise, is_prime = 0.
