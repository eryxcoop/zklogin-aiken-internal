pragma circom 2.2.3;
include "./nonce.circom";
include "./zkLoginId.circom";

template ZkLogin(audSize, issSize, subSize) {
    // Public
    signal input eph_pk_high;
    signal input eph_pk_low;
    signal input zkLoginId;
    signal input nonce;
    signal input max_epoch;
    // signal input OIDP_pk;
    // signal input jwt_signature;

    //Private
    // signal input JWT;
    signal input rand;
    signal input salt;
    signal input iss_ascii[issSize];
    signal input aud_ascii[audSize];
    signal input sub_ascii[subSize];

    // zkLoginId derivation check
    component id_derivation = ZkLoginIdAscii(audSize, issSize, subSize);
    id_derivation.iss_ascii <== iss_ascii;
    id_derivation.aud_ascii <== aud_ascii;
    id_derivation.sub_ascii <== sub_ascii;
    id_derivation.salt <== salt;
    zkLoginId === id_derivation.zkLoginId;

    // nonce derivation check
    component nonce_derivation = Nonce();
    nonce_derivation.eph_pk_high <== eph_pk_high;
    nonce_derivation.eph_pk_low <== eph_pk_low;
    nonce_derivation.randomness <== rand;
    nonce_derivation.max_epoch <== max_epoch;
    nonce_derivation.nonce === nonce;

    // JWT parsing
    /* component parser = JWTParser;
    parser.jwt <== JWT;
    parser.sub <== sub;
    parser.aud <== aud;
    parser.iss <== iss;
    parser.nonce <== nonce; */


    // OIDP signature verification
    /* component verificator = JWTSignatureVerification;
    verificator.OIDP_pk <== OIDP_pk;
    verificator.jwt_signature <== jwt_signature;
    verificator.jwt <== JWT; */
}

component main {public [eph_pk_high, eph_pk_low, zkLoginId, nonce, max_epoch]} = ZkLogin(72,27,21);

