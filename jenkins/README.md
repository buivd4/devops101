# Jenkins Examples and Labs

This directory contains examples and hands-on labs for learning Jenkins CI/CD pipelines, based on the KodeKloud Jenkins course.

## Directory Structure

```
jenkins/
├── examples/          # Working examples demonstrating Jenkins concepts
│   ├── declarative/   # Declarative Pipeline examples
│   │   ├── 01-basic-pipeline/
│   │   ├── 02-stages/
│   │   ├── 03-docker-agent/
│   │   ├── 04-environment-variables/
│   │   ├── 05-conditional-stages/
│   │   ├── 06-post-actions/
│   │   ├── 07-parameters/
│   │   ├── 08-nodejs-pipeline/
│   │   ├── 09-parallel-stages/
│   │   └── 10-script-block/
│   └── scripted/      # Scripted Pipeline examples
│       ├── 01-basic/
│       ├── 02-stages/
│       ├── 03-conditional/
│       ├── 04-docker/
│       ├── 05-parameters/
│       ├── 06-error-handling/
│       ├── 07-parallel/
│       ├── 08-loops/
│       ├── 09-advanced/
│       └── 10-complete/
├── labs/             # Lab exercises for practice
│   ├── lab-01-basic-pipeline/
│   ├── lab-02-multiple-stages/
│   ├── lab-03-docker-agent/
│   ├── lab-04-environment-variables/
│   ├── lab-05-conditional-deployment/
│   ├── lab-06-post-actions/
│   ├── lab-07-parameters/
│   ├── lab-08-complete-pipeline/
│   └── solutions/    # Solution files for labs (for instructors)
└── README.md         # This file
```

## Examples

The `examples/` directory contains working Jenkinsfiles organized into two subdirectories:

- **`declarative/`**: Declarative Pipeline syntax (easier to learn, recommended for beginners)
- **`scripted/`**: Scripted Pipeline syntax (more flexible, Groovy-based)

### Declarative Pipeline Examples (`declarative/`)

### 1. Basic Pipeline (`declarative/01-basic-pipeline/Jenkinsfile`)
- Introduction to Declarative Pipeline syntax
- Basic pipeline structure with `pipeline`, `agent`, and `stages`
- Simple echo steps

### 2. Multiple Stages (`declarative/02-stages/Jenkinsfile`)
- Creating multiple stages in a pipeline
- Sequential stage execution
- Build, Test, and Deploy stages

### 3. Docker Agent (`declarative/03-docker-agent/Jenkinsfile`)
- Using Docker containers as build agents
- Docker agent configuration
- Volume mounting for caching

### 4. Environment Variables (`declarative/04-environment-variables/Jenkinsfile`)
- Defining environment variables
- Using built-in Jenkins environment variables
- Accessing variables in pipeline stages

### 5. Conditional Stages (`declarative/05-conditional-stages/Jenkinsfile`)
- Using `when` directive for conditional execution
- Branch-based conditional deployment
- Environment-specific stages

### 6. Post Actions (`declarative/06-post-actions/Jenkinsfile`)
- Post-build actions (`always`, `success`, `failure`, `unstable`)
- Cleanup operations
- Notifications based on build status

### 7. Pipeline Parameters (`declarative/07-parameters/Jenkinsfile`)
- Defining pipeline parameters (string, choice, boolean)
- Using parameters in pipeline stages
- Conditional execution based on parameters

### 8. Node.js Pipeline (`declarative/08-nodejs-pipeline/Jenkinsfile`)
- Complete Node.js application pipeline
- Dependency installation
- Running tests
- Building the application

### 9. Parallel Stages (`declarative/09-parallel-stages/Jenkinsfile`)
- Running stages in parallel
- Optimizing pipeline execution time
- Independent parallel tasks

### 10. Script Block (`declarative/10-script-block/Jenkinsfile`)
- Using `script` block for complex logic
- Groovy scripting in Declarative Pipelines
- Conditional logic and loops

### Scripted Pipeline Examples (`scripted/`)

Scripted Pipelines use Groovy syntax and offer more flexibility and control than Declarative Pipelines. They are ideal for complex workflows requiring advanced logic.

### 1. Basic (`scripted/01-basic/Jenkinsfile`)
- Introduction to Scripted Pipeline syntax
- Basic `node` block structure
- Simple stage execution

### 2. Stages (`scripted/02-stages/Jenkinsfile`)
- Multiple stages in Scripted Pipeline
- Sequential stage execution
- Build, Test, and Deploy workflow

### 3. Conditional (`scripted/03-conditional/Jenkinsfile`)
- Using Groovy if/else statements
- Conditional logic based on branch names
- Full control flow capabilities

