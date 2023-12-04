from web3 import Web3, HTTPProvider
# from web3.middleware import geth_poa_middleware

web3 = Web3(HTTPProvider('http://127.0.0.1:8545/'))
# web3.middleware_onion.inject(geth_poa_middleware, layer=0)


sig = "updateSettings(address,uint256,uint256)"
goal = web3.keccak(text=sig).hex()[:10]

i = 1
while True:
    sig = f"checkpoint(uint256,(uint8,uint256,uint256)[],{int(i)},{int(i)})"
    if (sig == goal):
        print(sig)
        print(web3.keccak(text=sig).hex()[:10])
        exit()
    i += 1
