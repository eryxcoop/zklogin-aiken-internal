pragma circom 2.2.3;

include "slice.circom";
include "../node_modules/circomlib/circuits/bitify.circom";

template FeatureInclusionInJwtPayload(nCount, issSize, subSize, audSize) {

    signal input payload[nCount];

    // ------------- SUB ----------- //

    signal input subOffset;
    signal input sub[subSize];

    component subExtract = SliceFixed(nCount, subSize);
    subExtract.offset <== subOffset;
    subExtract.in <== payload;
    sub === subExtract.out;

    // ------------- AUD ----------- //
    signal input audOffset;
    signal input aud[audSize];

    component audExtract = SliceFixed(nCount, audSize);
    audExtract.offset <== audOffset;
    audExtract.in <== payload;
    aud === audExtract.out;

    // ------------- ISS ----------- //
    signal input issOffset;
    signal input iss[issSize];

    component issExtract = SliceFixed(nCount, issSize);
    issExtract.offset <== issOffset;
    issExtract.in <== payload;
    iss === issExtract.out;

    // ------------- nonce ----------- //
    var nonceSize = 103;

    signal input nonceOffset;
    signal input nonce[nonceSize];

    component nonceExtract = SliceFixed(nCount, nonceSize);
    nonceExtract.offset <== nonceOffset;
    nonceExtract.in <== payload;
    nonce === nonceExtract.out;
}

component main = FeatureInclusionInJwtPayload(439, 27, 21, 72);