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
- **Barretenberg**: The proving system backend

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

1. **Install Noir**: Follow the official installation guide at [noir-lang.org](https://noir-lang.org/getting_started/installation/)

2. **Verify Installation**:
   ```bash
   nargo --version
   ```

### Installation & Setup

1. **Clone the repository**:
   ```bash
   git clone <your-repo-url>
   cd "ZK Witness Coimbatore"
   ```

2. **Install dependencies**:
   ```bash
   nargo check
   ```

## 🎮 How to Run

### 1. Compile the Circuit

```bash
nargo compile
```

This compiles the Noir circuit and generates the necessary artifacts.

### 2. Generate a Proof

```bash
nargo prove
```

This command:
- Reads the puzzle and solution from `Prover.toml`
- Generates a zero-knowledge proof that the solution is valid
- Creates a proof file that can be verified without revealing the solution

### 3. Verify the Proof

```bash
nargo verify
```

This verifies that the generated proof is valid for the given puzzle.

### 4. Run the Program

```bash
nargo execute
```

This runs the circuit with the inputs from `Prover.toml` and outputs the result.

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

2. **Run the proof generation**:
   ```bash
   nargo prove
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

2. **Compilation errors**:
   - Ensure all constraints are properly defined
   - Check array bounds and indices
   - Verify input format matches expected types

3. **Proof generation fails**:
   - Verify your solution is actually valid
   - Check that puzzle and solution arrays are 81 elements each
   - Ensure solution respects fixed puzzle numbers

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