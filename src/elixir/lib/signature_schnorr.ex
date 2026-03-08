defmodule SignatureSchnorr do
  import Secp256k1

  def sign(d, m) do
    q = scalar(g(), d)
    r = :rand.uniform(order() - 2) + 1 |> round()
    large_r = scalar(g(), r)
    h = :crypto.hash(:sha256, "#{large_r.x.num}#{q.x.num}#{m}")
    |> Base.encode16(case: :lower)
    |> String.to_integer(16)
    |> rem(order())
    IO.puts "sig h: #{h}"
    s = r + h * d
    %{large_r: large_r, s: s}
  end

  def verify(%{large_r: large_r, s: s}, q, m) do
    h = :crypto.hash(:sha256, "#{large_r.x.num}#{q.x.num}#{m}")
    |> Base.encode16(case: :lower)
    |> String.to_integer(16)
    |> rem(order())

    IO.puts "verify h: #{h}"
    scalar(g(), s) == add(large_r, scalar(q, h))
  end
end
