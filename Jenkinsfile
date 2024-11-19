pipeline {
    agent any
    options {
        timestamps()  // Add timestamps for better logging
    }

    stages {
        stage('Getting project') {
            steps {
                // Clone the project repository
                sh "rm -rf DIS_Kursova; git clone https://github.com/PolinaNechaiko/DIS_Kursova.git"
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Make sure Dockerfile is available and build the Docker image
                    sh 'docker build -t calculator-container .'
                }
            }
        }

        stage('Run Docker Container') {
            steps {
                script {
                    // Run the container, exposing the necessary port
                    sh 'docker run -d -p 18080:80 --name calculator-container calculator-container'
                }
            }
        }

        stage('SonarQube analysis') {
            steps {
                script {
                    // Run SonarQube analysis
                    def scannerHome = tool 'Scanner'  // Make sure you have SonarScanner configured in Jenkins
                    withSonarQubeEnv('sonarqube') {
                        // Run the SonarQube Scanner for your project
                        sh "cd DIS_Kursova && ${scannerHome}/bin/sonar-scanner"
                    }
                }
            }
        }

        stage('Quality Gate check') {
            steps {
                script {
                    // Wait for the quality gate to pass/fail
                    def qualityGate = waitForQualityGate('sonarqube')  // 'sonarqube' is the name of the SonarQube server in Jenkins
                    if (qualityGate.status != 'OK') {
                        error "Quality Gate failed: ${qualityGate.status}"
                    }
                }
            }
        }

        stage('Deploying Docker container') {
            steps {
                script {
                    def containerExists = sh(script: "docker ps -a -q -f name=calculator-container", returnStdout: true).trim()

                    if (containerExists) {
                        // Stop and remove the existing container if it exists
                        sh "docker stop calculator-container"
                        sh "docker rm calculator-container"
                    }

                    // Run the container with the new Docker image
                    sh "docker run -d -p 18080:80 --name calculator-container calculator-container"
                }
            }
        }
    }

    post {
        always {
            // Clean up after the build if necessary
            echo 'Cleaning up...'
        }
        success {
            echo 'Build and deployment completed successfully!'
        }
        failure {
            echo 'Build failed, please check the logs for errors.'
        }
    }
}

