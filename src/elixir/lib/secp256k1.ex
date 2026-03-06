defmodule Secp256k1 do
  use FieldElement
  defstruct [:x, :y, :inf]
  @g_x 0x79be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798
  @g_y 0x483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8
  @order 0xfffffffffffffffffffffffffffffffebaaedce6af48a03bbfd25e8cd0364141
  @a 0
  @b 7
  @p 2 ** 256 - 2 ** 32 - 977

  defguard is_same_curve(p, q)
           when FieldElement.is_same_field(p.x, q.x) and
                FieldElement.is_same_field(p.y, q.y) and
                FieldElement.is_same_field(p.x, p.y)

  def g() do
    new(@g_x, @g_y)
  end

  def order() do
    @order
  end

  def new(x, y) do
    x = if is_struct(x, FieldElement) do x else FieldElement.new(x, @p) end
    y = if is_struct(y, FieldElement) do y else FieldElement.new(y, @p) end

    if y ** 2 != x ** 3 + @a * x + @b do
      raise "Point (#{x.num}, #{y.num}) is not on the curve"
    end

    %Secp256k1{x: x, y: y, inf: false}
  end

  def zero() do
    %Secp256k1{
      x: FieldElement.new(0, @p),
      y: FieldElement.new(0, @p),
      inf: true
    }
  end

  def equal(p, q) when is_same_curve(p, q) do
    p.x == q.x and p.y == q.y
  end

  def add(p, q) when is_same_curve(p, q) do
    y_zero = FieldElement.new(0, p.y.prime)

    cond do
      p.inf -> q
      q.inf -> p
      p == q and p.y == y_zero ->
        zero()
      p == q ->
        s = (3 * p.x ** 2 + @a) / (2 * p.y)
        x = s ** 2 - 2 * p.x
        y = s * (p.x - x) - p.y
        new(x, y)
      p != q and p.x == q.x ->
        zero()
      p != q ->
        s = (q.y - p.y) / (q.x - p.x)
        x = s ** 2 - p.x - q.x
        y = s * (p.x - x) - p.y
        new(x, y)
    end
  end

  defp scalar(p, n, sum) do
    cond do
      n == 0 -> sum
      rem(n, 2) == 0 ->
        scalar(add(p, p), div(n, 2), sum)
      rem(n, 2) == 1 ->
        scalar(add(p, p), div(n, 2), add(sum, p))
    end
  end

  def scalar(p, n) do
    scalar(p, n, zero())
  end


  defp pow(_base, 0, acc), do: rem(acc, @order)

  defp pow(base, exp, acc) do
    if rem(exp, 2) == 1 do
      pow(rem(base * base, @order), div(exp, 2), rem(acc * base, @order))
    else
      pow(rem(base * base, @order), div(exp, 2), acc)
    end
  end

  def pow(base, exp) do
    pow(rem(base, @order), exp, 1)
  end
end
