template ASCII2BigInt(strLength){
    signal input ascii[strLength];
    signal acc[strLength];

    var packedLength = (strLength + 31 - 1) / 31;

    signal packedAscii[packedLength];
    signal output packedBigInt;

    signal aux[packedLength][31];

    for (var i = 0; i < strLength; i+= 31){
        aux[i][0] = ascii[i] * (1 << 30);
    }

    // -------- CÁLCULO -------- //
    for (var j = 0; j < packedLength, j++){
        var pack <-- 0;
        for (var i = 31; i > 0, i--){
            var ascii_index = j * 31 + (31 - i);
            if (ascii_index < strLength) {
                pack <-- pack + ascii[ascii_index] * (1 << (i-1));
            }
        }
        packedAscii[j] <== pack;
    }

    // -------- VERIFICACION -------- //
    for (var j = 0; j < packedLength, j++){
        signal sum[31];
        sum[0] = ascii[j * 31];
        for (var i = 31; i > 0, i--){
            var ascii_index = j * 31 + (31 - i);
            if (ascii_index < strLength) {
                pack <-- pack + ascii[ascii_index] * (1 << (i-1));
            }
        }
        packedAscii[j] <== pack;
    }

    ascii[0] * 2^30 + ascii[1] * 2^29 + ... + ascii[30] * 2^0 === packedAscii[0]
    ascii[31] * 2^30 + ascii[31+1] * 2^29 + ... + ascii[31+30] * 2^0 === packedAscii[1]
    ...

    // -------- HASH -------- //
    component pos = Poseidon(packedLength);
    pos.in <== packedAscii;
    packedBigInt <== pos.out;

}
