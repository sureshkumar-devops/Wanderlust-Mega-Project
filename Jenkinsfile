@Library('shared') _
pipeline{
    
    agent any
    
    environment{
        scanner_home= tool 'SonarQube-Scanner'
    }
    
    parameters{
        string(name: 'FRONTEND_DOCKER_TAG', defaultValue: '', description: 'Setting docker image for latest push')
        string(name: 'BACKEND_DOCKER_TAG',  defaultValue: '', description: 'Setting docker image for latest push')
        choice(name: 'START_FROM_STAGE', choices: ['ALL','Validate Parameter','Clean Workspace','Git: Code CheckOut','GitLeaks: Check HardCode Pass','Trivy: File System Scan','OWASP: Dependency Check','SonarQube: Code Analysis','SonarQube: Code Quality Gates','Exporting environment variables','Docker: Build Image','Docker: Push to DockerHub'], description: 'Select stage to start from')
    }
    
    stages
    {
       stage('Validate Parameter'){
            when {
                expression { params.START_FROM_STAGE == 'ALL' }
            }
            steps{
                script{
                    if(params.FRONTEND_DOCKER_TAG == "" | params.BACKEND_DOCKER_TAG == "")
                    {
                        error("FRONTEND_DOCKER_TAG and BACKEND_DOCKER_TAG must be provided.")
                    }
                }    
            }
        }

       stage('Clean Workspace'){
           when {
                expression { params.START_FROM_STAGE in '['ALL', 'Clean Workspace']' }
            }
            steps{
               // cleanWs()
               echo "clean workspace"
                }
        }        

       stage('Git: Code CheckOut'){
           when {
                expression { params.START_FROM_STAGE in '['ALL', 'Git: Code CheckOut']' }
            }
            steps{
                script{
                    git_checkout('https://github.com/sureshkumar-devops/Wanderlust-Mega-Project.git', 'main')
                }
            }
       }       
       stage('GitLeaks: Check HardCode Pass'){
            when {
                expression { params.START_FROM_STAGE in '['ALL', 'GitLeaks: Check HardCode Pass']' }
            }
            steps{
                script{
                    //sh 'gitleaks detect --source . -r gitleaks-report.json -f json'    
                    echo "Git Leaks"
                }
            }
        }
        
       stage('Trivy: File System Scan'){
            when {
                expression { params.START_FROM_STAGE in '['ALL', 'Trivy: File System Scan']' }
            }
            steps{
                script{
                    trivy_fscan()
                }
            }
       }       

       stage('OWASP: Dependency Check'){           
            when {
                expression { params.START_FROM_STAGE in '['ALL', 'OWASP: Dependency Check']' }
            }
            steps{
                script{
                    owasp_dependency()
                }
            }
       }
       
       stage('SonarQube: Code Analysis'){           
            when {
                expression { params.START_FROM_STAGE in '['ALL', 'SonarQube: Code Analysis']' }
            }
            steps{
                script{
                   sonarqube_analysis("SonarQube-Server", "wanderlust", "wanderlust")
                }
            }
       }

       stage('SonarQube: Code Quality Gates'){
           when {
                expression { params.START_FROM_STAGE in '['ALL', 'SonarQube: Code Quality Gates']' }
            }
            steps{
                script{
                  sonarqube_code_quality()
                }
            }
       }
       
       stage('Exporting environment variables'){
           when {
                expression { params.START_FROM_STAGE in '['ALL', 'Exporting environment variables']' }
            }
            parallel{
                
                stage("Backend env setup"){
                    steps{
                        script{
                            dir("Automations"){
                                sh "bash updatebackendnew.sh"
                            }
                        }
                    }
                }
                
                stage("Frontend env setup"){
                    steps{
                        script{
                            dir("Automations"){
                                sh "bash updatefrontendnew.sh"
                            }
                        }
                    } 
                }
            }
       }       
       stage('Docker: Build Image'){
           when {
                expression { params.START_FROM_STAGE in '['ALL', 'Docker: Build Image']' }
            }
            steps{
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
       stage('Docker: Push to DockerHub'){
           when {
                expression { params.START_FROM_STAGE in '['ALL', 'Docker: Push to DockerHub']' }
            }
            steps{
                script{
                 docker_push("wanderlust-backend-beta","${params.BACKEND_DOCKER_TAG}","lehardocker")
                 docker_push("wanderlust-frontend-beta","${params.FRONTEND_DOCKER_TAG}","lehardocker")                  
                }
            }
       }
    }
    post{
       success{
           archiveArtifacts artifacts: '*.xml', followSymlinks: false
           build job: "Wanderlust-CD", parameters: [
                 string(name: 'FRONTEND_DOCKER_TAG', value: "${params.FRONTEND_DOCKER_TAG}"),
                 string(name: 'BACKEND_DOCKER_TAG', value: "${params.BACKEND_DOCKER_TAG}")
            ]
       }
       
       unstable{
           archiveArtifacts artifacts: '*.xml', followSymlinks: false
           build job: "Wanderlust-CD", parameters: [
                 string(name: 'FRONTEND_DOCKER_TAG', value: "${params.FRONTEND_DOCKER_TAG}"),
                 string(name: 'BACKEND_DOCKER_TAG', value: "${params.BACKEND_DOCKER_TAG}")
            ]
       }
    }  
}
