import type {PublicKey} from "@mysten/sui.js/cryptography";
import {poseidonHash} from "@mysten/zklogin";
import {toBigEndianBytes} from "@mysten/sui.js/zklogin";
import {base64url} from "jose";
import {toHEX} from "@mysten/bcs";

const NONCE_LENGTH = 27;

export function toBigIntBE(bytes: Uint8Array) {
    const hex = toHEX(bytes);
    if (hex.length === 0) {
        return BigInt(0);
    }
    return BigInt(`0x${hex}`);
}


export function generateNonce(publicKey: PublicKey, maxEpoch: number, randomness: string) {
    const publicKeyBytes = toBigIntBE(publicKey.toRawBytes());
    // const eph_public_key_0 = publicKeyBytes / 2n ** 128n;
    // const eph_public_key_1 = publicKeyBytes % 2n ** 128n;
    const bigNum = poseidonHash([publicKeyBytes, maxEpoch, BigInt(randomness)]);
    // const bigNum = poseidonHash([eph_public_key_0, eph_public_key_1, maxEpoch, BigInt(randomness)]);
    const Z = toBigEndianBytes(bigNum, 20);
    const nonce = base64url.encode(Z);
    if (nonce.length !== NONCE_LENGTH) {
        throw new Error(`Length of nonce ${nonce} (${nonce.length}) is not equal to ${NONCE_LENGTH}`);
    }
    return nonce;
}