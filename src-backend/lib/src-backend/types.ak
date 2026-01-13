use aiken/crypto.{VerificationKey}
use ak_381/groth16.{Proof}

pub type ZkLoginRedeemer {
  max_epoch: Int,
  ephemeral_public_key: VerificationKey
}