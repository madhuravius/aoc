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
    assert(length(result.four_of_a_kind) == 3)
    assert(length(result.two_pair) == 1)
  end

  test "Compute top level wager score sum" do
    result =
      test_hands()
      |> CamelCards.Core.compute_score_for_input()

    assert(result == 5905)
  end

  test "Compute upgrade by joker count" do
    assert(get_j_counts(:high_card, "Q2345") == :high_card)
    assert(get_j_counts(:one_pair, "QQ234") == :one_pair)
    assert(get_j_counts(:two_pair, "QQ665") == :two_pair)
    assert(get_j_counts(:three_of_a_kind, "QQQ56") == :three_of_a_kind)
    assert(get_j_counts(:full_house, "QQQ66") == :full_house)
    assert(get_j_counts(:four_of_a_kind, "QQQQ6") == :four_of_a_kind)
    assert(get_j_counts(:five_of_a_kind, "QQQQQ") == :five_of_a_kind)
    assert(get_j_counts(:high_card, "J2345") == :one_pair)
    assert(get_j_counts(:one_pair, "JJ234") == :three_of_a_kind)
    assert(get_j_counts(:two_pair, "JJ665") == :four_of_a_kind)
    assert(get_j_counts(:three_of_a_kind, "JJJ56") == :four_of_a_kind)
    assert(get_j_counts(:full_house, "JJJ66") == :five_of_a_kind)
    assert(get_j_counts(:four_of_a_kind, "JJJJ6") == :five_of_a_kind)
    assert(get_j_counts(:five_of_a_kind, "JJJJJ") == :five_of_a_kind)
  end

  defp get_j_counts(hand_type, hand) do
    CamelCards.Core.upgrade_hand_by_number_of_jokers(hand_type, %CamelCards.Hand{hand: hand})
  end

  defp test_hands do
    "32T3K 765
T55J5 684
KK677 28
KTJJT 220
QQQJA 483"
  end
end
