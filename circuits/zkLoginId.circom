pragma circom 2.2.3;
include "../node_modules/poseidon-bls12381-circom/circuits/poseidon255.circom";
include "./ascii_to_bigint.circom";

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

template ZkLoginIdAscii(audSize, audBlocks, issSize, issBlocks, subSize, subBlocks) {
    signal input salt;
    signal input iss_ascii[issSize];
    signal iss;
    signal input aud_ascii[audSize];
    signal aud;
    signal input sub_ascii[subSize];
    signal sub;
    signal output zkLoginId;

    component sub2field = ASCII2BigInt(subSize, subBlocks);
    sub2field.ascii <== sub_ascii;
    sub <== sub2field.packedBigInt;

    component aud2field = ASCII2BigInt(audSize, audBlocks);
    aud2field.ascii <== aud_ascii;
    aud <== aud2field.packedBigInt;

    component iss2field = ASCII2BigInt(issSize, issBlocks);
    iss2field.ascii <== iss_ascii;
    iss <== iss2field.packedBigInt;

    component zkLoginIdComputation = ZkLoginId();
    zkLoginIdComputation.salt <== salt;
    zkLoginIdComputation.aud <== aud;
    zkLoginIdComputation.iss <== iss;
    zkLoginIdComputation.sub <== sub;
    zkLoginId <== zkLoginIdComputation.zkLoginId;
}

component main = ZkLoginIdAscii(72,3,27,1,21,1);