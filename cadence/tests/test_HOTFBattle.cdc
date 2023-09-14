import Test

pub let pathHOTF = "../contracts/emulator-account/HOTF.cdc"
pub let pathHOTFBattle = "../contracts/emulator-account/HOTFBattle.cdc"

pub let battle = "../transactions/HOTFBattle_battle.cdc"

pub let blockchain = Test.newEmulatorBlockchain()
pub let admin = blockchain.createAccount()
pub let user = blockchain.createAccount()

pub fun setup() {
  log("HOTFBattle")
    blockchain.useConfiguration(Test.Configuration({
        "HOTFBattle": admin.address
    }))
    let err1 = blockchain.deployContract(
        name: "HOTF",
        code: Test.readFile(pathHOTF),
        account: admin,
        arguments: []
    )
    let err2 = blockchain.deployContract(
        name: "HOTFBattle",
        code: Test.readFile(pathHOTFBattle),
        account: admin,
        arguments: []
    )
    log("Admin address:".concat(admin.address.toString()))
    log("User address:".concat(user.address.toString()))
    Test.expect(err1, Test.beNil())
    Test.expect(err2, Test.beNil())
}

pub fun testBattle1(){
    log("testBattle1")
    let code = Test.readFile(battle)
    let tx = Test.Transaction(
        code: code,
        authorizers: [admin.address],
        signers: [admin],
        arguments: []
    )
    let result = blockchain.executeTransaction(tx)
    log(result)
    Test.expect(result.error, Test.beNil())
}

pub fun testBattle2(){
    log("testBattle2")
    let code = Test.readFile(battle)
    let tx = Test.Transaction(
        code: code,
        authorizers: [user.address],
        signers: [user],
        arguments: []
    )
    let result = blockchain.executeTransaction(tx)
    log(result)
    Test.expect(result, Test.beFailed())//Should fail, user is not admin
}



// pub fun testGetTeams() {
//     var script = Test.readFile(getMinions)
//     let scriptResult: Test.ScriptResult = blockchain.executeScript(script, [])
//     Test.expect(scriptResult, Test.beSucceeded())
//     let returnValue: Int = scriptResult.returnValue! as! Int
//     Test.assertEqual(3, returnValue)
// }
