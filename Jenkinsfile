#!groovy

pipeline {
  options {
    gitLabConnection('gitlab@cr.imson.co')
    gitlabBuilds(builds: ['jenkins'])
    disableConcurrentBuilds()
    timestamps()
  }
  post {
    failure {
      updateGitlabCommitStatus name: 'jenkins', state: 'failed'
    }
    unstable {
      updateGitlabCommitStatus name: 'jenkins', state: 'failed'
    }
    aborted {
      updateGitlabCommitStatus name: 'jenkins', state: 'canceled'
    }
    success {
      updateGitlabCommitStatus name: 'jenkins', state: 'success'
    }
    always {
      cleanWs()
    }
  }
  agent any
  environment {
    CI = 'true'
    RUBY_VERSION = '2.6'
    RUBOCOP_VERSION = '0.75.1'
  }
  stages {
    stage('Build image') {
      steps {
        updateGitlabCommitStatus name: 'jenkins', state: 'running'
        script {
          withDockerRegistry(credentialsId: 'e22deec5-510b-4fbe-8916-a89e837d1b8d', url: 'https://docker.cr.imson.co/v2/') {
            docker.build("docker.cr.imson.co/homelab-ci", "--build-arg RUBY_VERSION=${env.RUBY_VERSION} --build-arg RUBOCOP_VERSION=${env.RUBOCOP_VERSION} .").push()
          }
        }
      }
    }
  }
}
