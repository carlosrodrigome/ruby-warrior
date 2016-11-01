class Player
  @@hasFight = false;
  @@health = 20;
  @@retreatAndRest = false;

  def play_turn(warrior)
    look_and_react(warrior)
  end

  def warrior_attack(warrior)
    warrior.attack!
    @@hasFight = true
  end

  def warrior_walk(warrior)
    if is_under_attack(warrior.health)
      if !has_acceptable_health(warrior.health)
        if !@@retreatAndRest
          change_direction(warrior)
        end
        @@retreatAndRest = true
      end
    else
      if has_acceptable_health(warrior.health)
        if @@retreatAndRest
          change_direction(warrior)
          @@retreatAndRest = false
        else
          warrior.walk!
          @@hasFight = false
        end
      else
        warrior.rest!
      end
    end
  end

  def is_under_attack(health)
    if health == nil
      return false
    end
    return health < @@health
  end

  def has_acceptable_health(health)
    minHealth = 15
    if @@retreatAndRest
      minHealth = 20
    end
    return  health >= minHealth
  end

  def set_current_health(health)
    @@health = health
  end

  def setup_direction(warrior)
    if warrior.feel.wall?
      change_direction(warrior)
    end
  end

  def change_direction(warrior)
    warrior.pivot!
  end

  def is_critic_state(health)
    return health < 5
  end

  def look_and_react(warrior)
    if can_shoot_enemy(warrior.look)
      if is_under_attack(warrior.health)
        if !warrior.feel.enemy?
          warrior.walk!
        else
          perform_attack(warrior)
        end
      else
        if !warrior.feel.enemy?
          warrior.shoot!
        else
          perform_attack(warrior)
        end
      end
    else
    if warrior.feel.enemy?
      perform_attack(warrior)
    elsif warrior.feel.captive?
      warrior.rescue!
    elsif warrior.feel.wall?
      change_direction(warrior)
    else
      warrior_walk(warrior)
    end
  end
    set_current_health(warrior.health)
  end

  def can_shoot_enemy(spaces)
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

  def perform_attack(warrior)
    if is_critic_state(warrior.health)
      change_direction(warrior)
      @@retreatAndRest = true
    else
      warrior_attack(warrior)
    end
  end
end
