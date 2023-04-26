pipeline {
  agent any
  options {
    buildDiscarder(logRotator(numToKeepStr: '5'))
  }
  environment {
    DOCKERHUB_CREDENTIALS = credentials('dockerhub')
    GITHUB_CREDENTIALS = credentials('github')
  }
  stages {
    stage("Initial cleanup") {
       steps {
          dir("${WORKSPACE}") {
            deleteDir()
          }
       }
    }
    stage('Checkout') {
      steps {
        checkout([
          $class: 'GitSCM', 
          doGenerateSubmoduleConfigurations: false, 
          extensions: [],
          submoduleCfg: [], 
          // branches: [[name: '$branch']],
          userRemoteConfigs: [[url: "https://github.com/ahmedb24/php-todo.git ",credentialsId:'GITHUB_CREDENTIALS']] 	
          ])
          
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
      steps {
        environmentVariables {
          env('WEBSITE', websie)
          env('TIMEOUT', 5)
          env('ATTEMPTS', 5)
        }
      
        //Run a shell script from the workspace
        shell(readFileFromWorkspace('./check_status_code.sh'))
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
