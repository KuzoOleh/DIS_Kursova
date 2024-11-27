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

        stage('Build Application') {
            steps {
                script {
                    // Create build directory, configure cmake, and make the application
                    sh '''
		    mkdir -p DIS_Kursova/build
		    cd DIS_Kursova/build
		    cmake ..
		    make
		    '''
                }
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

pipeline {
    agent any
    stages {
        stage('Run Docker Container') {
            steps {
                script {
                    // Delete previous container if it exists
                    sh '''
                    if [ "$(docker ps -a -q -f name=calculator-container)" ]; then
                        echo "Stopping and removing existing container"
                        docker stop calculator-container
                        docker rm calculator-container
                    fi
                    '''
                    
                    // Run the container, exposing the necessary port
                    echo "Starting new container"
                    sh 'docker run -d --name calculator-container -p 18080:18080 calculator-container'
                }
            }
        }

        stage('Verify Deployment') {
            steps {
                script {
                    // Ensure the container is running and accessible
                    def containerStatus = sh(script: 'docker ps -q -f "name=calculator-container"', returnStdout: true).trim()
                    
                    if (containerStatus) {
                        echo "Container is running"
                    } else {
                        echo "Container not running!"
                    }

                    // Test if the application inside the container is accessible
                    try {
                        sh 'curl -f http://localhost:18080'
                        echo "App is responding!"
                    } catch (Exception e) {
                        echo "App not responding!"
                    }
                }
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

