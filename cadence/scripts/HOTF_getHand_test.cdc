import "HOTF"

pub fun main(address:Address): Int {
  let acct = getAccount(address)
  let refUserGameStateCap = acct.getCapability<&HOTF.UserGameState{HOTF.UserGameStatePublicInterface}>(HOTF.UserGameStatePublicPath)
  if (!refUserGameStateCap.check()) {
    log("Public GameState Link invalid")
    return 0
  }
  if (refUserGameStateCap.borrow() == nil) {
    log("Public GameState Link borrow failed")
    return 0
  }
  //return refUserGameStateCap.borrow()!.mana
  let hand = refUserGameStateCap.borrow()!.hand
  return hand.length
}
