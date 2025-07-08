@Library('shared') _

pipeline {
    agent any

    environment {
        scanner_home = tool 'SonarQube-Scanner'
    }

    parameters {
        string(name: 'FRONTEND_DOCKER_TAG', defaultValue: '', description: 'Setting docker image for latest push')
        string(name: 'BACKEND_DOCKER_TAG', defaultValue: '', description: 'Setting docker image for latest push')
        choice(
            name: 'START_FROM_STAGE',
            choices: [
                'ALL',
                'Validate Parameter',
                'Clean Workspace',
                'Git: Code CheckOut',
                'GitLeaks: Check HardCode Pass',
                'Trivy: File System Scan',
                'OWASP: Dependency Check',
                'SonarQube: Code Analysis',
                'SonarQube: Code Quality Gates',
                'Exporting environment variables',
                'Docker: Build Image',
                'Docker: Push to DockerHub'
            ],
            description: 'Select stage to start from'
        )
    }

    stages {
        stage('Initialize') {
            steps {
                script {
                    stageReached = false
                    def stageList = [
                        'Validate Parameter',
                        'Clean Workspace',
                        'Git: Code CheckOut',
                        'GitLeaks: Check HardCode Pass',
                        'Trivy: File System Scan',
                        'OWASP: Dependency Check',
                        'SonarQube: Code Analysis',
                        'SonarQube: Code Quality Gates',
                        'Exporting environment variables',
                        'Docker: Build Image',
                        'Docker: Push to DockerHub'
                    ]
                    shouldRun = { stageName ->
                        if (params.START_FROM_STAGE == 'ALL') {
                            return true
                        }
                        if (params.START_FROM_STAGE == stageName || stageReached) {
                            stageReached = true
                            return true
                        }
                        return false
                    }
                }
            }
        }

        stage('Validate Parameter') {
            when {
                expression { shouldRun('Validate Parameter') }
            }
            steps {
                script {
                    if (
                        params.FRONTEND_DOCKER_TAG == "" || 
                        params.BACKEND_DOCKER_TAG == "" || 
                        params.START_FROM_STAGE == ""
                    ) {
                        error("FRONTEND_DOCKER_TAG and BACKEND_DOCKER_TAG must be provided.")
                    }
                }
            }
        }

        stage('Clean Workspace') {
            when {
                expression { shouldRun('Clean Workspace') }
            }
            steps {
                echo "Clean workspace"
                // cleanWs()
            }
        }

        stage('Git: Code CheckOut') {
            when {
                expression { shouldRun('Git: Code CheckOut') }
            }
            steps {
                script{
                    git_checkout('https://github.com/sureshkumar-devops/Wanderlust-Mega-Project.git', 'main')
                }
            }
        }

        stage('GitLeaks: Check HardCode Pass') {
            when {
                expression { shouldRun('GitLeaks: Check HardCode Pass') }
            }
            steps {
                script{
                    //sh 'gitleaks detect --source . -r gitleaks-report.json -f json'    
                    echo "Git Leaks"
                }
            }
        }

        stage('Trivy: File System Scan') {
            when {
                expression { shouldRun('Trivy: File System Scan') }
            }
            steps{
                script{
                    trivy_fscan()
                }
            }
        }

        stage('OWASP: Dependency Check') {
            when {
                expression { shouldRun('OWASP: Dependency Check') }
            }
            steps{
                script{
                    owasp_dependency()
                }
            }
        }

        stage('SonarQube: Code Analysis') {
            when {
                expression { shouldRun('SonarQube: Code Analysis') }
            }
            steps {
                script{
                   sonarqube_analysis("SonarQube-Server", "wanderlust", "wanderlust")
                }
            }
        }

        stage('SonarQube: Code Quality Gates') {
            when {
                expression { shouldRun('SonarQube: Code Quality Gates') }
            }
            steps {
                script{
                  sonarqube_code_quality()
                }
            }
        }

        stage('Exporting environment variables') {
            when {
                expression { shouldRun('Exporting environment variables') }
            }
            parallel {
                stage('Backend env setup') {
                    steps {
                        dir("Automations") {
                            sh "bash updatebackendnew.sh"
                        }
                    }
                }
                stage('Frontend env setup') {
                    steps {
                        dir("Automations") {
                            sh "bash updatefrontendnew.sh"
                        }
                    }
                }
            }
        }

        stage('Docker: Build Image') {
            when {
                expression { shouldRun('Docker: Build Image') }
            }
            steps {
                script{
                    dir('backend'){
                        docker_build("wanderlust-backend-beta","${params.BACKEND_DOCKER_TAG}", "lehardocker")
                    }
                    dir('frontend'){
                        docker_build("wanderlust-frontend-beta","${params.FRONTEND_DOCKER_TAG}", "lehardocker")
                    }
                }
            }
        }

        stage('Docker: Push to DockerHub') {
            when {
                expression { shouldRun('Docker: Push to DockerHub') }
            }
            steps{
                 script{
                 docker_push("wanderlust-backend-beta","${params.BACKEND_DOCKER_TAG}","lehardocker")
                 docker_push("wanderlust-frontend-beta","${params.FRONTEND_DOCKER_TAG}","lehardocker")                  
                }
            }
        }
<<<<<<< HEAD
    }

   post {
        success {
            script {
                archiveArtifacts artifacts: '*.xml', followSymlinks: false
                build job: "Wanderlust-CD", parameters: [
                  string(name: 'FRONTEND_DOCKER_TAG', value: "${params.FRONTEND_DOCKER_TAG}"),
                  string(name: 'BACKEND_DOCKER_TAG', value: "${params.BACKEND_DOCKER_TAG}")
                ]
            }
        }
        unstable {
            script {
            archiveArtifacts artifacts: '*.xml', followSymlinks: false
            build job: "Wanderlust-CD", parameters: [
                string(name: 'FRONTEND_DOCKER_TAG', value: "${params.FRONTEND_DOCKER_TAG}"),
                string(name: 'BACKEND_DOCKER_TAG', value: "${params.BACKEND_DOCKER_TAG}")
                ]
            }
        }
        failure {
           echo "Pipeline failed."
        }
    }
}
=======
    }

   post {
        success {
            script {
                archiveArtifacts artifacts: '*.xml', followSymlinks: false
                build job: "Wanderlust-CD", parameters: [
                  string(name: 'FRONTEND_DOCKER_TAG', value: "${params.FRONTEND_DOCKER_TAG}"),
                  string(name: 'BACKEND_DOCKER_TAG', value: "${params.BACKEND_DOCKER_TAG}")
                ]
            }
        }
        unstable {
            script {
            archiveArtifacts artifacts: '*.xml', followSymlinks: false
            build job: "Wanderlust-CD", parameters: [
                string(name: 'FRONTEND_DOCKER_TAG', value: "${params.FRONTEND_DOCKER_TAG}"),
                string(name: 'BACKEND_DOCKER_TAG', value: "${params.BACKEND_DOCKER_TAG}")
                ]
            }
        }
        failure {
           echo "Pipeline failed."
        }
    }
}
>>>>>>> 723ef0e (added terraform ignore file)
