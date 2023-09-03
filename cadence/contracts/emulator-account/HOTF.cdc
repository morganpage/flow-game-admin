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
    pub fun login2(): @UserGameState{
      return <- create UserGameState(name: "test")
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
      pub fun getName() : String
    }

    pub resource interface UserGameStatePublicInterface
    {
      pub var mana: UInt8
      pub fun getName() : String
    }

    pub resource UserGameState : UserGameStatePublicInterface,UserGameStatePrivateInterface { //This contains the local state of the game for each user
      pub var name: String
      pub var minions: [Minion] //Minions available to the user
      pub var mana: UInt8

      init(name: String) {
        self.name = name
        self.minions = HOTF.getMinions() //For the moment the user gets all the minions, needs to be changed to only get the ones they have
        self.mana = 11 //First draw will reduce this to 10
      }

      pub fun draw() : [Minion] { //Draw random cards from the deck
        self.mana = self.mana - 1
        log("self.mana:".concat(self.mana.toString()))
        var drawnMinions: [Minion] = []
        var availableMinions: [Minion] = self.minions
        var i = 0
        while i < 3 && availableMinions.length > 0 {
            //let randomIndex =  Int(unsafeRandom()) % (availableMinions.length)
            let randomIndex = i % (availableMinions.length) //Change when unsafeRandom is fixed
            log("randomIndex:".concat(randomIndex.toString()))
            log("availableMinions.length:".concat(availableMinions.length.toString()))
            let randomMinion = availableMinions[randomIndex]
            drawnMinions.append(randomMinion)
            availableMinions.remove(at: randomIndex)
            i = i + 1
        }
        return drawnMinions
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