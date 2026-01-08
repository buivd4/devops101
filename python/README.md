# Python Examples and Labs

This directory contains examples and hands-on labs for learning Python, based on Python programming fundamentals.

## Directory Structure

```
python/
├── examples/          # Working examples demonstrating concepts
├── labs/             # Lab exercises for practice
│   └── solutions/    # Solution files for labs (for instructors)
└── README.md         # This file
```

## Examples

The `examples/` directory contains working scripts that demonstrate various Python concepts:

### 1. Basic Script (`01-first-script.py`)
- Introduction to Python scripts
- Basic print statements
- Importing standard library modules
- Working with datetime and os modules

### 2. Variables (`02-variables.py`)
- Variable declaration and assignment
- Different data types (int, float, bool, str, list, dict)
- Type checking with `type()`
- String formatting with f-strings

### 3. Command Line Arguments (`03-command-arguments.py`)
- Accessing arguments with `sys.argv`
- Argument validation
- Using command-line inputs

### 4. Control Logic (`04-control-logic.py`)
- If/elif/else statements
- For loops and range()
- While loops
- List iteration
- List comprehensions
- Dictionary iteration

### 5. Functions (`05-functions.py`)
- Function definition
- Function parameters and return values
- Default parameters
- Multiple return values
- Lambda functions
- Function documentation with docstrings

### 6. File Operations (`06-file-operations.py`)
- Reading from files
- Writing to files
- Appending to files
- File existence checks
- Working with file paths

### 7. Data Structures (`07-data-structures.py`)
- Lists (mutable, ordered)
- Tuples (immutable, ordered)
- Dictionaries (key-value pairs)
- Sets (unique elements)
- List and dictionary comprehensions

### 8. Error Handling (`08-error-handling.py`)
- Try/except blocks
- Multiple exception types
- Try/except/else/finally
- Raising exceptions
- Using assert statements

## Labs

The `labs/` directory contains hands-on exercises for you to complete:

### Lab 1: Basic Script
Create your first script that displays system information using Python.

### Lab 2: Variables
Practice working with variables, data types, and dictionaries.

### Lab 3: Command Line Arguments
Build a script that accepts and processes command line arguments.

### Lab 4: Control Logic
Implement conditional statements, loops, and iteration.

### Lab 5: Functions
Create reusable functions for calculations and operations.

### Lab 6: Complete Project
Build a comprehensive mission control system using all learned concepts.

## Solutions

Solution files for all labs are available in `labs/solutions/` directory. These are provided for instructors or for self-checking after completing the exercises.

## How to Use

### Running Examples

1. Navigate to the examples directory:
   ```bash
   cd python/examples
   ```

2. Make scripts executable (optional):
   ```bash
   chmod +x *.py
   ```

3. Run an example:
   ```bash
   python3 01-first-script.py
   ```
   Or if executable:
   ```bash
   ./01-first-script.py
   ```

### Completing Labs

1. Navigate to the labs directory:
   ```bash
   cd python/labs
   ```

2. Open a lab file in your editor:
   ```bash
   nano lab-01-basic-script.py
   # or
   code lab-01-basic-script.py
   ```

3. Complete the TODO sections marked in the script.

4. Run and test your solution:
   ```bash
   python3 lab-01-basic-script.py
   ```

5. Compare with the solution (after attempting):
   ```bash
   python3 solutions/lab-01-solution.py
   ```

## Best Practices

1. **Shebang**: Always start scripts with `#!/usr/bin/env python3`
2. **Style**: Follow PEP 8 style guide
3. **Documentation**: Use docstrings for functions and modules
4. **Error Handling**: Use try/except blocks for error handling
5. **Type Hints**: Consider using type hints for function parameters (advanced)
6. **Imports**: Import modules at the top of the file
7. **Comments**: Add comments to explain complex logic
8. **Variable Names**: Use descriptive names with underscores (snake_case)

## Python Version

All examples and labs are written for Python 3. Make sure you have Python 3 installed:

```bash
python3 --version
```

## Virtual Environments (Recommended)

It's good practice to use virtual environments for Python projects:

```bash
# Create a virtual environment
python3 -m venv venv

# Activate it
# On macOS/Linux:
source venv/bin/activate
# On Windows:
venv\Scripts\activate

# Deactivate when done
deactivate
```

## Testing Your Code

You can test your code using Python's built-in testing or by running the examples:

```bash
# Run with error checking
python3 -m py_compile lab-01-basic-script.py

# Run with warnings
python3 -W all lab-01-basic-script.py
```

## Resources

- [Python Documentation](https://docs.python.org/3/)
- [PEP 8 Style Guide](https://pep8.org/)
- [Real Python Tutorials](https://realpython.com/)
- [Python.org Tutorial](https://docs.python.org/3/tutorial/)
- [Python for Beginners](https://www.python.org/about/gettingstarted/)

## Learning Path

1. Start with `examples/01-first-script.py` to understand basics
2. Work through examples 2-5 to learn core concepts
3. Study `examples/06-file-operations.py` and `07-data-structures.py` for more advanced topics
4. Complete labs 1-5 in order
5. Finish with lab 6 to demonstrate mastery

Good luck with your Python journey! 🐍




