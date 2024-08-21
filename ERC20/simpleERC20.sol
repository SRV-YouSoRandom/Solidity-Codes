// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

interface Token {

    ///To check balance of a given address
    function balanceOf(address _owner) external view returns (uint256 balance);

    ///To enable transfer of the Token
    function transfer(address _to, uint256 _value)  external returns (bool success);

    ///Allowing others to transfer tokens from the Owners balance
    function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);

    ///Giving permissions to a different address to transfer tokens from owners address
    function approve(address _spender  , uint256 _value) external returns (bool success);

    ///How much the allowed address can use for transfers from the owners address
    function allowance(address _owner, address _spender) external view returns (uint256 remaining);

    ///Event are used to broadcast processes so that we can listen to them when they are used
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}


///Token declaration (The data will be taken from the owner while deploying the token
contract Standard_Token is Token {
    uint256 constant private MAX_UINT256 = 2**256 - 1;
    mapping (address => uint256) public balances;
    mapping (address => mapping (address => uint256)) public allowed;
    uint256 public totalSupply;

    string public name;
    uint8 public decimals;
    string public symbol;

    ///Getting the token details (constructors can only be used onces)
    constructor(uint256 _initialAmount, string memory _tokenName, uint8 _decimalUnits, string  memory _tokenSymbol) {
        balances[msg.sender] = _initialAmount;
        totalSupply = _initialAmount;
        name = _tokenName;
        decimals = _decimalUnits;
        symbol = _tokenSymbol;
    }

    function transfer(address _to, uint256 _value) public override returns (bool success) {
        require(balances[msg.sender] >= _value, "token balance is lower than the value requested");
        balances[msg.sender] -= _value;
        balances[_to] += _value;
        emit Transfer(msg.sender, _to, _value); //solhint-disable-line indent, no-unused-vars
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public override returns (bool success) {
        uint256 allowance = allowed[_from][msg.sender];
        require(balances[_from] >= _value && allowance >= _value, "token balance or allowance is lower than amount requested");
        balances[_to] += _value;
        balances[_from] -= _value;
        if (allowance < MAX_UINT256) {
            allowed[_from][msg.sender] -= _value;
        }
        emit Transfer(_from, _to, _value); //solhint-disable-line indent, no-unused-vars
        return true;
    }

    function balanceOf(address _owner) public override view returns (uint256 balance) {
        return balances[_owner];
    }

    function approve(address _spender, uint256 _value) public override returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value); //solhint-disable-line indent, no-unused-vars
        return true;
    }

    function allowance(address _owner, address _spender) public override view returns (uint256 remaining) {
        return allowed[_owner][_spender];
    }
}