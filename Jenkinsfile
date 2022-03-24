
stage('Build') {
  agent {
    kubernetes {
      label 'jenkinsrun'
      defaultContainer 'builder'
      yaml """
kind: Pod
metadata:
  name: kaniko
spec:
  containers:
  - name: builder
    image: gcr.io/kaniko-project/executor:debug
    imagePullPolicy: Always
    command:
    - /busybox/cat
    tty: true
    volumeMounts:
      - name: docker-config
        mountPath: /kaniko/.docker
  volumes:
    - name: docker-config
      configMap:
        name: docker-config
"""
    }
  }
steps {
      script {
        sh "ls -lR"
        //sh "/kaniko/executor --dockerfile `pwd`/Dockerfile --context `pwd` --destination=AWSACCOUNT.dkr.ecr.eu-west-1.amazonaws.com/app:${env.BUILD_ID}"
    }
  }
} 
