pipeline {
    agent any
    options {
        timestamps()
    }
    stages {
        stage('Getting project') {
            steps {
                // Clone the repository
                sh "rm -rf DIS_Kursova; git clone https://github.com/KuzoOleh/DIS_Kursova.git"
            }
        }

        stage('Installing dependencies') {
            steps {
                // Install dependencies
                sh """
                sudo apt update
                sudo apt install -y g++ cmake libboost-all-dev
                """
            }
        }

        stage('Building project') {
            steps {
                // Build the C++ project
                sh """
                mkdir -p DIS_Kursova/build
                cd DIS_Kursova/build
                cmake ..
                make
                """
            }
        }

        stage('SonarQube analysis') {
            steps {
                script {
                    // Run SonarQube Scanner
                    withSonarQubeEnv('sonarqube') {
                        sh """
                        cd DIS_Kursova
                        sonar-scanner
                        """
                    }
                }
            }
        }

        stage('Quality Gate check') {
            steps {
                script {
                    // Wait for the quality gate to pass/fail
                    def qualityGate = waitForQualityGate()
                    if (qualityGate.status != 'OK') {
                        error "Quality Gate failed: ${qualityGate.status}"
                    }
                }
            }
        }

        stage('Building Docker image with Crow app') {
            steps {
                // Build Docker image for the C++ app
                sh """
                cd DIS_Kursova
                docker build -t calculator-container -f Dockerfile .
                """
            }
        }

        stage('Deploying Docker container') {
            steps {
                script {
                    // Stop and remove existing container if it exists
                    def containerExists = sh(script: "docker ps -a -q -f name=calculator-container", returnStdout: true).trim()

                    if (containerExists) {
                        sh """
                        docker stop calculator-container
                        docker rm calculator-container
                        """
                    }

                    // Run the new Docker container
                    sh """
                     docker run -d -p 8080:8080 --name calculator-container calculator
                    """
                }
            }
        }
    }
}

