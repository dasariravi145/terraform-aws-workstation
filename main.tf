resource "aws_instance" "workstation" {

       ami = local.ami_id
       instance_type = "t3.micro"
       vpc_security_group_ids = [aws_security_group.workstation.id]
       user_data = templatefile("workstation.sh", {
            aws_access_key = var.aws_access_key
            aws_secret_key = var.aws_secret_key
       })

    root_block_device {

          volume_size = 50
          volume_type = "gp3"
          #  EBS volume tags
          tags = merge(
              {
                   Name = "${var.project}-${var.environment}-workstation"
              },
              local.common_tags
          )
    }
    tags = merge(

          {
             Name = "${var.project}-${var.environment}-workstation"
          },
          local.common_tags
    )

}

resource "terraform_data" "cluster_destroy" {

       input = {
           
             host     = aws_instance.workstation.public_ip
             password = var.ssh_password
       }

       provisioner "remote-exec" {

             when = destroy
             inline = [
                   "eksctl delete cluster -f /home/ec2-user/eksctl/eks.yaml --wait"
             ]
             connection {

                  type = "ssh"
                  host = self.input.host
                  user = "ec2-user"
                  password = self.input.password
             }
       }
}