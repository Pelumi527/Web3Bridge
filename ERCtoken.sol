// SPDX-License-Identifier: NONE

pragma solidity 0.8.1;


import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v2.3.0/contracts/math/SafeMath.sol";

contract TokenName{
    ///@dev all two value are immutable they can only be set during construction
    
    /// @dev token name for this token. 
    string private name_ = "Token";
    
    /// @dev token symbol for this token
    string private symbol_ = "SYB";
    
    ///@notice EIP-20 token decimal for this token;
    uint public constant decimal = 18;
    
    /// @notice Total supply of token in circulation;
    uint public _totalsupply = 10_000_000e18; // 10 million
    
    /// @dev Allowance amount on behave of others
    mapping (address => mapping (address => uint)) internal _allowance; 
    
    ///@dev official record for token balances for each account
    mapping (address => uint) internal _balances;
    
   ///@notice official record of each account delegate
    mapping (address => address) public _delegates;
    
    /// @notice The EIP-712 typehash for the contract's domain
    bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");

    /// @notice The EIP-712 typehash for the delegation struct used by the contract
    bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");

    /// @notice The EIP-712 typehash for the permit struct used by the contract
    bytes32 public constant PERMIT_TYPEHASH = keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");

    /// @notice A record of states for signing / validating signatures
    mapping (address => uint) public nonces;
    
    /// @dev Emitted when value token are moved from one account("from") to another('to')
    event Transfer (address indexed from, address indexed to, uint value);
    
    /// Emitted when the allowance of a "spender" for a "owner" is set by a call "approve". 'value is the new allowance'
    event Approval(address indexed owner, address indexed spender, uint value);
    
    constructor(address account){
        _balances[account] = _totalsupply;
        
    }
    
    /// @dev returns the name of the token;
    function name() public  pure returns(string memory){
        return "Token";
    }
    
    /// @dev returns the symbol of the token
    function symbol() public pure returns (string memory){
        return "SYB";
    }
    
    /// @dev return the total supply of the token;
    function TotalSupply() external view returns(uint){
        return _totalsupply;
    }   
    
    /// @dev return the amount of token owned by account;
    function balanceof(address account) external view  returns(uint){
        return _balances[account];
    }
    
    /// @dev moves amount "token" drom the caller address to the recipient
    
    /// returns a boolean value indicating whether the operation succeeded
    
    /// emit a (Transfer) event
    function transfer(address recipient, uint256 amount) external returns(bool){
        _transferToken(msg.sender, recipient, amount);
        return true;
    }
    
    
    ///@dev Returns the remaining number of tokens that 'spender' is allowed to spend
    /// on behalf of the owner through (transferfrom). This is zero by default.
    
    function allowance(address owner, address spender) external view returns(uint){
        return _allowance[owner][spender];
    }
    
    function approve(address spender, uint256 amount) external returns (bool){
        _approve(msg.sender, spender, amount);
        return true;
    }
    
    function TransferFrom(address sender, address recipient, uint256 amount) external returns(bool){
        _transferToken(sender, recipient, amount);
        
        uint256 currentAllowance = _allowance[sender][msg.sender];
        require(currentAllowance >= amount,"ERC20: allowance less than the amount");
        unchecked {
            _approve(sender, msg.sender, currentAllowance - amount);
        }
        
        return true;
    }
    
    
    /// @dev moves amount of token from sender to recipient
    
    /// this internal function is equivalebt to the function(transfer)
    
    ///Emits a transfer event
    
    function _transferToken(address sender, address recipient, uint256 amount) internal {
        require(sender != address(0), "ERC20: Transfer from the zero address");
        require(recipient != address(0), "ERC20: Transfer to the zero address");
        
        uint senderBalance = _balances[sender];
        require(senderBalance >= amount, "Transfer amount exceeds in your balance");
        unchecked {
            _balances[sender] = senderBalance - amount;
        }
            _balances[recipient] += amount;
    }
    
    function _approve(address owner, address spender, uint256 amount) internal {
        require(owner != address(0),"ERC20: Transfer from the zero address");
        require(spender != address(0),"ERC20: Transfer to the zero address");
        
        _allowance[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }
    
    
}


