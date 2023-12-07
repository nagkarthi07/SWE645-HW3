pipeline {
    agent any
    tools{
        maven 'Maven'
    }
    environment {
        DOCKER_HUB_CREDENTIALS = credentials('akhpng31') // Update with your Docker Hub credentials ID
        GIT_REPO = 'https://github.com/nagkarthi07/SWE645-HW3.git' // Update with your GitHub repository URL
        DOCKER_IMAGE_NAME = 'akhpng31/survey4'
        TIMESTAMP = new Date().format('yyyyMMdd-HHmmss')
        KUBE_CONFIG = 'kubeconfig'
        
    }
    
    stages {
        stage('Clone Repository and Build JAR') {
            steps {
                script {
                    git url: GIT_REPO
                    sh 'mvn clean package'
                    sh 'cp target/HW3-0.0.1-SNAPSHOT.jar ${WORKSPACE}/app.jar'
                }
            }
        }
    
            stage('Build Docker Image') {
                steps {
                    script {
                        // Build and tag the Docker image
                        def dockerImage = "${DOCKER_IMAGE_NAME}:${TIMESTAMP}"
                        sh "docker build -t ${dockerImage} ."
                       
                        }
                    }
                }

            
        stage('Push Docker Image to Docker Hub') {
            steps {
                script {
                    def dockerImage = "${DOCKER_IMAGE_NAME}:${TIMESTAMP}"

                    // Docker login
                    sh "docker login -u akhpng31 -p akhpngubuntu"

                    // Push the Docker image to Docker Hub
                    sh "docker push ${dockerImage}"

                    }
                }
            }
        

        stage('Update Kubernetes Deployments') {
            steps {
                script {
                    withCredentials([file(credentialsId: "$KUBE_CONFIG", variable: 'KUBECONFIG')]) {
                        sh "kubectl set image deployment/spring-boot-deployment spring-boot-container=${DOCKER_IMAGE_NAME}:${TIMESTAMP} --all"
                    }
                }
            }
        }
    }
    
    post {
        success {
            echo 'Jenkins Pipeline executed successfully!'
        }
        failure {
            echo 'Jenkins Pipeline failed!'
        }
    }
}
