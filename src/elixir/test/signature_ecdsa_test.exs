defmodule SignatureEcdsaTest do
  use ExUnit.Case

  test "sign returns r and s within the curve order" do
    d = 1
    z = 1

    sig = SignatureEcdsa.sign(d, z)

    assert %{r: r, s: s} = sig
    order = Secp256k1.order()

    assert is_integer(r)
    assert is_integer(s)
    assert r > 0 and r < order
    assert s > 0 and s < order
  end

  test "signature verifies with matching public key and message" do
    d = 1
    z = 1

    q = Secp256k1.scalar(Secp256k1.g(), d)
    sig = SignatureEcdsa.sign(d, z)

    assert SignatureEcdsa.verify(sig, q, z)
  end

  test "verification fails for different message" do
    d = 1
    z = 1
    other_z = 2

    q = Secp256k1.scalar(Secp256k1.g(), d)
    sig = SignatureEcdsa.sign(d, z)

    refute SignatureEcdsa.verify(sig, q, other_z)
  end

  test "verification fails for different public key" do
    d = 1
    z = 1
    other_d = 2

    other_q = Secp256k1.scalar(Secp256k1.g(), other_d)
    sig = SignatureEcdsa.sign(d, z)

    refute SignatureEcdsa.verify(sig, other_q, z)
  end
end
