import {useEffect, useState} from "react";
import {Contract} from "ethers";
import FundProjectABI from "./abis/FundProject.json";

const provider = new ethers.providers.Web3Provider(window.ethereum);
const signer = provider.getSigner();

const fundProjectContract = new Contract(<FundProject Contract Address>, FundProjectABI, signer);

function App() {
    const [fundsRaised, setFundsRaised] = useState();

    async function getFundsRaised() {
        const funds = await fundProjectContract.getFunds(<Project Address>);
        setFundsRaised(funds.toString());
    }

    useEffect(() => {
        getFundsRaised();
    }, []);

    return (
        <div className="App">
            <h1>Funds Raised: {fundsRaised}</h1>
        </div>
    );
}
export default App;
