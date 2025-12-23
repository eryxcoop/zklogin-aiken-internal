pragma circom 2.2.3;
include "../node_modules/poseidon-bls12381-circom/circuits/poseidon255.circom";


template Nonce {
    signal input max_epoch;
    signal input randomness;
    signal input eph_pk;
    signal output nonce;

    component poseidon = Poseidon255(3);
    poseidon.in[0] <== max_epoch;
    poseidon.in[1] <== randomness;
    poseidon.in[2] <== eph_pk;

    nonce <== poseidon.out;
}

//component main = Nonce();