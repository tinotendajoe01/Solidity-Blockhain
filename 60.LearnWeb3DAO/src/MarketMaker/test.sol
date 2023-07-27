pragma solidity ^0.8.20;

// import '@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol';

contract ERC20Trades {
    address private router;
    uint256 public eth_pool;
    uint256 public token_pool;
    ERC20 public token;
    // Set the address of the Uniswap v2 router

    constructor(address _router, ERC20 _token) public {
        router = _router;
        token = _token;
    }

    function ethToTokenSwap() public payable {
        uint256 fee = msg.value / 500;
        uint256 invariant = eth_pool * token_pool;
        uint256 new_eth_pool = eth_pool + msg.value;
        uint256 new_token_pool = invariant / (new_eth_pool - fee);
        uint256 tokens_out = token_pool - new_token_pool;
        eth_pool = new_eth_pool;
        token_pool = new_token_pool;
        token.transfer(msg.sender, tokens_out);
    }

    function tokenToEthSwap(uint256 tokens_in) public payable {
        uint256 fee = tokens_in / 500;
        uint256 invariant = eth_pool * token_pool;
        uint256 new_token_pool = token_pool + tokens_in;
        uint256 new_eth_pool = invariant / (new_token_pool - fee);
        uint256 eth_out = eth_pool - new_eth_pool;
        eth_pool = new_eth_pool;
        token_pool = new_token_pool;

        // You must approve the contract before calling this function
        token.transferFrom(msg.sender, address(this), tokens_in);
        // Sending the eth to the msg.sender
        payable(msg.sender).transfer(eth_out);
    }

    /**
     * Swap an exact amount of input tokens for as many output tokens as possible,
     * along the route determined by the path. The first element of path is the
     * input token, the last is the output token, and any intermediate elements
     * represent intermediate pairs to trade through (if, for example, a direct
     * pair does not exist).
     * @param amountIn The amount of input tokens to send.
     * @param amountOutMin The minimum amount of output tokens that must be received
     * for the transaction not to revert.
     * @param path An array of token addresses. path.length must be >= 2. Pools for
     * each consecutive pair of addresses must exist and have liquidity.
     * @param to Recipient of the output tokens.
     * @param deadline Unix timestamp after which the transaction will revert.
     */

    function swapExactTokensForTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external {
        IUniswapV2Router02(router).swapExactTokensForTokens(amountIn, amountOutMin, path, to, deadline);
    }

    /**
     * Swap as few input tokens as possible to receive an exact amount of output tokens,
     * along the route determined by the path. The first element of path is the input
     * token, the last is the output token, and any intermediate elements represent
     * intermediate pairs to trade through (if, for example, a direct pair does not exist).
     * @param amountOut The amount of output tokens to receive.
     * @param amountInMax The maximum amount of input tokens that can be sent.
     * @param path An array of token addresses. path.length must be >= 2. Pools for
     * each consecutive pair of addresses must exist and have liquidity.
     * @param to Recipient of the output tokens.
     * @param deadline Unix timestamp after which the transaction will revert.
     */
    function swapTokensForExactTokens(
        uint256 amountOut,
        uint256 amountInMax,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external {
        IUniswapV2Router02(router).swapTokensForExactTokens(amountOut, amountInMax, path, to, deadline);
    }

    /**
     * Returns the amount of output tokens that can be received for the given
     * amount of input tokens.
     * @param amountIn The amount of input tokens to send.
     * @param path An array of token addresses. path.length must be >= 2. Pools for
     * each consecutive pair of addresses must exist and have liquidity.
     */
    function getAmountsOut(uint256 amountIn, address[] memory path) public view returns (uint256[] memory amounts) {
        amounts = IUniswapV2Router02(router).getAmountsOut(amountIn, path);
    }
}
