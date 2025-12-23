import type {PublicKey} from "@mysten/sui.js/cryptography";
//import {poseidonHash} from "@mysten/zklogin";
//import {toBigEndianBytes} from "@mysten/sui.js/zklogin";
import {base64url} from "jose";
import {toHEX} from "@mysten/bcs";
import { poseidon4 } from "poseidon-bls12381";

//const NONCE_LENGTH = 27;

export function toBigIntBE(bytes: Uint8Array) {
    const hex = toHEX(bytes);
    if (hex.length === 0) {
        return BigInt(0);
    }
    return BigInt(`0x${hex}`);
}


export function generateNonce(publicKey: PublicKey, maxEpoch: number, randomness: string) {
    const publicKeyBytes = toBigIntBE(publicKey.toRawBytes());
    const eph_public_key_high = publicKeyBytes / 2n ** 128n;
    const eph_public_key_low = publicKeyBytes % 2n ** 128n;
    const bigNum = poseidon4([BigInt(maxEpoch), BigInt(randomness), eph_public_key_high, eph_public_key_low]);
    // const Z = toBigEndianBytes(bigNum, 20);
    console.log("----------------- Nonce: ", bigNum)
    console.log("----------------- pk_high: ", eph_public_key_high)
    console.log("----------------- low: ", eph_public_key_low)
    console.log("----------------- max_ep: ", BigInt(maxEpoch))
    console.log("----------------- randomness: ", BigInt(randomness))
    const nonce = base64url.encode(bigNum.toString());
    /*if (nonce.length !== NONCE_LENGTH) {
        throw new Error(`Length of nonce ${nonce} (${nonce.length}) is not equal to ${NONCE_LENGTH}`);
    }*/
    return nonce;
}