import "HOTF"

transaction() {
  let account: Address
  let userGameStateCap: Capability<&{HOTF.UserGameStatePrivateInterface}>

    prepare(acct: AuthAccount)  {
      self.account = acct.address
      log("Battle with User Account:  ".concat(self.account.toString()))
      self.userGameStateCap = acct.getCapability<&{HOTF.UserGameStatePrivateInterface}>(HOTF.UserGameStatePrivatePath)
      //var refUserGameState = acct.borrow<&HOTF.UserGameState>(from: HOTF.UserGameStateStoragePath) ?? panic("Cannot borrow user State")
      //HOTF.Battle()

      // if refUserGameState == nil
      // {
      //   log("Creating User Account:  ".concat(self.account.toString()))
      //   acct.save(<-HOTF.CreateUserGameState(name: name), to: HOTF.UserGameStateStoragePath)
      //   refUserGameState = acct.borrow<&HOTF.UserGameState>(from: HOTF.UserGameStateStoragePath)
      //   acct.link<&HOTF.UserGameState{HOTF.UserGameStatePrivateInterface}>(HOTF.UserGameStatePrivatePath, target:HOTF.UserGameStateStoragePath)
      //   acct.link<&HOTF.UserGameState{HOTF.UserGameStatePublicInterface}>(HOTF.UserGameStatePublicPath, target:HOTF.UserGameStateStoragePath)
      //   //Create game for new
      //   //refUserGameState!.createGame()

      // }else {
      //   log("User Account already exists:  ".concat(self.account.toString()))
      // }
      // var userName = refUserGameState!.name
      // log("User Name:  ".concat(userName))
    }
    execute {
      HOTF.Battle( userStateCapability: self.userGameStateCap)
    }


    post {
      // getAccount(self.account).getCapability<&HOTF.UserGameState{HOTF.UserGameStatePublicInterface}>(HOTF.UserGameStatePublicPath).check(): "Public GameState Link invalid"
    }
}
