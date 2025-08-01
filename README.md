# ZK Witness - Sudoku Zero-Knowledge Proof System

A zero-knowledge proof system for Sudoku puzzle verification built with Noir, demonstrating how to prove knowledge of a valid solution without revealing the solution itself.

## 🎯 Project Overview

This project implements a zero-knowledge proof circuit that verifies Sudoku puzzle solutions. The key innovation is that it allows you to prove you have a valid solution to a Sudoku puzzle without revealing what the actual solution is. This has applications in:

- **Privacy-preserving gaming**: Prove you solved a puzzle without sharing the answer
- **Educational systems**: Verify student solutions without revealing answers
- **Competitive platforms**: Fair verification of puzzle solutions
- **Blockchain applications**: On-chain verification of off-chain computations

## 🔧 Technology Stack

- **Noir**: A domain-specific language for zero-knowledge proofs
- **Nargo**: Noir's package manager and build tool
- **Barretenberg (BB)**: The proving system backend with CLI tools for proof generation and verification

## 📁 Project Structure

```
ZK Witness Coimbatore/
├── Nargo.toml          # Project configuration and dependencies
├── Prover.toml         # Input data for proving (puzzle and solution)
├── src/
│   └── main.nr         # Main circuit implementation
└── target/
    ├── zkwitness.gz    # Generated witness file
    └── zkwitness.json  # Witness data in JSON format
```

## 🚀 Getting Started

### Prerequisites

