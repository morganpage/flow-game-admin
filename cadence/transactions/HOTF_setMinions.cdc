import "HOTF"

transaction(name: [String], description: [String],imageURL: [String], attack: [UInt8], health: [UInt8] ) {

  prepare(acct: AuthAccount) {
    let adminRef = acct.borrow<&HOTF.Administrator>(from: /storage/HOTFAdmin) ?? panic("Not an admin!")
    var i = 0
    while i < name.length {
      adminRef.setMinion(minion: HOTF.Minion(name:name[i],description:description[i],imageURL:imageURL[i],attack:attack[i],health:health[i],trigger:nil,ability:nil,extra:nil,item:nil,team:0))
      i = i + 1
    }
  }

}
