const main = async () => {
    const nftContractFactory = await hre.ethers.getContractFactory('MyEpicNFT'); 
    const nftContract = await nftContractFactory.deploy(); 
    await nftContract.deployed(); 
    console.log("Contract deployed to:", nftContract.address); 

    // Call the function
    let txn = await nftContract.makeAnEpicNFT(); 
    // waiting for it to be mined. 
    await txn.wait(); 
    
    // another NFT just for testing purposes
    txn = await nftContract.makeAnEpicNFT(); 
    await txn.wait(); 
}; 

const runMain = async () => {
    try {
        await main(); 
        process.exit(0); 
    } catch (error) {
        console.log(error); 
        process.exit(1); 
    }
}; 

runMain(); 