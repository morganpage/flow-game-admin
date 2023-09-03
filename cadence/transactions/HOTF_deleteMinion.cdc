import "HOTF"

transaction(name: String) {

  prepare(acct: AuthAccount) {
        let adminRef = acct.borrow<&HOTF.Administrator>(from: /storage/HOTFAdmin) ?? panic("Not an admin!")
        adminRef.deleteMinion(name: name)
  }

}
