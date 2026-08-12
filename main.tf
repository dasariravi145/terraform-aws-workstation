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