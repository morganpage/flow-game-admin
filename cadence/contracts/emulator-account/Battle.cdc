pub contract Battle {

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
            minion.health = minion.health - self.attack
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

    pub var teams: [Team]

    //pub event Player1Attack(player1: String, player2: String)
    //pub event Player2Attack(player1: String, player2: String)

    init(){
        self.teams = [Team(name:"Friend"),Team(name:"Enemy")]
        var team:UInt8 = 0
        self.teams[team].addMinion(minion:Minion(name:"Mouse",attack:2,health:2,trigger:nil,ability:nil,item:nil,team:team))
        self.teams[team].addMinion(minion:Minion(name:"Mosquito",attack:2,health:3,trigger:Trigger.onStartBattle ,ability:Ability.damageRandomEnemy,item:nil,team:team))
        team = team + 1
        //self.teams[team].addMinion(minion:Minion(name:"Mosquito",attack:2,health:3,trigger:Trigger.onStartBattle,ability:Ability.damageRandomEnemy,item:nil,team:team))
        self.teams[team].addMinion(minion:Minion(name:"Ant",attack:2,health:2,trigger:nil,ability:nil,item:nil,team:team))
    }

    pub fun battleStart(){
        //Check for start of battle triggers and execute the abilities
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
                let randomIndex = unsafeRandom() % UInt64(self.teams[enemyTeam].minions.length)
                let randomEnemyRef = &self.teams[enemyTeam].minions[randomIndex] as &Minion
                minionRef.Attack(minion: randomEnemyRef)
            }
        }
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
        self.print()
    }

    pub fun removeZeroHealthMinions() {
       for team in self.teams {
            for minions in team.minions {

            }
       }
    }

    pub fun print(){
       for team in self.teams {
        log(team.toString())
       }
    }

}