// Jenkins: Docker ile build + aynı makinede c_hektar container’ı yenile
// Uzak sunucu kullanıyorsanız "Deploy (SSH)" aşamasındaki yorumu açıp betiği doldurun.
pipeline {
    agent any

    environment {
        // npm.newworldemlak altyapındaki isim: diğer servislerle aynı Docker ağına ekleyin
        IMAGE_NAME        = 'hektar-website'
        CONTAINER_NAME    = 'c_hektar'
        PUBLISH_PORT      = '3007'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Docker build') {
            steps {
                sh '''
                    docker build -t ${IMAGE_NAME}:${BUILD_NUMBER} -t ${IMAGE_NAME}:latest .
                '''
            }
        }

        // Opsiyonel: özel registry (GitHub CR, Docker Hub) — kimlik: Jenkins "Secret text" / credentials
        // stage('Docker push') {
        //     steps {
        //         withCredentials([usernamePassword(
        //             credentialsId: 'REGISTRY_CREDS',
        //             passwordVariable: 'REG_PASS', usernameVariable: 'REG_USER')]) {
        //             sh 'echo $REG_PASS | docker login $REGISTRY -u $REG_USER --password-stdin'
        //             sh 'docker push ${IMAGE_NAME}:latest'
        //         }
        //     }
        // }

        stage('Deploy (local / agent)') {
            // Jenkins agent, Docker’ın üzerinde çalıştığı aynı sunucuysa
            steps {
                sh """
                    docker stop ${CONTAINER_NAME} 2>/dev/null || true
                    docker rm ${CONTAINER_NAME} 2>/dev/null || true
                    docker run -d --name ${CONTAINER_NAME} \\
                        --network proxy_net \\
                        --restart unless-stopped \\
                        -p ${PUBLISH_PORT}:${PUBLISH_PORT} \\
                        ${IMAGE_NAME}:latest
                """
            }
        }
    }

    // post {
    //     // Uzak 46.224.110.157: SSH + docker compose / pull
    //     // sshagent(credentials: ['id_rsa_deploy']) { sh 'ssh user@IP "cd /opt/hektar-website && git pull && ..."' }
    // }
}
