class SituationActionFactory
  def create(situation)
      puts situation
      case situation
      when Situations::S_SHORT_RANGE_ATTACK
        return ShortRangeAttackAction.new
      when Situations::S_LONG_RANGE_ATTACK
        return LongRangeAttackAction.new
      when Situations::S_WRONG_DIRECTION_ATTACK
        return PivotAction.new
      when Situations::S_SAFE
        return MoveAction.new
      when Situations::S_RETREAT
        return PivotAction.new
      when Situations::S_REST
        return RestAction.new
      when Situations::S_ESCAPE
        return MoveAction.new
      when Situations::S_RETURN_TO_ACTION
        return PivotAction.new
      when Situations::S_RESCUE_CAPTIVE
        return RescueCaptiveAction.new
      when Situations::S_WALL
        return PivotAction.new
      end
  end
end
