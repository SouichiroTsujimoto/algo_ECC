defmodule KeyExchangeDhTest do
  use ExUnit.Case

  test "key exchange works" do
    alice = KeyExchangeDh.new()
    bob = KeyExchangeDh.new()

    secret_share_alice = KeyExchangeDh.exchange(alice, bob.public_key)
    secret_share_bob   = KeyExchangeDh.exchange(bob, alice.public_key)

    assert secret_share_alice == secret_share_bob
  end
end