### 4. Docker (`scripted/04-docker/Jenkinsfile`)
- Using Docker containers in Scripted Pipelines
- `docker.image().inside()` syntax
- Container-based builds

### 5. Parameters (`scripted/05-parameters/Jenkinsfile`)
- Defining parameters using `properties()`
- Handling parameters in Scripted Pipelines
- Parameter types (string, choice)

### 6. Error Handling (`scripted/06-error-handling/Jenkinsfile`)
- Try-catch blocks for error handling
- Setting build status manually
- Exception handling in pipelines

### 7. Parallel (`scripted/07-parallel/Jenkinsfile`)
- Parallel execution using `parallel()` function
- Running multiple tasks concurrently
- Parallel stage execution

### 8. Loops (`scripted/08-loops/Jenkinsfile`)
- Groovy loops and iteration
- Processing lists and collections
- Dynamic parallel builds using loops

### 9. Advanced (`scripted/09-advanced/Jenkinsfile`)
- Custom Groovy functions
- Closures and advanced Groovy features
- Complex logic and calculations

### 10. Complete (`scripted/10-complete/Jenkinsfile`)
- Complete CI/CD pipeline using Scripted syntax
- Combining all Scripted Pipeline concepts
- Real-world Node.js application pipeline

## Declarative vs Scripted Pipelines

Jenkins supports two types of Pipeline syntax:

### Declarative Pipeline (Examples 01-10)
- **Syntax**: Structured, domain-specific language
- **Format**: Uses `pipeline { }` block
- **Pros**: 
  - Easier to learn and read
  - Better validation and error checking
  - More restrictive, enforces best practices
- **Use When**: Most use cases, especially for beginners
- **Example**:
```groovy
pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                echo 'Building...'
            }
        }
    }
}
```

### Scripted Pipeline (Examples 11-20)
- **Syntax**: Full Groovy programming language
- **Format**: Uses `node { }` block
- **Pros**:
  - Maximum flexibility and control
  - Full access to Groovy features
  - Can handle complex logic and workflows
- **Cons**:
  - Steeper learning curve
  - Requires Groovy knowledge
  - Less validation
- **Use When**: Complex workflows requiring advanced logic
- **Example**:
```groovy
node {
    stage('Build') {
        echo 'Building...'
    }
}
```

**Recommendation**: Start with Declarative Pipelines, then learn Scripted when you need advanced features.

## Labs

The `labs/` directory contains hands-on exercises for you to complete:

### Lab 1: Basic Pipeline
Create your first Jenkins pipeline with a single stage that prints a greeting message.

### Lab 2: Multiple Stages
Build a pipeline with multiple sequential stages (Build, Test, Deploy).

### Lab 3: Docker Agent
Create a pipeline that uses a Docker agent and checks tool versions.

### Lab 4: Environment Variables
Practice defining and using environment variables in your pipeline.

### Lab 5: Conditional Deployment
Implement conditional deployment stages based on branch name.

### Lab 6: Post Actions
Add post-build actions to handle different build outcomes.

### Lab 7: Pipeline Parameters
Create parameterized pipelines for flexible builds.

### Lab 8: Complete Pipeline
Build a complete CI/CD pipeline combining all learned concepts.

## Solutions

Solution files for all labs are available in `labs/solutions/` directory. These are provided for instructors or for self-checking after completing the exercises.

## How to Use

### Prerequisites

