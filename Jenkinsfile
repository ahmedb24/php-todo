pipeline {
  agent any
  options {
    buildDiscarder(logRotator(numToKeepStr: '5'))
  }
  environment {
    DOCKERHUB_CREDENTIALS = credentials('dockerhub')
  }
  stages {
    stage('Starter') {
      steps {
        sh 'echo '
      }
    }
    stage('Build') {
      steps {
        sh 'docker build -t ahmedbello/php-todo:${BRANCH_NAME}-0.0.2 .'
      }
    }
    stage('Login') {
      steps {
        sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
      }
    }
    stage('Test') { 
        HTTP_CODE = sh (
                    script: 'echo $(curl --write-out \\"%{http_code}\\" --silent --output /dev/null http://localhost/)',
                    returnStdout: true
                ).trim()
        echo HTTP_CODE
        if ('200' != HTTP_CODE) {
            currentBuild.result = "FAILURE"
            error('Test stage failed!)
        }
    }
    stage('Push') {
      steps {
        sh 'docker push ahmedbello/php-todo:${GIT_BRANCH}-0.0.2'
      }
    }
  }
  post {
    always {
      sh 'docker logout'
    }
  }
}