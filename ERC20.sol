//SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract Erc20
{
    uint  private SupplyValue;
    string public Symbol;
    string  public name;

    mapping(address => uint) public _balance;

    mapping(address => mapping(address => uint)) public _allow;

    constructor(uint _TotalSupply, string memory Token_name, string memory Token_Symbol)
    {
        SupplyValue = _TotalSupply;
        name = Token_name; 
        Symbol = Token_Symbol;
        _balance[msg.sender] = _TotalSupply; 
    }

    event Transfer(address indexed _from, address indexed _to, uint _value);
    event Approval(address indexed _owner, address indexed _spender, uint _value);

    function MintCoin(uint _value) public  returns(bool)
    {
        SupplyValue += _value;
        _balance[msg.sender] += _value;

        return true;
    }

    function BurnCoin(uint _value) public returns(bool)
    {
        SupplyValue -= _value;

        return true;
    }

   function totalSupply() public view returns (uint)
   {
       return SupplyValue;
   }


   function balanceOf(address _owner) public view returns (uint)
   {
       return address(_owner).balance;
   } 


   function transfer(address _to, uint _value) public returns (bool success)
   {
       require(_balance[msg.sender] >= _value,"Insufficient funds");
       _balance[msg.sender] -=_value;
       _balance[_to] += _value;
       emit Transfer(msg.sender,_to, _value);
       return true;   
   }

   function transferFrom(address _from, address _to, uint _value) public returns (bool success)
   {
       require(_balance[_from] >= _value,"Insufficient funds");
       require(_balance[msg.sender] != _balance[_from]  && _balance[msg.sender] != _balance[_to],"You are not allowed");
       _balance[_from] -= _value;

       _balance[_to] += _value;

       _allow[_from][msg.sender] -= _value;

       emit Transfer(_from, _to, _value);

       return true;
   }


   function approve(address _spender, uint _value) public returns (bool success)
   {
       _allow[msg.sender][_spender] = _value;
       emit Approval(msg.sender , _spender, _value) ;
       return true;
   }

   function allowance(address _owner, address _spender) public view returns (uint remaining)
   {
       return _allow[_owner][_spender];
   }

}