1. **Jenkins Installation**: You need a Jenkins instance running. You can install Jenkins using:
   - Docker: `docker run -p 8080:8080 jenkins/jenkins:lts`
   - System package (Ubuntu/Debian): `sudo apt install jenkins`
   - WAR file: Download from [jenkins.io](https://www.jenkins.io/download/)

2. **Required Plugins**: Ensure the following plugins are installed:
   - Pipeline (usually pre-installed)
   - Docker Pipeline (for Docker agent examples)
   - Git (for SCM integration)

### Running Examples

1. **Create a Pipeline Job**:
   - Go to Jenkins Dashboard
   - Click "New Item"
   - Enter a job name
   - Select "Pipeline" as the project type
   - Click "OK"

2. **Configure the Pipeline**:
   - Scroll down to the "Pipeline" section
   - Select "Pipeline script from SCM" (for version control) OR
   - Select "Pipeline script" and paste the Jenkinsfile content directly

3. **Run the Pipeline**:
   - Click "Save"
   - Click "Build Now" to run the pipeline
   - View the build output in "Console Output"

### Completing Labs

1. **Copy Lab Files**:
   ```bash
   cd jenkins/labs/lab-01-basic-pipeline
   ```

2. **Open Jenkinsfile in your editor**:
   ```bash
   nano Jenkinsfile  # or use your preferred editor
   ```

3. **Complete the TODO sections** marked in the Jenkinsfile

4. **Test in Jenkins**:
   - Create a Pipeline job in Jenkins
   - Copy your completed Jenkinsfile content
   - Run the pipeline and verify it works correctly

5. **Compare with Solution** (optional):
   ```bash
   diff Jenkinsfile ../solutions/lab-01-solution/Jenkinsfile
   ```

## Jenkins Pipeline Concepts

### Declarative Pipeline Syntax

Jenkins Declarative Pipeline uses a structured, domain-specific syntax:

```groovy
pipeline {
    agent any  // or docker, label, etc.
    
    environment {
        // Environment variables
    }
    
    parameters {
        // Pipeline parameters
    }
    
    stages {
        stage('Stage Name') {
            steps {
                // Commands to execute
            }
        }
    }
    
    post {
        // Post-build actions
    }
}
```

### Key Components

- **Pipeline**: The top-level block that defines the entire pipeline
- **Agent**: Specifies where the pipeline runs (any, docker, label, etc.)
- **Stages**: Logical divisions of the pipeline workflow
- **Steps**: Individual commands executed within a stage
- **Environment**: Variables available throughout the pipeline
- **Parameters**: Inputs provided when triggering the pipeline
- **Post**: Actions executed after pipeline completion

### Scripted Pipeline Syntax

Scripted Pipelines use Groovy programming language:

```groovy
node {
    stage('Stage Name') {
        // Groovy code and pipeline steps
        echo 'Executing stage'
    }
}
```

### Common Steps

- `echo`: Print a message
- `sh`: Execute shell commands
- `script`: Execute Groovy code (Declarative only)
- `checkout scm`: Checkout source code from version control
- `archiveArtifacts`: Archive build artifacts
- `parallel`: Run stages in parallel
- `try-catch`: Error handling (Scripted only)

## Best Practices

1. **Version Control**: Always store Jenkinsfiles in version control (Git)
2. **Declarative First**: Start with Declarative Pipeline syntax, use Scripted when needed
3. **Environment Variables**: Use environment blocks for configuration
4. **Error Handling**: Use post actions (Declarative) or try-catch (Scripted) for failures
5. **Resource Efficiency**: Use Docker agents for consistent, isolated builds
6. **Parallel Execution**: Run independent stages in parallel to save time
7. **Code Reusability**: Use Shared Libraries for common functionality
8. **Security**: Use credentials plugin, never hardcode secrets
9. **Code Style**: Use consistent formatting and naming conventions
10. **Documentation**: Add comments to explain complex logic

## Learning Path

### Declarative Pipelines (Recommended Starting Point)
1. Start with `examples/declarative/01-basic-pipeline` to understand the basics
2. Work through examples 2-7 to learn core Declarative concepts
3. Study `examples/declarative/08-nodejs-pipeline` for a real-world example
4. Explore `examples/declarative/09-parallel-stages` and `10-script-block` for advanced features
5. Complete labs 1-8 in order to practice your skills

### Scripted Pipelines (Advanced)
1. Review `examples/scripted/01-basic` to understand Scripted syntax
2. Study examples 2-5 for core Scripted Pipeline concepts
3. Explore examples 6-9 for advanced Groovy features
4. Review `examples/scripted/10-complete` for a comprehensive example
5. Practice by converting Declarative examples to Scripted syntax

## Additional Resources

- [Jenkins Official Documentation](https://www.jenkins.io/doc/)
- [Pipeline Syntax Reference](https://www.jenkins.io/doc/book/pipeline/syntax/)
- [Jenkins Pipeline Best Practices](https://www.jenkins.io/doc/book/pipeline/pipeline-best-practices/)
- [Groovy Language Documentation](https://groovy-lang.org/documentation.html)

## Course Topics Covered

Based on the KodeKloud Jenkins course, these examples and labs cover:

- Jenkins Architecture (Controller, Nodes, Agents, Executors)
- **Declarative Pipeline syntax** (`examples/declarative/`)
  - Pipeline structure, stages, steps
  - Agents (any, docker, label-based)
  - Environment Variables
  - Conditional Execution (when directive)
  - Post-build Actions
  - Pipeline Parameters
  - Parallel Execution
  - Script Blocks
- **Scripted Pipeline syntax** (`examples/scripted/`)
  - Groovy-based pipelines
  - Node blocks and stages
  - Conditional logic and loops
  - Error handling (try-catch)
  - Parallel execution
  - Advanced Groovy features
- Docker Integration
- Node.js Application Pipelines

Good luck with your Jenkins CI/CD journey! 🚀

