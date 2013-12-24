require 'pp'

class Player
  @health = nil

  vision=[ :stairs, :empty, :wall, :captive, :enemy ]

  def scan(spaces)
    sight = {}

    spaces.each_with_index { |space, index|
      distance = index.succ
      entity = vision.select { |type|
        space.send "#{type.to_s}?".to_sym
      }.first
      raise "woah" unless entity
      sight[:nearest] = entity unless sight[:nearest]
      if sight[entity]
        sight[entity] << distance
      else
        sight[entity] = [distance]
      end

      nearest_entity_key = "nearest_#{entity.to_s}".to_sym
      sight[nearest_entity_key] = distance unless sight[nearest_entity_key]

      # zero based distance could be easy to forget...
      if sight[:view]
        sight[:view] << entity
      else
        sight[:view] = [entity]
      end
    }

    sight
  end

  def play_turn(warrior)
    @health = warrior.health unless @health
   

    if warrior.feel.wall?
      warrior.pivot!
    elsif warrior.feel.enemy?
      warrior.attack!
    elsif warrior.feel.captive?
      warrior.rescue!
    else
      i_spy = [:backward, :forward].reduce({}) { |area, direction|
        area[direction] = scan warrior.look(direction)
        area
      }

      if @health > warrior.health
        if warrior.health <= 9
          warrior.walk! :backward
        else
          warrior.walk! :forward
        end
      elsif warrior.health < 15
        warrior.rest!
      else
        if [:backward, :forward].all? { |dir| i_spy[dir][:enemy] }
          if i_spy[:backward][:nearest_enemy] > i_spy[:forward][:nearest_enemy]
            warrior.pivot!
          else
            warrior.walk!
          end
        else
          warrior.walk!
        end
      end
    end
    @health = warrior.health
  end
end