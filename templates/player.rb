require 'player-action'
require 'situations'

class Player
  @@health = 20;
  @@retreatAndRest = false;
  @@changeDirection = false;

  def play_turn(warrior)
    look_and_react(warrior)
  end

  def is_under_attack(health)
    if health == nil
      return false
    end
    return health < @@health
  end

  def has_acceptable_health(health)
    minHealth = 10
    if @@retreatAndRest
      minHealth = 20
    end
    return  health >= minHealth
  end

  def set_current_health(health)
    @@health = health
  end

  def is_critic_state(health)
    return health < 5
  end

  def is_berserk_mode_on(health)
    return health < 3 #better die fighting
  end

  def define_situation(warrior)
    spaces = warrior.look
    health = warrior.health

    if warrior.feel.captive?
      return Situations::S_RESCUE_CAPTIVE
    end
    if warrior.feel().wall?
      if has_acceptable_health(health)
        return Situations::S_WALL
      else
        return Situations::S_REST
      end
    end

    #Reatret Scenario
    if @@retreatAndRest
      if is_under_attack(health)
        return Situations::S_ESCAPE
      elsif has_acceptable_health(health)
        @@retreatAndRest = false
        if @@changeDirection
          return Situations::S_RETURN_TO_ACTION
        else
          return Situations::S_SAFE
        end
      else
        return Situations::S_REST
      end
    end
    #Under attack Scenario
    if is_under_attack(health)
      if is_critic_state(health)
        if is_berserk_mode_on(health)
          if warrior.feel.enemy?
            return Situations::S_SHORT_RANGE_ATTACK
          else
            return Situations::S_LONG_RANGE_ATTACK
          end
        elsif !@@retreatAndRest
          @@retreatAndRest = true
          @@changeDirection = true
          return Situations::S_RETREAT
        end
      elsif warrior.feel.enemy?
        return Situations::S_SHORT_RANGE_ATTACK
      else
        if has_enemy_in_range(spaces)
          return Situations::S_SAFE
        else
          return Situations::S_WRONG_DIRECTION_ATTACK
        end
      end
    end

    #Close enemy Scenario
    if has_enemy_in_range(spaces)
      if is_critic_state(health)
        if !@@retreatAndRest
          @@retreatAndRest = true
          return Situations::S_REST
        end
      elsif warrior.feel.enemy?
        return Situations::S_SHORT_RANGE_ATTACK
      else
        return Situations::S_LONG_RANGE_ATTACK
      end
    else
      return Situations::S_SAFE
    end



    #No enemy Scenario

  end




  def look_and_react(warrior)
    playerAction = PlayerAction.new(warrior)
    playerAction.perform(SituationActionFactory.new.create(define_situation(warrior)))
    set_current_health(warrior.health)
  end

  def setup_direction(warrior)
    if warrior.feel.wall?
      change_direction(warrior)
    end
  end

  def has_enemy_in_range(spaces)
    count = 1
    enemyPosition = 0
    captivePostion = 0
    for space in spaces
      if space.enemy?
        enemyPosition = count
      elsif space.captive?
        captivePostion = count
      end
      count = count+1
    end
    if enemyPosition > 0 && captivePostion > 0
      return enemyPosition < captivePostion
    elsif captivePostion == 0 && enemyPosition > 0
      return true
    elsif enemyPosition == 0
      return false
    end
  end
end
