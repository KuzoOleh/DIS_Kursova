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
                    // Set the timezone to UTC non-interactively and build the Docker image
                    sh 'export DEBIAN_FRONTEND=noninteractive && export TZ=UTC && apt-get install -y tzdata && docker build -t calculator-container .'
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
                    def scannerHome = tool 'sonarscanner'
		    withSonarQubeEnv('sonarqube') {
			sh "cd DIS_Kursova && ${scannerHome}/bin/sonar-scanner"
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

