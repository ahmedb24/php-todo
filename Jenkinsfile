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
    stage('Build') {
      steps {
        //sh 'docker build -t ahmedbello/php-todo:${BRANCH_NAME}-0.0.2 .'
        sh 'docker compose -f todo.yaml up --build -d'
      }
    }
    stage('Login') {
      steps {
        sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
      }
    }
    stage('Test') { 
      steps {
        sh '''#!/bin/bash
          url=\'http://54.204.162.135/'
          attempts=5
          timeout=5
          online=false
          
          echo "Checking status of $url."
          
          for (( i=1; i<=$attempts; i++ ))
          do
            code=`curl -sL --connect-timeout 20 --max-time 30 -w "%{http_code}\\\\n" "$url" -o /dev/null`
          
            echo "Found code $code for $url."
          
            if [ "$code" = "200" ]; then
              echo "Website $url is online."
              online=true
              break
            else
              echo "Website $url seems to be offline. Waiting $timeout seconds."
              sleep $timeout
            fi
          done
          
          if $online; then
            echo "Monitor finished, website is online."
            exit 0
          else
            echo "Monitor failed, website seems to be down."
            exit 1
          fi'''
      }
    }
    stage('Push') {
      steps {
        sh 'docker tag ahmedbello/php-todo ahmedbello/php-todo:${GIT_BRANCH}-0.0.2'
        sh 'docker push ahmedbello/php-todo:${GIT_BRANCH}-0.0.2'
      }
    }
  }
  post {
    always {
      sh 'docker compose -f todo.yaml down'
      sh 'docker logout'
    }
  }
}