DROP PROCEDURE IF EXISTS enableQueryLog;
DROP PROCEDURE IF EXISTS disableQueryLog;

DELIMITER ';;'
CREATE PROCEDURE enableQueryLog()
SQL SECURITY DEFINER
BEGIN
  SET GLOBAL slow_query_log_file='/var/log/mysql/accounts-slowquery.log';

  SET GLOBAL log_queries_not_using_indexes='ON';

  -- anything that takes longer than .3s probably needs to be optimised
  SET GLOBAL long_query_time=0.300000;

  -- unchanged from default, included anyway
  SET GLOBAL min_examined_row_limit=0;

  -- finally, enable everything.
  SET GLOBAL slow_query_log='ON';

END;;

CREATE PROCEDURE disableQueryLog()
SQL SECURITY DEFINER
BEGIN
  SET GLOBAL slow_query_log='OFF';

  -- no point in changing this back
  -- SET GLOBAL slow_query_log_file='/var/log/mysql/accounts-slowquery.log';
  SET GLOBAL log_queries_not_using_indexes='OFF';
  SET GLOBAL long_query_time=10.000000;
  SET GLOBAL min_examined_row_limit=0;
END;;
DELIMITER ';'


