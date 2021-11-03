pipeline {
   agent any
  
  environment {
    imagename = "bamik/docker-alpine"
    registry = '903120719010.dkr.ecr.us-east-1.amazonaws.com/docker-alpine'
    registryCredential = 'aws-access'
    DOCKERHUB_CREDENTIALS=credentials('dockerhub-access')
  }
  
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
        sh "docker save $imagename | gzip > phpsite_latest.tar.gz"
      }
    }    

    stage('Upload aftifact to S3') {
      steps{    
        withAWS(region: 'us-east-1', credentials: 'aws-access') {
                s3Upload(file: 'phpsite_latest.tar.gz', bucket: 'docker-alpine', path: 'artifacts/phpsite_latest.tar.gz')
      } 
     }
    }   
    stage('Deploy Image to DockerHub') {
      steps{
        sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
        sh "docker tag $imagename $imagename:latest" 
        sh "docker tag $imagename:latest $imagename:v1.0.$BUILD_NUMBER"
        sh "docker push $imagename:latest && docker push $imagename:v1.0.$BUILD_NUMBER"
        
      }
    }

    stage('Push image to ECR') {
      steps {
        script{  
         docker.withRegistry('https://903120719010.dkr.ecr.us-east-1.amazonaws.com', 'ecr:us-east-1:aws-access') {
            sh "docker tag $imagename:latest 903120719010.dkr.ecr.us-east-1.amazonaws.com/docker-alpine:latest"
            sh "docker tag $imagename:v1.0.$BUILD_NUMBER 903120719010.dkr.ecr.us-east-1.amazonaws.com/docker-alpine:v1.0.$BUILD_NUMBER"
            sh "docker push 903120719010.dkr.ecr.us-east-1.amazonaws.com/docker-alpine:latest"
            sh "docker push 903120719010.dkr.ecr.us-east-1.amazonaws.com/docker-alpine:v1.0.$BUILD_NUMBER"
        }
    }
      }    
}
    stage('Remove Unused docker image') {
      steps{
        sh "docker rmi $imagename:v1.0.$BUILD_NUMBER"
        sh "docker rmi $imagename:latest"
        sh "docker rmi 903120719010.dkr.ecr.us-east-1.amazonaws.com/docker-alpine:v1.0.$BUILD_NUMBER"
        sh "docker rmi 903120719010.dkr.ecr.us-east-1.amazonaws.com/docker-alpine:latest"

      }
    }
    stage('CleanWorkspace') {
            steps {
                cleanWs()
            }
        }
  }
}
