
resource "aws_lb_target_group_attachment" "tg_attach" {
    count = length(var.instances)
  target_group_arn = var.lb_tg_arn
  target_id        =  var.instances[count.index]
  port             = var.tg_port
}