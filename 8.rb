require 'pp'

class Player
  @health = nil
  vision=%w{ stairs empty wall captive enemy }
  def watch(warrior)
    sight = {}
    warrior.look.each_with_index { |space, index|
      index.succ
      thing = vision.select { |type|
        space.send "#{type}?".to_sym
      }.first
      raise "woah" unless thing
      sight[:nearest] = thing unless sight[:nearest]
      if sight[thing]
        sight[thing] << index
      else
        sight[thing] = [index]
      end
    }
    pp sight
    sight
  end
  def play_turn(warrior)
    @health = warrior.health unless @health
    if warrior.feel.wall?
      warrior.pivot!
    elsif warrior.feel.empty?
      i_spy = watch warrior
      next_good_guy = i_spy.fetch("captive", []).first
      next_bad_guy = i_spy.fetch("enemy", []).first
      if next_good_guy && next_bad_guy
        if next_good_guy < next_bad_guy
          warrior.walk!
        else
          warrior.shoot!
        end
      elsif next_bad_guy
        warrior.shoot!
      elsif @health > warrior.health
        if warrior.health <= 9
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