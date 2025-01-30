# resource "aws_docdb_cluster" "snacktech_dbcluster_pagamentos" {
#   cluster_identifier      = "${var.projectName}-dbcluster-pagamentos"
#   engine                  = "docdb"
#   master_username         = var.dbUserPagamentos
#   master_password         = sensitive(var.dbPasswordpagamentos)
#   backup_retention_period = 1
#   preferred_backup_window = "07:00-09:00"
#   skip_final_snapshot     = true
# }

# resource "aws_docdb_cluster_instance" "snacktech_dbcluster_pagamentos" {
#   count              = 1
#   identifier         = "${var.projectName}-db-pagamentos"
#   cluster_identifier = aws_docdb_cluster.snacktech_dbcluster_pagamentos.id
#   instance_class     = "db.t3.small"
# }


# resource "aws_iam_policy" "docdb_policy" {
#   name        = "docdb-policy"
#   description = "Policy for creating and managing DocumentDB resources"
#   policy      = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect   = "Allow"
#         Action   = [
#           "rds:CreateDBInstance",
#           "rds:DescribeDBInstances",
#           "rds:CreateDBCluster",
#           "rds:DescribeDBClusters",
#           "rds:DeleteDBInstance",
#           "rds:DeleteDBCluster",
#           "rds:ModifyDBInstance",
#           "rds:ModifyDBCluster",
#           "rds:AddTagsToResource",
#           "rds:ListTagsForResource"
#         ]
#         Resource = "*"
#       }
#     ]
#   })
# }

# resource "aws_iam_role_policy_attachment" "docdb_attachment" {
#   role       = data.aws_iam_role.labrole.name
#   policy_arn = aws_iam_policy.docdb_policy.arn
# }

# output "snacktech_dbcluster_pagamentos" {
#   value = aws_docdb_cluster.snacktech_dbcluster_pagamentos.endpoint
# }