defmodule CamelCards.Hand do
  defstruct [:hand, :score, :wager]

  @type t :: %__MODULE__{
          hand: String.t(),
          wager: number
        }
end

defmodule CamelCards.Groups do
  defstruct [
    :five_of_a_kind,
    :four_of_a_kind,
    :full_house,
    :three_of_a_kind,
    :two_pair,
    :one_pair,
    :high_card
  ]

  @type t :: %__MODULE__{
          five_of_a_kind: list(Hand) | nil,
          four_of_a_kind: list(Hand) | nil,
          full_house: list(Hand) | nil,
          three_of_a_kind: list(Hand) | nil,
          two_pair: list(Hand) | nil,
          one_pair: list(Hand) | nil,
          high_card: list(Hand) | nil
        }
end

defmodule CamelCards.Core do
  alias CamelCards.Hand
  require CamelCards.Core

  @core_rank %{
    A: "a",
    K: "b",
    Q: "c",
    T: "e",
    "9": "f",
    "8": "g",
    "7": "h",
    "6": "i",
    "5": "j",
    "4": "k",
    "3": "l",
    "2": "m",
    J: "n"
  }

  @hand_rank [
    :five_of_a_kind,
    :four_of_a_kind,
    :full_house,
    :three_of_a_kind,
    :two_pair,
    :one_pair,
    :high_card
  ]

  @spec translate_word_to_letter_map(word :: String.t()) :: String.t()
  def translate_word_to_letter_map(word) do
    word
    |> String.split("")
    |> Enum.map(fn letter ->
      Map.get(@core_rank, String.to_atom(letter))
    end)
    |> Enum.join()
  end

  @spec compute_score_for_input(input :: String.t()) :: number
  def compute_score_for_input(input) do
    grouped_organized_hands =
      parse_input_into_hands(input)
      |> organize_input_into_groups()

    [
      grouped_organized_hands.high_card,
      grouped_organized_hands.one_pair,
      grouped_organized_hands.two_pair,
      grouped_organized_hands.three_of_a_kind,
      grouped_organized_hands.full_house,
      grouped_organized_hands.four_of_a_kind,
      grouped_organized_hands.five_of_a_kind
    ]
    |> Enum.filter(&(!is_nil(&1)))
    |> Enum.map(fn hands ->
      hands
      |> Enum.sort(fn a, b ->
        translate_word_to_letter_map(a.hand) > translate_word_to_letter_map(b.hand)
      end)
    end)
    |> Enum.concat()
    |> Enum.with_index()
    |> Enum.map(fn {hand, idx} ->
      hand.wager * (idx + 1)
    end)
    |> Enum.sum()
  end

  @spec parse_input_into_hands(input :: String.t()) :: list(Hand)
  def parse_input_into_hands(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(fn hand_row -> String.split(hand_row, " ") end)
    |> Enum.map(fn hand_data ->
      {wager, ""} = Integer.parse(String.trim(Enum.at(hand_data, 1)), 10)
      hand = String.trim(Enum.at(hand_data, 0))

      %CamelCards.Hand{
        hand: hand,
        wager: wager
      }
    end)
  end

  @spec upgrade_hand_by_number_of_jokers(hand_type :: atom, hand :: Hand) :: atom
  def upgrade_hand_by_number_of_jokers(hand_type, hand) do
    rank_index = Enum.find_index(@hand_rank, fn rank -> rank == hand_type end)

    jokers =
      hand.hand
      |> String.split("")
      |> Enum.map(fn card -> card == "J" end)
      |> Enum.filter(fn is_joker -> is_joker == true end)
      |> Kernel.length()

    chosen_rank =
      @hand_rank
      |> Enum.at(max(0, rank_index - jokers))

    # goofy conditional logic made possible with test cases...
    if jokers == 0 do
      hand_type
    else
      case chosen_rank do
        :five_of_a_kind ->
          if hand_type == :three_of_a_kind do
            # invalid upgrade on joker spam
            :four_of_a_kind
          else
            chosen_rank
          end

        :full_house ->
          # always take the four as an upgrade if given
          :four_of_a_kind

        :three_of_a_kind ->
          if hand_type == :two_pair do
            :full_house
          else
            :three_of_a_kind
          end

        :two_pair ->
          :three_of_a_kind

        _ ->
          chosen_rank
      end
    end
  end

  @spec organize_input_into_groups(list(Hand)) :: any
  def organize_input_into_groups(hands) do
    hands
    |> Enum.reduce(%CamelCards.Groups{}, fn hand, acc ->
      hand_type =
        get_hand_type(hand)
        |> upgrade_hand_by_number_of_jokers(hand)

      Map.update(acc, hand_type, [], fn existing ->
        if is_nil(existing) do
          [hand]
        else
          [hand | existing]
        end
      end)
    end)
  end

  @spec get_hand_type(Hand) :: atom
  def get_hand_type(hand) do
    map_of_cards_and_counts =
      hand.hand
      |> to_charlist()
      |> Enum.reduce(%{}, fn char, acc ->
        Map.update(acc, char, 1, fn existing -> existing + 1 end)
      end)

    case length(Map.keys(map_of_cards_and_counts)) do
      1 ->
        :five_of_a_kind

      2 ->
        case map_of_cards_and_counts
             |> Map.values()
             |> Enum.sort()
             |> Enum.reverse()
             |> Enum.at(0) do
          4 -> :four_of_a_kind
          3 -> :full_house
        end

      3 ->
        case map_of_cards_and_counts
             |> Map.values()
             |> Enum.sort()
             |> Enum.reverse()
             |> Enum.at(0) do
          3 -> :three_of_a_kind
          2 -> :two_pair
        end

      4 ->
        :one_pair

      _ ->
        :high_card
    end
  end
end
