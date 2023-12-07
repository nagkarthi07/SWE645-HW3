pipeline {
    agent any
    tools {
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
                    try {
                        // Build and tag the Docker image using BuildKit
                        def dockerImage = "${DOCKER_IMAGE_NAME}:${TIMESTAMP}"
                        sh "DOCKER_BUILDKIT=1 docker build --progress=plain -t ${dockerImage} ."
                    } catch (Exception buildError) {
                        // Handle build error
                        currentBuild.result = 'FAILURE'
                        error "Failed to build Docker image: ${buildError}"
                    }
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
                    try {
                        withCredentials([file(credentialsId: "$KUBE_CONFIG", variable: 'KUBECONFIG')]) {
                            def deploymentName = 'pls'
                            def containerName = 'ydly'
                            def newImage = "${DOCKER_IMAGE_NAME}:${TIMESTAMP}"

                            sh "kubectl set image deployment/${deploymentName} ${containerName}=${newImage} --all"
                        }
                    } catch (Exception deploymentError) {
                        // Handle deployment error
                        currentBuild.result = 'FAILURE'
                        error "Failed to update Kubernetes deployment: ${deploymentError}"
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
