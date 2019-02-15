# Migrate DB artifacts(Stored Procedure, Function)
# Source -> Extract(Procedure, function) -> Target

require 'dbi'
require './env'

query = <<END_SQL.gsub(/\s+/, " ").strip
SELECT OBJECT_NAME
  , TO_CHAR(LAST_DDL_TIME, 'YYYYMMDD') AS EDIT_DATE
  , DBMS_METADATA.GET_DDL(OBJECT_TYPE, OBJECT_NAME) AS BODY
FROM USER_OBJECTS
WHERE 1 = 1
  AND OBJECT_NAME = ?
END_SQL

def print_help()
  puts("ruby #{__FILE__ } [PROD|DEV] A,B,C,D,E...")
end

def parse_artifacts_list(csvlist)
  csvlist.split(',')
end

# 추출한 Procedure, Function 쿼리를 실행(생성)
def migrate(target_con, name, sql)
  begin
    sth = target_con.prepare(sql)
    sth.execute()
  rescue DBI::DatabaseError => dbe
    STDERR.puts("Error whilte: #{name}")
    STDERR.puts(dbe)
  end

  puts("Migrated: #{name}")
end

begin
  if ARGV.length != 2
    print_help()
    exit(1)
  end

  artifacts_list = parse_artifacts_list(ARGV[1])

  env = DEV; prod = PROD;
  fail("Migrate to PROD is not supported for safety reason.") if ARGV[0] == "PROD"

  puts("Migrate DB Artifacts: PROD -> DEV")

  db_src = DBI.connect(prod[:DBI_STRING], prod[:DB_USER], prod[:DB_PW])
  db_tgt = DBI.connect(env[:DBI_STRING], env[:DB_USER], env[:DB_PW])

  artifacts_list.each do |elem|
    sth = db_src.prepare(query)
    sth.bind_param(1, elem)
    sth.execute()

    row = sth.fetch()
    if (row.nil?)
      puts("There is no: #{elem}")
      next
    end

    migrate(db_tgt, row['OBJECT_NAME'], row['BODY'].read)
  end

rescue DBI::DatabaseError => dbe
  STDERR.puts(dbe)
  sb_tgt.rollback
ensure
  db_src.disconnect if db_src
  db_tgt.disconnect if db_tgt
end


