# Environment file

# Edit below to your environment.
PROD = {
    :DBI_STRING => "DBI:OCI8:PRODOCI",
    :DB_USER => "USER",
    :DB_PW => "PASS",
    :SP_BACKUP_DIR => "SP_BACKUP_PROD",
    :FN_BACKUP_DIR => "FN_BACKUP_PROD"
}

DEV = {
    :DBI_STRING => "DBI:OCI8:DEVOCI",
    :DB_USER => "USER",
    :DB_PW => "PASS",
    :SP_BACKUP_DIR => "SP_BACKUP_DEV",
    :FN_BACKUP_DIR => "FN_BACKUP_DEV"
}