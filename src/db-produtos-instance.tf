resource "aws_db_instance" "snacktech_db_produtos" {
  allocated_storage         = 20
  storage_type              = "gp2"
  engine                    = "sqlserver-ex"
  engine_version            = "15.00.4410.1.v1"
  instance_class            = "db.t3.small"
  identifier                = "${var.projectName}-db-produtos"
  username                  = var.dbUserProdutos
  password                  = sensitive(var.dbPasswordProdutos)
  db_subnet_group_name      = aws_db_subnet_group.snack_tech_db_subnet_group.name
  vpc_security_group_ids    = [aws_security_group.sg.id]
  publicly_accessible       = true
  backup_retention_period   = 1             # Number of days to retain automated backups
  backup_window             = "03:00-04:00" # Preferred UTC backup window (hh24:mi-hh24:mi format)
  final_snapshot_identifier = "db-snap"
  maintenance_window        = "mon:04:00-mon:04:30" # Preferred UTC maintenance window
  copy_tags_to_snapshot     = true
  delete_automated_backups  = true

  # Enable automated backups
  skip_final_snapshot = true
  deletion_protection = false #Em produção mudar aqui para true
}

output "db_instance_produtos" {
  value = aws_db_instance.snacktech_db_produtos.address
  sensitive = true
}

output "db_port_produtos" {
  value = aws_db_instance.snacktech_db_produtos.port
}