// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.0;

/// ============ Imports ============

import { ERC20 } from "https://github.com/Jinchans/solmate/blob/main/src/tokens/ERC20.sol"; // Solmate: ERC20
import { MerkleProof } from "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/cryptography/MerkleProof.sol"; // OZ: MerkleProof

/// @title MerkleClaimERC20
/// @notice ERC20 claimable by members of a merkle tree
/// @author Anish Agnihotri <contact@anishagnihotri.com>
/// @dev Solmate ERC20 includes unused _burn logic that can be removed to optimize deployment cost
/// @changes added multiple vesting phases - JIN
contract MerkleClaimERC20 is ERC20 {


  /// ============ Immutable storage ============

  /// @notice ERC20-claimee inclusion root
  bytes32 public immutable merkleRoot;


  /// release times
  uint256 public releaseTime;
  uint256 public releaseTime2;
  uint256 public releaseTime3;
  uint256 public releaseTime4;
  uint256 public releaseTime5;

  /// ============ Mutable storage ============

  /// @notice Mapping of addresses who have claimed tokens
  mapping(address => bool) public hasClaimed; // 10% 
  mapping(address => bool) public hasClaimed2; // 20%  
  mapping(address => bool) public hasClaimed3; // 20%  
  mapping(address => bool) public hasClaimed4; // 25%  
  mapping(address => bool) public hasClaimed5; // 25%  



  /// ============ Errors ============

  /// @notice Thrown if address has already claimed
  error AlreadyClaimed();
  /// @notice Thrown if address/amount are not part of Merkle tree
  error NotInMerkle();
  /// @notice Too Early must wait for vest block timestamp
  error TooEarly();

  /// ============ Constructor ============

  /// @notice Creates a new MerkleClaimERC20 contract
  /// @param _name of token
  /// @param _symbol of token
  /// @param _decimals of token
  /// @param _merkleRoot of claimees
  constructor(
    string memory _name,
    string memory _symbol,
    uint8 _decimals,
    bytes32 _merkleRoot
  ) ERC20(_name, _symbol, _decimals) {
    merkleRoot = _merkleRoot; // Update root

    releaseTime = block.timestamp;
    releaseTime2 = block.timestamp + 1 * (30 minutes);
    releaseTime3 = block.timestamp + 1 * (2 hours);
    releaseTime4 = block.timestamp + 1 * (3 hours);
    releaseTime5 = block.timestamp + 1 * (10 hours);
  }

  /// ============ Events ============

  /// @notice Emitted after a successful token claim
  /// @param to recipient of claim
  /// @param amount of tokens claimed
  event Claim(address indexed to, uint256 amount);

  // all other claims
  event Claim2(address indexed to, uint256 amount);
  event Claim3(address indexed to, uint256 amount);
  event Claim4(address indexed to, uint256 amount);
  event Claim5(address indexed to, uint256 amount);

  /// ============ Functions ============

  /// @notice Allows claiming tokens if address is part of merkle tree
  /// @param to address of claimee
  /// @param amount of tokens owed to claimee
  /// @param proof merkle proof to prove address and amount are in tree
  function claim(address to, uint256 amount, bytes32[] calldata proof) external {
    // Throw if address has already claimed tokens
    if (hasClaimed[to]) revert AlreadyClaimed();

    // Verify merkle proof, or revert if not in tree
    bytes32 leaf = keccak256(abi.encodePacked(to, amount));
    bool isValidLeaf = MerkleProof.verify(proof, merkleRoot, leaf);
    if (!isValidLeaf) revert NotInMerkle();

    // Set address to claimed
    hasClaimed[to] = true;

    // Mint tokens to address
    uint256 phaseAmount = (amount / 100 * 10); // 10% for phase 1
    _mint(to, phaseAmount);

    // Emit claim event
    emit Claim(to, phaseAmount);
  }

    // Second claim - 20% after 3 months
    function claim2(address to, uint256 amount, bytes32[] calldata proof) external {
    // Throw if address has already claimed tokens
    if (hasClaimed2[to]) revert AlreadyClaimed();

    // Verify merkle proof, or revert if not in tree
    bytes32 leaf = keccak256(abi.encodePacked(to, amount));
    bool isValidLeaf = MerkleProof.verify(proof, merkleRoot, leaf);
    if (!isValidLeaf) revert NotInMerkle();

    // check vest time
    if(block.timestamp <= releaseTime2) revert TooEarly();

    // Set address to claimed
    hasClaimed2[to] = true;

    // Mint tokens to address
    uint256 phaseAmount = (amount / 100 * 20); // 20% for phase 2
    _mint(to, phaseAmount);

    // Emit claim event
    emit Claim2(to, phaseAmount);
  }

  function claim3(address to, uint256 amount, bytes32[] calldata proof) external {
    // Throw if address has already claimed tokens
    if (hasClaimed3[to]) revert AlreadyClaimed();

    // Verify merkle proof, or revert if not in tree
    bytes32 leaf = keccak256(abi.encodePacked(to, amount));
    bool isValidLeaf = MerkleProof.verify(proof, merkleRoot, leaf);
    if (!isValidLeaf) revert NotInMerkle();


    if(block.timestamp <= releaseTime3) revert TooEarly();

    // Set address to claimed
    hasClaimed3[to] = true;

    // Mint tokens to address
    uint256 phaseAmount = (amount / 100 * 20); // 20% for phase 3
    _mint(to, phaseAmount);

    // Emit claim event
    emit Claim3(to, phaseAmount);
  }

  // claim phase 4 25% after 
  function claim4(address to, uint256 amount, bytes32[] calldata proof) external {
    // Throw if address has already claimed tokens
    if (hasClaimed4[to]) revert AlreadyClaimed();

    // Verify merkle proof, or revert if not in tree
    bytes32 leaf = keccak256(abi.encodePacked(to, amount));
    bool isValidLeaf = MerkleProof.verify(proof, merkleRoot, leaf);
    if (!isValidLeaf) revert NotInMerkle();


    if(block.timestamp <= releaseTime4) revert TooEarly();

    // Set address to claimed
    hasClaimed4[to] = true;

    // Mint tokens to address
    uint256 phaseAmount = (amount / 100 * 25); // 25% for phase 4
    _mint(to, phaseAmount);

    // Emit claim event
    emit Claim4(to, phaseAmount);
  }

  // Final claim phase 25% after 2 years
  function claim5(address to, uint256 amount, bytes32[] calldata proof) external {
    // Throw if address has already claimed tokens
    if (hasClaimed5[to]) revert AlreadyClaimed();

    // Verify merkle proof, or revert if not in tree
    bytes32 leaf = keccak256(abi.encodePacked(to, amount));
    bool isValidLeaf = MerkleProof.verify(proof, merkleRoot, leaf);
    if (!isValidLeaf) revert NotInMerkle();


    if(block.timestamp <= releaseTime5) revert TooEarly();

    // Set address to claimed
    hasClaimed5[to] = true;

    // Mint tokens to address
    uint256 phaseAmount = (amount / 100 * 25); // 25% for phase 5
    _mint(to, phaseAmount);

    // Emit claim event
    emit Claim5(to, phaseAmount);
  }


}
