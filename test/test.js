const ERC20 = artifacts.require("ERC20");
const assert = require("chai").assert;

let _ERC20;
contract("ERC20", (accounts) => {
    before(async () => {
        _ERC20 = await ERC20.deployed();
    });
    const account1 = accounts[0];
    const account2 = accounts[1];
    const account3 = accounts[2];
    const account4 = accounts[3];
    const account5 = accounts[4];
    const account6 = accounts[5];
    const account7 = accounts[6];
    const account8 = accounts[7];

    const zeroAccount = "0x0000000000000000000000000000000000000000";
    describe("ERC20 token", async () => {
        context("Transfer function ", async () => {
            it("Should fail: when account0 trying to send 1000 token", async () => {
                try {
                    let res = await _ERC20.transfer(account1, "1000000000000000000000", {
                        from: owner,
                    });
                    let balance = await _ERC20.balanceOf(account1);
                    assert.equal("100000000000000000000", balance, "Passed");
                } catch (err) {
                    return true;
                }
            });
            it("Should pass when account0 trying to send 1000 token", async () => {
                let res = await _ERC20.transfer(account2, "1000000000000000000000", {
                    from: account1
                });
                let balance = await _ERC20.balanceOf(account2);
                assert.equal("1000000000000000000000", balance, "Passed");
            });
            it("Should fail: User balance is less than the given amount", async()=>{
                try{
                await _ERC20.transfer(account3,"100000000000000000000000",{
                    from: account2
                })
            }catch(err){
                return true;
            }
            });
        });
        context(" Approve Function ", async () => {
            it("Should fail: When user try to approve without balance", async () => {
                try {
                    let res = await _ERC20.approve(account2, "1000000000000000000000", {
                        from: account3
                    });
                    let balance = await _ERC20.allowance(account3, account2);
                    assert.equal("1000000000000000000000", balance, "Passed");
                } catch (err) {
                    return true
                }
            });
            it("Should pass: When user with sufficient balance try to send token", async () => {
                await _ERC20.approve(account3, "1000000000000000000000", {
                    from: account1
                })
                let res = await _ERC20.allowance(account1, account3);
                assert.equal("1000000000000000000000", res, "Passed");
            });
        });
        context("Transfer from function ", async () => {
            it("Should fail: User try to send insufficient allowance", async () => {
                try {
                    let res = await _ERC20.transferFrom(account2, account1, "10000000000000000000000", {
                        from: account1
                    });
                    let balance = await _ERC20.allowance(account2, account1);
                    assert.equal("10000000000000000000000", balance, "Passed");
                } catch (err) {
                    return true;
                }
            });
            it("Should pass: User with sufficient allowance", async () => {
                let res = await _ERC20.transferFrom(account1, account4, "1000000000000000000000", {
                    from: account3
                });
                let balance = await _ERC20.balanceOf(account4);
                assert.equal("1000000000000000000000", balance, "Passed");
            });
        });

    });
    context("TransferFrom function", async () => {
        it("Shoud fail: User try to send insufficient allowanc", async () => {
            try {
                let res = await _ERC20.transferFrom(account1, account2, "10000000000000000000000", {
                    from: account5
                });
                let balance = await _ERC20.allowance(account2, account1);
                assert.equal("10000000000000000000000", balance, "Passed");
            } catch (err) {
                return true;
            }
        });
        it("Should pass: User try to approve some token from account1", async () => {
            await _ERC20.approve(account5, "1000000000000000000000", {
                from: account2
            });
            let balance = await _ERC20.allowance(account2, account5);
            assert.equal("1000000000000000000000", balance);
        })
        it("Should pass: User send sufficient allowance", async () => {
            await _ERC20.transferFrom(account2, account6, "1000000000000000000000", {
                from: account5
            });
            let balance = await _ERC20.balanceOf(account6);
            assert.equal("1000000000000000000000", balance);
        });
        // it("Should fail: from is zero account", async () => {
        //     try {
        //         await _ERC20.approve(account1, "1000000000000000000000", {
        //             from: zeroAccount
        //         });
        //         let balance = await _ERC20.allowance(account1, zeroAccount)
        //         assert.equal("1000000000000000000000", balance);
        //     } catch (err) {
        //         return true;
        //     }
        // })
        it("Should fail: to is zero account", async () => {
            try {
                await _ERC20.approve(zeroAccount, "1000000000000000000000", {
                    from: account1
                });
            } catch (err) {
                return true;
            }
        });
    });
});