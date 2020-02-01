#set ($configurationSetName = $instance.getAttribute("configuration_set_name"))

resource "aws_ses_configuration_set" "$configurationSetName" {
  name = "$configurationSetName"
}
