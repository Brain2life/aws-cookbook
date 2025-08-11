locals {
  # Variable to check condition IfHasMoreThan2Azs
  has_third_subnet = length(data.aws_availability_zones.available.names) > 2
}