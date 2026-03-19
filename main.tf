/**
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags       = var.mandatory_tags
}

resource "aws_subnet" "private" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = false 
  tags                    = var.mandatory_tags
}

resource "aws_security_group" "safe_sg" {
  name   = "safe-sg"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = var.mandatory_tags
}

resource "aws_instance" "test_compliant" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.private.id
  vpc_security_group_ids      = [aws_security_group.safe_sg.id]
  associate_public_ip_address = false
  tags                        = var.mandatory_tags
}

**/