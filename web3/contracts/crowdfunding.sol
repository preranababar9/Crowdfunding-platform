// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract CrowdFunding {
    struct Campaign {
          address owner;
        string title;
        string description;
        uint256 target;// funding target
        uint256 deadline;// timestamp of campaign
        uint256 amountCollected;
        string image;
        address[] donators;// 
        uint256[] donations;
    }
// used mapping to store campaign data with uniqye id
    mapping(uint256 => Campaign) public campaigns;

    uint256 public numberOfCampaigns = 0;// track ofcampiagn created

     function createCampaign(address _owner, string memory _title, string memory _description, uint256 _target, uint256 _deadline, string memory _image) public returns (uint256) {
        Campaign storage campaign = campaigns[numberOfCampaigns];
// get a reference to the campaign using uinque id
        require(campaign.deadline < block.timestamp, "The deadline should be a date in the future.");

        campaign.owner = _owner;
        campaign.title = _title;
        campaign.description = _description;
        campaign.target = _target;
        campaign.deadline = _deadline;
        campaign.amountCollected = 0;
        campaign.image = _image;

        numberOfCampaigns++;

        return numberOfCampaigns - 1;
    }
// allow user to donate 
    function donateToCampaign(uint256 _id) public payable {
        uint256 amount = msg.value;// amount is setted with transcation

        Campaign storage campaign = campaigns[_id];// reference of campaign using id
// add donation address and amount to the campaign
        campaign.donators.push(msg.sender);
        campaign.donations.push(amount);
// sent donation to campaign owner and update amount collected
        (bool sent,) = payable(campaign.owner).call{value: amount}("");

        if(sent) {
            campaign.amountCollected = campaign.amountCollected + amount;
        }
    }
// list of donators
    function getDonators(uint256 _id) view public returns (address[] memory, uint256[] memory) {
        return (campaigns[_id].donators, campaigns[_id].donations);
    }
// info about the campaign
    function getCampaigns() public view returns (Campaign[] memory) {
        Campaign[] memory allCampaigns = new Campaign[](numberOfCampaigns);
// fill the array with campaign data
        for(uint i = 0; i < numberOfCampaigns; i++) {
            Campaign storage item = campaigns[i];

            allCampaigns[i] = item;
        }

        return allCampaigns;
    }
}

    
