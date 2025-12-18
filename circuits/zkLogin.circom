pragma circom 2.2.3;
include "./nonce.circom";
include "./zkLoginId.circom";

template ZkLogin {
    // Public
    signal input eph_pk;
    signal input zkLoginId;
    signal input nonce;
    signal input max_epoch;
    // signal input OIDP_pk;
    // signal input jwt_signature;

    //Private
    // signal input JWT;
    signal input rand;
    signal input salt;
    signal input sub;
    signal input aud;
    signal input iss;

    // zkLoginId derivation check
    component id_derivation = ZkLoginId();
    id_derivation.iss <== iss;
    id_derivation.aud <== aud;
    id_derivation.sub <== sub;
    id_derivation.salt <== salt;
    zkLoginId === id_derivation.zkLoginId;

    // nonce derivation check
    component nonce_derivation = Nonce();
    nonce_derivation.eph_pk <== eph_pk;
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

component main {public [eph_pk, zkLoginId, nonce, max_epoch]} = ZkLogin();

