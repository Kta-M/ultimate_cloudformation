require 'json'
require 'aws-sdk-lambda'
require 'aws-sdk-cloudformation'

def lambda_handler(event:, context:)
  # スタック名を取得
  lambda_client = Aws::Lambda::Client.new
  resp = lambda_client.list_tags({resource: event["lambda_arn"]})
  stack_name = resp.tags["aws:cloudformation:stack-name"]

  # スタックを削除
  cfn_client = Aws::CloudFormation::Client.new
  resp = cfn_client.describe_stacks(stack_name: stack_name)
  if resp.stacks.first.stack_status == "CREATE_COMPLETE"
    cfn_client.delete_stack(stack_name: stack_name)
  end
end
