pipeline {

  agent none
  environment {
    DOCKER_IMAGE = "ngoclqdocker/jenkins_asp_net_core"
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
			//sh "dotnet test" // Chạy các bài kiểm tra
		}
	}

	
	stage("deploy")
	{
		agent any
		steps{
			script{
				sshagent(['ssh-remote']) {
					sh 'ssh -o StrictHostKeyChecking=no -i ssh-remote root@192.168.10.6 touch deploy_jenkins_asp_net_core/test1.txt'
					//sh 'ssh -o StrictHostKeyChecking=no -i ssh-remote root@192.168.10.6 ./deploy_jenkins_asp_net_core/deploy.sh'
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
