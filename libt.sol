// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
contract Lib is ERC1155{
    constructor() ERC1155 (""){
        LibAdmin=msg.sender;
    }

    uint amountBooks=0;
    address LibAdmin;
    uint public priceForMonth = 1000 gwei;
    
    mapping(uint=>string) bookNumber; 
    mapping (uint=> address) rentedTo;

    //....admin 
    function changeAdmin(address _newAdmin) public {
    require(LibAdmin==msg.sender, "Only admin");
    LibAdmin= _newAdmin;
    //safeBatchTransferFrom(LibAdmin, _newAdmin, [0,1,...amount], amounts, data);
    }
    function wildraw() public {
        require(LibAdmin==msg.sender, "OnlyAdmin");
        payable(LibAdmin).transfer(address(this).balance);
    }

    //........book 
    function createBook (string calldata _url) public  {
        require(LibAdmin==msg.sender, "Only admin");
        //creation 
        bookNumber [amountBooks]=_url ;
        _mint(LibAdmin, amountBooks,1,"");
        amountBooks++;
    } 
    function url(uint _bookID) public view returns(string memory) {
        require (_bookID<amountBooks,"Not exist");
        return bookNumber[_bookID];
    }
    function rentBook (uint _bookID, uint _month) public payable {
        require (_bookID<amountBooks,"Not exist");
        require (balanceOf(LibAdmin, _bookID)!=0,"Already rented");
        require (priceForMonth*_month==msg.value, "Not enough funds");
        //require (rentedTo[_bookID]==0x0000000000000000000000000000000000000000,"Already rented");
        rentedTo[_bookID]==msg.sender;
        _setApprovalForAll(LibAdmin,msg.sender,true);
        safeTransferFrom(LibAdmin,msg.sender, _bookID,1,"");
        _setApprovalForAll(LibAdmin,msg.sender,false);
    }
    function searchBook (uint _bookID) public view returns (address){
        require (_bookID<amountBooks,"Not exist");
        return rentedTo[_bookID];
    } 
    function returnBook (uint _bookID) public {
        require(msg.sender==rentedTo[_bookID],"Only admin");
        safeTransferFrom(msg.sender,LibAdmin,_bookID,1,"");
        delete rentedTo[_bookID];
    }
    } 
