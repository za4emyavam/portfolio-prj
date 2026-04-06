resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.portfolio_vpc.id
  service_name      = "com.amazonaws.eu-central-1.s3"
  vpc_endpoint_type = "Gateway"

  route_table_ids = [aws_route_table.private_rt.id]

  tags = {
    Name    = "portfolio-s3-endpoint"
    Project = "portfolio"
  }
}