
// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

import "@openzeppelin/contracts/access/Ownable.sol";

// 2️⃣ Add a getProfile() function to the interface ✅ 
// 3️⃣ Initialize the IProfile in the contructor ✅ 
// HINT: don't forget to include the _profileContract address as a input 
// 4️⃣ Create a modifier called onlyRegistered that require the msg.sender to have a profile ✅
// HINT: use the getProfile() to get the user
// HINT: check if displayName.length > 0 to make sure the user exists
// 5️⃣ ADD the onlyRegistered modified to createTweet, likeTweet, and unlikeTweet function ✅

interface IProfile {
    struct UserProfile {
        string displayName;
        string bio;
    }
    
    // CODE HERE 👇
    function getProfile(address _user) external view returns (UserProfile memory);
}

contract Twitter is Ownable(msg.sender) {

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

    // Define a mapping between user addresses and tweets
    mapping(address => Tweet[]) public tweets; // KEY(address) -> VALUE (Tweet)

    // profile contract defined here 👇
    IProfile profileContract;
    
    // Define the events
    event TweetCreated(uint256 id, address author, string content, uint256 timestamp);
    event TweetLiked(address liker, address tweetAuthor, uint256 tweetId, uint256 newLikeCount);
    event TweetUnliked(address unLiker, address tweetAuthor, uint256 tweetId, uint256 newLikeCount);

    // create modifier here 👇
    modifier onlyRegistered() {
        IProfile.UserProfile memory userProfileTemp = profileContract.getProfile(msg.sender);
        require(bytes(userProfileTemp.displayName).length > 0, "USER IS NOT REGISTERED!");
        _;
    }

    // create constructor here 👇
    constructor(address _profileContract) {
        profileContract = IProfile(_profileContract);
    }

    function createTweet(string memory _tweet) public onlyRegistered {
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

        // Emit the TweetCreated event
        emit TweetCreated(newTweet.id, newTweet.author, newTweet.content, newTweet.timestamp);
    }

    function getTweet(uint _i) public view returns (Tweet memory) {
        return tweets[msg.sender][_i];
    }

    function getAllTweets(address _owner) public view returns (Tweet[] memory ){
        return tweets[_owner];
    }

    function changeTweetLength(uint16 _newTweetLength) public onlyOwner {
        MAX_TWEET_LENGTH = _newTweetLength;
    }


    function likeTweet(address author, uint256 id) external onlyRegistered {
        require(tweets[author][id].id == id, "TWEET DOES NOT EXIST");

        tweets[author][id].likes++;

        // Emit the TweetLiked event
        emit TweetLiked(msg.sender, author, id, tweets[author][id].likes);
    }

    function unLikeTweet(address author, uint256 id) external onlyRegistered {
        require(tweets[author][id].id == id, "TWEET DOES NOT EXIST");
        require(tweets[author][id].likes > 0, "TWEET HAS NO LIKES");

        tweets[author][id].likes--;

        // Emit the TweetUnliked event
        emit TweetUnliked(msg.sender, author, id, tweets[author][id].likes);
    }

    function getTotalLikes(address _author) external view returns (uint256) {
        uint256 totalLikes;

        // Loop over all the tweets 
        for (uint i = 0; i < tweets[_author].length; i++) {
            totalLikes += tweets[_author][i].likes;
        }

        return totalLikes;
    }
}