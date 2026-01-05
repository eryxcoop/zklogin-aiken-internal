pragma circom 2.2.3;

include "slice.circom";
include "../node_modules/circomlib/circuits/bitify.circom";

template FeatureInclusionInJwtPayload(nCount, nWidth, maxClaimLength) {

    signal input payload[nCount];

    signal input claimOffset;
    signal input claimLength;

    signal output claim[maxClaimLength];

    component claimExtract = Slice(nCount, maxClaimLength);
    // Podriamos usar el SliceFixed para los campos fijos, como el iss y el aud. No asi para el sub.
    // Creo que para el nonce tambien podriamos usar SliceFixed

    claimExtract.offset <== claimOffset;
    claimExtract.length <== claimLength;

    for(var p = 0; p < nCount; p++) {
        claimExtract.in[p] <== payload[p];
    }

    for(var i = 0; i < maxClaimLength; i++) {
        claim[i] <== claimExtract.out[i];
    }
}

component main = FeatureInclusionInJwtPayload(128, 8, 8);