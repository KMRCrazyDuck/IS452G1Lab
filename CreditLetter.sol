pragma solidity ^0.4.25;

contract CreditLetter {
    // Issuer of the credit letter.
    address private issuer;
    // Current holder of the credit letter.
    address private holder;
    // Acceptor of the credit
    address private acceptor;
    // Issuance timestamp
    uint256 private issuanceTime;
    // Interest rate
    uint256 private interestRate;
    // Credit.
    uint256 private credit;

    bool private statusApproved = false;
    // Status : Whether it has been failed.
    bool private statusPaid = false;
    // Flags for status
    uint256 private STATUS_APPROVED_ID = 0;
    uint256 private STATUS_PAID_ID = 1;
    event StatusChanged(uint256 id, bool latestStatus, uint256 timestamp);

    address[] private holderChangeHistory;
    uint256[] private holderChangeTimestamps;
    event HolderChanged(address from, address to, uint256 timestamp);
    // Related to change of credit.
    event CreditChanged(uint256 original, uint256 amount, uint256 timestamp);

    constructor (
        address issuerVal,
        address holderVal,
        address acceptorVal,
        uint256 issuanceTimeVal,
        uint256 interestRateVal,
        uint256 creditVal
    ) 
    public {
        
        require (tx.origin == issuerVal || tx.origin == acceptorVal, 
        "Only issuer or acceptor can issue his/her own letter");
        issuer = issuerVal;
        holder = holderVal;
        acceptor = acceptorVal;
        issuanceTime = issuanceTimeVal;
        interestRate = interestRateVal;
        credit = creditVal;
        holderChangeHistory.push(holderVal);        
        holderChangeTimestamps.push(issuanceTimeVal);

    }
    function getInfo() public view returns (
        address issuerVal,
        address holderVal,
        address acceptorVal,
        uint256 issuanceTimeVal,
        uint256 interestRateVal,
        uint256 creditVal,
        bool approved,
        bool paid
    ) 
    {
        return (issuer, holder, acceptor, issuanceTime, interestRate, credit, statusApproved, statusPaid);
    }

    function setStatusApproved(bool status, uint256 timestamp) public {
        require (timestamp > 0);
        // Only acceptors or issuers can change the approval status.
        require (msg.sender == acceptor || msg.sender == issuer, "Only acceptor or issuer can approve");
        statusApproved = status;
        emit StatusChanged(STATUS_APPROVED_ID, status, timestamp);
    }

    function setStatusPaid(bool status, uint256 timestamp) public {
        require (timestamp > 0);
        // Only the acceptor can change the paid status.
        require (msg.sender == acceptor, "Only acceptor can pay");
        statusPaid = status;
        emit StatusChanged(STATUS_PAID_ID, status, timestamp);
    }

    function transfer(address to, uint256 timestamp) public {
        require (holder != to);
        require (timestamp > 0);
        // Only the current holder can transfer the letter of credit.
        require (msg.sender == holder, "Only holder can transfer");
        holder = to;
        holderChangeHistory.push(msg.sender);
        holderChangeTimestamps.push(timestamp);
        emit HolderChanged(msg.sender, to, timestamp);
    }

    
    function resetCreditAmount(uint256 amount, uint256 timestamp) public {
        // Think: Why use tx.origin？
        require (tx.origin == issuer || tx.origin == acceptor, "Only issuer or acceptor can reset credit amount");
        credit = amount;
        emit CreditChanged(credit, amount, timestamp);
    }
}




