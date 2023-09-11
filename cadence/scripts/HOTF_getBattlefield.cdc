import "HOTF"

pub fun main(address:Address): {Int: HOTF.Minion} {
  let acct = getAccount(address)
  let refUserGameStateCap = acct.getCapability<&HOTF.UserGameState{HOTF.UserGameStatePublicInterface}>(HOTF.UserGameStatePublicPath)
  if (!refUserGameStateCap.check()) {
    log("Public GameState Link invalid")
    return {}
  }
  if (refUserGameStateCap.borrow() == nil) {
    log("Public GameState Link borrow failed")
    return {}
  }
  //return refUserGameStateCap.borrow()!.mana
  let hand = refUserGameStateCap.borrow()!.battlefield
  return hand
}
