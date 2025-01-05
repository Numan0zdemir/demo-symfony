pipeline {
    agent any
    environment {
        DOCKER_HUB_USER = 'numan0zdemir'
        DOCKER_HUB_PASS = credentials('dockerhub') // Jenkins Credential ID
        DOCKER_IMAGE = 'numan0zdemir/symfony-demo'
    }
    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', url: 'https://github.com/Numan0zdemir/demo-symfony.git'
            }
        }
        stage('Install Dependencies') {
            steps {
                sh 'composer install'
            }
        }
        stage('Run Unit Tests') {
            steps {
                sh './bin/phpunit'
            }
        }
        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $DOCKER_IMAGE .'
            }
        }
        stage('Push to Docker Hub') {
            steps {
                script {
                    sh '''
                        echo $DOCKER_HUB_PASS | docker login -u $DOCKER_HUB_USER --password-stdin
                        docker push $DOCKER_IMAGE
                    '''
                }
            }
        }
    }
    post {
        always {
            cleanWs()
        }
    }
}
