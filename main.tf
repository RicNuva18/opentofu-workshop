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

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = true 
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

resource "aws_security_group" "unsafe_sg" {
  name   = "unsafe-sg"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = var.mandatory_tags
}

resource "aws_instance" "test_compliant" {
  ami                         = "ami-1234567890abcdef0"
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.private.id
  vpc_security_group_ids      = [aws_security_group.safe_sg.id]
  associate_public_ip_address = false
  tags                        = var.mandatory_tags
}

resource "aws_instance" "test_fails_port" {
  ami                         = "ami-1234567890abcdef0"
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.private.id
  vpc_security_group_ids      = [aws_security_group.unsafe_sg.id]
  associate_public_ip_address = false
  tags                        = var.mandatory_tags
}

resource "aws_instance" "test_fails_subnet" {
  ami                         = "ami-1234567890abcdef0"
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.safe_sg.id]
  associate_public_ip_address = true
  tags                        = var.mandatory_tags
}

resource "aws_instance" "test_fails_tags" {
  ami                         = "ami-1234567890abcdef0"
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.private.id
  vpc_security_group_ids      = [aws_security_group.safe_sg.id]
  associate_public_ip_address = false
  
  tags = {
    owner       = "equipo-devops"
    environment = "produccion"
    app         = "backend-api"
  }
}