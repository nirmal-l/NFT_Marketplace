//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console, Vm} from "forge-std/Test.sol";
import {NFTX} from "../../src/NFTX.sol";
import {NFTXScript} from "../../script/NFTXScript.s.sol";
import {NFTXNFT} from "../../src/NFTXNFT.sol";
import {ERC721} from "../../lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";

contract NFTXTest is Test {
    NFTXScript public nftXScript;
    NFTX public nftX;
    NFTXNFT public nftXNFT;

    function setUp() public {
        nftXScript = new NFTXScript();
        (nftX, nftXNFT) = nftXScript.run();
    }

    function testGetETHUSDPrice() public view {
        uint256 USDAmount = 50;
        uint256 price = nftX.getUSDtoETHPRICE(USDAmount);
        console.log(price);
    }

    function testNFTisMintedInTheSellersAccount() public {
        address SELLER = makeAddr("SELLER");
        vm.deal(SELLER, 1 ether);
        vm.prank(SELLER);

        nftX.SellItem("sometokenurl", "sellername", 50, "itemname");
        assert(nftXNFT.ownerOf(0) == SELLER);
    }

    function testEVENTSemmitedDuringSellItem() public {
        address SELLER = makeAddr("SELLER");
        vm.deal(SELLER, 1 ether);
        vm.prank(SELLER);
        vm.recordLogs();

        nftX.SellItem("sometokenurl", "sellername", 50, "itemname");
        Vm.Log[] memory entries = vm.getRecordedLogs();
        console.log(entries.length);
        assert(entries.length > 0);
    }

    function testSelleerApprovesTheContractToSendNFT() public {
        address SELLER = makeAddr("SELLER");
        vm.deal(SELLER, 1 ether);
        vm.prank(SELLER);
        nftX.SellItem("sometokenurl", "sellername", 50, "itemname");
        vm.prank(SELLER); // i have  again call the vm.prank()
        nftXNFT.approve(address(nftX), 0);
    }

    function testBuyerPaidForTheNFTandSellerNoLongerOwnsTheNFT() public {
        address SELLER = makeAddr("SELLER");
        vm.deal(SELLER, 1 ether);
        vm.prank(SELLER);
        nftX.SellItem("sometokenurl", "sellername", 50, "itemname");
        vm.prank(SELLER); // i have  again call the vm.prank()
        nftXNFT.approve(address(nftX), 0);

        //NOW COMES THE BUYER
        address BUYER = makeAddr("BUYER");
        vm.deal(BUYER, 1 ether);
        vm.startPrank(BUYER);
        nftX.BuyItem{value: nftX.getItemPrice("sometokenurl")}("sometokenurl"); // BUYER BUYS THE ITEM
        vm.stopPrank();
        assert(address(BUYER).balance < 1 ether);
        console.log(address(BUYER).balance); // should be less than 1 ether
        console.log(nftX.getItemPrice("sometokenurl")); // correct price
        assert(nftXNFT.ownerOf(0) == address(nftX));
    }

    function testConfirmDelivery() public {
        address SELLER = makeAddr("SELLER");
        vm.deal(SELLER, 1 ether);
        vm.prank(SELLER);
        nftX.SellItem("sometokenurl", "sellername", 50, "itemname");
        vm.prank(SELLER); // i have  again call the vm.prank()
        nftXNFT.approve(address(nftX), 0);

        //NOW COMES THE BUYER
        address BUYER = makeAddr("BUYER");
        vm.deal(BUYER, 1 ether);
        vm.startPrank(BUYER);
        nftX.BuyItem{value: nftX.getItemPrice("sometokenurl")}("sometokenurl"); // BUYER BUYS THE ITEM
        vm.stopPrank();
        vm.startPrank(BUYER);
        nftX.ConfirmDelivery("sometokenurl");
        vm.stopPrank();
        assert(nftXNFT.ownerOf(0) == BUYER);
        assert(address(SELLER).balance > 1);
    }

    // function testRfeund() public {
    //     address SELLER = makeAddr("SELLER");
    //     vm.deal(SELLER, 1 ether);
    //     vm.prank(SELLER);
    //     nftX.SellItem("sometokenurl", "sellername", 50, "itemname");
    //     vm.prank(SELLER); // i have  again call the vm.prank()
    //     nftXNFT.approve(address(nftX), 0);

    //     //NOW COMES THE BUYER
    //     address BUYER = makeAddr("BUYER");
    //     vm.deal(BUYER, 1 ether);
    //     vm.startPrank(BUYER);
    //     nftX.BuyItem{value: nftX.getItemPrice("sometokenurl")}("sometokenurl"); // BUYER BUYS THE ITEM
    //     vm.stopPrank();
    //     vm.warp(block.timestamp + nftX.getTimePeriod() + 1); // warp the time to after the time period
    //     vm.roll(block.number + nftX.getTimePeriod() + 1); // roll the block number to after the time period
    //     // nftX.Refund();
    //     assert(nftXNFT.ownerOf(0) == address(SELLER));
    // }
}
