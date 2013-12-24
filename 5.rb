class Player
  @health = nil
  def play_turn(warrior)
    @health = warrior.health unless @health
    if warrior.feel.empty?
      if warrior.health < @health
        warrior.walk!
      elsif warrior.health < 14
        warrior.rest!
      else
        warrior.walk!
      end
    else
	if warrior.feel.enemy?
	    warrior.attack!
	else
	    warrior.rescue!
	end

    end
    @health = warrior.health
  end
end