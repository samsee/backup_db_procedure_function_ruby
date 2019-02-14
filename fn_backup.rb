require 'dbi'
require './env'

query = <<END_SQL.gsub(/\s+/, " ").strip
SELECT OBJECT_NAME
  , TO_CHAR(LAST_DDL_TIME, 'YYYYMMDD') AS EDIT_DATE
  , DBMS_METADATA.GET_DDL('FUNCTION', OBJECT_NAME) AS BODY
FROM USER_OBJECTS
WHERE 1 = 1
  AND OBJECT_TYPE = 'FUNCTION'
END_SQL

def file_write(filename, contents, dir)
  File.open(dir.gsub(/\\$/, "") + "\\" + filename, 'w') { |file| file.write(contents) }
  filename
end

def print_help()
  puts("ruby #{__FILE__} [PROD|DEV]")
end

begin
  if ARGV.length != 1
    print_help()
    exit(1)
  end

  env = DEV
  env = PROD if ARGV[0] == "PROD"

  dbh = DBI.connect(env[:DBI_STRING], env[:DB_USER], env[:DB_PW])

  sth = dbh.prepare(query)
  sth.execute()

  sth.fetch do |row|
    puts(row['OBJECT_NAME'])
    file_write(row['OBJECT_NAME'], row['BODY'].read, env[:FN_BACKUP_DIR])
  end

  sth.finish
rescue DBI::DatabaseError => dbe
  puts(dbe)
  dbh.rollback
ensure
  dbh.disconnect if dbh
end