defmodule FractionTest do
  use ExUnit.Case

  test "test fractions" do
    one_half = %Fraction{a: 1, b: 2}
    assert one_half.a == 1
    assert one_half.b == 2

    %Fraction{a: a, b: b} = one_half
    assert a == 1
    assert b == 2

    %Fraction{} = one_half

    one_quarter = %Fraction{one_half | b: 4}
    assert one_quarter == %Fraction{a: 1, b: 4}

    sum = Fraction.add(one_quarter, one_half)
    assert sum == %Fraction{a: 3, b: 4}

    diff = Fraction.subtract(one_half, one_quarter)
    assert diff == %Fraction{a: 1, b: 4}

  end
end
