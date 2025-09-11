pipeline {
  agent any
  environment {
    DOCKER_IMAGE = "wajihamahek/spring-pet"   // ✅ your DockerHub repo
    IMAGE_TAG = "${env.BUILD_NUMBER}"
    K8S_MANIFEST = "k8s/deployment.yaml"
  }
  stages {
    stage('Checkout') {
      steps { checkout scm }
    }
    stage('Build with Maven') {
      steps {
        sh 'mvn -B -DskipTests package'
      }
    }
    stage('Docker Build') {
      steps {
        sh "docker build -t ${DOCKER_IMAGE}:${IMAGE_TAG} ."
      }
    }
    stage('Docker Push') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
          sh '''
            echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
            docker push ${DOCKER_IMAGE}:${IMAGE_TAG}
          '''
        }
      }
    }
    stage('Deploy to Kubernetes') {
      steps {
        sh '''
          sed "s|IMAGE_PLACEHOLDER|${DOCKER_IMAGE}:${IMAGE_TAG}|g" ${K8S_MANIFEST} > /tmp/deploy.yaml
          kubectl apply -f /tmp/deploy.yaml
          kubectl rollout status deployment/spring-pet-deployment --timeout=3m
        '''
      }
    }
  }
}
