
resource "aws_security_group" "bastion_sg" {
  vpc_id      = aws_vpc.eks_vpc.id
  name        = "bastion-allow-ssh"
  description = "security group for bastion that allows ssh and all egress traffic"
}
resource "aws_security_group_rule" "ssh_inbound" {
    security_group_id = aws_security_group.bastion_sg.id
    type              = "ingress"
    from_port         = 22
    to_port           = 22
    protocol          = "tcp"
    cidr_blocks       = ["0.0.0.0/0"] # allow ssh from anywhere not to use in Production
}
resource "aws_security_group_rule" "download_egress" {
    security_group_id = aws_security_group.bastion_sg.id
    type              = "egress"
    from_port         = "0"
    to_port           = "0"
    protocol          = "-1"
    cidr_blocks       = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
}