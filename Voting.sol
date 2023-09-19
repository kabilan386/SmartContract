// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

contract Voting {
    address public owner;
    bool public  isStartElection;
    address public  winnerAddress;
    
    struct candiate {
        string name;
        string proposal;
        bool exist;
        uint count;
        address[] voterAddress;
    }

    struct voter {
        uint8 voteCount;
        address[] delegaterAddress;
        address[] VotedAddress;
        bool exist;
    }

    mapping(address => voter) public Voter;
    mapping(address => candiate) public Candiate;
    

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _; 
    }

    function addCandidate(
        string memory _name,
        string memory _proposal,
        address _candidate
    ) public {
        require(!Candiate[_candidate].exist, "Candidate already enrolled");
        
        candiate memory newCandidate = candiate(_name, _proposal, true,0, new address[](0));
        Candiate[_candidate] = newCandidate;
    }

    function addVoter(address _voterAddress) public onlyOwner {
        require(!Voter[_voterAddress].exist, "Voter already enrolled");        
        voter memory newVoter;
        newVoter.voteCount = 1;
        newVoter.delegaterAddress = new address[](0);
        newVoter.VotedAddress = new address[](0);
        newVoter.exist = true;
        Voter[_voterAddress] = newVoter;
    }

    function startElection() public onlyOwner {
        isStartElection = true;
    }

    function getCandidateDetails(address _candidateAddress) public view  returns (candiate memory) {
        return Candiate[_candidateAddress];
    }

    function showWinner() public view returns (candiate memory) {
        require(!isStartElection,"Election is not end");
        return Candiate[winnerAddress];
    }

    function delegateVote(address _delegetPersonAddress) public  {
        require(_delegetPersonAddress != msg.sender, "Same address not delegate as a voter");
        require(_delegetPersonAddress != address(0), "Please use correct format address" );
        require(Voter[_delegetPersonAddress].exist, "delegate address not enrolled as a voter");
        Voter[_delegetPersonAddress].voteCount++;
        Voter[_delegetPersonAddress].delegaterAddress.push(msg.sender);
    }

    function vote(address _candidateAddress) public {
        require(Candiate[_candidateAddress].exist, "Candidate not enrolled");
        require(Voter[msg.sender].voteCount > 0, "Already voted");
        Voter[msg.sender].voteCount--;
        Voter[msg.sender].VotedAddress.push(_candidateAddress);
        Candiate[_candidateAddress].count++;
        Candiate[_candidateAddress].voterAddress.push(msg.sender);
    }

    function endElection() public onlyOwner {
        isStartElection = false;
    }

    function electionResult(address _candidateAddress) public view returns (candiate memory) {
        return Candiate[_candidateAddress];
    }  

    function viewVoterProfile(address _voterAddress) public view returns (voter memory){
        return Voter[_voterAddress];
    }
}
