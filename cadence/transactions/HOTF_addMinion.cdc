import "HOTF"

transaction(name: String) {

  prepare(acct: AuthAccount) {
        let adminRef = acct.borrow<&HOTF.Administrator>(from: /storage/HOTFAdmin) ?? panic("Not an admin!")
        adminRef.addMinion(name: name)
        log("Minions: ".concat(HOTF.minions.length.toString()))
  }

  execute {}
}
