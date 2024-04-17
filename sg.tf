resource "aws_security_group" "irs-db" {
  name        = "irs-database-test2-sg"
  description = "Allow DB access"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description     = "Access from ECS-Admin"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.irs-admin-instance.id]
  }

  ingress {
    description     = "IRS-test2-Bastion-sg"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.irs-bastion.id]
  }

  ingress {
    description     = "Access from ECS App"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.irs-app-instance.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "irs-admin" {
  name        = "irs-test2-admin"
  description = "Allow Admin Access"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description      = "IRS-test-ecs-Admin-instance"
    from_port        = 8443
    to_port          = 8443
    protocol         = "tcp"
    cidr_blocks      = ["199.83.128.0/21", "185.11.124.0/22", "103.28.248.0/22", "131.125.128.0/17", "45.64.64.0/22", "107.154.0.0/16", "45.60.0.0/16", "45.223.0.0/16", "192.230.64.0/18", "149.126.72.0/21", "198.143.32.0/19"]
    ipv6_cidr_blocks = ["2a02:e980::/29"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "irs-api" {
  name        = "irs-test2-api"
  description = "Allow API access"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "Allow all traffic from internet"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow all traffic from internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 1024
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 1024
    to_port         = 65535
    protocol        = "tcp"
    security_groups = [aws_security_group.Test2-AllowInternalTraffic.id]
  }

}

resource "aws_security_group" "irs-admin-instance" {
  name        = "irs-test2-admin-instances"
  description = "Allow Admin Instance access"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description     = "Allow traffic from IRS Admin"
    from_port       = 1024
    to_port         = 65535
    protocol        = "tcp"
    security_groups = [aws_security_group.irs-admin.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "irs-app-instance" {
  name        = "irs-test2-api-instances"
  description = "Allow App Instance access"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description     = "Allow App Instance access"
    from_port       = 1024
    to_port         = 65535
    protocol        = "tcp"
    security_groups = [aws_security_group.irs-api.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "irs-bastion" {
  name        = "irs-test2-bastion-host"
  description = "Allow Bastion access"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "Casey TEMP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["74.96.4.157/32"]
  }

  ingress {
    description = "Bill Home"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["99.105.5.57/32"]
  }

  ingress {
    description = "jwest home"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["63.142.212.198/32"]
  }

  ingress {
    description = "Deborah Home"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["24.160.84.140/32"]
  }

  ingress {
    description = "George Home"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["136.226.54.170/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_security_group" "irs-cache" {
  name        = "irs-test2-cache"
  description = "Allow Cache access"
  vpc_id      = aws_vpc.vpc.id
  ingress {
    description     = "Allow Admin Instance access"
    from_port       = 6379
    to_port         = 6379
    protocol        = "tcp"
    security_groups = [aws_security_group.irs-admin.id]
  }
  ingress {
    description     = "Allow API access"
    from_port       = 6379
    to_port         = 6379
    protocol        = "tcp"
    security_groups = [aws_security_group.irs-api.id]
  }
  ingress {
    description     = "Allow Admin Instance access"
    from_port       = 6379
    to_port         = 6379
    protocol        = "tcp"
    security_groups = [aws_security_group.irs-app-instance.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "irs-alb" {
  name        = "irs-test2-alb"
  description = "Allow ALB access"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "Praveen home"
    from_port   = 8443
    to_port     = 8443
    protocol    = "tcp"
    cidr_blocks = ["103.170.6.30/32"]
  }
  ingress {
    description = "Pavel Home admin"
    from_port   = 8443
    to_port     = 8443
    protocol    = "tcp"
    cidr_blocks = ["47.200.162.76/32"]
  }
  ingress {
    description = "Deborah Home"
    from_port   = 8443
    to_port     = 8443
    protocol    = "tcp"
    cidr_blocks = ["24.160.84.140/32"]
  }
  ingress {
    description = "Internet Traffic"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "jwest Home"
    from_port   = 8443
    to_port     = 8443
    protocol    = "tcp"
    cidr_blocks = ["63.142.212.198/32"]
  }
  ingress {
    description = "jwest Home"
    from_port   = 5555
    to_port     = 5555
    protocol    = "tcp"
    cidr_blocks = ["63.142.212.198/32"]
  }
  ingress {
    description = "Pavel Home"
    from_port   = 5555
    to_port     = 5555
    protocol    = "tcp"
    cidr_blocks = ["47.200.162.76/32"]
  }
  ingress {
    description = "Brandy Home"
    from_port   = 8443
    to_port     = 8443
    protocol    = "tcp"
    cidr_blocks = ["67.243.74.167/32"]
  }
  ingress {
    description = "Erick Home"
    from_port   = 8443
    to_port     = 8443
    protocol    = "tcp"
    cidr_blocks = ["35.140.141.166/32"]
  }
  ingress {
    description = "Celery Flower, Deborah Home"
    from_port   = 5555
    to_port     = 5555
    protocol    = "tcp"
    cidr_blocks = ["24.160.84.140/32"]
  }
  ingress {
    description     = "Allow Admin Instance access"
    from_port       = 1024
    to_port         = 65535
    protocol        = "tcp"
    security_groups = [aws_security_group.irs-admin.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "Test2-AllowInternalTraffic" {
  name        = "Test2-AllowInternalTraffic"
  description = "Allow internal traffic"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.98.115.0/24"]

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
