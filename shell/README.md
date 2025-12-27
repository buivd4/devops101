# Shell Scripting Examples and Labs

This directory contains examples and hands-on labs for learning shell scripting, based on the KodeKloud Shell Scripting course.

## Directory Structure

```
shell/
├── examples/          # Working examples demonstrating concepts
├── labs/             # Lab exercises for practice
│   └── solutions/    # Solution files for labs (for instructors)
└── README.md         # This file
```

## Examples

The `examples/` directory contains working scripts that demonstrate various shell scripting concepts:

### 1. Basic Script (`01-first-script.sh`)
- Introduction to shell scripts
- Basic commands and output
- Shebang (`#!/bin/bash`)

### 2. Variables (`02-variables.sh`)
- Variable declaration and assignment
- Using variables with `$variable`
- Command substitution with `$(command)`
- Using curly braces `${variable}`

### 3. Command Line Arguments (`03-command-arguments.sh`)
- Accessing arguments with `$1`, `$2`, etc.
- `$0` for script name
- `$#` for argument count
- `$@` for all arguments

### 4. Control Logic (`04-control-logic.sh`)
- If/else statements
- While loops
- For loops
- Case statements

### 5. Functions (`05-functions.sh`)
- Function definition
- Function parameters
- Return values
- Local variables

### 6. Rocket Launch (`06-rocket-launch.sh`)
- Complete example combining all concepts
- Real-world scenario simulation
- Error handling

### 7. Arithmetic Operations (`07-arithmetic.sh`)
- Basic arithmetic with `$(( ))`
- Using `expr` and `let`
- Floating point operations with `bc`

### 8. File Operations (`08-file-operations.sh`)
- File existence checks
- File permissions
- File information

## Labs

The `labs/` directory contains hands-on exercises for you to complete:

### Lab 1: Basic Script
Create your first script that displays system information.

### Lab 2: Variables
Practice working with variables, command substitution, and variable expansion.

### Lab 3: Command Line Arguments
Build a script that accepts and processes command line arguments.

### Lab 4: Control Logic
Implement conditional statements and loops.

### Lab 5: Functions
Create reusable functions for calculations and operations.

### Lab 6: Complete Project
Build a comprehensive system information script using all learned concepts.

## Solutions

Solution files for all labs are available in `labs/solutions/` directory. These are provided for instructors or for self-checking after completing the exercises.

## How to Use

### Running Examples

1. Navigate to the examples directory:
   ```bash
   cd shell/examples
   ```

2. Make scripts executable:
   ```bash
   chmod +x *.sh
   ```

3. Run an example:
   ```bash
   ./01-first-script.sh
   ```

### Completing Labs

1. Navigate to the labs directory:
   ```bash
   cd shell/labs
   ```

2. Open a lab file in your editor:
   ```bash
   nano lab-01-basic-script.sh
   ```

3. Complete the TODO sections marked in the script.

4. Make it executable and test:
   ```bash
   chmod +x lab-01-basic-script.sh
   ./lab-01-basic-script.sh
   ```

## Best Practices

1. **Shebang**: Always start scripts with `#!/bin/bash`
2. **Naming**: Use descriptive names without `.sh` extension for executables
3. **Variables**: Use lowercase with underscores (e.g., `mission_name`)
4. **Quoting**: Always quote variables to prevent word splitting
5. **Error Handling**: Check for errors and exit codes
6. **Functions**: Use functions for reusable code
7. **Comments**: Add comments to explain complex logic

## ShellCheck

Use ShellCheck to validate your scripts:

```bash
# Install ShellCheck
# On Ubuntu/Debian:
sudo apt-get install shellcheck

# On RHEL/CentOS:
sudo yum install shellcheck

# Check a script
shellcheck lab-01-basic-script.sh
```

## Resources

- [ShellCheck](https://github.com/koalaman/shellcheck) - Shell script static analysis tool
- [Google Shell Style Guide](https://google.github.io/styleguide/shellguide.html)
- [Bash Guide](https://mywiki.wooledge.org/BashGuide)

## Learning Path

1. Start with `examples/01-first-script.sh` to understand basics
2. Work through examples 2-5 to learn core concepts
3. Study `examples/06-rocket-launch.sh` for a complete example
4. Complete labs 1-5 in order
5. Finish with lab 6 to demonstrate mastery

Good luck with your shell scripting journey! 🚀

