import "GameDB"

pub fun main() : [GameDB.Minion]  {
  var minions = GameDB.getMinions()
  return minions
}
