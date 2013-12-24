class Player
  @health = nil
  def play_turn(warrior)
    @health = warrior.health unless @health
    if warrior.feel.empty?
      if @health > warrior.health
        if warrior.health < 9
          warrior.walk! :backward
        else
          warrior.walk! :forward
        end
      else
        if warrior.health < 15
          warrior.rest!
        else
          warrior.walk! :forward
        end
      end
    else
      if warrior.feel.captive?
        warrior.rescue!
      else
        warrior.attack!
      end
    end

    @health = warrior.health
  end
end