pipeline {
    agent any
    environment {
        // Set the path to SonarScanner
        SONAR_SCANNER_HOME = "/opt/sonar-scanner-4.8.0.2856-linux"
        PATH = "${SONAR_SCANNER_HOME}/bin:${env.PATH}"
        // Set your SonarQube token here
        SONAR_TOKEN = "squ_a9ce58bee1a5403bb2f224011149144cb107303e"  // Replace with your actual token
    }
    options {
        timestamps()  // Show timestamps in the log
    }
    stages {
        stage('Checkout Project') {
            steps {
                // Clone the repository or get the project from your SCM
                checkout scm
            }
        }

        stage('SonarQube Analysis') {
            steps {
                script {
                    // Run SonarQube scanner with the provided token
                    sh "sonar-scanner -Dsonar.login=${env.SONAR_TOKEN}"
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build Docker image (update according to your needs)
                    sh """
                    docker build -t my-app-image -f ./Dockerfile .
                    """
                }
            }
        }

        stage('Deploy Docker Container') {
            steps {
                script {
                    // Stop and remove any existing container if it exists
                    def containerExists = sh(script: "docker ps -a -q -f name=my-app-container", returnStdout: true).trim()
                    if (containerExists) {
                        sh """
                            docker stop my-app-container
                            docker rm my-app-container
                        """
                    }
                    // Run the container with the new image
                    sh """
                        docker run -d -p 80:80 --name my-app-container my-app-image
                    """
                }
            }
        }
    }
    post {
        always {
            // Clean up any resources if necessary
            echo 'Pipeline finished.'
        }
        success {
            // Actions to perform on success, like sending notifications
            echo 'Build and analysis successful!'
        }
        failure {
            // Actions to perform on failure
            echo 'Build failed.'
        }
    }
}

