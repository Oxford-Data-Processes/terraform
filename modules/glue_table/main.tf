resource "aws_glue_catalog_table" "this" {
  database_name = var.database_name
  name          = var.table_name

  table_type = "EXTERNAL_TABLE"

  parameters = {
    EXTERNAL              = "TRUE"
    "parquet.compression" = "SNAPPY"
  }

  storage_descriptor {
    location      = "s3://${var.project}-bucket-${var.aws_account_id}/${var.database_name}/${var.table_name}/"
    input_format  = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat"

    ser_de_info {
      serialization_library = "org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe"
    }

    dynamic "columns" {
      for_each = var.columns
      content {
        name = columns.value.name
        type = columns.value.type
      }
    }
  }

  dynamic "partition_keys" {
    for_each = var.partition_keys
    content {
      name = partition_keys.value.name
      type = partition_keys.value.type
    }
  }
}