import "HOTF"

pub contract HOTFBattle {
  //This is given a battle setup and resolves the battle
  //Creates a new resource for each battle
  pub let BattleCreatorStoragePath: StoragePath

  pub struct Team {
      pub var name: String
      pub var minions: [HOTF.Minion]
      init(name:String){
          self.name = name
          self.minions = []
      }
      pub fun addMinion(minion:HOTF.Minion){
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
    log(testBattle.toString())
    destroy testBattle
  }

}