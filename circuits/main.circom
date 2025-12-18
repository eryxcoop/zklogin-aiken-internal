template ZkLogin {
    // Public
    signal input eph_pk;
    signal input OIDP_pk;
    signal input jwt_signature;
    signal input zkLoginId;
    signal input nonce;
    signal input max_epoch;

    //Private
    signal input JWT;
    signal input rand;
    signal input salt;
    signal input sub;
    signal input aud;
    signal input iss;

    // JWT parsing
    component parser = JWTParser;
    parser.jwt <== JWT;
    parser.sub <== sub;
    parser.aud <== aud;
    parser.iss <== iss;
    parser.nonce <== nonce;

    // zkLoginId derivation check
    component id_derivation = ZkLoginIdDerivation;
    id_derivation.jwt <== JWT;
    id_derivation.salt <== salt;
    zkLoginId === id_derivation.out;

    // nonce derivation check
    component nonce_derivation = NonceDerivation;
    nonce_derivation.eph_pk <== eph_pk;
    nonce_derivation.rand <== rand;
    nonce_derivation.max_epoch <== max_epoch;
    nonce_derivation.out === nonce;

    // OIDP signature verification
    component verificator = JWTSignatureVerification;
    verificator.OIDP_pk <== OIDP_pk;
    verificator.jwt_signature <== jwt_signature;
}