1. **Install Noir**: Follow the official installation guide at [noir-lang.org](https://noir-lang.org/docs/getting_started/quick_start)

2. **Install Barretenberg CLI**: The BB CLI tools are included with Noir installation

3. **Verify Installation**:
   ```bash
   nargo --version
   bb --version
   ```

### Installation & Setup

1. **Clone the repository**:
   ```bash
   git clone https://github.com/Proof-of-Witness/Zk-witness-coimbatore.git
   cd "ZK Witness Coimbatore"
   ```

2. **Install dependencies**:
   ```bash
   nargo check
   ```

## 🎮 How to Run

### Step 1: Generate Witness

First, we need to generate a witness using our public and private inputs:

```bash
nargo execute
```

This command:
- Reads the puzzle (public input) and solution (private input) from `Prover.toml`
- Executes the circuit and generates a witness file
- The witness contains all the intermediate values needed for proof generation

### Step 2: Generate Proof using Barretenberg (BB)

After generating the witness, we use the Barretenberg backend to create the actual zero-knowledge proof:

```bash
bb prove -w target/zkwitness.gz -b target/zkwitness.json -o target
```

This command:
- `-w target/zkwitness.gz`: Path to the witness file
- `-b target/zkwitness.json`: Path to the bytecode file
- `-o target`: Output directory for the proof

### Step 3: View the Generated Proof

To view the generated proof in hexadecimal format:

```bash
cat ./target/proof | od -An -v -t x1 | tr -d $' \n' | sed 's/^.\{8\}//'
```

This displays the proof in a readable hexadecimal format.

### Step 4: Clean Up (Optional)

After generating the proof, you can clean up intermediate files:

```bash
rm Prover.toml
rm -rf target/zkwitness.gz
rm -rf target/zkwitness.json
```

Now you have only the proof file and public inputs - perfect for sharing with verifiers!

### Step 5: Verify the Proof

There are two ways to verify the proof:

#### Method 1: Using Verification Key

1. **Generate Verification Key**:
   ```bash
   bb write_vk -b target/zkwitness.json -o target
   ```

2. **Verify the Proof**:
   ```bash
   bb verify
   ```

#### Method 2: Using Smart Contract

Generate a Solidity smart contract for on-chain verification:

```bash
bb write_solidity_verifier
```

This creates a Solidity contract that can verify the proof on Ethereum or other EVM-compatible blockchains.

## 🧩 Understanding the Circuit

The circuit in `src/main.nr` implements five key constraints to verify a valid Sudoku solution:

### 1. Fixed Cell Constraint
```noir
// If puzzle[i][j] != 0, then solution[i][j] == puzzle[i][j]
```
Ensures that the solution respects the original puzzle's fixed numbers.

### 2. Valid Digit Constraint
```noir
// All solution[i][j] must be in range [1, 9]
```
Verifies that all cells contain valid Sudoku digits (1-9).

### 3. Row Uniqueness
```noir
// Each row should have unique digits 1-9
```
Ensures no digit is repeated in any row.

### 4. Column Uniqueness
```noir
// Each column should have unique digits 1-9
```
Ensures no digit is repeated in any column.

### 5. 3x3 Box Uniqueness
```noir
// Every 3x3 sub-grid should have unique digits 1-9
```
Ensures no digit is repeated in any 3x3 box.

## 📊 Input Format

### Puzzle Format
The puzzle is represented as a 1D array of 81 elements (9x9 grid flattened):
- `0` represents an empty cell
- `1-9` represent fixed numbers in the puzzle

### Solution Format
The solution is also a 1D array of 81 elements:
- Each element must be `1-9`
- Must satisfy all Sudoku rules

### Example from Prover.toml
```toml
puzzle = [
    5, 3, 0, 0, 7, 0, 0, 0, 0,  # Row 1: 5,3,_,_,7,_,_,_,_
    6, 0, 0, 1, 9, 5, 0, 0, 0,  # Row 2: 6,_,_,1,9,5,_,_,_
    # ... continues for all 9 rows
]
```

## 🔍 How Zero-Knowledge Proofs Work

1. **Private Input**: Your solution to the Sudoku puzzle
2. **Public Input**: The original puzzle
3. **Proof Generation**: The circuit creates a mathematical proof that:
   - You know a valid solution
   - The solution satisfies all Sudoku rules
   - Without revealing what the solution actually is
4. **Verification**: Anyone can verify the proof is valid using only the puzzle

## 🛠️ Development

### Adding New Puzzles

To test with different puzzles:

1. **Edit `Prover.toml`**:
   ```toml
   puzzle = [
       # Your 81-element puzzle array
   ]
   
   solution = [
       # Your 81-element solution array
   ]
   ```

2. **Generate witness and proof**:
   ```bash
   nargo execute
   bb prove -w target/zkwitness.gz -b target/zkwitness.json -o target
   ```

3. **Verify the proof**:
   ```bash
   bb write_vk -b target/zkwitness.json -o target
   bb verify
   ```

### Modifying the Circuit

The circuit logic is in `src/main.nr`. Key functions:

- `main()`: Main circuit entry point
- `array_to_2d()`: Converts 1D array to 2D grid
- `check_uniqueness()`: Verifies no repeated digits
- `get_row()`, `get_column()`, `get_3x3_box()`: Helper functions

## 🐛 Troubleshooting

### Common Issues

1. **"Noir not found"**:
   ```bash
   curl -L https://raw.githubusercontent.com/noir-lang/noirup/main/install | bash
   source ~/.bashrc  # or ~/.zshrc
   ```

2. **"BB CLI not found"**:
   - BB CLI is included with Noir installation
   - If not found, reinstall Noir: `noirup update`

3. **Compilation errors**:
   - Ensure all constraints are properly defined
   - Check array bounds and indices
   - Verify input format matches expected types

4. **Witness generation fails**:
   - Verify your solution is actually valid
   - Check that puzzle and solution arrays are 81 elements each
   - Ensure solution respects fixed puzzle numbers

5. **Proof generation fails**:
   - Ensure witness file exists: `ls target/zkwitness.gz`
   - Check bytecode file exists: `ls target/zkwitness.json`
   - Verify BB CLI is properly installed: `bb --version`

6. **Verification fails**:
   - Ensure verification key was generated correctly
   - Check that proof file exists and is not corrupted
   - Verify you're using the correct verification method

### Debug Mode

Enable debug output:
```bash
nargo prove --verbose
```

## 📚 Learning Resources

- [Noir Documentation](https://noir-lang.org/)
- [Zero-Knowledge Proofs Explained](https://ethereum.org/en/zero-knowledge-proofs/)
- [Sudoku Rules and Strategies](https://en.wikipedia.org/wiki/Sudoku)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## 📄 License

This project is open source. Please check the LICENSE file for details.

## 🙏 Acknowledgments

- Built with [Noir](https://noir-lang.org/)
- Inspired by zero-knowledge proof applications in blockchain
- Developed for educational and research purposes

---

**Note**: This is a demonstration project. For production use, additional security considerations and optimizations may be required. 