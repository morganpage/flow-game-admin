import "HOTF"

transaction(name: String) {
  let account: Address

    prepare(acct: AuthAccount)  {
      self.account = acct.address
      //log("Login User Account:  ".concat(self.account.toString()))
      let userGameState <- acct.load<@HOTF.UserGameState>(from: HOTF.UserGameStateStoragePath)
      destroy userGameState
      // if refUserGameState == nil
      // {
      //   log("Creating User Account:  ".concat(self.account.toString()))
      //   acct.save(<-HOTF.CreateUserGameState(name: name), to: HOTF.UserGameStateStoragePath)
      //   refUserGameState = acct.borrow<&HOTF.UserGameState>(from: HOTF.UserGameStateStoragePath)
      //   acct.link<&HOTF.UserGameState{HOTF.UserGameStatePrivateInterface}>(HOTF.UserGameStatePrivatePath, target:HOTF.UserGameStateStoragePath)
      //   acct.link<&HOTF.UserGameState{HOTF.UserGameStatePublicInterface}>(HOTF.UserGameStatePublicPath, target:HOTF.UserGameStateStoragePath)
      // }else {
      //   log("User Account already exists:  ".concat(self.account.toString()))
      // }
      // var userName = refUserGameState!.name
      // log("User Name:  ".concat(userName))
    }

    post {
      //getAccount(self.account).getCapability<&HOTF.UserGameState{HOTF.UserGameStatePublicInterface}>(HOTF.UserGameStatePublicPath).check(): "Public GameState Link invalid"
    }
}
