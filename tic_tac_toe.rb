class X
  def initialize
    @name = 'X'
    @position = nil
  end
  
  def name
    @name
  end
  
  def position
    @position
  end
  
  def position=(n_pos)
    @position = n_pos
  end
end

class O < X
  def initialize
    @name = 'O'
    @position = nil
  end
end

class Board 
  def initialize
    @hash_map = Array.new(3) { Array.new(3, ' ') }
    @map = nil
  end
  
  def hash_map
    @hash_map
  end
 
  def map
    @map = %Q(
      1 2 3
           
    1 #{@hash_map[0][0]}|#{@hash_map[0][1]}|#{@hash_map[0][2]}    
      -----
    2 #{@hash_map[1][0]}|#{@hash_map[1][1]}|#{@hash_map[1][2]}  
      -----
    3 #{@hash_map[2][0]}|#{@hash_map[2][1]}|#{@hash_map[2][2]}
    )
  end             
end

class Game
  def initialize
    @player1 = X.new
    @player2 = O.new
    @board = Board.new
    @victory = false
  end
  
  def start
    until @victory
      [@player1, @player2].each do |player|
        redo unless positioning(player)
        if win(player) && @victory != "It's a tie!"
          return "#{@board.map}\n --> #{player.name} won! <--"
        elsif @victory == "It's a tie!"
          return "--> #{@victory} <--"
        end
      end
    end
  rescue Interrupt
    puts "--> Have a wonderful time! <--"
  end
  
  def positioning(player)
    puts @board.map
    puts "--> #{player.name} turn <--"
    player.position = gets.chomp.scan(/\d/)
    hash_map_pos = player.position.map { |i| i.to_i - 1 }
    if @board.hash_map[hash_map_pos[0]][hash_map_pos[1]] == ' '
      @board.hash_map[hash_map_pos[0]][hash_map_pos[1]] = player.name
    else
      puts "--> #{@board.hash_map[hash_map_pos[0]][hash_map_pos[1]]} already is there <--"
    end
  rescue TypeError
    puts "--> Enter a valid pair of coordinates <--"
    retry
  end
  
  def win(player)
    test = proc { |i| i == player.name }
    columns = @board.hash_map.transpose
    diagonals = [[],[]]
    @board.hash_map.each_with_index { |item, index|  diagonals[0] << item[index] }
    @board.hash_map.reverse.each_with_index { |item, index| diagonals[1] << item[index] }
    
    @victory = 
    case
    when @board.hash_map[0].all?(&test)
      true
    when @board.hash_map[1].all?(&test)
      true
    when @board.hash_map[2].all?(&test)
      true
    when columns[0].all?(&test)
      true
    when columns[1].all?(&test)
      true
    when columns[2].all?(&test)
      true
    when diagonals[0].all?(&test)
      true
    when diagonals[1].all?(&test)
      true
    when @board.hash_map.flatten.none? { |item| item == ' ' }
      "It's a tie!"
    end
  end      
end

game = Game.new
puts game.start
