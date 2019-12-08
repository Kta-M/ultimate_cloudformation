require 'aws-sdk-cloudformation'

def lambda_handler(event:, context:)
  msg =  event['Records'].first.dig('Sns', 'Message')
  if msg.include?("ResourceStatus='CREATE_COMPLETE'") &&
      msg.include?("LogicalResourceId='#{ENV['CHILD_STACK_NAME']}'")
    cfn_client = Aws::CloudFormation::Client.new
    while true
      sleep(1)
      stack_name = ENV['PARENT_STACK_NAME']
      resp = cfn_client.describe_stacks(stack_name: stack_name)
      next unless resp.stacks.first.stack_status == 'CREATE_COMPLETE'
      cfn_client.delete_stack(stack_name: stack_name)
    end
  end
end
