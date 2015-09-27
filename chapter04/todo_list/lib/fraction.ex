defmodule Fraction do
  defstruct a: nil, b: nil

  def add(%Fraction{a: a1, b: b1}, %Fraction{a: a2, b: b2}) do
    new_a = a1 * b2 + a2 * b1
    new_b = b1 * b2
    divisor = gcd(new_a, new_b)
    %Fraction{a: div(new_a, divisor), b: div(new_b, divisor)}
  end

  def subtract(%Fraction{a: a1, b: b1}, %Fraction{a: a2, b: b2}) do
    new_a = a1 * b2 - a2 * b1
    new_b = b1 * b2
    divisor = gcd(new_a, new_b)
    %Fraction{a: div(new_a, divisor), b: div(new_b, divisor)}
  end

  defp gcd(a, 0), do: a

  defp gcd(a, b), do: gcd(b, rem(a, b))
end
