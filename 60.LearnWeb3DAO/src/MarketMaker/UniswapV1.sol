// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

contract DEX {
    /**
     * ETH = X (POOLED ETH)
     * TOKEN = Y (POOLED TOKEN)
     * DX = +ETH SWAPPED TO POOL (X) FOR TOKEN
     * DY = -TOKEN FROM POOL (Y) FOR ETH (DX)
     * X + Y = K         ----INVARIANT AMM
     * (X+ DX)*(Y-DY)=K
     * (X+ DX)*(Y-DY)=X + Y
     * DY= YDX/(X+DX) ----- calculateOutputAmount here
     *
     */
    function calculateOutputAmount(uint256 inputAmount, uint256 inputPool, uint256 outputPool)
        private
        pure
        returns (uint256)
    {
        //******* */ dy=ydx/(x+dx)******//
        uint256 outputAmount = (outputPool * inputAmount) / (inputPool + inputAmount);
        return outputAmount;
    }

    function addLiquidity(uint256 tokenAmount) public payable {
        IERC20 token = IERC20(tokenAddress);
        token.transferFrom(msg.sender, address(this), tokenAmount);
    }

    function addLiquidity(uint256 tokenAmount) public payable {
        // assuming a hypothetical function
        // that returns the balance of the
        // token in the contract
        if (getPool() == 0) {
            IERC20 token = IERC20(tokenAddress);
            token.transferFrom(msg.sender, address(this), tokenAmount);
        } else {
            uint256 ethPool = address(this).balance - msg.value;
            uint256 tokenPool = getPool();
            uint256 proportionalTokenAmount = (msg.value * tokenPool) / ethPool;
            require(tokenAmount >= proportionalTokenAmount, "incorrect ratio of tokens provided");

            IERC20 token = IERC20(tokenAddress);
            token.transferFrom(msg.sender, address(this), proportionalTokenAmount);
        }
    }
}
