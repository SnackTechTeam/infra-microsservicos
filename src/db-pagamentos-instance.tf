resource "aws_docdb_cluster" "snacktech_dbcluster_pagamentos" {
  cluster_identifier      = "${var.projectName}-dbcluster-pagamentos"
  engine                  = "docdb"
  master_username         = var.dbUserPagamentos
  master_password         = sensitive(var.dbPasswordpagamentos)
  backup_retention_period = 1
  preferred_backup_window = "07:00-09:00"
  skip_final_snapshot     = true
}

resource "aws_docdb_cluster_instance" "snacktech_dbcluster_pagamentos" {
  count              = 1
  identifier         = "${var.projectName}-db-pagamentos"
  cluster_identifier = aws_docdb_cluster.snacktech_dbcluster_pagamentos.id
  instance_class     = "db.t3.small"
}

output "snacktech_dbcluster_pagamentos" {
  value = aws_docdb_cluster.snacktech_dbcluster_pagamentos.endpoint
}