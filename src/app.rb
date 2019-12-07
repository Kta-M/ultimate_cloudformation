require 'json'
require 'aws-sdk-cloudformation'

def lambda_handler(event:, context:)
  msg =  event['Records'].first.dig('Sns', 'Message')
  if msg.include?("ResourceStatus='CREATE_COMPLETE'") &&
      msg.include?("LogicalResourceId='#{ENV['CHILD_STACK_NAME']}'")
    cfn_client = Aws::CloudFormation::Client.new
    cfn_client.delete_stack(stack_name: ENV['PARENT_STACK_NAME'])
  end
end
