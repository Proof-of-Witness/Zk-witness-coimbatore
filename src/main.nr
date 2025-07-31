// Sudoku puzzle verification circuit
// Proves that a solution is valid for a given puzzle without revealing the full solution

fn main(
    // Public inputs
    puzzle: pub [u8; 81], // 9x9 grid flattened to 1D array
    // Private inputs  
    solution: [u8; 81] // 9x9 solution grid flattened to 1D array
) {
    // Convert 1D arrays to 2D for easier manipulation
    let puzzle_2d = array_to_2d(puzzle);
    let solution_2d = array_to_2d(solution);
    
    // Constraint 1: Fixed Cell Constraint
    // If puzzle[i][j] != 0, then solution[i][j] == puzzle[i][j]
    for i in 0..9 {
        for j in 0..9 {
            let puzzle_cell = puzzle_2d[i][j];
            let solution_cell = solution_2d[i][j];
            
            // If puzzle cell is not empty (not 0), solution must match
            if puzzle_cell != 0 {
                assert(solution_cell == puzzle_cell);
            }
        }
    }
    
    // Constraint 2: Valid Digit Constraint
    // All solution[i][j] must be in range [1, 9]
    for i in 0..9 {
        for j in 0..9 {
            let cell = solution_2d[i][j];
            assert(cell >= 1);
            assert(cell <= 9);
        }
    }
    
    // Constraint 3: Row Uniqueness
    // Each row should have unique digits 1-9
    for row in 0..9 {
        check_uniqueness(get_row(solution_2d, row));
    }
    
    // Constraint 4: Column Uniqueness  
    // Each column should have unique digits 1-9
    for col in 0..9 {
        check_uniqueness(get_column(solution_2d, col));
    }
    
    // Constraint 5: 3x3 Box Uniqueness
    // Every 3x3 sub-grid should have unique digits 1-9
    for box_row in 0..3 {
        for box_col in 0..3 {
            check_uniqueness(get_3x3_box(solution_2d, box_row, box_col));
        }
    }
}

// Helper function to convert 1D array to 2D 9x9 grid
fn array_to_2d(arr: [u8; 81]) -> [[u8; 9]; 9] {
    let mut result: [[u8; 9]; 9] = [[0; 9]; 9];
    
    for i in 0..9 {
        for j in 0..9 {
            result[i][j] = arr[i * 9 + j];
        }
    }
    
    result
}

// Helper function to get a row from 2D grid
fn get_row(grid: [[u8; 9]; 9], row: u8) -> [u8; 9] {
    grid[row as u32]
}

// Helper function to get a column from 2D grid
fn get_column(grid: [[u8; 9]; 9], col: u8) -> [u8; 9] {
    let mut result: [u8; 9] = [0; 9];
    
    for i in 0..9 {
        result[i] = grid[i][col as u32];
    }
    
    result
}

// Helper function to get a 3x3 box from 2D grid
fn get_3x3_box(grid: [[u8; 9]; 9], box_row: u8, box_col: u8) -> [u8; 9] {
    let mut result: [u8; 9] = [0; 9];
    let mut idx = 0;
    
    for i in 0..3 {
        for j in 0..3 {
            let row = box_row * 3 + i;
            let col = box_col * 3 + j;
            result[idx] = grid[row as u32][col as u32];
            idx += 1;
        }
    }
    
    result
}

// Helper function to check if all elements in array are unique (1-9)
fn check_uniqueness(arr: [u8; 9]) {
    // Check that each digit 1-9 appears exactly once
    for digit in 1..10 {
        let mut count = 0;
        for i in 0..9 {
            if arr[i] == digit {
                count += 1;
            }
        }
        assert(count == 1);
    }
}
