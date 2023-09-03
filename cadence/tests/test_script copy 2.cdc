import Test

pub let blockchain = Test.newEmulatorBlockchain()
pub let admin = blockchain.createAccount()
pub let user = blockchain.createAccount()

pub fun setup() {
    blockchain.useConfiguration(Test.Configuration({
        "../contracts/HOTF.cdc": admin.address
    }))

    let code = Test.readFile("../contracts/HOTF.cdc")
    let err = blockchain.deployContract(
        name: "HOTF",
        code: code,
        account: admin,
        arguments: []
    )
    log("Admin address:".concat(admin.address.toString()))
    log("User address:".concat(user.address.toString()))
    Test.expect(err, Test.beNil())
}

pub fun testAddMinion() {
    let code = Test.readFile("../transactions/HOTF_addMinion.cdc")
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

pub fun testAddMinionByUser() {
    let code = Test.readFile("../transactions/HOTF_addMinion.cdc")
    let tx = Test.Transaction(
        code: code,
        authorizers: [user.address],
        signers: [user],
        arguments: []
    )
    let result = blockchain.executeTransaction(tx)
    log(result)
    Test.expect(result, Test.beFailed())
}


pub fun testViewMinions() {
    let value: Bool = executeScript("../scripts/HOTF_view_minions_test.cdc")
    Test.assertEqual(true, value)
}
pub fun testGetMinions() {
    let value: Bool = executeScript("../scripts/HOTF_get_minions_test.cdc")
    Test.assertEqual(true, value)
}
//GAME
pub fun testLogin() {
    let code = Test.readFile("../transactions/HOTF_login.cdc")
    let tx = Test.Transaction(
        code: code,
        authorizers: [user.address],
        signers: [user],
        arguments: []
    )

    let result = blockchain.executeTransaction(tx)
    log(result)
}

pub fun testLogin2() {
    let code = Test.readFile("../transactions/HOTF_login2.cdc")
    let tx = Test.Transaction(
        code: code,
        authorizers: [user.address],
        signers: [user],
        arguments: []
    )

    let result = blockchain.executeTransaction(tx)
    log(result)
}

pub fun testDraw(){
    let code = Test.readFile("../transactions/HOTF_draw.cdc")
    let tx = Test.Transaction(
        code: code,
        authorizers: [user.address],
        signers: [user],
        arguments: []
    )

    let result = blockchain.executeTransaction(tx)
    log(result)
}


priv fun executeScript(_ scriptPath: String): Bool {
    var script = Test.readFile(scriptPath)
    let value = blockchain.executeScript(script, [])
    Test.expect(value, Test.beSucceeded())
    return value.returnValue! as! Bool
}
