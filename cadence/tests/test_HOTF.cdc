import Test

pub let pathHOTF = "../contracts/emulator-account/HOTF.cdc"
//Scripts
pub let getMinions = "../scripts/HOTF_getMinions_test.cdc"
pub let getMana = "../scripts/HOTF_getMana.cdc"
pub let getName = "../scripts/HOTF_getName.cdc"
pub let getHand = "../scripts/HOTF_getHand_test.cdc"
pub let getBattlefield = "../scripts/HOTF_getBattlefield_test.cdc"
//Transactions
pub let addMinion = "../transactions/HOTF_addMinion.cdc"
pub let draw = "../transactions/HOTF_draw.cdc"
pub let hold = "../transactions/HOTF_hold.cdc"
pub let login = "../transactions/HOTF_login.cdc"
pub let place = "../transactions/HOTF_place.cdc"
pub let battle = "../transactions/HOTF_battle.cdc"

pub let blockchain = Test.newEmulatorBlockchain()
pub let admin = blockchain.createAccount()
pub let user = blockchain.createAccount()

pub let heldMinion = nil

pub fun setup() {
    blockchain.useConfiguration(Test.Configuration({
        "HOTF": admin.address
    }))

    let code = Test.readFile(pathHOTF)
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

pub fun testGetMinions() {
    var script = Test.readFile(getMinions)
    let scriptResult: Test.ScriptResult = blockchain.executeScript(script, [])
    Test.expect(scriptResult, Test.beSucceeded())
    let returnValue: Int = scriptResult.returnValue! as! Int
    Test.assertEqual(3, returnValue)
}

pub fun testAdd30Minions() {
    let code = Test.readFile(addMinion)
    var x = 0
    while x < 30 {
        let tx = Test.Transaction(
            code: code,
            authorizers: [admin.address],
            signers: [admin],
            arguments: ["NewMinion ".concat(x.toString())]
        )
        let result = blockchain.executeTransaction(tx)
        //log(result)
        Test.expect(result.error, Test.beNil())
        x = x + 1
        Test.expect(result.error, Test.beNil())
    }
}

//Must do this first
pub fun testLogin() {
    let code = Test.readFile(login)
    let tx = Test.Transaction(
        code: code,
        authorizers: [user.address],
        signers: [user],
        arguments: ["Bob"]
    )
    let result = blockchain.executeTransaction(tx)
    //log(result)
}

pub fun testAddMinionByAdmin() {
    let code = Test.readFile(addMinion)
    let tx = Test.Transaction(
        code: code,
        authorizers: [admin.address],
        signers: [admin],
        arguments: ["NewMinion"]
    )
    let result = blockchain.executeTransaction(tx)
    //log(result)
    Test.expect(result.error, Test.beNil())
}


pub fun testAddMinionByUser() { //Should fail, not an admin
    let code = Test.readFile(addMinion)
    let tx = Test.Transaction(
        code: code,
        authorizers: [user.address],
        signers: [user],
        arguments: ["NewMinion"]
    )
    let result = blockchain.executeTransaction(tx)
    Test.expect(result, Test.beFailed())
}

pub fun testGetName() {
    var script = Test.readFile(getName)
    let scriptResult: Test.ScriptResult = blockchain.executeScript(script, [user.address])
    Test.expect(scriptResult, Test.beSucceeded())
    let returnValue: String = scriptResult.returnValue! as! String
    Test.assertEqual("Bob", returnValue)
}

pub fun testGetMana() {
    var script = Test.readFile(getMana)
    let scriptResult: Test.ScriptResult = blockchain.executeScript(script, [user.address])
    Test.expect(scriptResult, Test.beSucceeded())
    let returnValue: UInt8 = scriptResult.returnValue! as! UInt8
    Test.assertEqual(11 as UInt8, returnValue)
}


pub fun testDraw(){
    let code = Test.readFile(draw)
    let tx = Test.Transaction(
        code: code,
        authorizers: [user.address],
        signers: [user],
        arguments: []
    )
    let result = blockchain.executeTransaction(tx)
}

pub fun testGetHand() {
    var script = Test.readFile(getHand)
    let scriptResult: Test.ScriptResult = blockchain.executeScript(script, [user.address])
    Test.expect(scriptResult, Test.beSucceeded())
    let returnValue: Int = scriptResult.returnValue! as! Int
    log(returnValue)
    Test.assertEqual(3, returnValue)
}

pub fun testDraw2(){
    let code = Test.readFile(draw)
    let tx = Test.Transaction(
        code: code,
        authorizers: [user.address],
        signers: [user],
        arguments: []
    )
    let result = blockchain.executeTransaction(tx)
}

pub fun testGetHand2() {
    var script = Test.readFile(getHand)
    let scriptResult: Test.ScriptResult = blockchain.executeScript(script, [user.address])
    Test.expect(scriptResult, Test.beSucceeded())
    let returnValue: Int = scriptResult.returnValue! as! Int
    log(returnValue)
    Test.assertEqual(3, returnValue)
}


pub fun testHold() {
    let code = Test.readFile(hold)
    let tx = Test.Transaction(
        code: code,
        authorizers: [user.address],
        signers: [user],
        arguments: [0,true]
    )
    let result = blockchain.executeTransaction(tx)
    log(result)
    //Test.expect(result, Test.beFailed())
}

pub fun testDraw3(){
    let code = Test.readFile(draw)
    let tx = Test.Transaction(
        code: code,
        authorizers: [user.address],
        signers: [user],
        arguments: []
    )
    let result = blockchain.executeTransaction(tx)
}

pub fun testGetHand3() {
    var script = Test.readFile(getHand)
    let scriptResult: Test.ScriptResult = blockchain.executeScript(script, [user.address])
    Test.expect(scriptResult, Test.beSucceeded())
    let returnValue: Int = scriptResult.returnValue! as! Int
    log(returnValue)
    Test.assertEqual(3, returnValue)
}

pub fun testGetBattlefield1() {
    var script = Test.readFile(getBattlefield)
    let scriptResult: Test.ScriptResult = blockchain.executeScript(script, [user.address])
    Test.expect(scriptResult, Test.beSucceeded())
    let returnValue: Int = scriptResult.returnValue! as! Int
    log(returnValue)
    Test.assertEqual(0, returnValue)
}


pub fun testPlace1() {//Place minion 0 in hand to battlefield 0
    let code = Test.readFile(place)
    let tx = Test.Transaction(
        code: code,
        authorizers: [user.address],
        signers: [user],
        arguments: [0,0]
    )
    let result = blockchain.executeTransaction(tx)
}

pub fun testGetBattlefield2() {
    var script = Test.readFile(getBattlefield)
    let scriptResult: Test.ScriptResult = blockchain.executeScript(script, [user.address])
    Test.expect(scriptResult, Test.beSucceeded())
    let returnValue: Int = scriptResult.returnValue! as! Int
    log(returnValue)
    Test.assertEqual(1, returnValue)
}

pub fun testPlace2() {//Place minion 0 in hand to battlefield 1
    let code = Test.readFile(place)
    let tx = Test.Transaction(
        code: code,
        authorizers: [user.address],
        signers: [user],
        arguments: [1,0]
    )
    let result = blockchain.executeTransaction(tx)
}

pub fun testGetBattlefield3() {
    var script = Test.readFile(getBattlefield)
    let scriptResult: Test.ScriptResult = blockchain.executeScript(script, [user.address])
    Test.expect(scriptResult, Test.beSucceeded())
    let returnValue: Int = scriptResult.returnValue! as! Int
    log(returnValue)
    Test.assertEqual(2, returnValue)
}

pub fun testBattle1() {
    let code = Test.readFile(battle)
    let tx = Test.Transaction(
        code: code,
        authorizers: [user.address],
        signers: [user],
        arguments: []
    )
    let result = blockchain.executeTransaction(tx)
}
pub fun testBattle2() {
    let code = Test.readFile(battle)
    let tx = Test.Transaction(
        code: code,
        authorizers: [user.address],
        signers: [user],
        arguments: []
    )
    let result = blockchain.executeTransaction(tx)
}
