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

        stage('Build Docker Image') {
            steps {
                script {
                    // Prevent tzdata interactive prompt and build the Docker image
                    sh 'export DEBIAN_FRONTEND=noninteractive && docker build -t calculator-container .'
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
                    withCredentials([string(credentialsId: 'sonar-token-id', variable: 'SONAR_TOKEN')]) {
                        sh 'sonar-scanner -Dsonar.login=${SONAR_TOKEN}'
                    }
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

