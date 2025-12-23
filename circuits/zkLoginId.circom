pragma circom 2.2.3;
include "../node_modules/poseidon-bls12381-circom/circuits/poseidon255.circom";


template ZkLoginId {
    signal input salt;
    signal input sub;
    signal input aud;
    signal input iss;
    signal output zkLoginId;

    component poseidon = Poseidon255(4);
    poseidon.in[0] <== iss;
    poseidon.in[1] <== aud;
    poseidon.in[2] <== sub;
    poseidon.in[3] <== salt;

    zkLoginId <== poseidon.out;
}

//component main = ZkLoginId();