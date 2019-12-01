require 'json'
require 'aws-sdk-cloudformation'

def lambda_handler(event:, context:)
  # 関数名からスタック名取得
  cfn = Aws::CloudFormation::Client.new
  resp = cfn.describe_stack_resources({
    physical_resource_id: ENV['FUNCTION_NAME']
  })
  stack_name = resp.stack_resources.first.stack_name

  # スタックを削除
  cfn.delete_stack(stack_name: stack_name)
end
