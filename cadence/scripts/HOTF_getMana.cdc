import "HOTF"

pub fun main(address:Address): UInt8 {
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
  let mana = refUserGameStateCap.borrow()!.mana
  return mana
}
