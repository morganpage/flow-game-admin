pub contract HOTFBattle {
  //This is given a battle setup and resolves the battle
  //Creates a new resource for each battle
  pub let BattleCreatorStoragePath: StoragePath

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

  pub struct Minion {
    pub let name: String
    pub var attack: UInt8
    pub var health: UInt8
    pub var trigger: Trigger?
    pub var ability: Ability?
    pub var item: Item?
    pub var team: UInt8 //0-Friend; 1-Enemy

    init(name:String,attack:UInt8,health:UInt8,trigger:Trigger?,ability:Ability?,item:Item?,team:UInt8) {
        self.name = name
        self.attack = attack
        self.health = health
        self.trigger = trigger
        self.ability = ability
        self.item = item
        self.team = team
    }
    pub fun Attack(minion:&Minion){
        log(self.name.concat(" attacks ").concat(minion.name).concat(" with attack: ").concat(self.attack.toString()))
        if(self.attack > minion.health){
            log(minion.name.concat(" dies"))
            minion.health = 0
        } else {
            log(minion.name.concat(" survives with health: ").concat(minion.health.toString()))
            minion.health = minion.health - self.attack
        }
        //log(minion.toString())
    }
    pub fun toString() : String {
        return self.name.concat(": attack:").concat(self.attack.toString().concat(" health:").concat(self.health.toString()))
    }
  }

  pub struct Team {
    pub var name: String
    pub var minions: [Minion]
    init(name:String){
      self.name = name
      self.minions = []
    }
    pub fun addMinion(minion:Minion){
      self.minions.append(minion)
    }
    pub fun toString(): String{
      var teamString = self.name.concat(" - ")
      for minion in self.minions {
          teamString = teamString.concat(minion.toString()).concat(" ")
      }
      return teamString
    }
  }

  pub resource Battle {
    pub var teams: [Team]
    init(teams:[Team]){
      self.teams = teams
    }
    pub fun toString(): String{
      var battleString = ""
      for team in self.teams {
        battleString = battleString.concat(team.toString())
      }
      return battleString
    }

    pub fun battle() {
        let minionTeam0Ref = &self.teams[0].minions[0] as &Minion
        let minionTeam1Ref = &self.teams[1].minions[0] as &Minion
        //The minion with the highest attack goes first
        if minionTeam0Ref.attack > minionTeam1Ref.attack {
            minionTeam0Ref.Attack(minion: minionTeam1Ref)
        } else {
            minionTeam1Ref.Attack(minion: minionTeam0Ref)
        }
        //self.print()
    }



  }

  pub resource BattleCreator {
    pub fun createBattle(teams:[Team]): @Battle{
      log("createBattle")
      return <- create Battle(teams: teams)
    }
  }
  init(){
    log("init")
    self.BattleCreatorStoragePath = /storage/BattleCreator
    self.account.save<@BattleCreator>(<-create BattleCreator(), to: self.BattleCreatorStoragePath)
    let battleCreatorRef = self.account.borrow<&HOTFBattle.BattleCreator>(from: self.BattleCreatorStoragePath) ?? panic("Not an admin!")
    let testBattle <- battleCreatorRef.createBattle(teams: [Team(name: "Team 1"), Team(name: "Team 2")])
    //log(testBattle.toString())
    destroy testBattle
  }

}