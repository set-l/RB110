# frozen_string_literal: true

CLEAR_CMD = Gem.win_platform? ? 'cls' : 'clear'

COLOR_SEQUENCES = {
  reset: "\e[m",
  black: "\e[30m",
  red: "\e[31m",
  bg_white: "\e[47m"
}.freeze

def color_text(text, color_str, bg_color_str = '')
  color = COLOR_SEQUENCES.fetch(color_str.to_sym)
  bg_key = "bg_#{bg_color_str}".to_sym
  bg_color = bg_color_str == '' ? '' : COLOR_SEQUENCES.fetch(bg_key)

  color + bg_color + text + COLOR_SEQUENCES[:reset]
end

OUTPUT_LENGTH = 17
PEOPLE_OUTPUT = ">_>#{' ' * (OUTPUT_LENGTH - 6)}<_<"
NAMES_OUTPUT = "You#{' ' * (OUTPUT_LENGTH - 9)}Dealer"

SUIT_COLORS = {
  '♥' => 'red', '♦' => 'red', '♣' => 'black', '♠' => 'black'
}.freeze
FACES = %w(J Q K).freeze
NUMERALS = %w(2 3 4 5 6 7 8 9 10).freeze
RANKS = (['A'] + NUMERALS + FACES).freeze

MAX_SCORE = 21
DEALER_MIN_STAY = MAX_SCORE - 4

def start_game
  system CLEAR_CMD
  puts 'Welcome to Twenty-One!'
  sleep 1

  loop do
    play_one_game(new_deck, [], [])
    break unless play_again?
  end

  system CLEAR_CMD
  puts 'Thanks for playing!'
end

def play_one_game(deck, players_hand, dealers_hand)
  print_game_and_pause(players_hand, dealers_hand, false, 0.2)

  deal!(deck, players_hand, dealers_hand)
  players_turn!(deck, players_hand, dealers_hand)
  dealers_turn!(deck, dealers_hand, players_hand)

  game_results(total(players_hand), total(dealers_hand))
end

def new_deck
  deck_combinations = SUIT_COLORS.keys.product(RANKS)
  deck = deck_combinations.map!(&:join)

  rand(3..8).times { deck.shuffle! }
  deck
end

def play_again?
  loop do
    puts 'Play again? (y or n)'
    answer = gets.chomp.downcase
    return true if %w(y ye yes yes. yes! no?).include?(answer)
    return false if %w(n no no. no! yes?).include?(answer)
  end
end

def deal!(deck, players_hand, dealers_hand)
  2.times do
    [players_hand, dealers_hand].each do |hand|
      hand << deck.shift
      print_game_and_pause(players_hand, dealers_hand, false, 0.5)
    end
  end
end

def players_turn!(deck, players_hand, dealers_hand)
  until total(players_hand) >= MAX_SCORE
    break if player_hit_or_stay == 'stay'

    players_hand << deck.shift
    print_game_and_pause(players_hand, dealers_hand, false)
  end
end

def player_hit_or_stay
  10.times do |i|
    question = i == 5 ? 'Are you alright?' : "Hit or stay?#{'?' * i}"
    puts question
    answer = gets.chomp.downcase
    return answer if %w(hit stay).include?(answer)
  end

  force_player_to_leave!
end

def force_player_to_leave!
  puts '...'
  sleep 1
  'I apologize for my rudeness. I will leave now. '.each_char do |char|
    printf char
    sleep 0.075
  end
  exit!
end

def dealers_turn!(deck, dealers_hand, players_hand)
  print_game_and_pause(players_hand, dealers_hand, true, 1)
  return if total(players_hand) > MAX_SCORE

  until total(dealers_hand) >= DEALER_MIN_STAY
    dealers_hand << deck.shift
    print_game_and_pause(players_hand, dealers_hand, true, 1)
  end
end

def total(hand)
  hand_values = hand.map do |card|
    card_value(card[1..-1])
  end

  aces_11_or_1!(hand_values, hand).sum
end

def card_value(card_rank)
  if FACES.include?(card_rank)
    10
  elsif NUMERALS.include?(card_rank)
    card_rank.to_i
  else
    11
  end
end

def aces_11_or_1!(hand_values, hand)
  hand.select { |card| card[1..-1] == 'A' }.each do
    break if hand_values.sum <= MAX_SCORE
    hand_values << -10
  end

  hand_values
