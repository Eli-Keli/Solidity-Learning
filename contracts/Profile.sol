// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

// 1️⃣ Save UserProfile to the mapping in the setProfile() function ✅
// HINT: don't forget to set the _displayName and _bio


contract Profile {
    struct UserProfile {
        string displayName;
        string bio;
    }
    
    mapping(address => UserProfile) public profiles;

    function setProfile(string memory _displayName, string memory _bio) public {
        // CODE HERE 👇
        UserProfile memory newProfile = UserProfile({
            displayName: _displayName,
            bio: _bio
        });

        profiles[msg.sender] = newProfile;
    }

    function getProfile(address _user) public view returns (UserProfile memory) {
        return profiles[_user];
    }
}