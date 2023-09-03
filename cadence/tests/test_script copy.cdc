import Test
import "HOTF"

// pub let gameDB = GameDB()

// pub let blockchain = Test.newEmulatorBlockchain()
// pub let admin = blockchain.createAccount()
// pub let user = blockchain.createAccount()

// pub fun setup() {
//     log("Setup")
//     blockchain.useConfiguration(Test.Configuration({
//         "GameDB": admin.address
//     }))
//     let code = Test.readFile("../contracts/GameDB.cdc")
//     let err = blockchain.deployContract(
//         name: "GameDB",
//         code: code,
//         account: admin,
//         arguments: []
//     )
//     Test.expect(err, Test.beNil())
// }

// pub fun testGetMinions() {
//     let minions = gameDB.getMinions()
//     //log(minions)
//     Test.assert(minions.length > 0, message:"No minions found")
// }

// pub fun testGetMinions2() {
//     let code = Test.readFile("../scripts/gamedb_get_minions_test.cdc")
//     let scriptResult = blockchain.executeScript(code, [])
//     let totalMinions = (scriptResult.returnValue as! Int?)!
//     //log(totalMinions)
//     Test.expect(scriptResult, Test.beSucceeded())
//     Test.assert(totalMinions > 0, message:"No minions found")
// }

// pub fun testAddMinion() {
//     var code = Test.readFile("../scripts/gamedb_get_minions_test.cdc")
//     var scriptResult = blockchain.executeScript(code, [])
//     var totalMinions = (scriptResult.returnValue as! Int?)!
//     log(totalMinions)

//     code = Test.readFile("../transactions/AddMinion.cdc")
//     let tx = Test.Transaction(
//         code: code,
//         authorizers: [user.address],
//         signers: [user],
//         arguments: ["NewMinion"]
//     )
//     let txResult = blockchain.executeTransaction(tx)
//     //log(txResult)
//     Test.expect(txResult, Test.beSucceeded())

//     code = Test.readFile("../scripts/gamedb_get_minions_test.cdc")
//     scriptResult = blockchain.executeScript(code, [])
//     totalMinions = (scriptResult.returnValue as! Int?)!
//     log(totalMinions)


// }

