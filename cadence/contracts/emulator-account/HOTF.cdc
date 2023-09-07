pub contract HOTF {
    //Admin paths
    pub let AdminStoragePath: StoragePath
    pub let AdminPrivatePath: PrivatePath
    //UserGameState paths
    pub let UserGameStateStoragePath: StoragePath
    pub let UserGameStatePublicPath: PublicPath
    pub let UserGameStatePrivatePath: PrivatePath

    pub var minions: {String : Minion} //Global minion templates
    pub var games: {Address : GameState} //user address to gamestate mapping - All the games that are currently running and have ever run

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
    }

    pub fun getMinions(): [Minion] {
     return self.minions.values
    }
    pub fun login(userAddress: Address): GameState {
        log(self.account.address)
        log(userAddress)
        let userGameState = self.games[userAddress]
        if userGameState == nil {
            let newGameState = GameState(userAddress: userAddress)
            self.games[userAddress] = newGameState
            return newGameState
        }
        return userGameState!
    }

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

    pub struct GameState { //The full gamestate of each game ever played and being played
      pub var players: [Address] // 0 - player 1, 1 - player 2
      pub var mana: UInt8

      init(userAddress: Address) {
        self.players = [userAddress]//Put player into the game at index 0
        self.mana = 10
      }
    }

    // private interface, only accessible to owner and game contract
    pub resource interface UserGameStatePrivateInterface
    {
      pub var mana: UInt8
      pub var hand: [Minion] //Minions in the user's hand
      pub fun getName() : String
    }

    pub resource interface UserGameStatePublicInterface
    {
      pub var mana: UInt8
      pub var hand: [Minion] //Minions in the user's hand
      pub fun getName() : String
    }

    pub resource UserGameState : UserGameStatePublicInterface,UserGameStatePrivateInterface { //This contains the local state of the game for each user
      pub var name: String
      pub var minions: [Minion] //Minions available to the user
      pub var hand: [Minion] //Minions in the user's hand
      pub var mana: UInt8
      pub let maxHandSize: UInt8

      init(name: String) {
        self.name = name
        self.minions = HOTF.getMinions() //For the moment the user gets all the minions, needs to be changed to only get the ones they have
        self.hand = [] //Hand is empty at the start of the game
        self.mana = 11 //First draw will reduce this to 10
        self.maxHandSize = 3
      }

      pub fun hold(handIndex: Int,hold: Bool){
        if handIndex >= self.hand.length {
            return
        }
        self.hand[handIndex].hold = hold
      }

      pub fun draw() { //Draw random cards from the deck
        log("draw")
        self.mana = self.mana - 1
        log("self.mana:".concat(self.mana.toString()))
        var i: Int = 0
        //Clear any non-held cards from the hand
        i = (self.hand.length) - 1
        while i >= 0 {
          log(i.toString())
            if !self.hand[i].hold {
                self.hand.remove(at: i)
            }
            i = i - 1
        }
        i=0
        while UInt8(self.hand.length) < self.maxHandSize && self.minions.length > 0 {
            //let randomIndex =  Int(unsafeRandom()) % (availableMinions.length)
            let randomIndex = i % (self.minions.length) //Change when unsafeRandom is fixed in emulator
            log("randomIndex:".concat(randomIndex.toString()))
            log("availableMinions.length:".concat(self.minions.length.toString()))
            let randomMinion = self.minions[randomIndex]
            self.hand.append(randomMinion)
            self.minions.remove(at: randomIndex)
            i = i + 1
        }
        log("self.hand.length:".concat(self.hand.length.toString()))
        // while i < self.maxHandSize && self.minions.length > 0 {
        //     //let randomIndex =  Int(unsafeRandom()) % (availableMinions.length)
        //     let randomIndex = i % UInt8(self.minions.length) //Change when unsafeRandom is fixed in emulator
        //     log("randomIndex:".concat(randomIndex.toString()))
        //     log("availableMinions.length:".concat(self.minions.length.toString()))
        //     let randomMinion = self.minions[randomIndex]
        //     self.hand.append(randomMinion)
        //     self.minions.remove(at: randomIndex)
        //     i = i + 1
        // }
      }

      pub fun getName() : String
      {
          return self.name
      }
    }

    init(){
        self.minions = {}
        self.games = {}
        self.AdminStoragePath = /storage/HOTFAdmin
        self.AdminPrivatePath = /private/AdminPrivatePath
        self.UserGameStateStoragePath = /storage/HOTFUserGameState
        self.UserGameStatePublicPath = /public/HOTFUserGameState
        self.UserGameStatePrivatePath = /private/HOTFUserGameState
        //Create the one-off admin resource here
        self.account.save<@Administrator>(<-create Administrator(), to: self.AdminStoragePath)
        let adminRef = self.account.borrow<&HOTF.Administrator>(from: self.AdminStoragePath) ?? panic("Not an admin!")
        adminRef.addMinion(name: "Minion 1")
        adminRef.addMinion(name: "Minion 2")
        adminRef.addMinion(name: "Minion 3")
        // self.account.link<&GameDB>(self.AdminPrivatePath, target: self.AdminStoragePath) 
        //                                         ?? panic("Could not get a capability to the GameDB")
    }

    pub fun CreateUserGameState(name: String) : @UserGameState
    {
        return <- create UserGameState(name: name)
    }

}