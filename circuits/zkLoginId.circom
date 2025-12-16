pragma circom 2.2.3;
include "../node_modules/circomlib/circuits/poseidon.circom";


template ZkLoginIdVerification {
    signal input salt;
    signal input sub;
    signal input aud;
    signal input iss;
    signal input zkLoginId;

    component poseidon = Poseidon(4);
    poseidon.inputs[0] <== iss;
    poseidon.inputs[1] <== aud;
    poseidon.inputs[2] <== sub;
    poseidon.inputs[3] <== salt;

    zkLoginId === poseidon.out;
}

component main = ZkLoginIdVerification();