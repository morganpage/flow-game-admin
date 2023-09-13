import "HOTFBattle"

pub fun main(): Int {
    var teams = HOTFBattle.getMinions()
    log("Minions: ".concat(minions.length.toString()))
    return minions.length
}
