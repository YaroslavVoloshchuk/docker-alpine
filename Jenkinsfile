pipeline {
   agent any
  
  environment {
    imagename = "docker-alpine"
    registry = '903120719010.dkr.ecr.us-east-1.amazonaws.com/docker-alpine'
    registryCredential = 'aws-access'    
  }
  
  stages {
    stage('Cloning Git') {
      steps {
        git([url: 'git@github.com:YaroslavVoloshchuk/docker-alpine.git', branch: 'develop', credentialsId: 'git-access'])

      }
    }
    stage('Building image') {
      steps{
        script {
          dockerImage = docker.build imagename  
        }
      }
    }
    stage('Doker save') {
      steps{
         sh "docker save $imagename | gzip > "phpsite_${v1.0 + env.BUILD_NUMBER}.tar.gz""
      }
    }    

    stage('Upload aftifact to S3') {
      steps{    
        withAWS(region: 'us-east-1', credentials: 'aws-access') {
                s3Upload(file: "phpsite_${v1.0 + env.BUILD_NUMBER}.tar.gz", bucket: 'docker-alpine', path: 'artifacts/"phpsite_${v1.0 + env.BUILD_NUMBER}.tar.gz"')
      } 
     }
    }   

    stage('Push image to ECR') {
      steps {
        script{  
         docker.withRegistry('https://903120719010.dkr.ecr.us-east-1.amazonaws.com', 'ecr:us-east-1:aws-access') {
            sh "docker tag $imagename 903120719010.dkr.ecr.us-east-1.amazonaws.com/docker-alpine-dev:latest"
            sh "docker tag $imagename 903120719010.dkr.ecr.us-east-1.amazonaws.com/docker-alpine-dev:v1.0.$BUILD_NUMBER"
            sh "docker push 903120719010.dkr.ecr.us-east-1.amazonaws.com/docker-alpine-dev:latest"
            sh "docker push 903120719010.dkr.ecr.us-east-1.amazonaws.com/docker-alpine-dev:v1.0.$BUILD_NUMBER"
        }
    }
      }    
}
    stage('Remove Unused docker image') {
      steps{              
        sh "docker rmi 903120719010.dkr.ecr.us-east-1.amazonaws.com/docker-alpine-dev:v1.0.$BUILD_NUMBER"
        sh "docker rmi 903120719010.dkr.ecr.us-east-1.amazonaws.com/docker-alpine-dev:latest"
      }
    }
    stage('CleanWorkspace') {
            steps {
                cleanWs()
            }
        }
  }
}
