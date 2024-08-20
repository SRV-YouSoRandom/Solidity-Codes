(async () => {

    let accounts = await web3.eth.getAccounts();
    let balance = await web3.eth.getBalance(accounts[0])
    let balanceInEth = await web3.utils.fromWei(balance, "ether");
    console.log(accounts, balanceInEth);
})()