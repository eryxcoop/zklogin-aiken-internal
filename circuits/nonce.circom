pragma circom 2.2.3;
include "../node_modules/circomlib/circuits/poseidon.circom";


template Nonce {
    signal input max_epoch;
    signal input randomness;
    signal input eph_pk;
    signal output nonce;

    component poseidon = Poseidon(3);
    poseidon.inputs[0] <== max_epoch;
    poseidon.inputs[1] <== randomness;
    poseidon.inputs[2] <== eph_pk;

    nonce <== poseidon.out;
}
