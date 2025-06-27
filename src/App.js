import "./styles.css";
import { useEffect, useState } from "react";

// 1️⃣ Finish getProfile() function to check if user exists ✅
// 2️⃣ Complete createProfile() function in ProfileCreation.js to create profile for a new user
// 3️⃣ Set the correct profileContractAddress and contractAddress in Connect.js ✅

import Tweets from "./components/Tweets";
import AddTweet from "./components/AddTweet";
import Connect from "./components/Connect";
import ProfileCreation from "./components/ProfileCreation";

export default function App() {
  const [account, setAccount] = useState(null);
  const [profileExists, setProfileExists] = useState(null);
  const [web3, setWeb3] = useState(null);
  const [contract, setContract] = useState(null);
  const [profileContract, setProfileContract] = useState(null);
  const [tweets, setTweets] = useState([]);
  const [loading, setLoading] = useState(true);

  async function getTweets() {
    if (!web3 || !contract) {
      console.error("Web3 or contract not initialized.");
      return;
    }

    const tempTweets = await contract.methods.getAllTweets(account).call();
    // we do this so we can sort the tweets by timestamp
    const tweets = [...tempTweets];
    tweets.sort((a, b) => b.timestamp - a.timestamp);
    setTweets(tweets);
    setLoading(false);
  }

  async function checkProfile() {
    const userProfile = await getProfile(account);
    console.log("USER PROFILE: ", userProfile);

    setProfileExists(userProfile);
  }

  async function getProfile() {
    if (!web3 || !profileContract || !account) {
      console.error(
        "Web3 or profileContract not initialized or account not connected."
      );
      return;
    }

    // get profile using getProfile() function from the contract
    // return profile displayName
    // HINT: https://web3js.readthedocs.io/en/v1.2.11/web3-eth-contract.html#methods-mymethod-call
    // CODE HERE 👇
    const profile = await profileContract.methods.getProfile(account).call();
    console.log("GOT ACCOUNT: ", profile);

    setLoading(false);

    return profile.displayName;
  }

  useEffect(() => {
    if (contract && account) {
      if (profileExists) {
        getTweets();
      } else {
        checkProfile();
      }
    }
  }, [contract, account, profileExists]);

  function shortAddress(address, startLength = 6, endLength = 4) {
    if (address === account && profileExists) {
      return profileExists;
    } else if (address) {
      return `${address.slice(0, startLength)}...${address.slice(-endLength)}`;
    }
  }

  return (
    <div className="container">
      <h1>Twitter DAPP</h1>
      <Connect
        web3={web3}
        setWeb3={setWeb3}
        account={account}
        setAccount={setAccount}
        setContract={setContract}
        shortAddress={shortAddress}
        setProfileContract={setProfileContract}
      />
      {!loading && account && profileExists ? (
        <>
          <AddTweet
            contract={contract}
            account={account}
            getTweets={getTweets}
          />
          <Tweets tweets={tweets} shortAddress={shortAddress} />
        </>
      ) : (
        account &&
        !loading && (
          <ProfileCreation
            account={account}
            profileContract={profileContract}
            checkProfile={checkProfile}
          />
        )
      )}
    </div>
  );
}
