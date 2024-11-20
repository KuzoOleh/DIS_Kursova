pipeline {
    agent any
    options {
        timestamps()
    }

    stages {
        stage('Getting project') {
            steps {
                // Clone the repository and change to the repo directory
                sh "rm -rf DIS_Kursova; git clone https://github.com/KuzoOleh/DIS_Kursova.git"
                dir('DIS_Kursova') {
                    script {
                        // Ensure we're in the right directory for subsequent commands
                        echo "Cloning the repository and moving to DIS_Kursova directory"
                    }
                }
            }
        }

        stage('SonarQube Analysis') {
            steps {
                script {
                    // Run SonarQube analysis
                    def scannerHome = tool 'sonarscanner'
                    withSonarQubeEnv('sonarqube') {
                        // Assuming the project is in the 'DIS_Kursova' directory
                        dir('DIS_Kursova') {
                            sh "${scannerHome}/bin/sonar-scanner"
                        }
                    }
                }
            }
        }

        stage('Build Application') {
            steps {
                script {
                    // Create the build directory, run cmake and make
                    dir('DIS_Kursova') {
                        // Create a build directory and run cmake & make
                        sh 'mkdir -p build'
                        sh 'cd build && cmake .. && make'
                    }
                }
            }
        }

        stage('Move Calculator Binary') {
            steps {
                script {
                    // Move the compiled binary (calculator) out of the build directory
                    dir('DIS_Kursova') {
                        sh 'mv build/calculator ./calculator'
                    }
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build the Docker image with the compiled binary
                    dir('DIS_Kursova') {
                        sh 'docker build -t calculator-container .'
                    }
                }
            }
        }

        stage('Run Docker Container') {
            steps {
                script {
                    // Run the Docker container
                    sh 'docker run -d -p 18080:18080 calculator-container'
                }
            }
        }

        stage('Verify Deployment') {
            steps {
                script {
                    // Ensure the container is running and accessible
                    sh 'docker ps -q -f "name=calculator-container" || echo "Container not running!"'
                    sh 'curl -f http://localhost:18080 || echo "App not responding!"'
                }
            }
        }
    }

    post {
        always {
            // Clean up after the build if necessary
            echo 'Cleaning up...'
            sh 'docker ps -a -q --filter "name=calculator-container" | xargs -I {} docker rm -f {} || true'
        }
        success {
            echo 'Build and deployment completed successfully!'
        }
        failure {
            echo 'Build failed, please check the logs for errors.'
        }
    }
}

