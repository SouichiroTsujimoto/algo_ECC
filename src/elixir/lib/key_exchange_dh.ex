defmodule KeyExchangeDh do
  import Secp256k1
  defstruct [:private_key, :public_key]

  def new() do
    private_key = generate_key()
    %KeyExchangeDh{
      private_key: private_key,
      public_key: generate_public_key(private_key)
    }
  end

  defp generate_key() do
    :rand.uniform(order() - 1) |> round()
  end

  defp generate_public_key(private_key) do
    scalar(g(), private_key)
  end

  def exchange(self, other_public_key) do
    scalar(other_public_key, self.private_key)
  end
end