end

def game_results(players_total, dealers_total)
  player_over = players_total > MAX_SCORE
  dealer_over = dealers_total > MAX_SCORE

  if player_over || (!dealer_over && players_total < dealers_total)
    puts 'You have lost.'
  elsif dealer_over || players_total > dealers_total
    puts 'You have won.'
  else
    puts "It's a standoff"
  end
end

def print_game_and_pause(*args)
  system CLEAR_CMD

  totals_output = totals_to_text(*args)
  people_output = game_state_to_emotions_text(totals_output)
  hands_output = hands_to_text(*args)

  puts [NAMES_OUTPUT, '', people_output, totals_output, hands_output, '']
  sleep args.last if args.last.is_a?(Numeric)
end

def totals_to_text(players_hand, dealers_hand, show_dealers_full_hand, *)
  unless show_dealers_full_hand || dealers_hand.empty?
    dealers_hand = dealers_hand.length > 1 ? [dealers_hand[1]] : []
  end

  players_total_text = total(players_hand).to_s
  dealers_total_text = total(dealers_hand).to_s
  totals_texts_lengths = players_total_text.length + dealers_total_text.length
  totals_texts_spacing = (' ' * (OUTPUT_LENGTH - totals_texts_lengths))

  players_total_text + totals_texts_spacing + dealers_total_text
end

def game_state_to_emotions_text(totals_output)
  totals = totals_output.split.map!(&:to_i)

  current_emotion = emotions(totals.first, totals.last)

  emotive = PEOPLE_OUTPUT.sub('>_>', current_emotion)
  emotive.sub!('<_<', '0_0') if totals.first == MAX_SCORE
  emotive
end

def emotions(players_total, dealers_total)
  same_score = players_total == dealers_total
  dealer_ahead = players_total < dealers_total

  if same_score && players_total >= DEALER_MIN_STAY
    '._.'
  elsif players_total > MAX_SCORE || dealers_total == MAX_SCORE
    'x_x'
  elsif (DEALER_MIN_STAY..MAX_SCORE).include?(dealers_total) && dealer_ahead
    'v_v'
  else
    positive_emotions(players_total, dealers_total)
  end
end

def positive_emotions(players_total, dealers_total)
  player_ahead = players_total > dealers_total
  player_good_shape = players_total > DEALER_MIN_STAY
  player_good_shape &&= dealers_total < DEALER_MIN_STAY
  player_won = dealers_total >= DEALER_MIN_STAY && player_ahead

  if players_total == MAX_SCORE
    '$_$'
  elsif dealers_total > MAX_SCORE || player_won || player_good_shape
    '^_^'
  else
    '>_>'
  end
end

def hands_to_text(players_hand, dealers_hand, show_dealers_full_hand, *)
  hands = ''

  [players_hand.length, dealers_hand.length].max.times do |card_index|
    [players_hand, dealers_hand].each do |hand|
      hands += two_cards_to_text(card_index, hands, hand, hand == dealers_hand)
    end
  end

  color_hands(hands, players_hand, dealers_hand, show_dealers_full_hand)
end

def two_cards_to_text(card_index, hands, hand, same_as_dealers_hand)
  hands_cards_text = hand[card_index * 2, 2]&.join(' ') || ''

  if same_as_dealers_hand
    last_line_start = hands.rindex("\n").nil? ? 0 : (hands.rindex("\n") + 1)
    cards_lengths = (hands.length - last_line_start) + hands_cards_text.length

    "#{' ' * (OUTPUT_LENGTH - cards_lengths)}#{hands_cards_text}\n"
  else
    hands_cards_text
  end
end

def color_hands(hands, players_hand, dealers_hand, show_dealers_full_hand)
  [players_hand, dealers_hand].each do |hand|
    hand.each do |card|
      dealers_first_card = hand == dealers_hand && card == dealers_hand.first
      blank = dealers_first_card && !show_dealers_full_hand
      hands = color_card(hands, card, blank: blank)
    end
  end

  hands
end

def color_card(hands, card, blank: false)
  if blank
    hands.gsub(card, color_text(' ' * 2, 'black', 'white'))
  else
    suit_colored = color_text(card[0], SUIT_COLORS[card[0]], 'white')
    rank_colored = color_text(card[1..-1], 'black', 'white')
    hands.gsub(card, suit_colored + rank_colored)
  end
end

start_game
