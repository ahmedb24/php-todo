pipeline {
  agent any
  options {
    buildDiscarder(logRotator(numToKeepStr: '5'))
  }
  environment {
    DOCKERHUB_CREDENTIALS = credentials('dockerhub')
  }
  stages {
    stage('Build') {
      steps {
        sh 'docker build -t ahmedbello/php-todo:${GIT_LOCAL_BRANCH}-0.0.2 .'
      }
    }
    stage('Login') {
      steps {
        sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
      }
    }
    stage('Push') {
      steps {
        sh 'docker push ahmedbello/php-todo:${GIT_LOCAL_BRANCH}-0.0.2'
      }
    }
  }
  post {
    always {
      sh 'docker logout'
    }
  }
}