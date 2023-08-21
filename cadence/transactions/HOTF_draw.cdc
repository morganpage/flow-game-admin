import "HOTF"

// This transaction allows...

transaction {
    prepare(user: AuthAccount) {
        // Borrow a reference to the UserGameState Resource.
        let userRef = user.borrow<&HOTF.UserGameState>(from: HOTF.UserGameStateStoragePath) ?? panic("Not a user!")
        let minions = userRef.draw()
        log("Minions Drawn:  ".concat(minions.length.toString()))
        // let adminRef = admin.borrow<&HOTF.Administrator>(from: /storage/HOTFAdmin) ?? panic("Not an admin!")
        // let minion =
        //       HOTF.Minion(name:"Bob",description:"Bob is cool",attack:1,health:1,trigger:nil,ability:nil,extra:nil,item:nil,team:0)
        // adminRef.setMinion(minion: minion)
        // log("Minions Added:  ".concat(HOTF.minions.length.toString()))
    }

    post {
          //HOTF.minions.length == 1
    }
}
