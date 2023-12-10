pipeline {

  agent none
  environment {
    DOCKER_IMAGE = "ngoclqdocker/jenkins_asp_net_core"
    JAVA_HOME = "/opt/java/openjdk"
  }
  stages {
    stage("Test") {
		agent {
			docker {
				image 'mcr.microsoft.com/dotnet/sdk:3.1' // Sử dụng image SDK của .NET Core
				args '-u 0:0 -v /tmp:/root/.nuget' // Có thể cần thay đổi đường dẫn tùy theo cấu trúc dự án
			}
		}
		steps {
			sh "dotnet restore" // Sử dụng dotnet restore để khôi phục các gói NuGet
			sh "dotnet build" // Xây dựng ứng dụng
			//sh "apt-get update"
      			//sh "apt-get install --yes openjdk-11-jre"
		     	sh "dotnet tool install --global dotnet-sonarscanner"
		      	sh "export PATH=\"$PATH:$HOME/.dotnet/tools\""
			//sh "dotnet test" // Chạy các bài kiểm  tra
			withSonarQubeEnv('Sonarqube-jenkins-docker') {
			sh "dotnet ${tool 'SonarScannerforMSBuild'}/SonarScanner.MSBuild.dll begin /k:\"jenkins_asp_net_core\""
			sh "dotnet build"
			sh "dotnet ${tool 'SonarScannerforMSBuild'}/SonarScanner.MSBuild.dll end"
		}
		}
	}
	stage("build")
	{
		//agent { node { label 'master'} }
		agent any
		environment {
			DOCKER_TAG = "${GIT_BRANCH.tokenize('/').pop()}-${GIT_COMMIT.substring(0,7)}"
		}
		steps {
			sh "docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} . "
		  sh "docker tag ${DOCKER_IMAGE}:${DOCKER_TAG} ${DOCKER_IMAGE}:latest"
		  sh "docker image ls | grep ${DOCKER_IMAGE}"
		  withCredentials([usernamePassword(credentialsId: 'docker-hub', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
				sh 'echo $DOCKER_PASSWORD | docker login --username $DOCKER_USERNAME --password-stdin'
				sh "docker push ${DOCKER_IMAGE}:${DOCKER_TAG}"
				sh "docker push ${DOCKER_IMAGE}:latest"
		}

			//clean to save disk
			sh "docker image rm ${DOCKER_IMAGE}:${DOCKER_TAG}"
			sh "docker image rm ${DOCKER_IMAGE}:latest"
		}
	}
	stage("deploy")
	{
		agent any
		steps{
			script{
				sshagent(['ssh-remote']) {
					sh 'ssh -o StrictHostKeyChecking=no -i ssh-remote root@192.168.10.6 touch deploy_jenkins_asp_net_core/test1.txt'
					sh 'ssh -o StrictHostKeyChecking=no -i ssh-remote root@192.168.10.6 ./deploy_jenkins_asp_net_core/deploy.sh'
				}
			}
		}
	}
  }

  post {
    success {
      echo "SUCCESSFUL"
    }
    failure {
      echo "FAILED"
    }
  }
}
