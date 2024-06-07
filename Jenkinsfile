pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'node-hello-world'
    }

    stages {
        stage('Build') {
            steps {
                script {
                    docker.build(DOCKER_IMAGE)
                }
            }
        }
        stage('Test') {
            steps {
                script {
                    docker.image(DOCKER_IMAGE).inside {
                        withEnv(["NPM_CONFIG_CACHE=/tmp/.npm-cache"]) {
                            sh '''
                                mkdir -p /tmp/.npm-cache
                                chown -R $(id -u):$(id -g) /tmp/.npm-cache
                                npm install --cache /tmp/.npm-cache
                                npm test --cache /tmp/.npm-cache
                            '''
                        }
                    }
                }
            }
        }
        stage('Deploy') {
            steps {
                script {
                    // Detener y eliminar contenedores antiguos con el mismo nombre
                    def existingContainer = sh(script: "docker ps -aq -f name=node-hello-world-container", returnStdout: true).trim()
                    if (existingContainer) {
                        sh "docker stop $existingContainer"
                        sh "docker rm $existingContainer"
                    } else {
                        echo "No running containers found with name node-hello-world-container"
                    }

                    // Iniciar un nuevo contenedor
                    sh "docker run -d -p 3000:3000 --name node-hello-world-container ${DOCKER_IMAGE}"
                }
            }
        }
    }
}
