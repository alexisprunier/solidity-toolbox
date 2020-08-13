pragma solidity ^0.5.9; 

contract MathAndCryptography {

	// compute (x + y) % k where the addition is performed with arbitrary precision and does not wrap around at 2**256. Assert that k != 0 starting 
    
    addmod(uint x, uint y, uint k) returns (uint):

    // compute (x * y) % k where the multiplication is performed with arbitrary precision and does not wrap around at 2**256. Assert that k != 0 

	mulmod(uint x, uint y, uint k) returns (uint):

	// compute the Ethereum-SHA-3 (Keccak-256) hash of the (tightly packed) arguments

	keccak256(...) returns (bytes32):
	
	// compute the SHA-256 hash of the (tightly packed) arguments

	sha256(...) returns (bytes32):

	// alias to keccak256
	
	sha3(...) returns (bytes32):

	// compute RIPEMD-160 hash of the (tightly packed) arguments
	
	ripemd160(...) returns (bytes20):

	// recover the address associated with the public key from elliptic curve signature or return zero on error (example usage)
	
	ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) returns (address):
	
}