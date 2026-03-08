defmodule Ed25519 do
  use FieldElement
  defstruct [:x, :y, :inf]
  @a -1
  @d -121665/121666
  @g_x 15112221349535400772501151409588531511454012693041857206046113283949847762202
  @g_y 46316835694926478169428394003475163141307993866256225615783033603165251855960960
  @l 2 ** 252 + 27742317777372353535851937790883648493
  @cofactor 8
  @p 2 ** 255 - 19

  defguard is_same_curve(p, q)
           when FieldElement.is_same_field(p.x, q.x) and
                FieldElement.is_same_field(p.y, q.y) and
                FieldElement.is_same_field(p.x, p.y)

  def g do
    new(@g_x, @g_y)
  end

  def order do
    @l
  end

  def new(x, y) do
    x = if is_struct(x, FieldElement) do x else FieldElement.new(x, @p) end
    y = if is_struct(y, FieldElement) do y else FieldElement.new(y, @p) end

    if @a * x ** 2 + y ** 2 != 1 + @d * x ** 2 * y ** 2 do
      raise "Point (#{x.num}, #{y.num}) is not on the curve"
    end

    %Ed25519{x: x, y: y, inf: false}
  end

  def zero() do
    %Ed25519{x: FieldElement.new(0, @p), y: FieldElement.new(0, @p), inf: true}
  end

  def equal(p, q) when is_same_curve(p, q) do
    p.x == q.x and p.y == q.y
  end

  def add(p, q) when is_same_curve(p, q) do
    u_1 = p.x * q.y + q.x * p.y
    v_1 = 1 + @d * p.x * q.x * p.y * q.y
    u_2 = p.y * q.y - @a * p.x * q.x
    v_2 = 1 - @d * p.x * q.x * p.y * q.y
    x_3 = u_1 / v_1
    y_3 = u_2 / v_2

    case x_3 == 0 and y_3 == 0 do
      true -> zero()
      false -> new(x_3, y_3)
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
