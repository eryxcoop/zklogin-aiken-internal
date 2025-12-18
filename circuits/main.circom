template ZkLogin {
    // Public
    signal input eph_pk;
    signal input OIDP_pk;
    signal input zkLoginId;
    signal input max_epoch;
    signal input max_epoch;

    //Private
    signal input JWT;
    signal input rand;
    signal input salt;

    // JWT parsing
    component parser = JWTParser;
    parser.jwt <== JWT;

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
}