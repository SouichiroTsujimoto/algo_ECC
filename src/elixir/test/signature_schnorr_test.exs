defmodule SignatureSchnorrTest do
  use ExUnit.Case

  test "sign and verify work correctly" do
    d = 3247897491709281
    m = 79183474204718304174

    q = Secp256k1.scalar(Secp256k1.g(), d)

    sig = SignatureSchnorr.sign(d, m)
    verify = SignatureSchnorr.verify(sig, q, m)

    assert verify
  end

  test "verification fails for different message" do
    d = 4578237941639648173724192073
    m = 123456789097654321
    other_m = 2
    q = Secp256k1.scalar(Secp256k1.g(), d)

    sig = SignatureSchnorr.sign(d, m)
    verify = SignatureSchnorr.verify(sig, q, other_m)

    refute verify
  end

  test "verification fails for different public key" do
    d = 1
    m = 1
    other_d = 2
    other_q = Secp256k1.scalar(Secp256k1.g(), other_d)

    sig = SignatureSchnorr.sign(d, m)
    verify = SignatureSchnorr.verify(sig, other_q, m)

    refute verify
  end
end
