#!/usr/bin/env groovy

disableConcurrentBuilds()

properties([
    buildDiscarder(
            logRotator(
                    numToKeepStr: "15")
    )
])

podTemplate(yaml: '''
    apiVersion: v1
    kind: Pod
    spec:
      containers:
      - name: worker-pod
        image: alpine
        command:
        - sleep
        args:
        - 99d
      nodeSelector:
        nodeType: jenkinsJobs
      tolerations:
      - key: jenkinsJobs
        effect: NoSchedule
''') {
  node(POD_LABEL) {

    container('worker-pod') {
      stage('Get deployment modules') {
          sh "ls -lR;pwd"
 
      }
    }
  }
}
