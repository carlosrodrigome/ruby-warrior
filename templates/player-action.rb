require 'situations'
require 'situation-action'

class PlayerAction
  def initialize(warrior)
    @warrior = warrior
  end
  def perform(action)
    action.do(@warrior)
  end
end

class LongRangeAttackAction
  def do(warrior)
    warrior.shoot!
  end
end

class ShortRangeAttackAction
  def do(warrior)
    warrior.attack!
  end
end

class RescueCaptiveAction
  def do(warrior)
    warrior.rescue!
  end
end

class MoveAction
  def do(warrior)
    warrior.walk!
  end
end

class PivotAction
  def do(warrior)
    warrior.pivot!
  end
end

class RestAction
  def do(warrior)
    warrior.rest!
  end
end
