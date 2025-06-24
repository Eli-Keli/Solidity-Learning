// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

// 1️⃣ Add id to Tweet Struct to make every Tweet Unique ✅
// 2️⃣ Set the id to be the Tweet[] length ✅
// HINT: you do it in the createTweet function
// 3️⃣ Add a function to like the tweet ✅
// HINT: there should be 2 parameters, id and author
// 4️⃣ Add a function to unlike the tweet ✅
// HINT: make sure you can unlike only if likes count is greater then 0
// 4️⃣ Mark both functions external ✅

contract Twitter {
    
    // define owner variable
    address public owner;

    // define our constant variable (CHANGED) -> constant
    uint16 public MAX_TWEET_LENGTH = 280;

    // define our struct
    struct Tweet {
        uint256 id;
        address author;
        string content;
        uint256 timestamp;
        uint256 likes;
    }

    mapping(address => Tweet[]) public tweets; // KEY(address) -> VALUE (Tweet)

    // constructor function to set an owner of contract (called when deploying contract)
    constructor() {
        owner = msg.sender;
    }

    // modifier to allow only the owner to call the function
    modifier onlyOwner() {
        require(msg.sender == owner, "YOU ARE NOT THE OWNER");
        _;
    }

    function createTweet(string memory _tweet) public {
        // conditional
        // if tweet length <= 280 then we are good, otherwise we revert
        require(bytes(_tweet).length <= MAX_TWEET_LENGTH, "Tweet is too long!");

        Tweet memory newTweet = Tweet({
            id: tweets[msg.sender].length,
            author: msg.sender,
            content: _tweet,
            timestamp: block.timestamp,
            likes: 0
        });

        tweets[msg.sender].push(newTweet);
    }

    function getTweet(uint _i) public view returns (Tweet memory) {
        return tweets[msg.sender][_i];
    }

    function getAllTweets() public view returns (Tweet[] memory) {
        return tweets[msg.sender];
    }

    function changeTweetLength(uint16 _newTweetLength) public onlyOwner {
        MAX_TWEET_LENGTH = _newTweetLength;
    }

    function likeTweet(address author, uint256 id) external {
        require(tweets[author][id].id == id, "TWEET DOES NOT EXIST");

        tweets[author][id].likes++;
    }

    function unLikeTweet(address author, uint256 id) external {
        require(tweets[author][id].id == id, "TWEET DOES NOT EXIST");
        require(tweets[author][id].likes > 0, "TWEET HAS NO LIKES");

        tweets[author][id].likes--;
    }
}