import "HOTF"

pub fun main(): Int {
    var minions = HOTF.getMinions()
    log("Minions: ".concat(minions.length.toString()))
    return minions.length
}
