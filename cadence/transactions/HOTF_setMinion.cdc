import "HOTF"

transaction(name: String, description: String,imageURL: String, attack: UInt8, health: UInt8 ) {

  prepare(acct: AuthAccount) {
        let adminRef = acct.borrow<&HOTF.Administrator>(from: /storage/HOTFAdmin) ?? panic("Not an admin!")
  //init(name:String,description:String,attack:UInt8,health:UInt8,trigger:Trigger?,ability:Ability?,extra:String?,item:Item?,team:UInt8) {

        adminRef.setMinion(minion: HOTF.Minion(name:name,description:description,imageURL:imageURL,attack:attack,health:health,trigger:nil,ability:nil,extra:nil,item:nil,team:0))
  }

}
