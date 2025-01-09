pipeline {
    agent any
    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub')
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
        stage('Code Analysis') {
            environment {
                scannerHome = tool 'Sonar'
            }
            steps {
                script {
                    withSonarQubeEnv('Sonar') {
                        sh """
                            ${scannerHome}/bin/sonar-scanner \
                            -Dsonar.projectKey=jenkins-demo \
                            -Dsonar.projectName=jenkins-demo
                        """
                    }
                }
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
                        echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin
                        docker push $DOCKER_IMAGE
                    '''
                }
            }
        }
        stage('Verify Deployment') {
            steps {
                withKubeCredentials(kubectlCredentials: [[caCertificate: '', clusterName: 'test', contextName: '', credentialsId: 'k8s-secret-token', namespace: 'webapps', serverUrl: 'https://7D46154418F0883CAE8C8903F4465390.gr7.eu-central-1.eks.amazonaws.com']]) {
                    sh "kubectl apply -f helm-charts/configmap-app.yaml"
                    sh "kubectl apply -f helm-charts/deployment-app.yaml"
                    sh "kubectl wait --for=condition=available --timeout=300s deployment -l app=symfony-app -n webapps"
                    sh "kubectl apply -f helm-charts/service-app.yaml"
                    sh "kubectl apply -f helm-charts/ingress-app.yaml"
                    sh "kubectl get pods -n webapps"
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
