pipeline {
    agent any
    options{
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
                    // Make sure the Dockerfile is available and build the Docker image
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

