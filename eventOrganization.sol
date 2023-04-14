// SPDX-License-Identifier: GPL-3.0

pragma solidity >= 0.5.9 < 0.9.0;

contract EventOrganization{

    struct Event{
        address organizer;
        string name;
        uint date;
        uint price;
        uint ticketCount;
        uint ticketRemain;
    }

    mapping(uint=>Event) public events;
    mapping(address=>mapping(uint=>uint)) public tickets;
    uint public nextId;

    function createEvent(string memory name, uint date, uint price, uint ticketCount) public {
        require(date>block.timestamp,"please enter future date to organize event");
        require(ticketCount>0, "please enter ticket count");
        events[nextId]=Event(msg.sender,name,date,price,ticketCount, ticketCount);
        nextId++;
    }

    function buyTicket(uint id, uint quantity) public payable{
        require(events[id].date!=0,"Event does not exist");
        require(events[id].date>block.timestamp,"Event has already orrured");
        Event storage _event=events[id];
        require(msg.value==(_event.price*quantity),"Ether is not enough");
        require(_event.ticketRemain>=quantity,"Event does not have enough ticket");
        _event.ticketRemain-=quantity;
        tickets[msg.sender][id]+=quantity;
    }

    function transferTicket(uint id, uint quantity,address to) external{
        require(events[id].date!=0,"Event does not exist");
        require(events[id].date>block.timestamp,"Event has already orrured");
        require(tickets[msg.sender][id]>=quantity,"You do not have enough tickets");
        tickets[msg.sender][id]-=quantity;
        tickets[to][id]+=quantity;
    }
}
