output "ecs_cluster_id" {
  value = aws_ecs_cluster.medusa_cluster.id
}

output "ecs_service_name" {
  value = aws_ecs_service.medusa_service.name
}

output "load_balancer_arn" {
  value = aws_lb.alb.arn
}

output "load_balancer_dns" {
  value = aws_lb.alb.dns_name
}
