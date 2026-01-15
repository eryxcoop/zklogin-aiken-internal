use aiken/collection/list
use ak_381/groth16.{Proof, SnarkVerificationKey, groth_verify}
use aiken/interval.{Finite}
use aiken/primitive/bytearray.{to_int_big_endian, take, drop}
use cardano/transaction.{OutputReference, Transaction}
use src_backend/types.{ZkLoginRedeemer}
use src_backend/ephemeral_auth.{verify_ephemeral_signature}

validator zk_login(_zk_login_id: String) {
    spend(
        _datum: Option<Data>,
        redeemer: ZkLoginRedeemer,
        _own_ref: OutputReference,
        self: Transaction,
    ) {
        let eph_pk_high_bytearray = take(redeemer.ephemeral_public_key, 128)
        let eph_pk_low_bytearray = drop(redeemer.ephemeral_public_key, 128)

        let eph_pk_high = to_int_big_endian(eph_pk_high_bytearray)
        let eph_pk_low = to_int_big_endian(eph_pk_low_bytearray)

        let verifies_ephemeral_signature = verify_ephemeral_signature(redeemer, self)
        let max_epoch_is_valid = self.validity_range.upper_bound.bound_type == Finite(redeemer.max_epoch)
        expect _redeemer = zk_verify_or_fail(redeemer, [Single(eph_pk_high), Single(eph_pk_low), Single(zk_login_id), Single(max_epoch)])
        
        verifies_ephemeral_signature && max_epoch_is_valid
    }
}

test spend_passes_when_tx_is_signed_with_an_ephemeral_key_matching_redeemer_ephemeral_key() {
    let redeemer = ZkLoginRedeemer{ max_epoch: 41, ephemeral_public_key: #"1234"}
    let placeholder_utxo = OutputReference{transaction_id: #"", output_index: 0}
    let signatories_containing_redeemer_key_hash = [#"1234"] // extra_signatories is a field that is filled by the node
    zk_login.spend(
        None,
        redeemer,
        placeholder_utxo,
        Transaction{..transaction.placeholder, extra_signatories: signatories_containing_redeemer_key_hash},
    )
}

test spend_fails_when_tx_is_not_signed_by_any_extra_signatories() fail {
    let redeemer = ZkLoginRedeemer{ephemeral_key_hash: #"1234"}
    let placeholder_utxo = OutputReference{transaction_id: #"", output_index: 0}
    let empty_signatories = []
    zk_login.spend(
        None,
        redeemer,
        placeholder_utxo,
        Transaction{..transaction.placeholder, extra_signatories: empty_signatories},
    )
}

// The user trying to spend this utxo doesn't know the eph key pair or
// provides an incorrect ephemeral key in the redeemer
test spend_fails_when_redeemer_ephemeral_key_does_not_match_any_extra_signatures() fail {
    let redeemer = ZkLoginRedeemer{ephemeral_key_hash: #"1234"}
    let placeholder_utxo = OutputReference{transaction_id: #"", output_index: 0}
    let signatories_that_dont_match_redeemer_key_hash = [#"4567", #"1237"]
    zk_login.spend(
        None,
        redeemer,
        placeholder_utxo,
        Transaction{..transaction.placeholder, extra_signatories: signatories_that_dont_match_redeemer_key_hash},
    )
}
    type ZKInputType {
        Single(Int)
        Many(List<Int>)
    }

    fn zk_verify_or_fail(
        zk_redeemer: ZK<Redeemer>,
        public_inputs: List<ZKInputType>
    ) -> ZK<Redeemer> {

        let vk: SnarkVerificationKey =
            SnarkVerificationKey {
                nPublic: 4,
                vkAlpha: #"8eb3e4b19d0db52a71cb397b2dab83179416c370c79b186b1c9b9ddfc882919d5462cade73f77f628325b42270737ebc",
                vkBeta: #"882c8e5f5a621339311fce39f168d19668b738be53879ad30a6b5c5e25b896331c1051b954d3fab37b50fd062eae773d15ad1724087721028bdd5d01095a3b4954e11bad59bb79e2e0b71a46206ee160d5fd591c967d77b5a5bb7fa1306b5391",
                vkGamma: #"93e02b6052719f607dacd3a088274f65596bd0d09920b61ab5da61bbdc7f5049334cf11213945d57e5ac7d055d042b7e024aa2b2f08f0a91260805272dc51051c6e47ad4fa403b02b4510b647ae3d1770bac0326a805bbefd48056c8c121bdb8",
                vkDelta: #"b824005d651bf6d38362f30967f78a33381fde734ebd5687265d2b250f54aa5b10860c1e0cd522e375a7f04178efe69c0747d9ee650176e8376346111c82fd997c3b16604ef241edd84843e9d84a3fd3833bcb2308b5ce4dfa9f465b18dbec7c",
                vkAlphaBeta: [],
                vkIC: [
                #"91ba57dbea67e8a90e5a44f29913c1dbae113fb7c5d3326e6d5cdab3cbc40d1a6813460e84ac7bafe41ef4d5df1dd7d9",
                #"9203eaf52244d1e272222faab950179fff7e39c2f02f6ceb30ffbe1c0caa2c575ce7240590476e9054e8364b5b157ef1",
                #"89b6d35e5e792c1f716270b990b3d9caab3659e77895e5787ab07b67bf8639d799760ccec57b1f47c1d05aec2450431f",
                #"aece4d0b054c78b61be76b655e1c2eeab1ab7c92d4dac2ef45162668c3f279e0f5f67a9a0d6a7e1d0863a36dc38e8984",
                #"adb2431e30119faa2cdc9c34b04b934831d74d487fb3f9a9da90528090cff3fd7e534faea0e149007ce983a7a66c1f9e",
                ],
            }

        expect Some(proof) = list.head(zk_redeemer.proofs)

        let flattened_public_inputs: List<Int> = list.flat_map(public_inputs, fn(item) {
            when item is {
              Single(x) -> [x]
              Many(xs) -> xs
            }
        })

        if !groth_verify(vk, proof, flattened_public_inputs) {
          fail
          Void
        } else {
          Void
        }

        expect Some(proofs) = list.tail(zk_redeemer.proofs)
        ZK { redeemer: zk_redeemer.redeemer, proofs }
    }