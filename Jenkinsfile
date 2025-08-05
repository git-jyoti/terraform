pipeline {
    agent any
    environment {
        // Replace 'your-aws-credentials-id' with the ID of your AWS credentials configured in Jenkins
        AWS_ACCESS_KEY_ID = credentials('aws')
        AWS_SECRET_ACCESS_KEY = credentials('aws')
        AWS_REGION = 'ap-south-1' // Specify your desired AWS region
    }
  stages {
        stage('List EC2 Instances') {
            steps {
                script {
                    echo 'Listing EC2 Instances...'
                    // Execute the AWS CLI command to describe instances and extract Instance IDs
                    sh 'aws ec2 describe-instances --query "Reservations[*].Instances[*].InstanceId" --output text'
                }
            }
        }
          stage('Terraform Init') {
                steps {
                // Execute the terraform init command
                sh 'terraform init' 
            }
        }
    }
}
