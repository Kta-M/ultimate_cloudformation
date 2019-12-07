require 'json'
require 'aws-sdk-cloudformation'

def lambda_handler(event:, context:)
  stack_name = ENV['STACK_NAME']
  cfn_client = Aws::CloudFormation::Client.new
  resp = cfn_client.describe_stacks(stack_name: stack_name)
  if resp.stacks.first.stack_status == "CREATE_COMPLETE"
    cfn_client.delete_stack(stack_name: stack_name)
  end
end
