pub contract HOTF {
    //Admin paths
    pub let AdminStoragePath: StoragePath
    pub let AdminPrivatePath: PrivatePath
    //Game paths
    pub let GamesStoragePath: StoragePath
    //UserGameState paths
    pub let UserGameStateStoragePath: StoragePath
    pub let UserGameStatePublicPath: PublicPath
    pub let UserGameStatePrivatePath: PrivatePath

    pub var minions: {String : Minion} //Global minion templates
    //pub var games: @{UInt64: Game}
    pub var games: {UInt64 : Game} //All the games that are currently running and have ever run
    //pub var games: @{Int: Game}

    pub enum Trigger: UInt8 {
        pub case onStartBattle
        pub case onBuy
    }

    pub enum Ability: UInt8 {
        pub case damageRandomEnemy
    }

    pub enum Item: UInt8 {
        pub case anItemHere
    }

    pub struct Minion{
        pub var name: String
        pub var description: String
        pub var imageURL: String
        pub var attack: UInt8
        pub var health: UInt8
        pub var trigger: Trigger?
        pub var ability: Ability?
        pub var extra: String? //Json string for extra data
        pub var item: Item?
        pub var team: UInt8 //0-Friend; 1-Enemy
        pub(set) var hold: Bool

        init(name:String,description:String,imageURL:String,attack:UInt8,health:UInt8,trigger:Trigger?,ability:Ability?,extra:String?,item:Item?,team:UInt8) {
            self.name = name
            self.description = description
            self.imageURL = imageURL
            self.attack = attack
            self.health = health
            self.trigger = trigger
            self.ability = ability
            self.extra = extra
            self.item = item
            self.team = team
            self.hold = false
        }
        pub fun toString() : String {
            return self.name.concat(": attack:").concat(self.attack.toString().concat(" health:").concat(self.health.toString()))
        }

    }

    pub fun getMinions(): [Minion] {
     return self.minions.values
    }

    pub struct Game{
      pub var players: [Capability<&AnyResource{HOTF.UserGameStatePrivateInterface}>]
      pub var uuid: UInt64
      init(userStateCapability: Capability<&AnyResource{HOTF.UserGameStatePrivateInterface}>) {
        let userGameState = userStateCapability.borrow() ?? panic("Cannot borrow user State")
        self.players = [userStateCapability]
        self.uuid = UInt64(HOTF.games.length) + 1
        userGameState.setGameId(gameId: self.uuid)
      }
      // init(userStateCapability: Capability<&AnyResource{HOTF.UserGameStatePrivateInterface}>) {
      //   self.players = [userStateCapability]//Put player into the game at index 0
      //   //Set this player's game to this game
      //   let userGameState = userStateCapability.borrow()
      //   //userGameState.gameId = self.uuid
      //   userGameState?.setGameId(gameId: self.uuid)
      //   self.uuid = UInt64(unsafeRandom())
      // }
      pub fun getPlayers()
      {
        log("getPlayers")
        log(self.players.length.toString())
        for player in self.players {
          log("player: ".concat(player.borrow()?.getName() ?? "No name"))
        }
      }
    }

    // pub resource Games {
    //   pub var games: @{UInt64: Game}
    //   init(){
    //     self.games <- {}
    //   }
    //   pub fun CreateGame(userStateCapability: Capability<&AnyResource{HOTF.UserGameStatePrivateInterface}>) {
    //     let game <- create Game(userStateCapability: userStateCapability)
    //     let gameId = game.uuid
    //     self.games[gameId] <-! game
    //     log("Game created: ".concat(gameId.toString()))
    //   }

    //   pub fun getIDs(): [UInt64] {
    //     // The keys in the games dictionary are the IDs
    //     return self.games.keys
    //   }

    //   // pub fun CreateGame(userStateCapability: Capability<&AnyResource{HOTF.UserGameStatePrivateInterface}>){
    //   //   let userGameState = userStateCapability.borrow()
    //   //   var userAddress: Address = userGameState?.owner?.address ?? panic("User state has no owner")
    //   //   self.games[userAddress] = Game()
    //   // }
    //   destroy (){
    //     destroy self.games
    //   }
    // }

    // pub resource Game {
    //   //pub var players: [Address] // 0 - player 1, 1 - player 2
    //   pub var players: [Capability<&AnyResource{HOTF.UserGameStatePrivateInterface}>]
    //   // init(){
    //   //   self.players = []
    //   // }
    //   init(userStateCapability: Capability<&AnyResource{HOTF.UserGameStatePrivateInterface}>) {
    //     self.players = [userStateCapability]//Put player into the game at index 0
    //     //Set this player's game to this game
    //     let userGameState = userStateCapability.borrow()
    //     //userGameState.gameId = self.uuid
    //     userGameState?.setGameId(gameId: self.uuid)
    //   }
    //   pub fun getPlayers()
    //   {
    //     log("getPlayers")
    //     log(self.players.length.toString())
    //     for player in self.players {
    //       log("player: ".concat(player.borrow()?.getName() ?? "No name"))
    //     }
    //   }

    // }

    //   // init(userAddress: Address) {
    //   //   self.players = [userAddress]//Put player into the game at index 0
    //   // }

    //   // pub fun CreateGame(userStateCapability: Capability<&AnyResource{HOTF.UserGameStatePrivateInterface}>){
    //   //   let userGameState = userStateCapability.borrow()
    //   //   var userAddress: Address = userGameState?.owner?.address ?? panic("User state has no owner")
    //   //   self.players.append(userAddress)
    //   //   //self.players.append(userGameState.getName())
    //   // }

    // }

    // pub fun login(userAddress: Address): GameState {
    //     log(self.account.address)
    //     log(userAddress)
    //     let userGameState = self.games[userAddress]
    //     if userGameState == nil {
    //         let newGameState = GameState(userAddress: userAddress)
    //         self.games[userAddress] = newGameState
    //         return newGameState
    //     }
    //     return userGameState!
    // }

    pub resource Administrator {

        pub fun addMinion(name:String) {
            let minion = Minion(name: name, description: "A minion",imageURL:"", attack: 1, health: 1, trigger: nil, ability: nil, extra: nil, item: nil, team: 0)
            HOTF.minions[minion.name] = minion
        }

        pub fun setMinion(minion:Minion) {
            HOTF.minions[minion.name] = minion
        }
        pub fun deleteMinion(name: String){
            HOTF.minions.remove(key: name)
        }
    }

    // pub struct GameState { //The full gamestate of each game ever played and being played
    //   pub var players: [Address] // 0 - player 1, 1 - player 2

    //   init(userAddress: Address) {
    //     self.players = [userAddress]//Put player into the game at index 0
    //   }
    // }

    // private interface, only accessible to owner and game contract
    pub resource interface UserGameStatePrivateInterface
    {
      pub var gameId: UInt64
      pub var mana: UInt8
      pub var hand: [Minion] //Minions in the user's hand
      pub fun getName() : String
      pub var battlefield: {Int: Minion}
      pub fun setGameId(gameId: UInt64)
    }

    pub resource interface UserGameStatePublicInterface
    {
      pub var gameId: UInt64
      pub var mana: UInt8
      pub var hand: [Minion] //Minions in the user's hand
      pub fun getName() : String
      pub var battlefield: {Int: Minion}
    }

    pub resource UserGameState : UserGameStatePublicInterface,UserGameStatePrivateInterface { //This contains the local state of the game for each user
      pub var name: String
      pub var gameId: UInt64
      pub var minions: [Minion] //Minions available to the user
      pub var hand: [Minion] //Minions in the user's hand,position in hand doesn't matter
      pub var battlefield: {Int: Minion} //Minions on the user's battlefield, position does matter
      pub var mana: UInt8
      pub let maxHandSize: UInt8
      pub let maxBattlefieldSize: UInt8

      init(name: String) {
        self.name = name
        self.gameId = 0
        self.minions = HOTF.getMinions() //For the moment the user gets all the minions, needs to be changed to only get the ones they have
        self.hand = [] //Hand is empty at the start of the game
        self.battlefield = {} //Battlefield is empty at the start of the game
        self.mana = 11 //First draw will reduce this to 10
        self.maxHandSize = 3
        self.maxBattlefieldSize = 5
      }

      pub fun setGameId(gameId: UInt64) {
        self.gameId = gameId
      }

      pub fun place(battleIndex: Int,handIndex: Int) {//Place a minion from the hand onto the battlefield
        pre {
            handIndex < self.hand.length: "Hand index out of bounds"
            UInt8(battleIndex) < self.maxBattlefieldSize: "Battlefield index out of bounds"
            self.battlefield[battleIndex] == nil: "Battlefield index already occupied"
            self.mana >= 3: "Not enough mana"
        }
        self.battlefield[battleIndex] = self.hand[handIndex]
        self.hand.remove(at: handIndex)
        self.mana = self.mana - 3
      }

      pub fun move(battleIndexFrom: Int,battleIndexTo: Int) {//Move a minion on the battlefield
        pre {
            UInt8(battleIndexFrom) < self.maxBattlefieldSize: "Battlefield index out of bounds"
            UInt8(battleIndexTo) < self.maxBattlefieldSize: "Battlefield index out of bounds"
            self.battlefield[battleIndexFrom] != nil: "Battlefield from index is empty"
            self.battlefield[battleIndexTo] == nil: "Battlefield to index is occupied"
        }
        self.battlefield[battleIndexTo] = self.battlefield[battleIndexFrom]
        self.battlefield[battleIndexFrom] = nil
      }

      pub fun hold(handIndex: Int,hold: Bool){
         pre {
            handIndex < self.hand.length: "Hand index out of bounds"
         }
        self.hand[handIndex].hold = hold
      }

      pub fun draw() { //Draw random cards from the deck
       pre {
            self.mana > 0: "Not enough mana"
        }
        self.mana = self.mana - 1
        var i: Int = 0
        i = (self.hand.length) - 1
        while i >= 0 {  //Clear any non-held cards from the hand
          log(i.toString())
            if !self.hand[i].hold {
                self.hand.remove(at: i)
            }
            i = i - 1
        }
        i=0
        while UInt8(self.hand.length) < self.maxHandSize && self.minions.length > 0 {
            //let randomIndex =  Int(unsafeRandom()) % (self.minions.length)
            let randomIndex = i % (self.minions.length) //Change when unsafeRandom is fixed in emulator
            log("randomIndex:".concat(randomIndex.toString()))
            log("availableMinions.length:".concat(self.minions.length.toString()))
            let randomMinion = self.minions[randomIndex]
            self.hand.append(randomMinion)
            self.minions.remove(at: randomIndex)
            i = i + 1
        }
        log("self.hand.length:".concat(self.hand.length.toString()))
      }



      pub fun getName() : String
      {
          return self.name
      }
    }

    init(){
        self.minions = {}
        //self.games <- {}
        self.games = {}
        self.AdminStoragePath = /storage/HOTFAdmin
        self.AdminPrivatePath = /private/AdminPrivatePath
        self.GamesStoragePath = /storage/HOTFGame
        self.UserGameStateStoragePath = /storage/HOTFUserGameState
        self.UserGameStatePublicPath = /public/HOTFUserGameState
        self.UserGameStatePrivatePath = /private/HOTFUserGameState
        //Create the one-off admin resource here, this looks after the minion templates
        self.account.save<@Administrator>(<-create Administrator(), to: self.AdminStoragePath)
        let adminRef = self.account.borrow<&HOTF.Administrator>(from: self.AdminStoragePath) ?? panic("Not an admin!")
        adminRef.addMinion(name: "Minion 1")
        adminRef.addMinion(name: "Minion 2")
        adminRef.addMinion(name: "Minion 3")
        //Create the one-off games resource here, this looks after the games
        //self.account.save<@Games>(<-create Games(), to: self.GamesStoragePath)
        //self.account.link<&{HOTF.GamesInterface}>(/public/Games, target: self.GamesStoragePath)

        // self.account.link<&GameDB>(self.AdminPrivatePath, target: self.AdminStoragePath) 
        //                                         ?? panic("Could not get a capability to the GameDB")
    }

    pub fun CreateUserGameState(name: String) : @UserGameState
    {
        return <- create UserGameState(name: name)
    }
    pub fun Battle(userStateCapability: Capability<&AnyResource{HOTF.UserGameStatePrivateInterface}>){
      log("Battle")
      let userState = userStateCapability.borrow() ?? panic("Cannot borrow user State")
      var gameId = userState.gameId //Will be 0 if no game
      log("gameId:".concat(gameId.toString()))
      if(gameId == 0) {
        log("Creating game")
        let game = Game(userStateCapability: userStateCapability)
        gameId = game.uuid
        self.games[game.uuid] = game
      }
      else {
        log("Game already exists: ".concat(gameId.toString()))
      }
      let game = self.games[gameId] ?? panic("Game not found")
      log(game.uuid.toString())
      game.getPlayers()
      //Battle code here
      //Add enemy minions to the battlefield
      //game.players[1]


      log("Battle end:")
    }

    // pub fun Battle(userStateCapability: Capability<&AnyResource{HOTF.UserGameStatePrivateInterface}>){
    //   log("Battle")
    //   let userState = userStateCapability.borrow() ?? panic("Cannot borrow user State")
    //   var gameId = userState.gameId //Will be 0 if no game
    //   log("gameId:".concat(gameId.toString()))
    //   if(gameId == 0) {
    //     log("Creating game")
    //     let game <- create Game(userStateCapability: userStateCapability)
    //     gameId = game.uuid
    //     self.games[game.uuid] <-! game
    //   }
    //   else {
    //     log("Game already exists: ".concat(gameId.toString()))
    //   }
    //   //let game <-! self.games[gameId] <- nil
    //   let game  <-! self.games[gameId] <- nil

    //   game?.getPlayers()
    //   self.games[gameId] <-! game
    //   self.games[gameId]?.getPlayers()
    //   log("Battle end:")
    // }

//     pub fun Battle(userStateCapability: Capability<&AnyResource{HOTF.UserGameStatePrivateInterface}>) {
//       //When a user clicks the battle button, this is called
//       //Either create a game if first battle or resume a game if not
//       //First try and get existing game from uuid
//       //let game = self.account.getCapability<&AnyResource>(self.GamesStoragePath).borrow()
//       //let games = self.account.getCapability<&Games>(self.GamesStoragePath).borrow()
//       let userState = userStateCapability.borrow() ?? panic("Cannot borrow user State")
//       let gameId = userState.gameId
//       log("gameId:".concat(gameId.toString()))
// // if let inboxCollection = self.account.getCapability(self.CollectionPublicPath).borrow<&{FlovatarInbox.CollectionPublic}>()  {
// //             return inboxCollection.getFlovatarDustBalance(id: id)
// //         }
//     }
}