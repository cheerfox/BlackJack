#if blackjack
#if busted

require 'pry'

SUIT = ['C', 'D', 'H', 'S']
NUMBER = ['A', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K']

def initialize_deck(deck)
  3.times do
    SUIT.each do |suit|
      NUMBER.each {|number| deck << [suit, number]}
    end  
    deck.shuffle!
  end
end

def deal_a_card(deck)
  deck.pop  
end

def show_user_cards(user_cards)
  puts "Now User's cards are: "
  user_cards.each {|card| p card}
end

def show_dealer_cards(dealer_cards)
  puts "Now Dealer's cards are: "
  dealer_cards.each {|card| p card}
end

def show_user_point(user_cards)
  puts "User's point are: "
  p count_the_point(user_cards)
end

def show_dealer_point(dealer_cards)
  puts "Dealer's point are: "
  p count_the_point(dealer_cards)
end

def count_the_point(cards)
  point = 0
  cards.each do |card|
    if card[1] == 'J' || card[1] == 'Q' || card[1] == 'K'
      point += 10
    elsif card[1] == 'A'
      point += 11
    else
      point += card[1].to_i
    end
  end
  #correct ace
  cards.select {|e| e[1] == 'A'}.count.times do
    point -= 10 if point>21
  end

  point
end

def blackjack?(cards)
  count_the_point(cards) == 21
end

def busted?(cards)
  count_the_point(cards) > 21
end

def initialization(deck, user_cards, dealer_cards)
  initialize_deck(deck)
  2.times {user_cards << deal_a_card(deck)}
  show_user_cards(user_cards)
  show_user_point(user_cards)
  2.times {dealer_cards << deal_a_card(deck)}
  show_dealer_cards(dealer_cards)
  show_dealer_point(dealer_cards)
end

def user_round(deck, user_cards, point)
  winner = ' '
  if blackjack?(user_cards)
    puts "Blackjack!!"
    winner = 'user'
    point[:user] = 21
    return winner
  end
  loop do
    hit_or_stay = ' '
    puts "=> Hit press 'h' ,or Stay press 's' "
    hit_or_stay = gets.chomp.downcase 
    if !['h', 's'].include?(hit_or_stay)
      puts "H or S Please!!!"
      next
    elsif hit_or_stay == 'h'
      user_cards << deal_a_card(deck)
      show_user_cards(user_cards)
      show_user_point(user_cards)
      if busted?(user_cards)
        puts "Busted!!"
        winner = 'dealer'
        point[:user] = count_the_point(user_cards)
        break
      elsif blackjack?(user_cards)
        puts "Blackjack!!"
        winner = 'user'
        point[:user] = 21
        break
      else
        puts "=> Now your point is #{count_the_point(user_cards)}"
      end
    else
      point[:user] = count_the_point(user_cards)
      break
    end
  end
  puts "=> Your final point = #{point[:user]}"
  winner
end

def dealer_round(deck, dealer_cards, point, winner)
  loop do
    sleep(3)
    if busted?(dealer_cards)
      puts "Busted!!"
      winner = 'user'
      point[:dealer] = count_the_point(dealer_cards)
      break
    elsif blackjack?(dealer_cards)
      puts "Blackjack!!"
      winner = 'dealer'
      point[:dealer] = 21
      break
    else
      if count_the_point(dealer_cards) < 17
        dealer_cards << deal_a_card(deck)
        show_dealer_cards(dealer_cards)
        show_dealer_point(dealer_cards)
      else
        point[:dealer] = count_the_point(dealer_cards)
        break
      end
    end
  end
  puts "=> Dealer's final point = #{point[:dealer]}"
  winner
end


def get_winner(winner, point)
  if winner == 'user'
    puts "You Win !!"
  elsif winner == 'dealer'
    puts "You Lose !!"
  else
    if point[:user] > point[:dealer]
      puts "You win!!"
    elsif point[:user] < point[:dealer]
      puts "You lose!!"
    else
      puts "Tie!!"
    end
  end
end

def play_again?
  puts "=> Wonna play again? Y or N"
  gets.chomp.downcase != 'n'
end

#main
loop do
  system('clear')
  deck = []
  user_cards = []
  dealer_cards = []
  point = {user: 0, dealer: 0}
  winner = ' '
  initialization(deck, user_cards, dealer_cards)
  winner = user_round(deck, user_cards, point)
  if winner == 'user'
    puts "You Win!!"
  elsif winner == 'dealer'
    puts "You Lose!!"
  else
    winner = dealer_round(deck, dealer_cards, point, winner)
    get_winner(winner, point)
  end
  break unless play_again?
end



















