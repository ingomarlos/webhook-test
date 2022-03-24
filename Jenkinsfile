
// Uses Declarative syntax to run commands inside a container.
pipeline {
    agent {
        kubernetes {
            // Rather than inline YAML, in a multibranch Pipeline you could use: yamlFile 'jenkins-pod.yaml'
            // Or, to avoid YAML:
            // containerTemplate {
            //     name 'shell'
            //     image 'ubuntu'
            //     command 'sleep'
            //     args 'infinity'
            // }
            yaml '''
apiVersion: v1
kind: Pod
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
'''
            // Can also wrap individual steps:
            // container('shell') {
            //     sh 'hostname'
            // }
            defaultContainer 'builder'
        }
    }
    stages {
        stage('Main') {
            steps {
                sh "/kaniko/executor --dockerfile Dockerfile --context `pwd` --destination=437291019013.dkr.ecr.eu-central-1.amazonaws.com/dse/unzer-aws-shared-core-jenkins-slave-ecr"
            }
        }
    }
