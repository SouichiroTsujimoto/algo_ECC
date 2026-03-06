defmodule SignatureEcdsa do
  import Secp256k1

  def sign(d, z) do
    k = :rand.uniform(order() - 1) |> round()
    r = (scalar(g(), k)).x.num
    k_inv = pow(k, order() - 2)
    s = (z + r * d) * k_inv |> rem(order())
    %{r: r, s: s}
  end

  def verify(%{r: r, s: s}, q, z) do
    s_inv = pow(s, order() - 2)
    u = z * s_inv |> rem(order())
    v = r * s_inv |> rem(order())
    total = add(scalar(g(), u), scalar(q, v))
    total.x.num == r
  end
end
