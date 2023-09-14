pub contract HOTFBattle {
  //This is given a battle setup and resolves the battle
  //Creates a new resource for each battle
  pub let BattleCreatorStoragePath: StoragePath

  pub resource Random {} //Unsaferandom currently not working in emulator so next best thing???!!! Let's use unsaferandom when it works

  pub fun RandomNumber() : UInt64 {
    let random <- create Random()
    var randomNumber = random.uuid //For some reason this always gives an odd number!!! so lets add the block id to it to mitigate this
    destroy random
    var blockId = getCurrentBlock().id
    if(blockId.length > 0){
      randomNumber = randomNumber + UInt64(blockId[0])
    }
    log("RandomNumber: ".concat(randomNumber.toString()))
    return randomNumber
  }

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
        if(self.attack >= minion.health){
            minion.health = 0
            log(minion.name.concat(" dies"))
        } else {
            minion.health = minion.health - self.attack
            log(minion.name.concat(" survives with health: ").concat(minion.health.toString()))
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
    // pub fun removeMinion(index:Int){
    //   self.minions.remove(at: index)
    // }
    pub fun removeZeroHealthMinions(){
      for indexOfMinion, minion in self.minions {
        if minion.health == 0 {
          self.minions.remove(at: indexOfMinion)
          log(minion.name.concat(" removed from team ").concat(self.name))
        }
      }
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
      self.battleStart()
      while self.teams[0].minions.length > 0 && self.teams[1].minions.length > 0 {
          self.battleRound()
      }
      if self.teams[0].minions.length > 0 {
          log(self.teams[0].name.concat(" wins"))
      } else {
          log(self.teams[1].name.concat(" wins"))
      }
    }

    access(self) fun battleRound(){//Battles the front minions of each team
      let minionTeam0Ref = &self.teams[0].minions[0] as &Minion
      let minionTeam1Ref = &self.teams[1].minions[0] as &Minion
      //The minion with the highest attack goes first
      if minionTeam0Ref.attack > minionTeam1Ref.attack {
          minionTeam0Ref.Attack(minion: minionTeam1Ref)
          //The attacked, attacks back even if it is dead!!!???
          minionTeam1Ref.Attack(minion: minionTeam0Ref)
      } else {
          minionTeam1Ref.Attack(minion: minionTeam0Ref)
          //The attacked, attacks back even if it is dead!!!???
          minionTeam0Ref.Attack(minion: minionTeam1Ref)
      }
      self.removeZeroHealthMinions()
    }


    access(self) fun battleStart(){ //Check for start of battle triggers and execute the abilities
      var startBattleTriggerMinions:[&Minion] = []
      for team in self.teams {
          for minion in team.minions {
              if minion.trigger == Trigger.onStartBattle {
                  startBattleTriggerMinions.append(&minion as &Minion)
              }
          }
      }
      //TODO - Now order the minions by attack
      //Now execute the abilities
      for minionRef in startBattleTriggerMinions {
          if minionRef.ability == Ability.damageRandomEnemy {
              log("Damage Random Enemy: ".concat(minionRef.name))
              var enemyTeam = 0
              if(minionRef.team == 0){
                  enemyTeam = 1
              }
              let enemyTeamSize = self.teams[enemyTeam].minions.length
              log("Enemy Team Size: ".concat(enemyTeamSize.toString()))
              let randomIndex = HOTFBattle.RandomNumber() % UInt64(self.teams[enemyTeam].minions.length)
              log("Random Index: ".concat(randomIndex.toString()))
              let randomEnemyRef = &self.teams[enemyTeam].minions[randomIndex] as &Minion
              minionRef.Attack(minion: randomEnemyRef)
          }
      }
    }

    access(self) fun removeZeroHealthMinions(){
      var teamIndex = 0
      while teamIndex < self.teams.length {
        let teamRef = &self.teams[teamIndex] as &Team
        teamRef.removeZeroHealthMinions()
        teamIndex = teamIndex + 1
      }
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