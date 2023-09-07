import "HOTF"

// This transaction allows...

transaction(handIndex: Int, hold: Bool)  {
    prepare(user: AuthAccount) {
        // Borrow a reference to the UserGameState Resource.
        let userRef = user.borrow<&HOTF.UserGameState>(from: HOTF.UserGameStateStoragePath) ?? panic("Not a user!")
        userRef.hold(handIndex: handIndex,hold: hold)
    }
}
