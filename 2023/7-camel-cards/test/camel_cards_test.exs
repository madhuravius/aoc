defmodule CamelCardsTest do
  use ExUnit.Case

  test "Parses input into hands" do
    result =
      test_hands()
      |> CamelCards.Core.parse_input_into_hands()

    assert Enum.at(result, 0).hand == "32T3K"
    assert Enum.at(result, 0).wager == 765
    assert Enum.at(result, 4).hand == "QQQJA"
    assert Enum.at(result, 4).wager == 483
  end

  test "Use hand to get type" do
    assert(CamelCards.Core.get_hand_type(%CamelCards.Hand{hand: "66666"}) == :five_of_a_kind)
    assert(CamelCards.Core.get_hand_type(%CamelCards.Hand{hand: "26666"}) == :four_of_a_kind)
    assert(CamelCards.Core.get_hand_type(%CamelCards.Hand{hand: "22666"}) == :full_house)
    assert(CamelCards.Core.get_hand_type(%CamelCards.Hand{hand: "23666"}) == :three_of_a_kind)
    assert(CamelCards.Core.get_hand_type(%CamelCards.Hand{hand: "23366"}) == :two_pair)
    assert(CamelCards.Core.get_hand_type(%CamelCards.Hand{hand: "23466"}) == :one_pair)
    assert(CamelCards.Core.get_hand_type(%CamelCards.Hand{hand: "23456"}) == :high_card)
  end

  test "Organize inputs into groups" do
    result =
      test_hands()
      |> CamelCards.Core.parse_input_into_hands()
      |> CamelCards.Core.organize_input_into_groups()

    assert(length(result.one_pair) == 1)
    assert(length(result.three_of_a_kind) == 2)
    assert(length(result.two_pair) == 2)
  end

  test "Compute top level wager score sum" do
    result =
      test_hands()
      |> CamelCards.Core.compute_score_for_input()

    assert(result == 6440)
  end

  defp test_hands do
    "32T3K 765
T55J5 684
KK677 28
KTJJT 220
QQQJA 483"
  end
end
