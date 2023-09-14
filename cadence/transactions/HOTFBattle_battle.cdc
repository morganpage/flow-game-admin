import "HOTFBattle"

transaction() {
  //let account: Address

    prepare(acct: AuthAccount)  {//This will usually be done directly by the HOTF contract
      log("HOTFBattle Transaction: ".concat(acct.address.toString()))
      //Get the battle creator reference, you must be an admin to do this
      let battleCreatorRef = acct.borrow<&HOTFBattle.BattleCreator>(from: HOTFBattle.BattleCreatorStoragePath) ?? panic("Not an admin!")
      //Create teams
      var team:UInt8 = 0
      let team1 = HOTFBattle.Team(name: "Friend")
      team1.addMinion(minion: HOTFBattle.Minion(name:"Mouse",attack:1,health:1,trigger:nil,ability:nil,item:nil,team:team))
      let team2 = HOTFBattle.Team(name: "Enemy")
      team2.addMinion(minion: HOTFBattle.Minion(name:"Cat",attack:2,health:2,trigger:nil,ability:nil,item:nil,team:team))
      //BATTLE!
      let testBattle <- battleCreatorRef.createBattle(teams: [team1, team2 ])
      log("Start of Battle: ".concat(testBattle.toString()))
      testBattle.battle()
      log("End of Battle: ".concat(testBattle.toString()))
      destroy testBattle
    }

    post {}
}
