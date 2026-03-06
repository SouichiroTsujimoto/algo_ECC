defmodule FieldElement do
  import Kernel, except: [+: 2, -: 2, *: 2, /: 2, ==: 2, **: 2]
  defstruct [:num, :prime]

  defmacro __using__(_) do
    quote do
      import Kernel, except: [+: 2, -: 2, *: 2, /: 2, ==: 2, **: 2]
      import FieldElement, only: [+: 2, -: 2, *: 2, /: 2, ==: 2, **: 2]
    end
  end

  defguard is_same_field(a, b)
           when is_struct(a, FieldElement) and
                is_struct(b, FieldElement) and
                Kernel.==(a.prime, b.prime)

  def new(num, prime) do
    if num >= prime or num < 0 do
      raise "Num #{num} not in field range 0 to #{prime - 1}"
    end

    %FieldElement{num: num, prime: prime}
  end

  def a == b when is_same_field(a, b) do
    Kernel.==(a.num, b.num)
  end

  def a == b do
    Kernel.==(a, b)
  end

  def a + b when is_same_field(a, b) do
    num = Kernel.+(a.num, b.num) |> Integer.mod(a.prime)
    new(num, a.prime)
  end

  def a + b do
    cond do
      is_struct(a, FieldElement) and is_integer(b) -> a + new(b, a.prime)
      is_struct(b, FieldElement) and is_integer(a) -> new(a, b.prime) + b
      true -> Kernel.+(a, b)
    end
  end

  def a - b when is_same_field(a, b) do
    num = Kernel.-(a.num, b.num) |> Integer.mod(a.prime)
    new(num, a.prime)
  end

  def a - b do
    cond do
      is_struct(a, FieldElement) and is_integer(b) -> a - new(b, a.prime)
      is_struct(b, FieldElement) and is_integer(a) -> new(a, b.prime) - b
      true -> Kernel.-(a, b)
    end
  end

  def a * b when is_same_field(a, b) do
    num = Kernel.*(a.num, b.num) |> Integer.mod(a.prime)
    new(num, a.prime)
  end

  def a * b do
    cond do
      is_struct(a, FieldElement) and is_integer(b) -> a * new(b, a.prime)
      is_struct(b, FieldElement) and is_integer(a) -> new(a, b.prime) * b
      true -> Kernel.*(a, b)
    end
  end

  defp pow_mod(_a, 0, acc), do: acc

  defp pow_mod(a, exp, acc) when exp > 0 do
    if rem(exp, 2) == 1 do
      pow_mod(a * a, div(exp, 2), acc * a)
    else
      pow_mod(a * a, div(exp, 2), acc)
    end
  end

  def a ** exp when is_struct(a, FieldElement) and is_integer(exp) and exp >= 0 do
    pow_mod(a, exp, new(1, a.prime))
  end

  def a ** exp do
    Kernel.**(a, exp)
  end

  def a / b when is_same_field(a, b) do
    # n_1 * (n_2 ^ (p - 2)) mod p
    a * (b ** (a.prime - 2))
  end

  def a / b do
    cond do
      is_struct(a, FieldElement) and is_integer(b) -> a / new(b, a.prime)
      is_struct(b, FieldElement) and is_integer(a) -> new(a, b.prime) / b
      true -> Kernel./(a, b)
    end
  end
end
