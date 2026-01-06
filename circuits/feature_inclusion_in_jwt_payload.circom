pragma circom 2.2.3;

include "slice.circom";
include "../node_modules/circomlib/circuits/bitify.circom";

template FeatureInclusionInJwtPayload(nCount, subMaxLength, audMaxLength) {

    signal input payload[nCount];

    // ------------- SUB ----------- //

    signal input subOffset;
    signal input subLength;
    signal output sub[subMaxLength];

    component subExtract = Slice(nCount, subMaxLength);
    subExtract.offset <== subOffset;
    subExtract.length <== subLength;
    for(var p = 0; p < nCount; p++) {
        subExtract.in[p] <== payload[p];
    }
    for(var i = 0; i < subMaxLength; i++) {
        sub[i] <== subExtract.out[i];
    }

    // ------------- AUD ----------- //
    signal input audOffset;
    signal input audLength;
    signal output aud[audMaxLength];

    component audExtract = Slice(nCount, audMaxLength);
    audExtract.offset <== audOffset;
    audExtract.length <== audLength;
    for(var p = 0; p < nCount; p++) {
        audExtract.in[p] <== payload[p];
    }
    for(var i = 0; i < audMaxLength; i++) {
        aud[i] <== audExtract.out[i];
    }

    // ------------- ISS ----------- //
    var issLength = 27;
    var iss_cte[issLength] = [104, 116, 116, 112, 115, 58, 47, 47, 97, 99, 99, 111, 117, 110, 116, 115, 46, 103, 111, 111, 103, 108, 101, 46, 99, 111, 109];
    signal input issOffset;

    component issExtract = SliceFixed(nCount, issLength);
    issExtract.offset <== issOffset;

    for(var p = 0; p < nCount; p++) {
        issExtract.in[p] <== payload[p];
    }

    // ------------- nonce ----------- //
    signal input nonceOffset;
    var nonceLength = 103;
    signal output nonce[nonceLength];

    component nonceExtract = SliceFixed(nCount, nonceLength);
    nonceExtract.offset <== nonceOffset;
    for(var p = 0; p < nCount; p++) {
        nonceExtract.in[p] <== payload[p];
    }
    for(var i = 0; i < nonceLength; i++) {
        nonce[i] <== nonceExtract.out[i];
    }

}

component main = FeatureInclusionInJwtPayload(439, 21, 72);