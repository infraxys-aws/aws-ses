#set ($eventDestinationName = $instance.getAttribute("event_destination_name"))
#set ($eventDestinationName = $instance.getAttribute("event_destination_name"))

resource "aws_ses_event_destination" "$eventDestinationName" {
  name = "$eventDestinationName"
  configuration_set_name =  aws_ses_configuration_set.${instance.getAttribute("configuration_set_name")}.name
  enabled = $instance.getBoolean("destination_enabled")
 
  matching_types = [
#foreach ($matchingType in $instance.getAttribute("matching_types").split(','))
#if ($matchingType != "")
        "$matchingType"#if( $foreach.hasNext ),
#end
#end
#end

  ]
#if ($instance.getParentInstanceByPacketType("AWS-SNS-TOPIC"))
  #set ($topicName = $instance.parent.getAttribute("topic_name"))
  sns_destination {
	topic_arn = aws_sns_topic.${topicName}.arn
  }
#else
  $environment.throwException("Only event destinations under instances of type 'AWS-SNS-TOPIC' are currently suppoorted")
#end

}

#if (! $instance.getParentInstanceByPacketType("TERRAFORM-AWS-RUNNER"))
provider "aws" {
  region = "us-east-1"
  version = "~> 2.32.0"
}

#end
