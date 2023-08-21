import "GameDB"

pub fun main(): Int {
  var minions = GameDB.getMinions()
  return minions.length
}
