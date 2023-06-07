// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
contract CarSharing is ERC1155{
    constructor() ERC1155 (""){
        CarAdmin=msg.sender;
    }

    uint amountCars=0;
    address CarAdmin;
    uint public priceForDay = 1000 gwei; 

    struct Car{
        string number;
        string location;
        bool availability;
    }

    struct User{
        uint age;
        bool license;
    } 
    mapping(address=>User) user;
    mapping(uint=>string) carNumber; 
    mapping (uint=> address) rentedTo;

    //....admin 
    function changeAdmin(address _newAdmin) public {
        require(CarAdmin==msg.sender, "Only admin");
        CarAdmin= _newAdmin;
    }

    function wildraw() public {
        require(CarAdmin==msg.sender, "OnlyAdmin");
        payable(CarAdmin).transfer(address(this).balance);
    }

    function createCar (string calldata _url) public  {
        require(CarAdmin==msg.sender, "Only admin");
        //creation 
        carNumber [amountCars]=_url ;
        _mint(CarAdmin, amountCars,1,"");
        amountCars++;
    } 

    function url(uint _carID) public view returns(string memory) {
        require (_carID<amountCars,"Not exist");
        return carNumber[_carID];
    }

    function rentCar (uint _carID, uint _day) public payable {
        require (_carID<amountCars,"Not exist");
        require (balanceOf(CarAdmin, _carID)!=0,"Already rented");
        require(user[msg.sender].license==true,"No license");
        require (user[msg.sender].age>=18, "Too young");
        require (priceForDay*_day==msg.value, "Not enough funds");
        rentedTo[_carID]==msg.sender;
        _setApprovalForAll(CarAdmin,msg.sender,true);
        safeTransferFrom(CarAdmin,msg.sender, _carID,1,"");
        _setApprovalForAll(CarAdmin,msg.sender,false);
    }

    function registration(uint age, bool license) public {
        user[msg.sender]=User(age,license);
    }

    function searchCar (uint _carID) public view returns (address){
        require (_carID<amountCars,"Not exist");
        return rentedTo[_carID];
    } 
    
    function returnCar (uint _carID) public {
        require(msg.sender==rentedTo[_carID],"Only admin");
        safeTransferFrom(msg.sender,CarAdmin,_carID,1,"");
        delete rentedTo[_carID];
    }
    } 
