import "HOTF"

// This transaction allows...

transaction(battleIndex: Int,handIndex: Int)  {
    prepare(user: AuthAccount) {
        // Borrow a reference to the UserGameState Resource.
        let userRef = user.borrow<&HOTF.UserGameState>(from: HOTF.UserGameStateStoragePath) ?? panic("Not a user!")
        userRef.place(battleIndex: battleIndex,handIndex: handIndex)
    }
}
