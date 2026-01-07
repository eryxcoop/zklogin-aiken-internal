import {decodeJwt} from "jose";
import {poseidon4} from "poseidon-bls12381";

const MAX_KEY_CLAIM_VALUE_LENGTH = 115;
const MAX_AUD_VALUE_LENGTH = 145;

export function computeZkLoginId(jwt: string, userSalt: string | bigint) {
    const decodedJWT = decodeJwt(jwt);
    if (!decodedJWT.sub || !decodedJWT.iss || !decodedJWT.aud) {
        throw new Error('Missing jwt data');
    }

    if (Array.isArray(decodedJWT.aud)) {
        throw new Error('Not supported aud. Aud is an array, string was expected.');
    }

    const zkLoginId = poseidon4([
        BigInt(decodedJWT.iss),
        BigInt(decodedJWT.aud),
        BigInt(decodedJWT.sub),
        BigInt(userSalt)]);
    return zkLoginId.toString();
}