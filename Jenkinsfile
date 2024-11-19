pipeline {
    agent any

    environment {
        // Set the timezone environment variable non-interactively
        TZ = 'America/New_York'  // You can change this to your desired time zone
    }

    stages {
        stage('Setup Time Zone') {
            steps {
                script {
                    // Configure the system to avoid interactive tzdata prompts
                    sh 'export DEBIAN_FRONTEND=noninteractive && sudo apt-get install -y tzdata'
                    sh "sudo timedatectl set-timezone ${env.TZ}"
                }
            }
        }

        stage('Checkout Code') {
            steps {
                script {
                    // Checkout the code from your repository
                    checkout scm
                }
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
                    sh 'docker run -d -p 18080:80 calculator-container'
                }
            }
        }

        stage('SonarQube Analysis') {
            steps {
                script {
                    // Run SonarQube analysis
                    sh 'sonar-scanner -Dsonar.login=${SONAR_TOKEN}'
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    // Deploy your app, for example, to a cloud or a server
                    echo 'Deploying the app...'
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

