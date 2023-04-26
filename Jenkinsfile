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
  //  stage("Initial cleanup") {
  //     steps {
  //        dir("${WORKSPACE}") {
  //          deleteDir()
  //        }
  //     }
  //  }
  //  stage('Checkout') {
  //    steps {
  //      checkout([
  //        $class: 'GitSCM', 
  //        doGenerateSubmoduleConfigurations: false, 
  //        extensions: [],
  //        submoduleCfg: [], 
  //        // branches: [[name: '$branch']],
  //        userRemoteConfigs: [[url: "https://github.com/ahmedb24/php-todo.git ",credentialsId:'GITHUB_CREDENTIALS']] 	
  //        ])
  //        
  //      }
  //    }
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
        sh '''#!/bin/bash
          url=\'http://website-to-test\'
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
        // sh '/var/lib/docker/volumes/jenkins_home/_data/workspace/jenkins-dockerhub_main/check_status_code'      
        //environmentVariables {
        //  env('WEBSITE', websie)
        //  env('TIMEOUT', 5)
        //  env('ATTEMPTS', 5)
        //}
      
        ////Run a shell script from the workspace
        //shell(readFileFromWorkspace('./check_status_code.sh'))
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
