        stage('SonarQube Analysis') {
            steps {
                // Bước chạy SonarQube Scanner
                withSonarQubeEnv('SonarQubeServer') {
                    sh "${tool 'sonarqube-scanner'}/bin/sonar-scanner"
                }
            }
        }
