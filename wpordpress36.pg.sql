--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: casts; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA casts;


ALTER SCHEMA casts OWNER TO postgres;

--
-- Name: fn; Type: SCHEMA; Schema: -; Owner: wordpress
--

CREATE SCHEMA fn;


ALTER SCHEMA fn OWNER TO wordpress;

--
-- Name: mysql; Type: SCHEMA; Schema: -; Owner: wordpress
--

CREATE SCHEMA mysql;


ALTER SCHEMA mysql OWNER TO wordpress;

--
-- Name: plperlu; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plperlu WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plperlu; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plperlu IS 'PL/PerlU untrusted procedural language';


--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = casts, pg_catalog;

--
-- Name: _date_to_bigint(date); Type: FUNCTION; Schema: casts; Owner: wordpress
--

CREATE FUNCTION _date_to_bigint(date) RETURNS bigint
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
  SELECT casts._date_to_integer($1)::bigint
$_$;


ALTER FUNCTION casts._date_to_bigint(date) OWNER TO wordpress;

--
-- Name: _date_to_integer(date); Type: FUNCTION; Schema: casts; Owner: wordpress
--

CREATE FUNCTION _date_to_integer(date) RETURNS integer
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
  SELECT
    EXTRACT(YEAR FROM $1)::integer * 10000
    + EXTRACT(MONTH FROM $1)::integer * 100
    + EXTRACT(DAY FROM $1)::integer
$_$;


ALTER FUNCTION casts._date_to_integer(date) OWNER TO wordpress;

--
-- Name: _interval_to_bigint(interval); Type: FUNCTION; Schema: casts; Owner: wordpress
--

CREATE FUNCTION _interval_to_bigint(interval) RETURNS bigint
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
  SELECT
    EXTRACT(YEAR FROM $1)::bigint * 10000000000
    + EXTRACT(MONTH FROM $1)::bigint * 100000000
    + EXTRACT(DAY FROM $1)::bigint * 1000000
    + EXTRACT(HOUR FROM $1)::bigint * 10000
    + EXTRACT(MINUTE FROM $1)::bigint * 100
    + EXTRACT(SECONDS FROM $1)::bigint
$_$;


ALTER FUNCTION casts._interval_to_bigint(interval) OWNER TO wordpress;

--
-- Name: _text_to_bigint(text); Type: FUNCTION; Schema: casts; Owner: wordpress
--

CREATE FUNCTION _text_to_bigint(text) RETURNS bigint
    LANGUAGE plperlu IMMUTABLE STRICT COST 1
    AS $_X$
  return $1 if ($_[0] =~ m/^(\d+)(\.\d+)?$/);
  return undef;
$_X$;


ALTER FUNCTION casts._text_to_bigint(text) OWNER TO wordpress;

--
-- Name: _text_to_date(text); Type: FUNCTION; Schema: casts; Owner: wordpress
--

CREATE FUNCTION _text_to_date(text) RETURNS date
    LANGUAGE plperlu IMMUTABLE STRICT COST 1
    AS $_X$
  $_[0] =~ s/0000-00-00/0001-01-01/; #its just for mysql date format
  return $& if( $_[0] =~ m/^(\d{4}-\d{1,2}-\d{1,2})/ );
  return undef;
$_X$;


ALTER FUNCTION casts._text_to_date(text) OWNER TO wordpress;

--
-- Name: _text_to_numeric(text); Type: FUNCTION; Schema: casts; Owner: wordpress
--

CREATE FUNCTION _text_to_numeric(text) RETURNS numeric
    LANGUAGE plperlu IMMUTABLE STRICT COST 1
    AS $_X$
  return $1.$2 if( $_[0] =~ m/^(\d+)(\.\d+)?$/);
  return undef;
$_X$;


ALTER FUNCTION casts._text_to_numeric(text) OWNER TO wordpress;

--
-- Name: _text_to_time(text); Type: FUNCTION; Schema: casts; Owner: wordpress
--

CREATE FUNCTION _text_to_time(text) RETURNS time without time zone
    LANGUAGE plperlu IMMUTABLE STRICT COST 1
    AS $_X$
  
  return $& if( $_[0] =~ s/^(\d{1,2}:\d{1,2})(:\d{1,2}(\.\d+)?)?$/$1$2/ );
  return undef;
$_X$;


ALTER FUNCTION casts._text_to_time(text) OWNER TO wordpress;

--
-- Name: _text_to_timestamp(text); Type: FUNCTION; Schema: casts; Owner: wordpress
--

CREATE FUNCTION _text_to_timestamp(text) RETURNS timestamp without time zone
    LANGUAGE plperlu IMMUTABLE STRICT COST 1
    AS $_X$
  $_[0] =~ s/0000-00-00/0001-01-01/; #its just for mysql date format
  return $_[0] if( $_[0] =~ s/^(\d{4}-\d{2}-\d{2})( \d{1,2}:\d{2}:\d{2})?(\.\d+)?([\+\-\d\:.]+)?/$1$2$3$4/ );
  return undef;
$_X$;


ALTER FUNCTION casts._text_to_timestamp(text) OWNER TO wordpress;

--
-- Name: _text_to_timestamptz(text); Type: FUNCTION; Schema: casts; Owner: wordpress
--

CREATE FUNCTION _text_to_timestamptz(text) RETURNS timestamp with time zone
    LANGUAGE plperlu IMMUTABLE STRICT COST 1
    AS $_X$
  $_[0] =~ s/0000-00-00/0001-01-01/; #its just for mysql date format
  return $_[0] if( $_[0] =~ s/^(\d{4}-\d{2}-\d{2})( \d{1,2}:\d{2}:\d{2})?(\.\d+)?([\+\-\d\:.]+)?/$1$2$3$4/ );
  return undef;
$_X$;


ALTER FUNCTION casts._text_to_timestamptz(text) OWNER TO wordpress;

--
-- Name: _time_to_integer(time without time zone); Type: FUNCTION; Schema: casts; Owner: wordpress
--

CREATE FUNCTION _time_to_integer(time without time zone) RETURNS integer
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
  SELECT
    EXTRACT(HOUR FROM $1)::integer * 10000
    + EXTRACT(MINUTE FROM $1)::integer * 100
    + EXTRACT(SECONDS FROM $1)::integer
$_$;


ALTER FUNCTION casts._time_to_integer(time without time zone) OWNER TO wordpress;

--
-- Name: _time_to_integer(time with time zone); Type: FUNCTION; Schema: casts; Owner: wordpress
--

CREATE FUNCTION _time_to_integer(time with time zone) RETURNS integer
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
  SELECT
    EXTRACT(HOUR FROM $1)::integer * 10000
    + EXTRACT(MINUTE FROM $1)::integer * 100
    + EXTRACT(SECONDS FROM $1)::integer
$_$;


ALTER FUNCTION casts._time_to_integer(time with time zone) OWNER TO wordpress;

--
-- Name: _unknown_to_bigint(unknown); Type: FUNCTION; Schema: casts; Owner: postgres
--

CREATE FUNCTION _unknown_to_bigint(unknown) RETURNS bigint
    LANGUAGE plperlu
    AS $_X$
  return $1 if ($_[0] =~ m/^(\d+)(\.\d+)?$/);
  return undef;
$_X$;


ALTER FUNCTION casts._unknown_to_bigint(unknown) OWNER TO postgres;

SET search_path = fn, pg_catalog;

--
-- Name: __particular__text__512__idx(text); Type: FUNCTION; Schema: fn; Owner: postgres
--

CREATE FUNCTION __particular__text__512__idx(text text) RETURNS text
    LANGUAGE sql IMMUTABLE
    AS $_$
SELECT CASE WHEN length($1) <= 500 THEN substring($1,0,500) ELSE NULL END$_$;


ALTER FUNCTION fn.__particular__text__512__idx(text text) OWNER TO postgres;

--
-- Name: post_tsv(); Type: FUNCTION; Schema: fn; Owner: wordpress
--

CREATE FUNCTION post_tsv() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN
  NEW.tsv = setweight(to_tsvector('russian', coalesce(NEW.post_title,'')), 'A') || setweight(to_tsvector('russian', coalesce(NEW.post_content,'')), 'B');
  RETURN NEW;
END;$$;


ALTER FUNCTION fn.post_tsv() OWNER TO wordpress;

SET search_path = mysql, pg_catalog;

--
-- Name: TIME(timestamp without time zone); Type: FUNCTION; Schema: mysql; Owner: postgres
--

CREATE FUNCTION "TIME"(timestamp without time zone) RETURNS time without time zone
    LANGUAGE sql
    AS $_$
SELECT mysql."time"($1)
$_$;


ALTER FUNCTION mysql."TIME"(timestamp without time zone) OWNER TO postgres;

--
-- Name: _mysqlf_pgsql(text); Type: FUNCTION; Schema: mysql; Owner: postgres
--

CREATE FUNCTION _mysqlf_pgsql(text) RETURNS text
    LANGUAGE sql
    AS $_$
SELECT array_to_string(ARRAY(SELECT s
FROM (SELECT CASE WHEN substring($1 FROM i FOR 1) <> '%'
AND substring($1 FROM i-1 FOR 1) <> '%'
THEN substring($1 FROM i for 1)
ELSE CASE substring($1 FROM i FOR 2)
WHEN '%H' THEN 'HH24'
WHEN '%p' THEN 'am'
WHEN '%Y' THEN 'YYYY'
WHEN '%m' THEN 'MM'
WHEN '%d' THEN 'DD'
WHEN '%i' THEN 'MI'
WHEN '%s' THEN 'SS'
WHEN '%a' THEN 'Dy'
WHEN '%b' THEN 'Mon'
WHEN '%W' THEN 'Day'
WHEN '%M' THEN 'Month'
END
END s
FROM generate_series(1,length($1)) g(i)) g
WHERE s IS NOT NULL),
'')
$_$;


ALTER FUNCTION mysql._mysqlf_pgsql(text) OWNER TO postgres;

--
-- Name: adddate(date, interval); Type: FUNCTION; Schema: mysql; Owner: postgres
--

CREATE FUNCTION adddate(date, interval) RETURNS date
    LANGUAGE sql
    AS $_$
SELECT ($1 + $2)::date; $_$;


ALTER FUNCTION mysql.adddate(date, interval) OWNER TO postgres;

--
-- Name: char(integer[]); Type: FUNCTION; Schema: mysql; Owner: postgres
--

CREATE FUNCTION "char"(VARIADIC integer[]) RETURNS text
    LANGUAGE sql
    AS $_$
SELECT array_to_string(ARRAY(SELECT chr(unnest($1))),'')
$_$;


ALTER FUNCTION mysql."char"(VARIADIC integer[]) OWNER TO postgres;

--
-- Name: concat(text[]); Type: FUNCTION; Schema: mysql; Owner: postgres
--

CREATE FUNCTION concat(VARIADIC str text[]) RETURNS text
    LANGUAGE sql
    AS $_$
SELECT array_to_string($1, '');
$_$;


ALTER FUNCTION mysql.concat(VARIADIC str text[]) OWNER TO postgres;

--
-- Name: concat_ws(text, text[]); Type: FUNCTION; Schema: mysql; Owner: postgres
--

CREATE FUNCTION concat_ws(separator text, VARIADIC str text[]) RETURNS text
    LANGUAGE sql
    AS $_$
SELECT array_to_string($2, $1);
$_$;


ALTER FUNCTION mysql.concat_ws(separator text, VARIADIC str text[]) OWNER TO postgres;

--
-- Name: convert_tz(timestamp without time zone, text, text); Type: FUNCTION; Schema: mysql; Owner: postgres
--

CREATE FUNCTION convert_tz(dt timestamp without time zone, from_tz text, to_tz text) RETURNS timestamp without time zone
    LANGUAGE sql
    AS $_$
SELECT ($1 AT TIME ZONE $2) AT TIME ZONE $3;
$_$;


ALTER FUNCTION mysql.convert_tz(dt timestamp without time zone, from_tz text, to_tz text) OWNER TO postgres;

--
-- Name: curdate(); Type: FUNCTION; Schema: mysql; Owner: postgres
--

CREATE FUNCTION curdate() RETURNS date
    LANGUAGE sql
    AS $$
SELECT CURRENT_DATE
$$;


ALTER FUNCTION mysql.curdate() OWNER TO postgres;

--
-- Name: date(anyelement); Type: FUNCTION; Schema: mysql; Owner: postgres
--

CREATE FUNCTION date(anyelement) RETURNS date
    LANGUAGE sql
    AS $_$
SELECT $1::date;
$_$;


ALTER FUNCTION mysql.date(anyelement) OWNER TO postgres;

--
-- Name: date_add(date, interval); Type: FUNCTION; Schema: mysql; Owner: postgres
--

CREATE FUNCTION date_add(date, interval) RETURNS date
    LANGUAGE sql
    AS $_$
SELECT adddate($1, $2)
$_$;


ALTER FUNCTION mysql.date_add(date, interval) OWNER TO postgres;

--
-- Name: date_format(date, text); Type: FUNCTION; Schema: mysql; Owner: postgres
--

CREATE FUNCTION date_format(date, text) RETURNS text
    LANGUAGE sql
    AS $_$
SELECT to_char($1, mysql._mysqlf_pgsql($2))
$_$;


ALTER FUNCTION mysql.date_format(date, text) OWNER TO postgres;

--
-- Name: date_format(timestamp without time zone, text); Type: FUNCTION; Schema: mysql; Owner: postgres
--

CREATE FUNCTION date_format(timestamp without time zone, text) RETURNS text
    LANGUAGE sql
    AS $_$
SELECT to_char($1, mysql._mysqlf_pgsql($2))
$_$;


ALTER FUNCTION mysql.date_format(timestamp without time zone, text) OWNER TO postgres;

--
-- Name: date_sub(date, interval); Type: FUNCTION; Schema: mysql; Owner: postgres
--

CREATE FUNCTION date_sub(date, interval) RETURNS date
    LANGUAGE sql
    AS $_$
SELECT ($1 - $2)::date;
$_$;


ALTER FUNCTION mysql.date_sub(date, interval) OWNER TO postgres;

--
-- Name: datediff(date, date); Type: FUNCTION; Schema: mysql; Owner: postgres
--

CREATE FUNCTION datediff(date, date) RETURNS integer
    LANGUAGE sql
    AS $_$
SELECT $1 - $2
$_$;


ALTER FUNCTION mysql.datediff(date, date) OWNER TO postgres;

--
-- Name: day(date); Type: FUNCTION; Schema: mysql; Owner: postgres
--

CREATE FUNCTION day(date) RETURNS integer
    LANGUAGE sql
    AS $_$
SELECT dayofmonth($1)
$_$;


ALTER FUNCTION mysql.day(date) OWNER TO postgres;

--
-- Name: dayname(date); Type: FUNCTION; Schema: mysql; Owner: postgres
--

CREATE FUNCTION dayname(date) RETURNS text
    LANGUAGE sql
    AS $_$
SELECT to_char($1, 'TMDay')
$_$;


ALTER FUNCTION mysql.dayname(date) OWNER TO postgres;

--
-- Name: dayofmonth(date); Type: FUNCTION; Schema: mysql; Owner: postgres
--

CREATE FUNCTION dayofmonth(date) RETURNS integer
    LANGUAGE sql
    AS $_$
SELECT EXTRACT(day from $1)::int
$_$;


ALTER FUNCTION mysql.dayofmonth(date) OWNER TO postgres;

--
-- Name: dayofweek(date); Type: FUNCTION; Schema: mysql; Owner: postgres
--

CREATE FUNCTION dayofweek(date) RETURNS integer
    LANGUAGE sql
    AS $_$
SELECT EXTRACT(dow FROM $1)::int
$_$;


ALTER FUNCTION mysql.dayofweek(date) OWNER TO postgres;

--
-- Name: dayofyear(date); Type: FUNCTION; Schema: mysql; Owner: postgres
--

CREATE FUNCTION dayofyear(date) RETURNS integer
    LANGUAGE sql
    AS $_$
SELECT EXTRACT(doy FROM $1)::int
$_$;


ALTER FUNCTION mysql.dayofyear(date) OWNER TO postgres;

--
-- Name: elt(integer, text[]); Type: FUNCTION; Schema: mysql; Owner: postgres
--

CREATE FUNCTION elt(integer, VARIADIC text[]) RETURNS text
    LANGUAGE sql
    AS $_$
SELECT $2[$1];
$_$;


ALTER FUNCTION mysql.elt(integer, VARIADIC text[]) OWNER TO postgres;

--
-- Name: field(text, text[]); Type: FUNCTION; Schema: mysql; Owner: postgres
--

CREATE FUNCTION field(text, VARIADIC text[]) RETURNS integer
    LANGUAGE sql STRICT
    AS $_$
  SELECT i
     FROM generate_subscripts($2,1) g(i)
    WHERE $1 = $2[i]
    UNION ALL
    SELECT 0
    LIMIT 1
$_$;


ALTER FUNCTION mysql.field(text, VARIADIC text[]) OWNER TO postgres;

--
-- Name: field(character varying, text[]); Type: FUNCTION; Schema: mysql; Owner: postgres
--

CREATE FUNCTION field(character varying, VARIADIC text[]) RETURNS integer
    LANGUAGE sql STRICT
    AS $_$
SELECT i
FROM generate_subscripts($2,1) g(i)
WHERE $1 = $2[i]
UNION ALL
SELECT 0
LIMIT 1
$_$;


ALTER FUNCTION mysql.field(character varying, VARIADIC text[]) OWNER TO postgres;

--
-- Name: find_in_set(text, text); Type: FUNCTION; Schema: mysql; Owner: postgres
--

CREATE FUNCTION find_in_set(str text, strlist text) RETURNS integer
    LANGUAGE sql STRICT
    AS $_$
SELECT i
   FROM generate_subscripts(string_to_array($2,','),1) g(i)
  WHERE (string_to_array($2, ','))[i] = $1
  UNION ALL
  SELECT 0
  LIMIT 1
$_$;


ALTER FUNCTION mysql.find_in_set(str text, strlist text) OWNER TO postgres;

--
-- Name: foreign_key_checks(boolean); Type: FUNCTION; Schema: mysql; Owner: postgres
--

CREATE FUNCTION foreign_key_checks(enable boolean) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
DECLARE public_table RECORD;
DECLARE count INT8;
BEGIN
count=0;
FOR public_table
IN SELECT tablename
FROM pg_catalog.pg_tables
WHERE schemaname='public' AND hastriggers=TRUE
LOOP
EXECUTE 'ALTER TABLE '||public_table.tablename||' '||
(CASE WHEN enable THEN 'EN' ELSE 'DIS' END)||
'ABLE TRIGGER ALL;';
count=count+1;
END LOOP;
RETURN count;
END;
$$;


ALTER FUNCTION mysql.foreign_key_checks(enable boolean) OWNER TO postgres;

--
-- Name: from_days(integer); Type: FUNCTION; Schema: mysql; Owner: postgres
--

CREATE FUNCTION from_days(integer) RETURNS date
    LANGUAGE sql
    AS $_$
SELECT date '0001-01-01bc' + $1
$_$;


ALTER FUNCTION mysql.from_days(integer) OWNER TO postgres;

--
-- Name: from_unixtime(double precision); Type: FUNCTION; Schema: mysql; Owner: postgres
--

CREATE FUNCTION from_unixtime(double precision) RETURNS timestamp without time zone
    LANGUAGE sql
    AS $_$
SELECT to_timestamp($1)::timestamp
$_$;


ALTER FUNCTION mysql.from_unixtime(double precision) OWNER TO postgres;

--
-- Name: get_format(text, text); Type: FUNCTION; Schema: mysql; Owner: postgres
--

CREATE FUNCTION get_format(text, text) RETURNS text
    LANGUAGE sql
    AS $_$
SELECT CASE lower($1)
WHEN 'date' THEN
CASE lower($2)
WHEN 'usa' THEN '%m.%d.%Y'
WHEN 'jis' THEN '%Y-%m-%d'
WHEN 'iso' THEN '%Y-%m-%d'
WHEN 'eur' THEN '%d.%m.%Y'
WHEN 'internal' THEN '%Y%m%d'
END
WHEN 'datetime' THEN
CASE lower($2)
WHEN 'usa' THEN '%Y-%m-%d %H-.%i.%s'
WHEN 'jis' THEN '%Y-%m-%d %H:%i:%s'
WHEN 'iso' THEN '%Y-%m-%d %H:%i:%s'
WHEN 'eur' THEN '%Y-%m-%d %H.%i.%s'
WHEN 'internal' THEN '%Y%m%d%H%i%s'
END
WHEN 'time' THEN
CASE lower($2)
WHEN 'usa' THEN '%h:%i:%s %p'
WHEN 'jis' THEN '%H:%i:%s'
WHEN 'iso' THEN '%H:%i:%s'
WHEN 'eur' THEN '%H.%i.%s'
WHEN 'internal' THEN '%H%i%s'
END
END;
$_$;


ALTER FUNCTION mysql.get_format(text, text) OWNER TO postgres;

--
-- Name: group_concat_atom(text, text); Type: FUNCTION; Schema: mysql; Owner: postgres
--

CREATE FUNCTION group_concat_atom(column1 text, column2 text) RETURNS text
    LANGUAGE plpgsql
    AS $$
BEGIN
RETURN COALESCE(column1||','||column2, column2, column1);
END;
$$;


ALTER FUNCTION mysql.group_concat_atom(column1 text, column2 text) OWNER TO postgres;

--
-- Name: group_concat_atom(bigint, bigint); Type: FUNCTION; Schema: mysql; Owner: postgres
--

CREATE FUNCTION group_concat_atom(column1 bigint, column2 bigint) RETURNS text
    LANGUAGE plpgsql
    AS $$
BEGIN
RETURN COALESCE(CAST(column1 AS TEXT)||','||CAST(column2 AS TEXT), CAST(column2 AS TEXT), CAST(column1 AS TEXT));
END;
$$;


ALTER FUNCTION mysql.group_concat_atom(column1 bigint, column2 bigint) OWNER TO postgres;

--
-- Name: group_concat_atom(bigint, text); Type: FUNCTION; Schema: mysql; Owner: postgres
--

CREATE FUNCTION group_concat_atom(column1 bigint, column2 text) RETURNS text
    LANGUAGE plpgsql
    AS $$
BEGIN
RETURN COALESCE(CAST(column1 AS TEXT)||','||column2, column2, CAST(column1 AS TEXT));
END;
$$;


ALTER FUNCTION mysql.group_concat_atom(column1 bigint, column2 text) OWNER TO postgres;

--
-- Name: group_concat_atom(text, bigint); Type: FUNCTION; Schema: mysql; Owner: postgres
--

CREATE FUNCTION group_concat_atom(column1 text, column2 bigint) RETURNS text
    LANGUAGE plpgsql
    AS $$
BEGIN
RETURN COALESCE(column1||','||CAST(column2 AS TEXT), CAST(column2 AS TEXT), column1);
END;
$$;


ALTER FUNCTION mysql.group_concat_atom(column1 text, column2 bigint) OWNER TO postgres;

--
-- Name: group_concat_atom(text, text, text); Type: FUNCTION; Schema: mysql; Owner: postgres
--

CREATE FUNCTION group_concat_atom(column1 text, column2 text, delimiter text) RETURNS text
    LANGUAGE plpgsql
    AS $$
BEGIN
RETURN COALESCE(column1||delimiter||column2, column2, column1);
END;
$$;


ALTER FUNCTION mysql.group_concat_atom(column1 text, column2 text, delimiter text) OWNER TO postgres;

--
-- Name: group_concat_atom(text, bigint, text); Type: FUNCTION; Schema: mysql; Owner: postgres
--

CREATE FUNCTION group_concat_atom(column1 text, column2 bigint, delimiter text) RETURNS text
    LANGUAGE plpgsql
    AS $$
BEGIN
RETURN COALESCE(column1||delimiter||CAST(column2 AS TEXT), CAST(column2 AS TEXT), column1);
END;
$$;


ALTER FUNCTION mysql.group_concat_atom(column1 text, column2 bigint, delimiter text) OWNER TO postgres;

--
-- Name: group_concat_atom(bigint, text, text); Type: FUNCTION; Schema: mysql; Owner: postgres
--

CREATE FUNCTION group_concat_atom(column1 bigint, column2 text, delimiter text) RETURNS text
    LANGUAGE plpgsql
    AS $$
BEGIN
RETURN COALESCE(CAST(column1 AS TEXT)||delimiter||column2, column2, CAST(column1 AS TEXT));
END;
$$;


ALTER FUNCTION mysql.group_concat_atom(column1 bigint, column2 text, delimiter text) OWNER TO postgres;

--
-- Name: group_concat_atom(bigint, bigint, text); Type: FUNCTION; Schema: mysql; Owner: postgres
--

CREATE FUNCTION group_concat_atom(column1 bigint, column2 bigint, delimiter text) RETURNS text
    LANGUAGE plpgsql
    AS $$
BEGIN
RETURN COALESCE(CAST(column1 AS TEXT)||delimiter||CAST(column2 AS TEXT), CAST(column2 AS TEXT), CAST(column1 AS TEXT));
END;
$$;


ALTER FUNCTION mysql.group_concat_atom(column1 bigint, column2 bigint, delimiter text) OWNER TO postgres;

--
-- Name: hex(integer); Type: FUNCTION; Schema: mysql; Owner: postgres
--

CREATE FUNCTION hex(integer) RETURNS text
    LANGUAGE sql
    AS $_$
SELECT upper(to_hex($1));
$_$;


ALTER FUNCTION mysql.hex(integer) OWNER TO postgres;

--
-- Name: hex(bigint); Type: FUNCTION; Schema: mysql; Owner: postgres
--

CREATE FUNCTION hex(bigint) RETURNS text
    LANGUAGE sql
    AS $_$
SELECT upper(to_hex($1));
$_$;


ALTER FUNCTION mysql.hex(bigint) OWNER TO postgres;

--
-- Name: hex(text); Type: FUNCTION; Schema: mysql; Owner: postgres
--

CREATE FUNCTION hex(text) RETURNS text
    LANGUAGE sql
    AS $_$
SELECT upper(encode($1::bytea, 'hex'))
$_$;


ALTER FUNCTION mysql.hex(text) OWNER TO postgres;

--
-- Name: hour(time without time zone); Type: FUNCTION; Schema: mysql; Owner: postgres
--

CREATE FUNCTION hour(time without time zone) RETURNS integer
    LANGUAGE sql
    AS $_$
SELECT EXTRACT(hour FROM $1)::int;
$_$;


ALTER FUNCTION mysql.hour(time without time zone) OWNER TO postgres;

--
-- Name: hour(timestamp without time zone); Type: FUNCTION; Schema: mysql; Owner: postgres
--

CREATE FUNCTION hour(timestamp without time zone) RETURNS integer
    LANGUAGE sql
    AS $_$
SELECT EXTRACT(hour FROM $1)::int;
$_$;


ALTER FUNCTION mysql.hour(timestamp without time zone) OWNER TO postgres;

--
-- Name: last_day(date); Type: FUNCTION; Schema: mysql; Owner: postgres
--

CREATE FUNCTION last_day(date) RETURNS date
    LANGUAGE sql
    AS $_$
SELECT (date_trunc('month',$1 + interval '1 month'))::date - 1
$_$;


ALTER FUNCTION mysql.last_day(date) OWNER TO postgres;

--
-- Name: lcase(text); Type: FUNCTION; Schema: mysql; Owner: postgres
--

CREATE FUNCTION lcase(str text) RETURNS text
    LANGUAGE sql
    AS $_$
SELECT lower($1)
$_$;


ALTER FUNCTION mysql.lcase(str text) OWNER TO postgres;

--
-- Name: left(text, integer); Type: FUNCTION; Schema: mysql; Owner: postgres
--

CREATE FUNCTION "left"(str text, len integer) RETURNS text
    LANGUAGE sql
    AS $_$
SELECT substring($1 FROM 1 FOR $2)
$_$;


ALTER FUNCTION mysql."left"(str text, len integer) OWNER TO postgres;

--
-- Name: locate(text, text); Type: FUNCTION; Schema: mysql; Owner: postgres
--

CREATE FUNCTION locate(substr text, str text) RETURNS integer
    LANGUAGE sql
    AS $_$
SELECT position($1 in $2)
$_$;


ALTER FUNCTION mysql.locate(substr text, str text) OWNER TO postgres;

--
-- Name: makedate(integer, integer); Type: FUNCTION; Schema: mysql; Owner: postgres
--

CREATE FUNCTION makedate(year integer, dayofyear integer) RETURNS date
    LANGUAGE sql
    AS $_$
SELECT (date '0001-01-01' + ($1 - 1) * interval '1 year' + ($2 - 1) * interval '1 day'):: date
$_$;


ALTER FUNCTION mysql.makedate(year integer, dayofyear integer) OWNER TO postgres;

--
-- Name: maketime(integer, integer, double precision); Type: FUNCTION; Schema: mysql; Owner: postgres
--

CREATE FUNCTION maketime(integer, integer, double precision) RETURNS time without time zone
    LANGUAGE sql
    AS $_$
SELECT time '00:00:00' + $1 * interval '1 hour' + $2 * interval '1 min'
+ $3 * interval '1 sec'
$_$;


ALTER FUNCTION mysql.maketime(integer, integer, double precision) OWNER TO postgres;

--
-- Name: minute(timestamp without time zone); Type: FUNCTION; Schema: mysql; Owner: postgres
--

CREATE FUNCTION minute(timestamp without time zone) RETURNS integer
    LANGUAGE sql
    AS $_$
SELECT EXTRACT(minute FROM $1)::int
$_$;


ALTER FUNCTION mysql.minute(timestamp without time zone) OWNER TO postgres;

--
-- Name: month(date); Type: FUNCTION; Schema: mysql; Owner: postgres
--

CREATE FUNCTION month(date) RETURNS integer
    LANGUAGE sql
    AS $_$
SELECT EXTRACT(month FROM $1)::int
$_$;


ALTER FUNCTION mysql.month(date) OWNER TO postgres;

--
-- Name: monthname(date); Type: FUNCTION; Schema: mysql; Owner: postgres
--

CREATE FUNCTION monthname(date) RETURNS text
    LANGUAGE sql
    AS $_$
SELECT to_char($1, 'TMMonth')
$_$;


ALTER FUNCTION mysql.monthname(date) OWNER TO postgres;

--
-- Name: reverse(text); Type: FUNCTION; Schema: mysql; Owner: postgres
--

CREATE FUNCTION reverse(str text) RETURNS text
    LANGUAGE sql
    AS $_$
SELECT array_to_string(ARRAY(SELECT substring($1 FROM i FOR 1)
                                FROM generate_series(length($1),1,-1) g(i)),
                       '')
$_$;


ALTER FUNCTION mysql.reverse(str text) OWNER TO postgres;

--
-- Name: right(text, integer); Type: FUNCTION; Schema: mysql; Owner: postgres
--

CREATE FUNCTION "right"(str text, len integer) RETURNS text
    LANGUAGE sql
    AS $_$
SELECT substring($1 FROM length($1) - $2 FOR $2)
$_$;


ALTER FUNCTION mysql."right"(str text, len integer) OWNER TO postgres;

--
-- Name: space(integer); Type: FUNCTION; Schema: mysql; Owner: postgres
--

CREATE FUNCTION space(n integer) RETURNS text
    LANGUAGE sql
    AS $_$
SELECT repeat(' ', $1)
$_$;


ALTER FUNCTION mysql.space(n integer) OWNER TO postgres;

--
-- Name: str_to_date(text, text); Type: FUNCTION; Schema: mysql; Owner: postgres
--

CREATE FUNCTION str_to_date(text, text) RETURNS date
    LANGUAGE sql
    AS $_$
SELECT to_date($1, mysql._mysqlf_pgsql($2))
$_$;


ALTER FUNCTION mysql.str_to_date(text, text) OWNER TO postgres;

--
-- Name: strcmp(text, text); Type: FUNCTION; Schema: mysql; Owner: postgres
--

CREATE FUNCTION strcmp(text, text) RETURNS integer
    LANGUAGE sql
    AS $_$
SELECT CASE WHEN $1 < $2 THEN -1
WHEN $1 > $2 THEN 1
ELSE 0 END;
$_$;


ALTER FUNCTION mysql.strcmp(text, text) OWNER TO postgres;

--
-- Name: substring_index(text, text, integer); Type: FUNCTION; Schema: mysql; Owner: postgres
--

CREATE FUNCTION substring_index(str text, delim text, count integer) RETURNS text
    LANGUAGE sql
    AS $_$
SELECT CASE WHEN $3 > 0 
THEN array_to_string((string_to_array($1, $2))[1:$3], $2)
ELSE array_to_string(ARRAY(SELECT unnest(string_to_array($1,$2))
                             OFFSET array_upper(string_to_array($1,$2),1) + $3),
                     $2)
END
$_$;


ALTER FUNCTION mysql.substring_index(str text, delim text, count integer) OWNER TO postgres;

--
-- Name: time(timestamp without time zone); Type: FUNCTION; Schema: mysql; Owner: postgres
--

CREATE FUNCTION "time"(timestamp without time zone) RETURNS time without time zone
    LANGUAGE sql
    AS $_$
SELECT $1::time
$_$;


ALTER FUNCTION mysql."time"(timestamp without time zone) OWNER TO postgres;

--
-- Name: to_days(date); Type: FUNCTION; Schema: mysql; Owner: postgres
--

CREATE FUNCTION to_days(date) RETURNS integer
    LANGUAGE sql
    AS $_$
SELECT $1 - '0001-01-01bc'
$_$;


ALTER FUNCTION mysql.to_days(date) OWNER TO postgres;

--
-- Name: ucase(text); Type: FUNCTION; Schema: mysql; Owner: postgres
--

CREATE FUNCTION ucase(str text) RETURNS text
    LANGUAGE sql
    AS $_$
SELECT upper($1)
$_$;


ALTER FUNCTION mysql.ucase(str text) OWNER TO postgres;

--
-- Name: unhex(text); Type: FUNCTION; Schema: mysql; Owner: postgres
--

CREATE FUNCTION unhex(text) RETURNS text
    LANGUAGE sql
    AS $_$
SELECT convert_from(decode($1, 'hex'),'utf8');
$_$;


ALTER FUNCTION mysql.unhex(text) OWNER TO postgres;

--
-- Name: unix_timestamp(); Type: FUNCTION; Schema: mysql; Owner: postgres
--

CREATE FUNCTION unix_timestamp() RETURNS double precision
    LANGUAGE sql
    AS $$
SELECT EXTRACT(epoch FROM current_timestamp)
$$;


ALTER FUNCTION mysql.unix_timestamp() OWNER TO postgres;

--
-- Name: unix_timestamp(timestamp without time zone); Type: FUNCTION; Schema: mysql; Owner: postgres
--

CREATE FUNCTION unix_timestamp(timestamp without time zone) RETURNS double precision
    LANGUAGE sql
    AS $_$
SELECT EXTRACT(epoch FROM $1)
$_$;


ALTER FUNCTION mysql.unix_timestamp(timestamp without time zone) OWNER TO postgres;

--
-- Name: week(date); Type: FUNCTION; Schema: mysql; Owner: postgres
--

CREATE FUNCTION week(date) RETURNS integer
    LANGUAGE sql
    AS $_$
SELECT EXTRACT(week FROM $1)::int;
$_$;


ALTER FUNCTION mysql.week(date) OWNER TO postgres;

--
-- Name: year(date); Type: FUNCTION; Schema: mysql; Owner: postgres
--

CREATE FUNCTION year(date) RETURNS integer
    LANGUAGE sql
    AS $_$
SELECT EXTRACT(year FROM $1)::int
$_$;


ALTER FUNCTION mysql.year(date) OWNER TO postgres;

SET search_path = public, pg_catalog;

--
-- Name: post_tsv(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION post_tsv() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.tsv := 'rrr';
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.post_tsv() OWNER TO postgres;

SET search_path = mysql, pg_catalog;

--
-- Name: group_concat(text); Type: AGGREGATE; Schema: mysql; Owner: postgres
--

CREATE AGGREGATE group_concat(text) (
    SFUNC = mysql.group_concat_atom,
    STYPE = text
);


ALTER AGGREGATE mysql.group_concat(text) OWNER TO postgres;

--
-- Name: group_concat(bigint); Type: AGGREGATE; Schema: mysql; Owner: postgres
--

CREATE AGGREGATE group_concat(bigint) (
    SFUNC = mysql.group_concat_atom,
    STYPE = text
);


ALTER AGGREGATE mysql.group_concat(bigint) OWNER TO postgres;

--
-- Name: group_concat(text, text); Type: AGGREGATE; Schema: mysql; Owner: postgres
--

CREATE AGGREGATE group_concat(text, text) (
    SFUNC = mysql.group_concat_atom,
    STYPE = text
);


ALTER AGGREGATE mysql.group_concat(text, text) OWNER TO postgres;

--
-- Name: group_concat(bigint, text); Type: AGGREGATE; Schema: mysql; Owner: postgres
--

CREATE AGGREGATE group_concat(bigint, text) (
    SFUNC = mysql.group_concat_atom,
    STYPE = text
);


ALTER AGGREGATE mysql.group_concat(bigint, text) OWNER TO postgres;

SET search_path = pg_catalog;

--
-- Name: CAST (date AS integer); Type: CAST; Schema: pg_catalog; Owner: 
--

CREATE CAST (date AS integer) WITH FUNCTION casts._date_to_integer(date) AS IMPLICIT;


--
-- Name: CAST (date AS bigint); Type: CAST; Schema: pg_catalog; Owner: 
--

CREATE CAST (date AS bigint) WITH FUNCTION casts._date_to_bigint(date) AS IMPLICIT;


--
-- Name: CAST (interval AS bigint); Type: CAST; Schema: pg_catalog; Owner: 
--

CREATE CAST (interval AS bigint) WITH FUNCTION casts._interval_to_bigint(interval) AS IMPLICIT;


--
-- Name: CAST (text AS date); Type: CAST; Schema: pg_catalog; Owner: 
--

CREATE CAST (text AS date) WITH FUNCTION casts._text_to_date(text) AS IMPLICIT;


--
-- Name: CAST (text AS bigint); Type: CAST; Schema: pg_catalog; Owner: 
--

CREATE CAST (text AS bigint) WITH FUNCTION casts._text_to_bigint(text) AS IMPLICIT;


--
-- Name: CAST (text AS numeric); Type: CAST; Schema: pg_catalog; Owner: 
--

CREATE CAST (text AS numeric) WITH FUNCTION casts._text_to_numeric(text) AS IMPLICIT;


--
-- Name: CAST (text AS time without time zone); Type: CAST; Schema: pg_catalog; Owner: 
--

CREATE CAST (text AS time without time zone) WITH FUNCTION casts._text_to_time(text) AS IMPLICIT;


--
-- Name: CAST (text AS timestamp without time zone); Type: CAST; Schema: pg_catalog; Owner: 
--

CREATE CAST (text AS timestamp without time zone) WITH FUNCTION casts._text_to_timestamp(text) AS IMPLICIT;


--
-- Name: CAST (text AS timestamp with time zone); Type: CAST; Schema: pg_catalog; Owner: 
--

CREATE CAST (text AS timestamp with time zone) WITH FUNCTION casts._text_to_timestamptz(text) AS IMPLICIT;


--
-- Name: CAST (time without time zone AS integer); Type: CAST; Schema: pg_catalog; Owner: 
--

CREATE CAST (time without time zone AS integer) WITH FUNCTION casts._time_to_integer(time without time zone) AS IMPLICIT;


--
-- Name: CAST (time with time zone AS integer); Type: CAST; Schema: pg_catalog; Owner: 
--

CREATE CAST (time with time zone AS integer) WITH FUNCTION casts._time_to_integer(time with time zone) AS IMPLICIT;


--
-- Name: CAST (unknown AS bigint); Type: CAST; Schema: pg_catalog; Owner: 
--

CREATE CAST (unknown AS bigint) WITH FUNCTION casts._unknown_to_bigint(unknown) AS IMPLICIT;


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: wp_commentmeta; Type: TABLE; Schema: public; Owner: wordpress; Tablespace: 
--

CREATE TABLE wp_commentmeta (
    meta_id bigint NOT NULL,
    comment_id bigint DEFAULT 0::bigint,
    meta_key character varying(255) DEFAULT NULL::character varying,
    meta_value text
);


ALTER TABLE public.wp_commentmeta OWNER TO wordpress;

--
-- Name: wp_commentmeta_meta_id_seq; Type: SEQUENCE; Schema: public; Owner: wordpress
--

CREATE SEQUENCE wp_commentmeta_meta_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.wp_commentmeta_meta_id_seq OWNER TO wordpress;

--
-- Name: wp_commentmeta_meta_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: wordpress
--

ALTER SEQUENCE wp_commentmeta_meta_id_seq OWNED BY wp_commentmeta.meta_id;


--
-- Name: wp_comments; Type: TABLE; Schema: public; Owner: wordpress; Tablespace: 
--

CREATE TABLE wp_comments (
    "comment_ID" bigint NOT NULL,
    "comment_post_ID" bigint DEFAULT 0::bigint,
    comment_author text NOT NULL,
    comment_author_email character varying(100) DEFAULT ''::character varying,
    comment_author_url character varying(200) DEFAULT ''::character varying,
    "comment_author_IP" character varying(100) DEFAULT ''::character varying,
    comment_date timestamp without time zone DEFAULT '0001-01-01 00:00:00'::timestamp without time zone,
    comment_date_gmt timestamp without time zone DEFAULT '0001-01-01 00:00:00'::timestamp without time zone,
    comment_content text NOT NULL,
    comment_karma integer DEFAULT 0,
    comment_approved character varying(20) DEFAULT '1'::character varying,
    comment_agent character varying(255) DEFAULT ''::character varying,
    comment_type character varying(20) DEFAULT ''::character varying,
    comment_parent bigint DEFAULT 0::bigint,
    user_id bigint DEFAULT 0::bigint
);


ALTER TABLE public.wp_comments OWNER TO wordpress;

--
-- Name: wp_comments_comment_ID_seq; Type: SEQUENCE; Schema: public; Owner: wordpress
--

CREATE SEQUENCE "wp_comments_comment_ID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."wp_comments_comment_ID_seq" OWNER TO wordpress;

--
-- Name: wp_comments_comment_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: wordpress
--

ALTER SEQUENCE "wp_comments_comment_ID_seq" OWNED BY wp_comments."comment_ID";


--
-- Name: wp_links; Type: TABLE; Schema: public; Owner: wordpress; Tablespace: 
--

CREATE TABLE wp_links (
    link_id bigint NOT NULL,
    link_url character varying(255) DEFAULT ''::character varying,
    link_name character varying(255) DEFAULT ''::character varying,
    link_image character varying(255) DEFAULT ''::character varying,
    link_target character varying(25) DEFAULT ''::character varying,
    link_description character varying(255) DEFAULT ''::character varying,
    link_visible character varying(20) DEFAULT 'Y'::character varying,
    link_owner bigint DEFAULT 1::bigint,
    link_rating integer DEFAULT 0,
    link_updated timestamp without time zone DEFAULT '0001-01-01 00:00:00'::timestamp without time zone,
    link_rel character varying(255) DEFAULT ''::character varying,
    link_notes text NOT NULL,
    link_rss character varying(255) DEFAULT ''::character varying
);


ALTER TABLE public.wp_links OWNER TO wordpress;

--
-- Name: wp_links_link_id_seq; Type: SEQUENCE; Schema: public; Owner: wordpress
--

CREATE SEQUENCE wp_links_link_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.wp_links_link_id_seq OWNER TO wordpress;

--
-- Name: wp_links_link_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: wordpress
--

ALTER SEQUENCE wp_links_link_id_seq OWNED BY wp_links.link_id;


--
-- Name: wp_options; Type: TABLE; Schema: public; Owner: wordpress; Tablespace: 
--

CREATE TABLE wp_options (
    option_id bigint NOT NULL,
    option_name character varying(64) DEFAULT ''::character varying,
    option_value text NOT NULL,
    autoload character varying(20) DEFAULT 'yes'::character varying
);


ALTER TABLE public.wp_options OWNER TO wordpress;

--
-- Name: wp_options_option_id_seq; Type: SEQUENCE; Schema: public; Owner: wordpress
--

CREATE SEQUENCE wp_options_option_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.wp_options_option_id_seq OWNER TO wordpress;

--
-- Name: wp_options_option_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: wordpress
--

ALTER SEQUENCE wp_options_option_id_seq OWNED BY wp_options.option_id;


--
-- Name: wp_postmeta; Type: TABLE; Schema: public; Owner: wordpress; Tablespace: 
--

CREATE TABLE wp_postmeta (
    meta_id bigint NOT NULL,
    post_id bigint DEFAULT 0::bigint,
    meta_key character varying(255) DEFAULT NULL::character varying,
    meta_value text
);


ALTER TABLE public.wp_postmeta OWNER TO wordpress;

--
-- Name: wp_postmeta_meta_id_seq; Type: SEQUENCE; Schema: public; Owner: wordpress
--

CREATE SEQUENCE wp_postmeta_meta_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.wp_postmeta_meta_id_seq OWNER TO wordpress;

--
-- Name: wp_postmeta_meta_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: wordpress
--

ALTER SEQUENCE wp_postmeta_meta_id_seq OWNED BY wp_postmeta.meta_id;


--
-- Name: wp_posts; Type: TABLE; Schema: public; Owner: wordpress; Tablespace: 
--

CREATE TABLE wp_posts (
    "ID" bigint NOT NULL,
    post_author bigint DEFAULT 0::bigint,
    post_date timestamp without time zone DEFAULT '0001-01-01 00:00:00'::timestamp without time zone,
    post_date_gmt timestamp without time zone DEFAULT '0001-01-01 00:00:00'::timestamp without time zone,
    post_content text NOT NULL,
    post_title text NOT NULL,
    post_excerpt text NOT NULL,
    post_status character varying(20) DEFAULT 'publish'::character varying,
    comment_status character varying(20) DEFAULT 'open'::character varying,
    ping_status character varying(20) DEFAULT 'open'::character varying,
    post_password character varying(20) DEFAULT ''::character varying,
    post_name character varying(200) DEFAULT ''::character varying,
    to_ping text NOT NULL,
    pinged text NOT NULL,
    post_modified timestamp without time zone DEFAULT '0001-01-01 00:00:00'::timestamp without time zone,
    post_modified_gmt timestamp without time zone DEFAULT '0001-01-01 00:00:00'::timestamp without time zone,
    post_content_filtered text NOT NULL,
    post_parent bigint DEFAULT 0::bigint,
    guid character varying(255) DEFAULT ''::character varying,
    menu_order integer DEFAULT 0,
    post_type character varying(20) DEFAULT 'post'::character varying,
    post_mime_type character varying(100) DEFAULT ''::character varying,
    comment_count bigint DEFAULT 0::bigint,
    tsv tsvector
);


ALTER TABLE public.wp_posts OWNER TO wordpress;

--
-- Name: wp_posts_ID_seq; Type: SEQUENCE; Schema: public; Owner: wordpress
--

CREATE SEQUENCE "wp_posts_ID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."wp_posts_ID_seq" OWNER TO wordpress;

--
-- Name: wp_posts_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: wordpress
--

ALTER SEQUENCE "wp_posts_ID_seq" OWNED BY wp_posts."ID";


--
-- Name: wp_term_relationships; Type: TABLE; Schema: public; Owner: wordpress; Tablespace: 
--

CREATE TABLE wp_term_relationships (
    object_id bigint NOT NULL,
    term_taxonomy_id bigint DEFAULT (0)::bigint NOT NULL,
    term_order integer DEFAULT 0
);


ALTER TABLE public.wp_term_relationships OWNER TO wordpress;

--
-- Name: wp_term_relationships_object_id_seq; Type: SEQUENCE; Schema: public; Owner: wordpress
--

CREATE SEQUENCE wp_term_relationships_object_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.wp_term_relationships_object_id_seq OWNER TO wordpress;

--
-- Name: wp_term_relationships_object_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: wordpress
--

ALTER SEQUENCE wp_term_relationships_object_id_seq OWNED BY wp_term_relationships.object_id;


--
-- Name: wp_term_taxonomy; Type: TABLE; Schema: public; Owner: wordpress; Tablespace: 
--

CREATE TABLE wp_term_taxonomy (
    term_taxonomy_id bigint NOT NULL,
    term_id bigint DEFAULT 0::bigint,
    taxonomy character varying(32) DEFAULT ''::character varying,
    description text NOT NULL,
    parent bigint DEFAULT 0::bigint,
    count bigint DEFAULT 0::bigint
);


ALTER TABLE public.wp_term_taxonomy OWNER TO wordpress;

--
-- Name: wp_term_taxonomy_term_taxonomy_id_seq; Type: SEQUENCE; Schema: public; Owner: wordpress
--

CREATE SEQUENCE wp_term_taxonomy_term_taxonomy_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.wp_term_taxonomy_term_taxonomy_id_seq OWNER TO wordpress;

--
-- Name: wp_term_taxonomy_term_taxonomy_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: wordpress
--

ALTER SEQUENCE wp_term_taxonomy_term_taxonomy_id_seq OWNED BY wp_term_taxonomy.term_taxonomy_id;


--
-- Name: wp_terms; Type: TABLE; Schema: public; Owner: wordpress; Tablespace: 
--

CREATE TABLE wp_terms (
    term_id bigint NOT NULL,
    name character varying(200) DEFAULT ''::character varying,
    slug character varying(200) DEFAULT ''::character varying,
    term_group bigint DEFAULT 0::bigint
);


ALTER TABLE public.wp_terms OWNER TO wordpress;

--
-- Name: wp_terms_term_id_seq; Type: SEQUENCE; Schema: public; Owner: wordpress
--

CREATE SEQUENCE wp_terms_term_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.wp_terms_term_id_seq OWNER TO wordpress;

--
-- Name: wp_terms_term_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: wordpress
--

ALTER SEQUENCE wp_terms_term_id_seq OWNED BY wp_terms.term_id;


--
-- Name: wp_usermeta; Type: TABLE; Schema: public; Owner: wordpress; Tablespace: 
--

CREATE TABLE wp_usermeta (
    umeta_id bigint NOT NULL,
    user_id bigint DEFAULT 0::bigint,
    meta_key character varying(255) DEFAULT NULL::character varying,
    meta_value text
);


ALTER TABLE public.wp_usermeta OWNER TO wordpress;

--
-- Name: wp_usermeta_umeta_id_seq; Type: SEQUENCE; Schema: public; Owner: wordpress
--

CREATE SEQUENCE wp_usermeta_umeta_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.wp_usermeta_umeta_id_seq OWNER TO wordpress;

--
-- Name: wp_usermeta_umeta_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: wordpress
--

ALTER SEQUENCE wp_usermeta_umeta_id_seq OWNED BY wp_usermeta.umeta_id;


--
-- Name: wp_users; Type: TABLE; Schema: public; Owner: wordpress; Tablespace: 
--

CREATE TABLE wp_users (
    "ID" bigint NOT NULL,
    user_login character varying(60) DEFAULT ''::character varying,
    user_pass character varying(64) DEFAULT ''::character varying,
    user_nicename character varying(50) DEFAULT ''::character varying,
    user_email character varying(100) DEFAULT ''::character varying,
    user_url character varying(100) DEFAULT ''::character varying,
    user_registered timestamp without time zone DEFAULT '0001-01-01 00:00:00'::timestamp without time zone,
    user_activation_key character varying(60) DEFAULT ''::character varying,
    user_status integer DEFAULT 0,
    display_name character varying(250) DEFAULT ''::character varying
);


ALTER TABLE public.wp_users OWNER TO wordpress;

--
-- Name: wp_users_ID_seq; Type: SEQUENCE; Schema: public; Owner: wordpress
--

CREATE SEQUENCE "wp_users_ID_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."wp_users_ID_seq" OWNER TO wordpress;

--
-- Name: wp_users_ID_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: wordpress
--

ALTER SEQUENCE "wp_users_ID_seq" OWNED BY wp_users."ID";


--
-- Name: meta_id; Type: DEFAULT; Schema: public; Owner: wordpress
--

ALTER TABLE ONLY wp_commentmeta ALTER COLUMN meta_id SET DEFAULT nextval('wp_commentmeta_meta_id_seq'::regclass);


--
-- Name: comment_ID; Type: DEFAULT; Schema: public; Owner: wordpress
--

ALTER TABLE ONLY wp_comments ALTER COLUMN "comment_ID" SET DEFAULT nextval('"wp_comments_comment_ID_seq"'::regclass);


--
-- Name: link_id; Type: DEFAULT; Schema: public; Owner: wordpress
--

ALTER TABLE ONLY wp_links ALTER COLUMN link_id SET DEFAULT nextval('wp_links_link_id_seq'::regclass);


--
-- Name: option_id; Type: DEFAULT; Schema: public; Owner: wordpress
--

ALTER TABLE ONLY wp_options ALTER COLUMN option_id SET DEFAULT nextval('wp_options_option_id_seq'::regclass);


--
-- Name: meta_id; Type: DEFAULT; Schema: public; Owner: wordpress
--

ALTER TABLE ONLY wp_postmeta ALTER COLUMN meta_id SET DEFAULT nextval('wp_postmeta_meta_id_seq'::regclass);


--
-- Name: ID; Type: DEFAULT; Schema: public; Owner: wordpress
--

ALTER TABLE ONLY wp_posts ALTER COLUMN "ID" SET DEFAULT nextval('"wp_posts_ID_seq"'::regclass);


--
-- Name: object_id; Type: DEFAULT; Schema: public; Owner: wordpress
--

ALTER TABLE ONLY wp_term_relationships ALTER COLUMN object_id SET DEFAULT nextval('wp_term_relationships_object_id_seq'::regclass);


--
-- Name: term_taxonomy_id; Type: DEFAULT; Schema: public; Owner: wordpress
--

ALTER TABLE ONLY wp_term_taxonomy ALTER COLUMN term_taxonomy_id SET DEFAULT nextval('wp_term_taxonomy_term_taxonomy_id_seq'::regclass);


--
-- Name: term_id; Type: DEFAULT; Schema: public; Owner: wordpress
--

ALTER TABLE ONLY wp_terms ALTER COLUMN term_id SET DEFAULT nextval('wp_terms_term_id_seq'::regclass);


--
-- Name: umeta_id; Type: DEFAULT; Schema: public; Owner: wordpress
--

ALTER TABLE ONLY wp_usermeta ALTER COLUMN umeta_id SET DEFAULT nextval('wp_usermeta_umeta_id_seq'::regclass);


--
-- Name: ID; Type: DEFAULT; Schema: public; Owner: wordpress
--

ALTER TABLE ONLY wp_users ALTER COLUMN "ID" SET DEFAULT nextval('"wp_users_ID_seq"'::regclass);


--
-- Data for Name: wp_commentmeta; Type: TABLE DATA; Schema: public; Owner: wordpress
--



--
-- Name: wp_commentmeta_meta_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wordpress
--

SELECT pg_catalog.setval('wp_commentmeta_meta_id_seq', 1, false);


--
-- Data for Name: wp_comments; Type: TABLE DATA; Schema: public; Owner: wordpress
--

INSERT INTO wp_comments ("comment_ID", "comment_post_ID", comment_author, comment_author_email, comment_author_url, "comment_author_IP", comment_date, comment_date_gmt, comment_content, comment_karma, comment_approved, comment_agent, comment_type, comment_parent, user_id) VALUES (1, 1, 'Mr WordPress', '', 'http://wordpress.org/', '', '2013-08-11 14:03:28', '2013-08-11 14:03:28', 'Hi, this is a comment.
To delete a comment, just log in and view the post&#039;s comments. There you will have the option to edit or delete them.', 0, '1', '', '', 0, 0);


--
-- Name: wp_comments_comment_ID_seq; Type: SEQUENCE SET; Schema: public; Owner: wordpress
--

SELECT pg_catalog.setval('"wp_comments_comment_ID_seq"', 2, true);


--
-- Data for Name: wp_links; Type: TABLE DATA; Schema: public; Owner: wordpress
--



--
-- Name: wp_links_link_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wordpress
--

SELECT pg_catalog.setval('wp_links_link_id_seq', 1, false);


--
-- Data for Name: wp_options; Type: TABLE DATA; Schema: public; Owner: wordpress
--

INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (1, 'siteurl', 'http://[% HOST_NAME %]', 'yes');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (2, 'blogname', 'the site', 'yes');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (3, 'blogdescription', 'Just another WordPress site', 'yes');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (4, 'users_can_register', '0', 'yes');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (5, 'admin_email', 'admin@admin.admin', 'yes');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (6, 'start_of_week', '1', 'yes');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (7, 'use_balanceTags', '0', 'yes');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (8, 'use_smilies', '1', 'yes');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (9, 'require_name_email', '1', 'yes');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (10, 'comments_notify', '1', 'yes');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (11, 'posts_per_rss', '10', 'yes');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (12, 'rss_use_excerpt', '0', 'yes');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (13, 'mailserver_url', 'mail.example.com', 'yes');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (14, 'mailserver_login', 'login@example.com', 'yes');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (15, 'mailserver_pass', 'password', 'yes');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (16, 'mailserver_port', '110', 'yes');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (17, 'default_category', '1', 'yes');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (18, 'default_comment_status', 'open', 'yes');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (19, 'default_ping_status', 'open', 'yes');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (20, 'default_pingback_flag', '1', 'yes');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (21, 'posts_per_page', '10', 'yes');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (22, 'date_format', 'F j, Y', 'yes');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (23, 'time_format', 'g:i a', 'yes');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (24, 'links_updated_date_format', 'F j, Y g:i a', 'yes');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (25, 'links_recently_updated_prepend', '<em>', 'yes');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (26, 'links_recently_updated_append', '</em>', 'yes');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (27, 'links_recently_updated_time', '120', 'yes');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (28, 'comment_moderation', '0', 'yes');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (29, 'moderation_notify', '1', 'yes');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (30, 'permalink_structure', '', 'yes');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (31, 'gzipcompression', '0', 'yes');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (32, 'hack_file', '0', 'yes');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (33, 'blog_charset', 'UTF-8', 'yes');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (34, 'moderation_keys', '', 'no');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (35, 'active_plugins', 'a:0:{}', 'yes');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (36, 'home', 'http://[% HOST_NAME %]', 'yes');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (37, 'category_base', '', 'yes');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (38, 'ping_sites', 'http://rpc.pingomatic.com/', 'yes');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (39, 'advanced_edit', '0', 'yes');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (40, 'comment_max_links', '2', 'yes');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (41, 'gmt_offset', '0', 'yes');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (42, 'default_email_category', '1', 'yes');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (43, 'recently_edited', '', 'no');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (44, 'template', 'twentythirteen', 'yes');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (45, 'stylesheet', 'twentythirteen', 'yes');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (46, 'comment_whitelist', '1', 'yes');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (47, 'blacklist_keys', '', 'no');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (48, 'comment_registration', '0', 'yes');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (49, 'html_type', 'text/html', 'yes');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (50, 'use_trackback', '0', 'yes');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (51, 'default_role', 'subscriber', 'yes');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (52, 'db_version', '24448', 'yes');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (53, 'uploads_use_yearmonth_folders', '1', 'yes');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (54, 'upload_path', '', 'yes');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (55, 'blog_public', '1', 'yes');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (56, 'default_link_category', '2', 'yes');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (57, 'show_on_front', 'posts', 'yes');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (58, 'tag_base', '', 'yes');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (59, 'show_avatars', '1', 'yes');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (60, 'avatar_rating', 'G', 'yes');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (61, 'upload_url_path', '', 'yes');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (62, 'thumbnail_size_w', '150', 'yes');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (63, 'thumbnail_size_h', '150', 'yes');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (64, 'thumbnail_crop', '1', 'yes');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (65, 'medium_size_w', '300', 'yes');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (66, 'medium_size_h', '300', 'yes');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (67, 'avatar_default', 'mystery', 'yes');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (68, 'large_size_w', '1024', 'yes');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (69, 'large_size_h', '1024', 'yes');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (70, 'image_default_link_type', 'file', 'yes');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (71, 'image_default_size', '', 'yes');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (72, 'image_default_align', '', 'yes');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (73, 'close_comments_for_old_posts', '0', 'yes');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (74, 'close_comments_days_old', '14', 'yes');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (75, 'thread_comments', '1', 'yes');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (76, 'thread_comments_depth', '5', 'yes');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (77, 'page_comments', '0', 'yes');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (78, 'comments_per_page', '50', 'yes');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (79, 'default_comments_page', 'newest', 'yes');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (80, 'comment_order', 'asc', 'yes');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (81, 'sticky_posts', 'a:0:{}', 'yes');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (82, 'widget_categories', 'a:2:{i:2;a:4:{s:5:"title";s:0:"";s:5:"count";i:0;s:12:"hierarchical";i:0;s:8:"dropdown";i:0;}s:12:"_multiwidget";i:1;}', 'yes');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (83, 'widget_text', 'a:0:{}', 'yes');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (84, 'widget_rss', 'a:0:{}', 'yes');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (85, 'uninstall_plugins', 'a:0:{}', 'no');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (86, 'timezone_string', '', 'yes');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (87, 'page_for_posts', '0', 'yes');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (88, 'page_on_front', '0', 'yes');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (89, 'default_post_format', '0', 'yes');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (90, 'link_manager_enabled', '0', 'yes');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (91, 'initial_db_version', '24448', 'yes');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (92, 'wp_user_roles', 'a:5:{s:13:"administrator";a:2:{s:4:"name";s:13:"Administrator";s:12:"capabilities";a:62:{s:13:"switch_themes";b:1;s:11:"edit_themes";b:1;s:16:"activate_plugins";b:1;s:12:"edit_plugins";b:1;s:10:"edit_users";b:1;s:10:"edit_files";b:1;s:14:"manage_options";b:1;s:17:"moderate_comments";b:1;s:17:"manage_categories";b:1;s:12:"manage_links";b:1;s:12:"upload_files";b:1;s:6:"import";b:1;s:15:"unfiltered_html";b:1;s:10:"edit_posts";b:1;s:17:"edit_others_posts";b:1;s:20:"edit_published_posts";b:1;s:13:"publish_posts";b:1;s:10:"edit_pages";b:1;s:4:"read";b:1;s:8:"level_10";b:1;s:7:"level_9";b:1;s:7:"level_8";b:1;s:7:"level_7";b:1;s:7:"level_6";b:1;s:7:"level_5";b:1;s:7:"level_4";b:1;s:7:"level_3";b:1;s:7:"level_2";b:1;s:7:"level_1";b:1;s:7:"level_0";b:1;s:17:"edit_others_pages";b:1;s:20:"edit_published_pages";b:1;s:13:"publish_pages";b:1;s:12:"delete_pages";b:1;s:19:"delete_others_pages";b:1;s:22:"delete_published_pages";b:1;s:12:"delete_posts";b:1;s:19:"delete_others_posts";b:1;s:22:"delete_published_posts";b:1;s:20:"delete_private_posts";b:1;s:18:"edit_private_posts";b:1;s:18:"read_private_posts";b:1;s:20:"delete_private_pages";b:1;s:18:"edit_private_pages";b:1;s:18:"read_private_pages";b:1;s:12:"delete_users";b:1;s:12:"create_users";b:1;s:17:"unfiltered_upload";b:1;s:14:"edit_dashboard";b:1;s:14:"update_plugins";b:1;s:14:"delete_plugins";b:1;s:15:"install_plugins";b:1;s:13:"update_themes";b:1;s:14:"install_themes";b:1;s:11:"update_core";b:1;s:10:"list_users";b:1;s:12:"remove_users";b:1;s:9:"add_users";b:1;s:13:"promote_users";b:1;s:18:"edit_theme_options";b:1;s:13:"delete_themes";b:1;s:6:"export";b:1;}}s:6:"editor";a:2:{s:4:"name";s:6:"Editor";s:12:"capabilities";a:34:{s:17:"moderate_comments";b:1;s:17:"manage_categories";b:1;s:12:"manage_links";b:1;s:12:"upload_files";b:1;s:15:"unfiltered_html";b:1;s:10:"edit_posts";b:1;s:17:"edit_others_posts";b:1;s:20:"edit_published_posts";b:1;s:13:"publish_posts";b:1;s:10:"edit_pages";b:1;s:4:"read";b:1;s:7:"level_7";b:1;s:7:"level_6";b:1;s:7:"level_5";b:1;s:7:"level_4";b:1;s:7:"level_3";b:1;s:7:"level_2";b:1;s:7:"level_1";b:1;s:7:"level_0";b:1;s:17:"edit_others_pages";b:1;s:20:"edit_published_pages";b:1;s:13:"publish_pages";b:1;s:12:"delete_pages";b:1;s:19:"delete_others_pages";b:1;s:22:"delete_published_pages";b:1;s:12:"delete_posts";b:1;s:19:"delete_others_posts";b:1;s:22:"delete_published_posts";b:1;s:20:"delete_private_posts";b:1;s:18:"edit_private_posts";b:1;s:18:"read_private_posts";b:1;s:20:"delete_private_pages";b:1;s:18:"edit_private_pages";b:1;s:18:"read_private_pages";b:1;}}s:6:"author";a:2:{s:4:"name";s:6:"Author";s:12:"capabilities";a:10:{s:12:"upload_files";b:1;s:10:"edit_posts";b:1;s:20:"edit_published_posts";b:1;s:13:"publish_posts";b:1;s:4:"read";b:1;s:7:"level_2";b:1;s:7:"level_1";b:1;s:7:"level_0";b:1;s:12:"delete_posts";b:1;s:22:"delete_published_posts";b:1;}}s:11:"contributor";a:2:{s:4:"name";s:11:"Contributor";s:12:"capabilities";a:5:{s:10:"edit_posts";b:1;s:4:"read";b:1;s:7:"level_1";b:1;s:7:"level_0";b:1;s:12:"delete_posts";b:1;}}s:10:"subscriber";a:2:{s:4:"name";s:10:"Subscriber";s:12:"capabilities";a:2:{s:4:"read";b:1;s:7:"level_0";b:1;}}}', 'yes');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (93, 'widget_search', 'a:2:{i:2;a:1:{s:5:"title";s:0:"";}s:12:"_multiwidget";i:1;}', 'yes');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (94, 'widget_recent-posts', 'a:2:{i:2;a:2:{s:5:"title";s:0:"";s:6:"number";i:5;}s:12:"_multiwidget";i:1;}', 'yes');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (95, 'widget_recent-comments', 'a:2:{i:2;a:2:{s:5:"title";s:0:"";s:6:"number";i:5;}s:12:"_multiwidget";i:1;}', 'yes');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (96, 'widget_archives', 'a:2:{i:2;a:3:{s:5:"title";s:0:"";s:5:"count";i:0;s:8:"dropdown";i:0;}s:12:"_multiwidget";i:1;}', 'yes');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (97, 'widget_meta', 'a:2:{i:2;a:1:{s:5:"title";s:0:"";}s:12:"_multiwidget";i:1;}', 'yes');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (98, 'sidebars_widgets', 'a:4:{s:19:"wp_inactive_widgets";a:0:{}s:9:"sidebar-1";a:6:{i:0;s:8:"search-2";i:1;s:14:"recent-posts-2";i:2;s:17:"recent-comments-2";i:3;s:10:"archives-2";i:4;s:12:"categories-2";i:5;s:6:"meta-2";}s:9:"sidebar-2";a:0:{}s:13:"array_version";i:3;}', 'yes');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (106, '_site_transient_timeout_browser_2e3083065e3876c46c8742cedf860e44', '1376834615', 'yes');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (107, '_site_transient_browser_2e3083065e3876c46c8742cedf860e44', 'a:9:{s:8:"platform";s:7:"Windows";s:4:"name";s:6:"Chrome";s:7:"version";s:12:"28.0.1500.95";s:10:"update_url";s:28:"http://www.google.com/chrome";s:7:"img_src";s:49:"http://s.wordpress.org/images/browsers/chrome.png";s:11:"img_src_ssl";s:48:"https://wordpress.org/images/browsers/chrome.png";s:15:"current_version";s:2:"18";s:7:"upgrade";b:0;s:8:"insecure";b:0;}', 'yes');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (108, 'dashboard_widget_options', 'a:4:{s:25:"dashboard_recent_comments";a:1:{s:5:"items";i:5;}s:24:"dashboard_incoming_links";a:5:{s:4:"home";s:20:"http://[% HOST_NAME %]";s:4:"link";s:96:"http://blogsearch.google.com/blogsearch?scoring=d&partner=wordpress&q=link:http://[% HOST_NAME %]/";s:3:"url";s:129:"http://blogsearch.google.com/blogsearch_feeds?scoring=d&ie=utf-8&num=10&output=rss&partner=wordpress&q=link:http://[% HOST_NAME %]/";s:5:"items";i:10;s:9:"show_date";b:0;}s:17:"dashboard_primary";a:7:{s:4:"link";s:26:"http://wordpress.org/news/";s:3:"url";s:31:"http://wordpress.org/news/feed/";s:5:"title";s:14:"WordPress Blog";s:5:"items";i:2;s:12:"show_summary";i:1;s:11:"show_author";i:0;s:9:"show_date";i:1;}s:19:"dashboard_secondary";a:7:{s:4:"link";s:28:"http://planet.wordpress.org/";s:3:"url";s:33:"http://planet.wordpress.org/feed/";s:5:"title";s:20:"Other WordPress News";s:5:"items";i:5;s:12:"show_summary";i:0;s:11:"show_author";i:0;s:9:"show_date";i:0;}}', 'yes');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (110, 'can_compress_scripts', '0', 'yes');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (99, 'cron', 'a:3:{i:1376489010;a:3:{s:16:"wp_version_check";a:1:{s:32:"40cd750bba9870f18aada2478b24840a";a:3:{s:8:"schedule";s:10:"twicedaily";s:4:"args";a:0:{}s:8:"interval";i:43200;}}s:17:"wp_update_plugins";a:1:{s:32:"40cd750bba9870f18aada2478b24840a";a:3:{s:8:"schedule";s:10:"twicedaily";s:4:"args";a:0:{}s:8:"interval";i:43200;}}s:16:"wp_update_themes";a:1:{s:32:"40cd750bba9870f18aada2478b24840a";a:3:{s:8:"schedule";s:10:"twicedaily";s:4:"args";a:0:{}s:8:"interval";i:43200;}}}i:1376489015;a:1:{s:19:"wp_scheduled_delete";a:1:{s:32:"40cd750bba9870f18aada2478b24840a";a:3:{s:8:"schedule";s:5:"daily";s:4:"args";a:0:{}s:8:"interval";i:86400;}}}s:7:"version";i:2;}', 'yes');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (177, '_transient_dash_de3249c4736ad3bd2cd29147c4a0d43e', '<h4>Most Popular</h4>
<h5><a href=''http://wordpress.org/plugins/contact-form-plugin/''>Contact Form</a></h5>&nbsp;<span>(<a href=''plugin-install.php?tab=plugin-information&amp;plugin=contact-form-plugin&amp;_wpnonce=5db32557a8&amp;TB_iframe=true&amp;width=600&amp;height=800'' class=''thickbox'' title=''Contact Form''>Install</a>)</span>
<p>Add Contact Form to your WordPress website.</p>
<h4>Newest Plugins</h4>
<h5><a href=''http://wordpress.org/plugins/sisow-for-woocommerce/''>WooCommerce - Sisow Payment Options</a></h5>&nbsp;<span>(<a href=''plugin-install.php?tab=plugin-information&amp;plugin=sisow-for-woocommerce&amp;_wpnonce=6f99316cc3&amp;TB_iframe=true&amp;width=600&amp;height=800'' class=''thickbox'' title=''WooCommerce - Sisow Payment Options''>Install</a>)</span>
<p>Sisow Payment methods for WooCommerce 1.6 and WooCommerce 2.X</p>
', 'no');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (101, '_site_transient_update_core', 'O:8:"stdClass":3:{s:7:"updates";a:1:{i:0;O:8:"stdClass":9:{s:8:"response";s:6:"latest";s:8:"download";s:38:"http://wordpress.org/wordpress-3.6.zip";s:6:"locale";s:5:"en_US";s:8:"packages";O:8:"stdClass":4:{s:4:"full";s:38:"http://wordpress.org/wordpress-3.6.zip";s:10:"no_content";s:49:"http://wordpress.org/wordpress-3.6-no-content.zip";s:11:"new_bundled";s:50:"http://wordpress.org/wordpress-3.6-new-bundled.zip";s:7:"partial";b:0;}s:7:"current";s:3:"3.6";s:11:"php_version";s:5:"5.2.4";s:13:"mysql_version";s:3:"5.0";s:11:"new_bundled";s:3:"3.6";s:15:"partial_version";s:0:"";}}s:12:"last_checked";i:1376480108;s:15:"version_checked";s:3:"3.6";}', 'yes');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (105, '_site_transient_update_themes', 'O:8:"stdClass":3:{s:12:"last_checked";i:1376480109;s:7:"checked";a:2:{s:14:"twentythirteen";s:3:"1.0";s:12:"twentytwelve";s:3:"1.2";}s:8:"response";a:0:{}}', 'yes');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (102, '_site_transient_update_plugins', 'O:8:"stdClass":3:{s:12:"last_checked";i:1376480179;s:7:"checked";a:2:{s:19:"akismet/akismet.php";s:5:"2.5.9";s:9:"hello.php";s:3:"1.6";}s:8:"response";a:0:{}}', 'yes');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (143, '_transient_is_multi_author', '1', 'yes');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (144, '_site_transient_timeout_theme_roots', '1376481908', 'yes');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (145, '_site_transient_theme_roots', 'a:2:{s:14:"twentythirteen";s:7:"/themes";s:12:"twentytwelve";s:7:"/themes";}', 'yes');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (146, '_site_transient_timeout_browser_8d24e18be16ed42fa22c9a5f635088a3', '1377084973', 'yes');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (147, '_site_transient_browser_8d24e18be16ed42fa22c9a5f635088a3', 'a:9:{s:8:"platform";s:7:"Windows";s:4:"name";s:6:"Chrome";s:7:"version";s:12:"28.0.1500.95";s:10:"update_url";s:28:"http://www.google.com/chrome";s:7:"img_src";s:49:"http://s.wordpress.org/images/browsers/chrome.png";s:11:"img_src_ssl";s:48:"https://wordpress.org/images/browsers/chrome.png";s:15:"current_version";s:2:"18";s:7:"upgrade";b:0;s:8:"insecure";b:0;}', 'yes');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (148, '_transient_timeout_feed_bc45cf3662467ce6c31cdbc6f28a9e91', '1376523375', 'no');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (149, '_transient_feed_bc45cf3662467ce6c31cdbc6f28a9e91', 'a:4:{s:5:"child";a:1:{s:0:"";a:1:{s:3:"rss";a:1:{i:0;a:6:{s:4:"data";s:4:"
  
";s:7:"attribs";a:1:{s:0:"";a:1:{s:7:"version";s:3:"2.0";}}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:1:{s:0:"";a:1:{s:7:"channel";a:1:{i:0;a:6:{s:4:"data";s:33:"
    
    
    
    
    
    
  ";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:2:{s:0:"";a:3:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:47:"link:http://[% HOST_NAME %]/ - Google Blog Search";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:84:"http://www.google.com/search?ie=utf-8&q=link:http://[% HOST_NAME %]/&tbm=blg&tbs=sbd:1";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:78:"Your search - <b>link:http://[% HOST_NAME %]/</b> - did not match any documents.";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:36:"http://a9.com/-/spec/opensearch/1.1/";a:3:{s:12:"totalResults";a:1:{i:0;a:5:{s:4:"data";s:1:"0";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:10:"startIndex";a:1:{i:0;a:5:{s:4:"data";s:1:"1";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:12:"itemsPerPage";a:1:{i:0;a:5:{s:4:"data";s:2:"10";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}}}}}}}}s:4:"type";i:128;s:7:"headers";a:10:{s:12:"content-type";s:28:"text/xml; charset=ISO-8859-1";s:4:"date";s:29:"Wed, 14 Aug 2013 11:36:15 GMT";s:7:"expires";s:2:"-1";s:13:"cache-control";s:18:"private, max-age=0";s:10:"set-cookie";a:2:{i:0;s:143:"PREF=ID=65bacf2445ad3df4:FF=0:TM=1376480175:LM=1376480175:S=mXagCbDvIiCWkpR3; expires=Fri, 14-Aug-2015 11:36:15 GMT; path=/; domain=.google.com";i:1;s:212:"NID=67=VlzBmmDNMmywieQu8-klTtMq60NFVtyVNVN2LUFbD_qc2-VBQ_7Om36QlmMWDR4t6KfYksmCeSJZnu8SiRi7W4-EOJHSW7anR9OvpoNFyXcjpSvuJd_dO00pxpre4DuM; expires=Thu, 13-Feb-2014 11:36:15 GMT; path=/; domain=.google.com; HttpOnly";}s:3:"p3p";s:122:"CP="This is not a P3P policy! See http://www.google.com/support/accounts/bin/answer.py?hl=en&answer=151657 for more info."";s:6:"server";s:3:"gws";s:16:"x-xss-protection";s:13:"1; mode=block";s:15:"x-frame-options";s:10:"SAMEORIGIN";s:18:"alternate-protocol";s:7:"80:quic";}s:5:"build";s:14:"20130708171016";}', 'no');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (150, '_transient_timeout_feed_mod_bc45cf3662467ce6c31cdbc6f28a9e91', '1376523375', 'no');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (151, '_transient_feed_mod_bc45cf3662467ce6c31cdbc6f28a9e91', '1376480175', 'no');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (152, '_transient_timeout_dash_20494a3d90a6669585674ed0eb8dcd8f', '1376523375', 'no');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (153, '_transient_dash_20494a3d90a6669585674ed0eb8dcd8f', '<p>This dashboard widget queries <a href="http://blogsearch.google.com/">Google Blog Search</a> so that when another blog links to your site it will show up here. It has found no incoming links&hellip; yet. It&#8217;s okay &#8212; there is no rush.</p>
', 'no');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (154, '_transient_timeout_feed_ac0b00fe65abe10e0c5b588f3ed8c7ca', '1376523376', 'no');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (155, '_transient_feed_ac0b00fe65abe10e0c5b588f3ed8c7ca', 'a:4:{s:5:"child";a:1:{s:0:"";a:1:{s:3:"rss";a:1:{i:0;a:6:{s:4:"data";s:3:"


";s:7:"attribs";a:1:{s:0:"";a:1:{s:7:"version";s:3:"2.0";}}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:1:{s:0:"";a:1:{s:7:"channel";a:1:{i:0;a:6:{s:4:"data";s:50:"
	
	
	
	
	
	
	
	
	
		
		
		
		
		
		
		
		
		
		
	";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:3:{s:0:"";a:7:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:14:"WordPress News";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:25:"http://wordpress.org/news";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:14:"WordPress News";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:13:"lastBuildDate";a:1:{i:0;a:5:{s:4:"data";s:31:"Thu, 01 Aug 2013 21:49:34 +0000";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:8:"language";a:1:{i:0;a:5:{s:4:"data";s:5:"en-US";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:9:"generator";a:1:{i:0;a:5:{s:4:"data";s:39:"http://wordpress.org/?v=3.7-alpha-25000";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"item";a:10:{i:0;a:6:{s:4:"data";s:42:"
		
		
		
		
		
				

		
		
				
			
		
		";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:5:{s:0:"";a:7:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:25:"WordPress 3.6 “Oscar”";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:40:"http://wordpress.org/news/2013/08/oscar/";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:8:"comments";a:1:{i:0;a:5:{s:4:"data";s:49:"http://wordpress.org/news/2013/08/oscar/#comments";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:31:"Thu, 01 Aug 2013 21:43:22 +0000";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:8:"category";a:1:{i:0;a:5:{s:4:"data";s:8:"Releases";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"guid";a:1:{i:0;a:5:{s:4:"data";s:33:"http://wordpress.org/news/?p=2661";s:7:"attribs";a:1:{s:0:"";a:1:{s:11:"isPermaLink";s:5:"false";}}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:368:"The latest and greatest WordPress, version 3.6, is now live to the world and includes a beautiful new blog-centric theme, bullet-proof autosave and post locking, a revamped revision browser, native support for audio and video embeds, and improved integrations with Spotify, Rdio, and SoundCloud. Here&#8217;s a video that shows off some of the features using [&#8230;]";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:32:"http://purl.org/dc/elements/1.1/";a:1:{s:7:"creator";a:1:{i:0;a:5:{s:4:"data";s:14:"Matt Mullenweg";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:40:"http://purl.org/rss/1.0/modules/content/";a:1:{s:7:"encoded";a:1:{i:0;a:5:{s:4:"data";s:18626:"<p>The latest and greatest WordPress, version 3.6, is now <a href="http://wordpress.org/download/">live to the world</a> and includes a beautiful new blog-centric theme, bullet-proof autosave and post locking, a revamped revision browser, native support for audio and video embeds, and improved integrations with Spotify, Rdio, and SoundCloud. Here&#8217;s a video that shows off some of the features using our cast of professional actors:</p>
<div id="v-UmhwbWJH-1" class="video-player"><embed id="v-UmhwbWJH-1-video" src="http://s0.videopress.com/player.swf?v=1.03&amp;guid=UmhwbWJH&amp;isDynamicSeeking=true" type="application/x-shockwave-flash" width="692" height="388" title="Introducing WordPress 3.6 &quot;Oscar&quot;" wmode="direct" seamlesstabbing="true" allowfullscreen="true" allowscriptaccess="always" overstretch="true"></embed></div>
<p>We&#8217;re calling this release &#8220;Oscar&#8221; in honor of the great jazz pianist <a href="http://en.wikipedia.org/wiki/Oscar_Peterson">Oscar Peterson</a>. Here&#8217;s a bit more about some of the new features, which you can also find on the about page in your dashboard after you upgrade.</p>
<h3>User Features</h3>
<p><img class="alignright" alt="" src="https://wordpress.org/images/core/3.6/twentythirteen.png" width="300" /></p>
<ul>
<li>The <strong>new Twenty Thirteen theme</strong> inspired by modern art puts focus on your content with a colorful, single-column design made for media-rich blogging.</li>
<li><strong>Revamped Revisions</strong> save every change and the new interface allows you to scroll easily through changes to see line-by-line who changed what and when.</li>
<li><strong>Post Locking</strong> and <strong>Augmented Autosave</strong> will especially be a boon to sites where more than a single author is working on a post. Each author now has their own autosave stream, which stores things locally as well as on the server (so much harder to lose something) and there&#8217;s an interface for taking over editing of a post, as demonstrated beautifully by our bearded buddies in the video above.</li>
<li><strong>Built-in HTML5 media player</strong> for native audio and video embeds with no reliance on external services.</li>
<li>The <strong>Menu Editor</strong> is now much easier to understand and use.</li>
</ul>
<h3>Developer features</h3>
<ul>
<li>A new audio/video API gives you access to metadata like ID3 tags.</li>
<li>You can now choose HTML5 markup for things like comment and search forms, and comment lists.</li>
<li>Better filters for how revisions work, so you can store a different amount of history for different post types.</li>
<li>Tons more <a href="http://codex.wordpress.org/Version_3.6">listed on the Codex</a>, and of course you can always <a href="http://core.trac.wordpress.org/query?status=closed&amp;group=resolution&amp;milestone=3.6">browse the over 700 closed tickets</a>.</li>
</ul>
<h3>The Band</h3>
<p>This release was led by <a href="http://markjaquith.com/">Mark Jaquith</a> and <a href="http://geekreprieve.com/">Aaron Campbell</a>, and included contributions from the following fine folks. Pull up some Oscar Peterson on your music service of choice, or vinyl if you have it, and check out some of their profiles:</p>
<p><a href="http://profiles.wordpress.org/technosailor">Aaron Brazell</a>, <a href="http://profiles.wordpress.org/aaroncampbell">Aaron D. Campbell</a>, <a href="http://profiles.wordpress.org/aaronholbrook">Aaron Holbrook</a>, <a href="http://profiles.wordpress.org/jorbin">Aaron Jorbin</a>, <a href="http://profiles.wordpress.org/kawauso">Adam Harley</a>, <a href="http://profiles.wordpress.org/adamsilverstein">adamsilverstein</a>, <a href="http://profiles.wordpress.org/akted">AK Ted</a>, <a href="http://profiles.wordpress.org/xknown">Alex Concha</a>, <a href="http://profiles.wordpress.org/alexkingorg">Alex King</a>, <a href="http://profiles.wordpress.org/viper007bond">Alex Mills (Viper007Bond)</a>, <a href="http://profiles.wordpress.org/momo360modena">Amaury Balmer</a>, <a href="http://profiles.wordpress.org/sabreuse">Amy Hendrix (sabreuse)</a>, <a href="http://profiles.wordpress.org/anatolbroder">Anatol Broder</a>, <a href="http://profiles.wordpress.org/nacin">Andrew Nacin</a>, <a href="http://profiles.wordpress.org/azaozz">Andrew Ozz</a>, <a href="http://profiles.wordpress.org/andrewryno">Andrew Ryno</a>, <a href="http://profiles.wordpress.org/andy">Andy Skelton</a>, <a href="http://profiles.wordpress.org/gorgoglionemeister">Antonio</a>, <a href="http://profiles.wordpress.org/apimlott">apimlott</a>, <a href="http://profiles.wordpress.org/awellis13">awellis13</a>, <a href="http://profiles.wordpress.org/barry">Barry</a>, <a href="http://profiles.wordpress.org/beaulebens">Beau Lebens</a>, <a href="http://profiles.wordpress.org/belloswan">BelloSwan</a>, <a href="http://profiles.wordpress.org/bilalcoder">bilalcoder</a>, <a href="http://profiles.wordpress.org/bananastalktome">Billy (bananastalktome)</a>, <a href="http://profiles.wordpress.org/bobbingwide">bobbingwide</a>, <a href="http://profiles.wordpress.org/bobbravo2">Bob Gregor</a>, <a href="http://profiles.wordpress.org/bradparbs">bradparbs</a>, <a href="http://profiles.wordpress.org/bradyvercher">Brady Vercher</a>, <a href="http://profiles.wordpress.org/kraftbj">Brandon Kraft</a>, <a href="http://profiles.wordpress.org/brianlayman">Brian Layman</a>, <a href="http://profiles.wordpress.org/beezeee">Brian Zeligson</a>, <a href="http://profiles.wordpress.org/bpetty">Bryan Petty</a>, <a href="http://profiles.wordpress.org/chmac">Callum Macdonald</a>, <a href="http://profiles.wordpress.org/carldanley">Carl Danley</a>, <a href="http://profiles.wordpress.org/caspie">Caspie</a>, <a href="http://profiles.wordpress.org/charlestonsw">Charleston Software Associates</a>, <a href="http://profiles.wordpress.org/cheeserolls">cheeserolls</a>, <a href="http://profiles.wordpress.org/chipbennett">Chip Bennett</a>, <a href="http://profiles.wordpress.org/c3mdigital">Chris Olbekson</a>, <a href="http://profiles.wordpress.org/cochran">Christopher Cochran</a>, <a href="http://profiles.wordpress.org/cfinke">Christopher Finke</a>, <a href="http://profiles.wordpress.org/chriswallace">Chris Wallace</a>, <a href="http://profiles.wordpress.org/corvannoorloos">Cor van Noorloos</a>, <a href="http://profiles.wordpress.org/crazycoders">crazycoders</a>, <a href="http://profiles.wordpress.org/danielbachhuber">Daniel Bachhuber</a>, <a href="http://profiles.wordpress.org/mzaweb">Daniel Dvorkin (MZAWeb)</a>, <a href="http://profiles.wordpress.org/redsweater">Daniel Jalkut (Red Sweater)</a>, <a href="http://profiles.wordpress.org/daniloercoli">daniloercoli</a>, <a href="http://profiles.wordpress.org/dannydehaan">Danny de Haan</a>, <a href="http://profiles.wordpress.org/csixty4">Dave Ross</a>, <a href="http://profiles.wordpress.org/dfavor">David Favor</a>, <a href="http://profiles.wordpress.org/jdtrower">David Trower</a>, <a href="http://profiles.wordpress.org/davidwilliamson">David Williamson</a>, <a href="http://profiles.wordpress.org/dd32">Dion Hulse</a>, <a href="http://profiles.wordpress.org/dllh">dllh</a>, <a href="http://profiles.wordpress.org/ocean90">Dominik Schilling (ocean90)</a>, <a href="http://profiles.wordpress.org/dovyp">dovyp</a>, <a href="http://profiles.wordpress.org/drewapicture">Drew Jaynes (DrewAPicture)</a>, <a href="http://profiles.wordpress.org/dvarga">dvarga</a>, <a href="http://profiles.wordpress.org/cais">Edward Caissie</a>, <a href="http://profiles.wordpress.org/elfin">elfin</a>, <a href="http://profiles.wordpress.org/empireoflight">Empireoflight</a>, <a href="http://profiles.wordpress.org/ericlewis">Eric Andrew Lewis</a>, <a href="http://profiles.wordpress.org/ethitter">Erick Hitter</a>, <a href="http://profiles.wordpress.org/ericmann">Eric Mann</a>, <a href="http://profiles.wordpress.org/evansolomon">Evan Solomon</a>, <a href="http://profiles.wordpress.org/faishal">faishal</a>, <a href="http://profiles.wordpress.org/feedmeastraycat">feedmeastraycat</a>, <a href="http://profiles.wordpress.org/frank-klein">Frank Klein</a>, <a href="http://profiles.wordpress.org/f-j-kaiser">Franz Josef Kaiser</a>, <a href="http://profiles.wordpress.org/fstop">FStop</a>, <a href="http://profiles.wordpress.org/mintindeed">Gabriel Koen</a>, <a href="http://profiles.wordpress.org/garyc40">Gary Cao</a>, <a href="http://profiles.wordpress.org/garyj">Gary Jones</a>, <a href="http://profiles.wordpress.org/gcorne">gcorne</a>, <a href="http://profiles.wordpress.org/geertdd">GeertDD</a>, <a href="http://profiles.wordpress.org/soulseekah">Gennady Kovshenin</a>, <a href="http://profiles.wordpress.org/georgestephanis">George Stephanis</a>, <a href="http://profiles.wordpress.org/gish">gish</a>, <a href="http://profiles.wordpress.org/tivnet">Gregory Karpinsky</a>, <a href="http://profiles.wordpress.org/hakre">hakre</a>, <a href="http://profiles.wordpress.org/hbanken">hbanken</a>, <a href="http://profiles.wordpress.org/hebbet">hebbet</a>, <a href="http://profiles.wordpress.org/helen">Helen Hou-Sandi</a>, <a href="http://profiles.wordpress.org/helgatheviking">helgatheviking</a>, <a href="http://profiles.wordpress.org/hirozed">hirozed</a>, <a href="http://profiles.wordpress.org/hurtige">hurtige</a>, <a href="http://profiles.wordpress.org/hypertextranch">hypertextranch</a>, <a href="http://profiles.wordpress.org/iandunn">Ian Dunn</a>, <a href="http://profiles.wordpress.org/ipstenu">Ipstenu (Mika Epstein)</a>, <a href="http://profiles.wordpress.org/jakub">jakub</a>, <a href="http://profiles.wordpress.org/h4ck3rm1k3">James Michael DuPont</a>, <a href="http://profiles.wordpress.org/jbutkus">jbutkus</a>, <a href="http://profiles.wordpress.org/jeremyfelt">Jeremy Felt</a>, <a href="http://profiles.wordpress.org/jerrysarcastic">Jerry Bates (JerrySarcastic)</a>, <a href="http://profiles.wordpress.org/jayjdk">Jesper Johansen (Jayjdk)</a>, <a href="http://profiles.wordpress.org/joehoyle">Joe Hoyle</a>, <a href="http://profiles.wordpress.org/joen">Joen Asmussen</a>, <a href="http://profiles.wordpress.org/jkudish">Joey Kudish</a>, <a href="http://profiles.wordpress.org/johnbillion">John Blackbourn (johnbillion)</a>, <a href="http://profiles.wordpress.org/johnjamesjacoby">John James Jacoby</a>, <a href="http://profiles.wordpress.org/jond3r">Jonas Bolinder (jond3r)</a>, <a href="http://profiles.wordpress.org/desrosj">Jonathan Desrosiers</a>, <a href="http://profiles.wordpress.org/jonbishop">Jon Bishop</a>, <a href="http://profiles.wordpress.org/duck_">Jon Cave</a>, <a href="http://profiles.wordpress.org/jcastaneda">Jose Castaneda</a>, <a href="http://profiles.wordpress.org/josephscott">Joseph Scott</a>, <a href="http://profiles.wordpress.org/jvisick77">Josh Visick</a>, <a href="http://profiles.wordpress.org/jrbeilke">jrbeilke</a>, <a href="http://profiles.wordpress.org/jrf">jrf</a>, <a href="http://profiles.wordpress.org/devesine">Justin de Vesine</a>, <a href="http://profiles.wordpress.org/justinsainton">Justin Sainton</a>, <a href="http://profiles.wordpress.org/kadamwhite">kadamwhite</a>, <a href="http://profiles.wordpress.org/trepmal">Kailey (trepmal)</a>, <a href="http://profiles.wordpress.org/karmatosed">karmatosed</a>, <a href="http://profiles.wordpress.org/ryelle">Kelly Dwan</a>, <a href="http://profiles.wordpress.org/keoshi">keoshi</a>, <a href="http://profiles.wordpress.org/kovshenin">Konstantin Kovshenin</a>, <a href="http://profiles.wordpress.org/obenland">Konstantin Obenland</a>, <a href="http://profiles.wordpress.org/ktdreyer">ktdreyer</a>, <a href="http://profiles.wordpress.org/kurtpayne">Kurt Payne</a>, <a href="http://profiles.wordpress.org/kwight">kwight</a>, <a href="http://profiles.wordpress.org/lancewillett">Lance Willett</a>, <a href="http://profiles.wordpress.org/leewillis77">Lee Willis (leewillis77)</a>, <a href="http://profiles.wordpress.org/lessbloat">lessbloat</a>, <a href="http://profiles.wordpress.org/settle">Mantas Malcius</a>, <a href="http://profiles.wordpress.org/maor">Maor Chasen</a>, <a href="http://profiles.wordpress.org/macbrink">Marcel Brinkkemper</a>, <a href="http://profiles.wordpress.org/marcuspope">MarcusPope</a>, <a href="http://profiles.wordpress.org/mark-k">Mark-k</a>, <a href="http://profiles.wordpress.org/markjaquith">Mark Jaquith</a>, <a href="http://profiles.wordpress.org/markmcwilliams">Mark McWilliams</a>, <a href="http://profiles.wordpress.org/markoheijnen">Marko Heijnen</a>, <a href="http://profiles.wordpress.org/mjbanks">Matt Banks</a>, <a href="http://profiles.wordpress.org/mboynes">Matthew Boynes</a>, <a href="http://profiles.wordpress.org/matthewruddy">MatthewRuddy</a>, <a href="http://profiles.wordpress.org/mattwiebe">Matt Wiebe</a>, <a href="http://profiles.wordpress.org/maxcutler">Max Cutler</a>, <a href="http://profiles.wordpress.org/melchoyce">Mel Choyce</a>, <a href="http://profiles.wordpress.org/mgibbs189">mgibbs189</a>, <a href="http://profiles.wordpress.org/fanquake">Michael</a>, <a href="http://profiles.wordpress.org/mdawaffe">Michael Adams (mdawaffe)</a>, <a href="http://profiles.wordpress.org/tw2113">Michael Beckwith</a>, <a href="http://profiles.wordpress.org/mfields">Michael Fields</a>, <a href="http://profiles.wordpress.org/mikehansenme">Mike Hansen</a>, <a href="http://profiles.wordpress.org/dh-shredder">Mike Schroder</a>, <a href="http://profiles.wordpress.org/dimadin">Milan Dinic</a>, <a href="http://profiles.wordpress.org/mitchoyoshitaka">mitcho (Michael Yoshitaka Erlewine)</a>, <a href="http://profiles.wordpress.org/batmoo">Mohammad Jangda</a>, <a href="http://profiles.wordpress.org/najamelan">najamelan</a>, <a href="http://profiles.wordpress.org/Nao">Naoko Takano</a>, <a href="http://profiles.wordpress.org/alex-ye">Nashwan Doaqan</a>, <a href="http://profiles.wordpress.org/niallkennedy">Niall Kennedy</a>, <a href="http://profiles.wordpress.org/nickdaugherty">Nick Daugherty</a>, <a href="http://profiles.wordpress.org/celloexpressions">Nick Halsey</a>, <a href="http://profiles.wordpress.org/ninnypants">ninnypants</a>, <a href="http://profiles.wordpress.org/norcross">norcross</a>, <a href="http://profiles.wordpress.org/paradiseporridge">ParadisePorridge</a>, <a href="http://profiles.wordpress.org/pauldewouters">Paul</a>, <a href="http://profiles.wordpress.org/pdclark">Paul Clark</a>, <a href="http://profiles.wordpress.org/pavelevap">pavelevap</a>, <a href="http://profiles.wordpress.org/petemall">Pete Mall</a>, <a href="http://profiles.wordpress.org/westi">Peter Westwood</a>, <a href="http://profiles.wordpress.org/phill_brown">Phill Brown</a>, <a href="http://profiles.wordpress.org/mordauk">Pippin Williamson</a>, <a href="http://profiles.wordpress.org/pollett">Pollett</a>, <a href="http://profiles.wordpress.org/nprasath002">Prasath Nadarajah</a>, <a href="http://profiles.wordpress.org/programmin">programmin</a>, <a href="http://profiles.wordpress.org/rachelbaker">rachelbaker</a>, <a href="http://profiles.wordpress.org/ramiy">Rami Yushuvaev</a>, <a href="http://profiles.wordpress.org/redpixelstudios">redpixelstudios</a>, <a href="http://profiles.wordpress.org/reidburke">reidburke</a>, <a href="http://profiles.wordpress.org/retlehs">retlehs</a>, <a href="http://profiles.wordpress.org/greuben">Reuben Gunday</a>, <a href="http://profiles.wordpress.org/rlerdorf">rlerdorf</a>, <a href="http://profiles.wordpress.org/rodrigosprimo">Rodrigo Primo</a>, <a href="http://profiles.wordpress.org/roulandf">roulandf</a>, <a href="http://profiles.wordpress.org/rovo89">rovo89</a>, <a href="http://profiles.wordpress.org/ryanduff">Ryan Duff</a>, <a href="http://profiles.wordpress.org/ryanhellyer">Ryan Hellyer</a>, <a href="http://profiles.wordpress.org/rmccue">Ryan McCue</a>, <a href="http://profiles.wordpress.org/zeo">Safirul Alredha</a>, <a href="http://profiles.wordpress.org/saracannon">sara cannon</a>, <a href="http://profiles.wordpress.org/scholesmafia">scholesmafia</a>, <a href="http://profiles.wordpress.org/sc0ttkclark">Scott Kingsley Clark</a>, <a href="http://profiles.wordpress.org/coffee2code">Scott Reilly</a>, <a href="http://profiles.wordpress.org/wonderboymusic">Scott Taylor</a>, <a href="http://profiles.wordpress.org/scribu">scribu</a>, <a href="http://profiles.wordpress.org/tenpura">Seisuke Kuraishi (tenpura)</a>, <a href="http://profiles.wordpress.org/sergej">Sergej</a>, <a href="http://profiles.wordpress.org/sergeybiryukov">Sergey Biryukov</a>, <a href="http://profiles.wordpress.org/sim">Simon Hampel</a>, <a href="http://profiles.wordpress.org/simonwheatley">Simon Wheatley</a>, <a href="http://profiles.wordpress.org/siobhan">Siobhan</a>, <a href="http://profiles.wordpress.org/sirzooro">sirzooro</a>, <a href="http://profiles.wordpress.org/slene">slene</a>, <a href="http://profiles.wordpress.org/solarissmoke">solarissmoke</a>, <a href="http://profiles.wordpress.org/srinig">SriniG</a>, <a href="http://profiles.wordpress.org/stephenh1988">Stephen Harris</a>, <a href="http://profiles.wordpress.org/storkontheroof">storkontheroof</a>, <a href="http://profiles.wordpress.org/sunnyratilal">Sunny Ratilal</a>, <a href="http://profiles.wordpress.org/sweetie089">sweetie089</a>, <a href="http://profiles.wordpress.org/tar">Tar</a>, <a href="http://profiles.wordpress.org/tlovett1">Taylor Lovett</a>, <a href="http://profiles.wordpress.org/thomasvanderbeek">Thomas van der Beek</a>, <a href="http://profiles.wordpress.org/n7studios">Tim Carr</a>, <a href="http://profiles.wordpress.org/tjsingleton">tjsingleton</a>, <a href="http://profiles.wordpress.org/tobiasbg">TobiasBg</a>, <a href="http://profiles.wordpress.org/toscho">toscho</a>, <a href="http://profiles.wordpress.org/taupecat">Tracy Rotton</a>, <a href="http://profiles.wordpress.org/travishoffman">TravisHoffman</a>, <a href="http://profiles.wordpress.org/uuf6429">uuf6429</a>, <a href="http://profiles.wordpress.org/lightningspirit">Vitor Carvalho</a>, <a href="http://profiles.wordpress.org/wojtek">wojtek</a>, <a href="http://profiles.wordpress.org/wpewill">wpewill</a>, <a href="http://profiles.wordpress.org/wraithkenny">WraithKenny</a>, <a href="http://profiles.wordpress.org/wycks">wycks</a>, <a href="http://profiles.wordpress.org/xibe">Xavier Borderie</a>, <a href="http://profiles.wordpress.org/yoavf">Yoav Farhi</a>, <a href="http://profiles.wordpress.org/thelastcicada">Zachary Brown</a>, <a href="http://profiles.wordpress.org/tollmanz">Zack Tollman</a>, <a href="http://profiles.wordpress.org/zekeweeks">zekeweeks</a>, <a href="http://profiles.wordpress.org/ziegenberg">ziegenberg</a>, and <a href="http://profiles.wordpress.org/viniciusmassuchetto">viniciusmassuchetto</a>.</p>
<p>Time to upgrade!</p>
";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:36:"http://wellformedweb.org/CommentAPI/";a:1:{s:10:"commentRss";a:1:{i:0;a:5:{s:4:"data";s:45:"http://wordpress.org/news/2013/08/oscar/feed/";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:38:"http://purl.org/rss/1.0/modules/slash/";a:1:{s:8:"comments";a:1:{i:0;a:5:{s:4:"data";s:1:"0";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}i:1;a:6:{s:4:"data";s:45:"
		
		
		
		
		
				
		

		
		
				
			
		
		";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:5:{s:0:"";a:7:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:33:"WordPress 3.6 Release Candidate 2";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:68:"http://wordpress.org/news/2013/07/wordpress-3-6-release-candidate-2/";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:8:"comments";a:1:{i:0;a:5:{s:4:"data";s:77:"http://wordpress.org/news/2013/07/wordpress-3-6-release-candidate-2/#comments";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:31:"Wed, 24 Jul 2013 07:25:10 +0000";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:8:"category";a:2:{i:0;a:5:{s:4:"data";s:11:"Development";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}i:1;a:5:{s:4:"data";s:7:"Testing";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"guid";a:1:{i:0;a:5:{s:4:"data";s:33:"http://wordpress.org/news/?p=2649";s:7:"attribs";a:1:{s:0:"";a:1:{s:11:"isPermaLink";s:5:"false";}}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:341:"The second release candidate for WordPress 3.6 is now available for download and testing. We&#8217;re down to only a few remaining issues, and the final release should be available in a matter of days. In RC2, we&#8217;ve tightened up some aspects of revisions, autosave, and the media player, and fixed some bugs that were spotted [&#8230;]";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:32:"http://purl.org/dc/elements/1.1/";a:1:{s:7:"creator";a:1:{i:0;a:5:{s:4:"data";s:12:"Mark Jaquith";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:40:"http://purl.org/rss/1.0/modules/content/";a:1:{s:7:"encoded";a:1:{i:0;a:5:{s:4:"data";s:1325:"<p>The second release candidate for WordPress 3.6 is now available for download and testing.</p>
<p>We&#8217;re down to only a few remaining issues, and the final release should be available in a matter of days. In RC2, we&#8217;ve tightened up some aspects of revisions, autosave, and the media player, and fixed some bugs that were spotted in RC1. Please test this release candidate as much as you can, so we can deliver a smooth final release!</p>
<p><strong>Think you&#8217;ve found a bug?</strong> Please post to the <a href="http://wordpress.org/support/forum/alphabeta/">Alpha/Beta area in the support forums</a>.</p>
<p><strong>Developers,</strong> please continue to test your plugins and themes, so that if there is a compatibility issue, we can figure it out before the final release. You can find our <a href="http://core.trac.wordpress.org/report/6">list of known issues here</a>.</p>
<p>To test WordPress 3.6, try the <a href="http://wordpress.org/extend/plugins/wordpress-beta-tester/">WordPress Beta Tester</a> plugin (you&#8217;ll want &#8220;bleeding edge nightlies&#8221;). Or you can <a href="http://wordpress.org/wordpress-3.6-RC2.zip">download the release candidate here (zip)</a>.</p>
<p><em>Revisions so smooth</em><br />
<em>We autosave your changes</em><br />
<em>Data loss begone!</em></p>
";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:36:"http://wellformedweb.org/CommentAPI/";a:1:{s:10:"commentRss";a:1:{i:0;a:5:{s:4:"data";s:73:"http://wordpress.org/news/2013/07/wordpress-3-6-release-candidate-2/feed/";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:38:"http://purl.org/rss/1.0/modules/slash/";a:1:{s:8:"comments";a:1:{i:0;a:5:{s:4:"data";s:1:"0";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}i:2;a:6:{s:4:"data";s:45:"
		
		
		
		
		
				
		

		
		
				
			
		
		";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:5:{s:0:"";a:7:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:31:"WordPress 3.6 Release Candidate";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:66:"http://wordpress.org/news/2013/07/wordpress-3-6-release-candidate/";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:8:"comments";a:1:{i:0;a:5:{s:4:"data";s:75:"http://wordpress.org/news/2013/07/wordpress-3-6-release-candidate/#comments";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:31:"Sat, 13 Jul 2013 03:23:17 +0000";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:8:"category";a:2:{i:0;a:5:{s:4:"data";s:11:"Development";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}i:1;a:5:{s:4:"data";s:7:"Testing";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"guid";a:1:{i:0;a:5:{s:4:"data";s:33:"http://wordpress.org/news/?p=2639";s:7:"attribs";a:1:{s:0:"";a:1:{s:11:"isPermaLink";s:5:"false";}}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:344:"The first release candidate for WordPress 3.6 is now available. We hope to ship WordPress 3.6 in a couple weeks. But to do that, we really need your help! If you haven&#8217;t tested 3.6 yet, there&#8217;s no time like the present. (But please: not on a live production site, unless you&#8217;re feeling especially adventurous.) Think [&#8230;]";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:32:"http://purl.org/dc/elements/1.1/";a:1:{s:7:"creator";a:1:{i:0;a:5:{s:4:"data";s:12:"Mark Jaquith";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:40:"http://purl.org/rss/1.0/modules/content/";a:1:{s:7:"encoded";a:1:{i:0;a:5:{s:4:"data";s:1504:"<p>The first release candidate for WordPress 3.6 is now available.</p>
<p>We hope to ship WordPress 3.6 in a couple weeks. But to do that, we really need your help! If you haven&#8217;t tested 3.6 yet, there&#8217;s no time like the present. (But please: not on a live production site, unless you&#8217;re feeling especially adventurous.)</p>
<p><strong>Think you&#8217;ve found a bug?</strong> Please post to the <a href="http://wordpress.org/support/forum/alphabeta/">Alpha/Beta area in the support forums</a>. If any known issues come up, you’ll be able to <a href="http://core.trac.wordpress.org/report/6">find them here</a>. <strong>Developers,</strong> please test your plugins and themes, so that if there is a compatibility issue, we can sort it out before the final release.</p>
<p>To test WordPress 3.6, try the <a href="http://wordpress.org/extend/plugins/wordpress-beta-tester/">WordPress Beta Tester</a> plugin (you&#8217;ll want &#8220;bleeding edge nightlies&#8221;). Or you can <a href="http://wordpress.org/wordpress-3.6-RC1.zip">download the release candidate here (zip)</a>.</p>
<p>As you may have heard, we backed the Post Format UI feature out of the release. On the other hand, our slick new revisions browser had some extra time to develop. You should see it with 200+ revisions loaded — scrubbing back and forth at lightning speed is a thing of beauty.</p>
<p><em>Delayed, but still loved</em><br />
<em>The release will be out soon</em><br />
<em>Test it, por favor</em></p>
";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:36:"http://wellformedweb.org/CommentAPI/";a:1:{s:10:"commentRss";a:1:{i:0;a:5:{s:4:"data";s:71:"http://wordpress.org/news/2013/07/wordpress-3-6-release-candidate/feed/";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:38:"http://purl.org/rss/1.0/modules/slash/";a:1:{s:8:"comments";a:1:{i:0;a:5:{s:4:"data";s:1:"0";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}i:3;a:6:{s:4:"data";s:45:"
		
		
		
		
		
				
		

		
		
				
			
		
		";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:5:{s:0:"";a:7:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:34:"Annual WordPress Survey &amp; WCSF";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:63:"http://wordpress.org/news/2013/07/annual-wordpress-survey-wcsf/";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:8:"comments";a:1:{i:0;a:5:{s:4:"data";s:72:"http://wordpress.org/news/2013/07/annual-wordpress-survey-wcsf/#comments";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:31:"Tue, 09 Jul 2013 23:50:29 +0000";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:8:"category";a:2:{i:0;a:5:{s:4:"data";s:9:"Community";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}i:1;a:5:{s:4:"data";s:6:"Events";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"guid";a:1:{i:0;a:5:{s:4:"data";s:33:"http://wordpress.org/news/?p=2625";s:7:"attribs";a:1:{s:0:"";a:1:{s:11:"isPermaLink";s:5:"false";}}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:347:"It&#8217;s time for our third annual user and developer survey! If you&#8217;re a WordPress user, developer, or business, we want your feedback. Just like previous years, we&#8217;ll share the data at the upcoming WordCamp San Francisco (WCSF). Results will also be sent to each survey respondent. It only takes a few minutes to fill out [&#8230;]";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:32:"http://purl.org/dc/elements/1.1/";a:1:{s:7:"creator";a:1:{i:0;a:5:{s:4:"data";s:14:"Matt Mullenweg";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:40:"http://purl.org/rss/1.0/modules/content/";a:1:{s:7:"encoded";a:1:{i:0;a:5:{s:4:"data";s:1242:"<p><img class="alignright" alt="" align="right" src="http://wpdotorg.files.wordpress.com/2013/07/wcsf-2013.jpg" width="278" height="185" />It&#8217;s time for our third annual user and developer survey! If you&#8217;re a WordPress user, developer, or business, we want your feedback. Just like previous years, we&#8217;ll share the data at the upcoming <a href="http://2013.sf.wordcamp.org/">WordCamp San Francisco</a> (WCSF). Results will also be sent to each survey respondent.</p>
<p>It only takes a few minutes to <a href="http://wp-survey.polldaddy.com/s/wp-2013">fill out the survey</a>, which will provide an overview of how people use WordPress.</p>
<p>If you missed past State of the Word keynotes, be sure to check out them out for survey results from <a href="http://wordpress.org/news/2011/08/state-of-the-word/">2011</a> and <a href="http://ma.tt/2012/08/state-of-the-word-2012/">2012</a>.</p>
<p>Speaking of WCSF, if you didn&#8217;t get a ticket or are too far away to attend, you can still <a href="http://2013.sf.wordcamp.org/tickets/">get a ticket for the live stream</a>! Watch the live video stream from the comfort of your home on July 26 and 27; WCSF t-shirt, or any shirt, optional.</p>
<p>I hope to see you there.</p>
";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:36:"http://wellformedweb.org/CommentAPI/";a:1:{s:10:"commentRss";a:1:{i:0;a:5:{s:4:"data";s:68:"http://wordpress.org/news/2013/07/annual-wordpress-survey-wcsf/feed/";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:38:"http://purl.org/rss/1.0/modules/slash/";a:1:{s:8:"comments";a:1:{i:0;a:5:{s:4:"data";s:1:"0";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}i:4;a:6:{s:4:"data";s:45:"
		
		
		
		
		
				
		

		
		
				
			
		
		";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:5:{s:0:"";a:7:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:48:"WordPress 3.5.2 Maintenance and Security Release";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:50:"http://wordpress.org/news/2013/06/wordpress-3-5-2/";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:8:"comments";a:1:{i:0;a:5:{s:4:"data";s:59:"http://wordpress.org/news/2013/06/wordpress-3-5-2/#comments";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:31:"Fri, 21 Jun 2013 19:54:26 +0000";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:8:"category";a:2:{i:0;a:5:{s:4:"data";s:8:"Releases";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}i:1;a:5:{s:4:"data";s:8:"Security";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"guid";a:1:{i:0;a:5:{s:4:"data";s:33:"http://wordpress.org/news/?p=2612";s:7:"attribs";a:1:{s:0:"";a:1:{s:11:"isPermaLink";s:5:"false";}}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:380:"WordPress 3.5.2 is now available. This is the second maintenance release of 3.5, fixing 12 bugs. This is a security release for all previous versions and we strongly encourage you to update your sites immediately. The WordPress security team resolved seven security issues, and this release also contains some additional security hardening. The security fixes included: [&#8230;]";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:32:"http://purl.org/dc/elements/1.1/";a:1:{s:7:"creator";a:1:{i:0;a:5:{s:4:"data";s:12:"Andrew Nacin";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:40:"http://purl.org/rss/1.0/modules/content/";a:1:{s:7:"encoded";a:1:{i:0;a:5:{s:4:"data";s:2549:"<p>WordPress 3.5.2 is now available. This is the second maintenance release of 3.5, fixing <a href="http://core.trac.wordpress.org/query?status=closed&amp;group=resolution&amp;milestone=3.5.2">12 bugs</a>. <strong>This is a security release for all previous versions and we strongly encourage you to update your sites immediately.</strong> The WordPress security team resolved seven security issues, and this release also contains some additional security hardening.</p>
<p>The security fixes included:</p>
<ul>
<li>Blocking server-side request forgery attacks, which could potentially enable an attacker to gain access to a site.</li>
<li>Disallow contributors from improperly publishing posts, reported by <a href="http://kovshenin.com/">Konstantin Kovshenin</a>, or reassigning the post&#8217;s authorship, reported by <a href="http://www.sharefaith.com/">Luke Bryan</a>.</li>
<li>An update to the SWFUpload external library to fix cross-site scripting vulnerabilities. Reported by <a href="http://ma.la">mala</a> and <a href="http://mars.iti.pk.edu.pl/~grucha/">Szymon Gruszecki</a>. (Developers: More on SWFUpload <a href="http://make.wordpress.org/core/2013/06/21/secure-swfupload/">here</a>.)</li>
<li>Prevention of a denial of service attack, affecting sites using password-protected posts.</li>
<li>An update to an external TinyMCE library to fix a cross-site scripting vulnerability. Reported by <a href="http://twitter.com/rinakikun">Wan Ikram</a>.</li>
<li>Multiple fixes for cross-site scripting. Reported by <a href="http://webapplicationsecurity.altervista.org/">Andrea Santese</a> and Rodrigo.</li>
<li>Avoid disclosing a full file path when a upload fails. Reported by <a href="http://hauntit.blogspot.de/">Jakub Galczyk</a>.</li>
</ul>
<p>We appreciated <a href="http://codex.wordpress.org/FAQ_Security">responsible disclosure</a> of these issues directly to our security team. For more information on the changes, see the <a href="http://codex.wordpress.org/Version_3.5.2">release notes</a> or consult <a href="http://core.trac.wordpress.org/log/branches/3.5?rev=24498&amp;stop_rev=23347">the list of changes</a>.</p>
<p><a href="http://wordpress.org/wordpress-3.5.2.zip">Download WordPress 3.5.2</a> or update now from the Dashboard → Updates menu in your site’s admin area.</p>
<p><em>Also:</em> <strong>WordPress 3.6 Beta 4:</strong> If you are testing WordPress 3.6, please note that <a href="http://wordpress.org/wordpress-3.6-beta4.zip">WordPress 3.6 Beta 4</a> (zip) includes fixes for these security issues.</p>
";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:36:"http://wellformedweb.org/CommentAPI/";a:1:{s:10:"commentRss";a:1:{i:0;a:5:{s:4:"data";s:55:"http://wordpress.org/news/2013/06/wordpress-3-5-2/feed/";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:38:"http://purl.org/rss/1.0/modules/slash/";a:1:{s:8:"comments";a:1:{i:0;a:5:{s:4:"data";s:1:"0";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}i:5;a:6:{s:4:"data";s:42:"
		
		
		
		
		
				

		
		
				
			
		
		";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:5:{s:0:"";a:7:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:14:"Ten Good Years";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:49:"http://wordpress.org/news/2013/05/ten-good-years/";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:8:"comments";a:1:{i:0;a:5:{s:4:"data";s:58:"http://wordpress.org/news/2013/05/ten-good-years/#comments";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:31:"Fri, 31 May 2013 17:54:35 +0000";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:8:"category";a:1:{i:0;a:5:{s:4:"data";s:4:"Meta";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"guid";a:1:{i:0;a:5:{s:4:"data";s:33:"http://wordpress.org/news/?p=2606";s:7:"attribs";a:1:{s:0:"";a:1:{s:11:"isPermaLink";s:5:"false";}}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:343:"It&#8217;s been ten years since we started this thing, and what a long way we&#8217;ve come. From a discussion between myself and Mike Little about forking our favorite blogging software, to powering 18% of the web. It&#8217;s been a crazy, exciting, journey, and one that won&#8217;t stop any time soon. At ten years, it&#8217;s fun [&#8230;]";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:32:"http://purl.org/dc/elements/1.1/";a:1:{s:7:"creator";a:1:{i:0;a:5:{s:4:"data";s:14:"Matt Mullenweg";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:40:"http://purl.org/rss/1.0/modules/content/";a:1:{s:7:"encoded";a:1:{i:0;a:5:{s:4:"data";s:9852:"<p><img class="alignright" alt="" align="right" src="http://wpdotorg.files.wordpress.com/2013/05/wp10.jpg" width="316" height="164" />It&#8217;s been ten years since we started this thing, and what a long way we&#8217;ve come. From a discussion between myself and <a href="http://mikelittle.org/">Mike Little</a> about <a href="http://ma.tt/2003/01/the-blogging-software-dilemma/">forking our favorite blogging software</a>, to powering 18% of the web. It&#8217;s been a crazy, exciting, journey, and one that won&#8217;t stop any time soon.</p>
<p>At ten years, it&#8217;s fun to reflect on our beginnings. We launched WordPress on 27th May 2003, but that wasn&#8217;t inception. Go back far enough, and you can <a href="http://zengun.org/weblog/archives/2001/06/post1958/">read a post by Michel Valdrighi</a> who, frustrated by the self-hosted blogging platforms available, decided to write his own software; &#8220;b2, a PHP+MySQL alternative to Blogger and GreyMatter.&#8221; b2 was easy to install, easy to configure, and easy for developers to extend. Of all the blogging platforms out there, <a href="http://cafelog.com">b2</a> was the right one for me: I could write my content and get it on the web quickly and painlessly.</p>
<p>Sometimes, however, life gets in the way. In 2002, Michel stopped maintaining b2. Over time, security flaws became apparent and updates were needed and, while the b2 community could write patches and fixes, no one was driving the software forward. We were lucky that Michel decided to release b2 under the GPL; the software may have been abandoned, but we weren&#8217;t without options. A fork was always a possibility. That was where it stood in January 2003, when <a href="http://ma.tt/2003/01/the-blogging-software-dilemma/">I posted about forking b2</a> and <a href="http://ma.tt/2003/01/the-blogging-software-dilemma/#comment-445">Mike responded</a>. The rest, as they say, is history.</p>
<p>From the very beginning to the present day, I&#8217;ve been impressed by the thought, care, and dedication that WordPress&#8217; developers have demonstrated. Each one has brought his or her unique perspective, each individual has strengthened the whole. It would be impossible to thank each of them here individually, but their achievements speak for themselves. In WordPress 1.2 the new Plugin API made it easy for developers to extend WordPress. In the same release <code>gettext()</code> internationalization opened WordPress up to every language (hat tip: <a href="http://ryan.boren.me/">Ryan Boren</a> for spending hours wrapping strings with gettext). In WordPress 1.5 our Theme system made it possible for WordPress users to quickly change their site&#8217;s design: there was huge resistance to the theme system from the wider community at the time, but can you imagine WordPress without it? Versions 2.7, 2.8, and 2.9 saw improvements that let users install and update their plugins and themes with one click. WordPress has seen a redesign by <a href="http://v2.happycog.com/create/wordpress/?p=design/wordpress/">happycog</a> (2.3) and gone under extensive user testing and redesign (<a href="http://www.slideshare.net/edanzico/riding-the-crazyhorse-future-generation-wordpress-presentation">Crazyhorse</a>, Liz Danzico and Jen Mylo, WordPress 2.5). In WordPress 3.0 we merged WordPress MU with WordPress &#8212; a huge job but 100% worth it. And in WordPress 3.5 we revamped the media uploader to make it easier for people to get their images, video, and media online.</p>
<p>In sticking to our commitment to user experience, we&#8217;ve done a few things that have made us unpopular. The <a href="http://tech.gaeatimes.com/index.php/archive/wordpress-wysiwyg-editor-is-a-disaster/">WYSIWYG editor</a> was hated by many, especially those who felt that if you have a blog you should know HTML. Some developers hated that we stuck with our code, refusing to rewrite, but it&#8217;s always been the users that matter: better a developer lose sleep than a site break for a user. Our code isn&#8217;t always beautiful, after all, when WordPress was created most of us were still learning PHP, but we try to make a flawless experience for users.</p>
<p>It&#8217;s not all about developers. WordPress&#8217; strength lies in the diversity of its community. From the start, we wanted a low barrier to entry and we came up with our &#8220;famous 5 minute install&#8221;. This brought on board users from varied technical background: people who didn&#8217;t write code wanted to help make WordPress better. If you couldn&#8217;t write code, it didn&#8217;t matter: you could answer a question in the support forums, write documentation, translate WordPress, or build your friends and family a WordPress website. There is <a href="https://make.wordpress.org/">space in the community</a> for anyone with a passion for WordPress.</p>
<p>It&#8217;s been wonderful to see all of the people who have used WordPress to build their home on the internet. Early on <a href="http://wordpress.org/news/2004/04/switchers/">we got excited</a> by <a href="http://wordpress.org/news/2004/04/more-switchers/">switchers</a>. From a community of tinkerers we grew, as writers such as <a href="http://ma.tt/2004/05/om-malik/">Om Malik</a>, <a href="http://dougal.gunters.org/blog/2004/05/15/mark-pilgrim-switches/">Mark Pilgrim</a>, and <a href="http://ma.tt/2004/07/mollycom-switches/">Molly Holzschlag</a> made the switch to WordPress. Our commitment to effortless publishing quickly paid off and has continued to do so: <strong>the WordPress 1.2 release saw 822 downloads per day, our latest release, WordPress 3.5, has seen 145,692 per day.</strong></p>
<p>I&#8217;m continually amazed by what people have built with WordPress. I&#8217;ve seen <a href="http://justintimberlake.com/main/">musicians</a> and <a href="http://ma.tt/2013/01/neil-leifer-on-wordpress/">photographers</a>, magazines such as <a href="http://life.time.com/">Life</a>, <a href="http://boingboing.net/">BoingBoing</a>, and the <a href="http://observer.com/">New York Observer</a>, <a href="http://www.compliance.gov/">government websites</a>, a <a href="http://josephscott.org/archives/2011/05/pressfs-a-wordpress-filesystem/">filesystem</a>, <a href="http://www.ymcanyc.org/association/pages/y-mvp"> mobile applications</a>, and even <a href="http://www.viper007bond.com/2010/06/12/so-apparently-wordpress-can-guide-missiles/">seen WordPress guide missiles</a>.</p>
<p>As the web evolves, WordPress evolves. Factors outside of our control will always influence WordPress&#8217; development: today it&#8217;s mobile devices and retina display, tomorrow it could be Google Glass or technology not yet conceived. A lot can happen in ten years! As technology changes and advances, WordPress has to change with it while remaining true to its core values: making publishing online easy for everyone. How we rise to these challenges will be what defines WordPress over the coming ten years.</p>
<p><strong>To celebrate ten years of WordPress, we&#8217;re working on a book about our history.</strong> We&#8217;re carrying out interviews with people who have involved with the community from the very beginning, those who are still around, and those who have left. It&#8217;s a huge project, but we wanted to have something to share with you on the 10th anniversary. To learn about the very early days of WordPress, just after Mike and I forked b2 <a href="http://wordpress.org/about/history/">you can download Chapter 3 right here</a>. We&#8217;ll be releasing the rest of the book serially, so watch out as the story of the last ten years emerges.</p>
<p>In the meantime, <a href="http://ma.tt/2013/05/dear-wordpress/"> I penned my own letter to WordPress</a> and other community members have been sharing their thoughts:</p>
<ul>
<li><a href="http://zed1.com/journalized/archives/2013/01/25/wordpress-a-10-year-journey/">Mike Little on our Ten Year Journey</a>.</li>
<li>Core contributor Helen Hou-Sandi <a href="http://helen.wordpress.com/2013/05/27/happy-10th-wordpress-and-thanks-from-my-little-family/">wishes WordPress happy birthday</a>.</li>
<li>Peter Westwood on <a href="http://blog.ftwr.co.uk/archives/2013/05/27/a-decade-gone-more-to-come/">a decade gone</a>.</li>
<li>Support rep Mika Epstein <a href="http://ipstenu.org/2013/you-me-and-wp/">on her WordPress journey</a>.</li>
<li>Dougal Campbell <a href="http://dougal.gunters.org/blog/2013/05/27/instagram-my-wife-suzecampbell-and-i-celebrating-the-wordpress-10th-anniversary-with-bbq-in-our-wordpress-shirts-wp10/">celebrating with his wife, Suze</a>.</li>
<li>Otto on <a href="http://ottodestruct.com/blog/2013/how-wp-affected-me/">how WordPress affected him</a>.</li>
</ul>
<p>You can see how WordPress&#8217; 10th Anniversary was celebrated all over the world <a href="http://wp10.wordpress.net/">by visiting the wp10 website</a>, according to Meetup we had 4,999 celebrators.</p>
<p>To finish, I just want to say thank you to everyone: to the developers who write the code, to the designers who make WordPress sing, to the worldwide community translating WordPress into so many languages, to volunteers who answer support questions, to those who make WordPress accessible, to the systems team and the plugin and theme reviewers, to documentation writers, event organisers, evangelists, detractors, supporters and friends. Thanks to the jazzers whose music inspired us and whose names are at the heart of WordPress. Thanks to everyone who uses WordPress to power their blog or website, and to everyone who will in the future. Thanks to WordPress and its community that I&#8217;m proud to be part of.</p>
<p>Thank you. I can&#8217;t wait to see what the next ten years bring.</p>
<p><em>Final thanks to <a href="http://siobhanmckeown.com/">Siobhan McKeown</a> for help with this post.</em></p>
";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:36:"http://wellformedweb.org/CommentAPI/";a:1:{s:10:"commentRss";a:1:{i:0;a:5:{s:4:"data";s:54:"http://wordpress.org/news/2013/05/ten-good-years/feed/";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:38:"http://purl.org/rss/1.0/modules/slash/";a:1:{s:8:"comments";a:1:{i:0;a:5:{s:4:"data";s:1:"0";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}i:6;a:6:{s:4:"data";s:42:"
		
		
		
		
		
				

		
		
				
			
		
		";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:5:{s:0:"";a:7:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:22:"The Next 10 Starts Now";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:57:"http://wordpress.org/news/2013/05/the-next-10-starts-now/";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:8:"comments";a:1:{i:0;a:5:{s:4:"data";s:66:"http://wordpress.org/news/2013/05/the-next-10-starts-now/#comments";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:31:"Mon, 27 May 2013 20:47:05 +0000";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:8:"category";a:1:{i:0;a:5:{s:4:"data";s:9:"Community";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"guid";a:1:{i:0;a:5:{s:4:"data";s:33:"http://wordpress.org/news/?p=2594";s:7:"attribs";a:1:{s:0:"";a:1:{s:11:"isPermaLink";s:5:"false";}}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:365:"All around the globe today, people are celebrating the 10th anniversary of the first WordPress release, affectionately known as #wp10. Watching the feed of photos, tweets, and posts from Auckland to Zambia is incredible; from first-time bloggers to successful WordPress-based business owners, people are coming out in droves to raise a glass and share the [&#8230;]";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:32:"http://purl.org/dc/elements/1.1/";a:1:{s:7:"creator";a:1:{i:0;a:5:{s:4:"data";s:8:"Jen Mylo";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:40:"http://purl.org/rss/1.0/modules/content/";a:1:{s:7:"encoded";a:1:{i:0;a:5:{s:4:"data";s:3901:"<p>All around the globe today, people are celebrating the 10th anniversary of the first WordPress release, affectionately known as #wp10. <a href="http://wp10.wordpress.net">Watching the feed</a> of photos, tweets, and posts from Auckland to Zambia is incredible; from first-time bloggers to successful WordPress-based business owners, people are coming out in droves to raise a glass and share the &#8220;holiday&#8221; with their local communities. With hundreds of parties going on today, it&#8217;s more visible than ever just how popular WordPress has become.</p>
<p><strong>Thank you to everyone who has ever contributed to this project: your labors of love made this day possible.</strong></p>
<p>But today isn&#8217;t just about reflecting on how we got this far (though I thought <a href="http://ma.tt/2013/05/dear-wordpress/">Matt&#8217;s reflection on the first ten years</a> was lovely). We are constantly moving forward. As each release cycle begins and ends (3.6 will be here soon, promise!), we always see an ebb and flow in the contributor pool. Part of ensuring the longevity of WordPress means mentoring new contributors, continually bringing new talent and fresh points of view to our family table.</p>
<p>I am beyond pleased to announce that this summer we will be mentoring 8 interns, most of them new contributors, through <a href="http://www.google-melange.com/gsoc/homepage/google/gsoc2013">Google Summer of Code</a> and the <a href="https://live.gnome.org/OutreachProgramForWomen/2013/JuneSeptember">Gnome Outreach Program for Women</a>. Current contributors, who already volunteer their time working on WordPress, will provide the guidance and oversight for a variety of exciting projects  this summer. Here are the people/projects involved in the summer internships:</p>
<ul>
<li><strong><strong>Ryan McCue</strong>, </strong>from Australia, working on a JSON-based REST API. Mentors will be Bryan Petty and Eric Mann, with a reviewer assist from Andrew Norcross.</li>
<li><strong>Kat Hagan</strong>, from the United States, working on a Post by Email plugin to replace the core function. Mentors will be Justin Shreve and George Stephanis, with an assist from Peter Westwood.</li>
<li><strong>Siobhan Bamber</strong>, from Wales, working on a support (forums, training, documentation) internship. Mentors will be Mika Epstein and Hanni Ross.</li>
<li><strong>Frederick Ding</strong>, from the United States, working on improving portability. Mentors will be Andrew Nacin and Mike Schroder.</li>
<li><strong>Sayak Sakar</strong>, from India, working on porting WordPress for WebOS to Firefox OS. Mentor will be Eric Johnson.</li>
<li><strong>Alex Höreth</strong>, from Germany, working on  adding WordPress native revisions to the theme and plugin code editors. Mentors will be Dominik Schilling and Aaron Campbell, with a reviewer assist from Daniel Bachhuber.</li>
<li><strong>Mert Yazicioglu</strong>, from Turkey, working on ways to improve our community profiles at profiles.wordpress.org. Mentors will be Scott Reilly and Boone Gorges.</li>
<li><strong>Daniele Maio</strong>, from Italy, working on a native WordPress app for Blackberry 10. Mentor will be Danilo Ercoli.</li>
</ul>
<p>Did you notice that our summer cohort is as international as the #wp10 parties going on today? I can only think that this is a good sign.</p>
<p>It&#8217;s always a difficult process to decide which projects to mentor through these programs. There are always more applicants with interesting ideas with whom we&#8217;d like to work than there are opportunities. Luckily, WordPress is a free/libre open source software project, and anyone can begin contributing at any time. Is this the year for you? We&#8217;d love for you to join us as we work toward #wp20. <img src=''http://wordpress.org/news/wp-includes/images/smilies/icon_wink.gif'' alt='';)'' class=''wp-smiley'' /> </p>
";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:36:"http://wellformedweb.org/CommentAPI/";a:1:{s:10:"commentRss";a:1:{i:0;a:5:{s:4:"data";s:62:"http://wordpress.org/news/2013/05/the-next-10-starts-now/feed/";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:38:"http://purl.org/rss/1.0/modules/slash/";a:1:{s:8:"comments";a:1:{i:0;a:5:{s:4:"data";s:1:"0";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}i:7;a:6:{s:4:"data";s:42:"
		
		
		
		
		
				

		
		
				
			
		
		";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:5:{s:0:"";a:7:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:20:"WordPress 3.6 Beta 3";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:55:"http://wordpress.org/news/2013/05/wordpress-3-6-beta-3/";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:8:"comments";a:1:{i:0;a:5:{s:4:"data";s:64:"http://wordpress.org/news/2013/05/wordpress-3-6-beta-3/#comments";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:31:"Sat, 11 May 2013 03:44:41 +0000";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:8:"category";a:1:{i:0;a:5:{s:4:"data";s:11:"Development";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"guid";a:1:{i:0;a:5:{s:4:"data";s:33:"http://wordpress.org/news/?p=2584";s:7:"attribs";a:1:{s:0:"";a:1:{s:11:"isPermaLink";s:5:"false";}}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:374:"WordPress 3.6 Beta 3 is now available! This is software still in development and we really don’t recommend that you run it on a production site — set up a test site just to play with the new version. To test WordPress 3.6, try the WordPress Beta Tester plugin (you’ll want “bleeding edge nightlies”). Or you can download the beta here (zip). Beta [&#8230;]";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:32:"http://purl.org/dc/elements/1.1/";a:1:{s:7:"creator";a:1:{i:0;a:5:{s:4:"data";s:12:"Mark Jaquith";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:40:"http://purl.org/rss/1.0/modules/content/";a:1:{s:7:"encoded";a:1:{i:0;a:5:{s:4:"data";s:2452:"<p>WordPress 3.6 Beta 3 is now available!</p>
<p>This is software still in development and <strong>we <em>really</em> don’t recommend that you run it on a production site</strong> — set up a test site just to play with the new version. To test WordPress 3.6, try the <a href="http://wordpress.org/extend/plugins/wordpress-beta-tester/">WordPress Beta Tester</a> plugin (you’ll want “bleeding edge nightlies”). Or you can <a href="http://wordpress.org/wordpress-3.6-beta3.zip">download the beta here</a> (zip).</p>
<p>Beta 3 contains about a hundred changes, including improvements to the image Post Format flow (yay, drag-and-drop image upload!), a more polished revision comparison screen, and a more quote-like quote format for Twenty Thirteen.</p>
<p>As a bonus, we now have oEmbed support for the popular music-streaming services <a href="http://www.rdio.com/">Rdio</a> and <a href="http://www.spotify.com/">Spotify</a> (the latter of which kindly created an oEmbed endpoint a mere 24 hours after we lamented their lack of one). Here&#8217;s an album that&#8217;s been getting a lot of play as I&#8217;ve been working on WordPress 3.6:</p>
<p><iframe width="500" height="250" src="https://rd.io/i/Qj5r8SE//?source=oembed" frameborder="0"></iframe></p>
<p><iframe src="https://embed.spotify.com/?uri=spotify:album:6dJZDZMNdBPZrJcNv57bEq" width="300" height="380" frameborder="0" allowtransparency="true"></iframe></p>
<p>Plugin developers, theme developers, and WordPress hosts should be testing beta 3 extensively. The more you test the beta, the more stable our release candidates and our final release will be.</p>
<p>As always, if you think you’ve found a bug, you can post to the <a href="http://wordpress.org/support/forum/alphabeta">Alpha/Beta area</a> in the support forums. Or, if you’re comfortable writing a reproducible bug report, <a href="http://core.trac.wordpress.org/">file one on the WordPress Trac</a>. There, you can also find <a href="http://core.trac.wordpress.org/report/5">a list of known bugs</a> and <a href="http://core.trac.wordpress.org/query?status=closed&amp;group=component&amp;milestone=3.6">everything we&#8217;ve fixed</a> so far.</p>
<p>We&#8217;re looking forward to your feedback. If you find a bug, please report it, and if you’re a developer, try to help us fix it. We&#8217;ve already had more than 150 contributors to version 3.6 — it&#8217;s not too late to join in!</p>
";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:36:"http://wellformedweb.org/CommentAPI/";a:1:{s:10:"commentRss";a:1:{i:0;a:5:{s:4:"data";s:60:"http://wordpress.org/news/2013/05/wordpress-3-6-beta-3/feed/";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:38:"http://purl.org/rss/1.0/modules/slash/";a:1:{s:8:"comments";a:1:{i:0;a:5:{s:4:"data";s:1:"0";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}i:8;a:6:{s:4:"data";s:42:"
		
		
		
		
		
				

		
		
				
			
		
		";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:5:{s:0:"";a:7:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:20:"WordPress 3.6 Beta 2";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:55:"http://wordpress.org/news/2013/04/wordpress-3-6-beta-2/";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:8:"comments";a:1:{i:0;a:5:{s:4:"data";s:64:"http://wordpress.org/news/2013/04/wordpress-3-6-beta-2/#comments";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:31:"Mon, 29 Apr 2013 22:48:55 +0000";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:8:"category";a:1:{i:0;a:5:{s:4:"data";s:11:"Development";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"guid";a:1:{i:0;a:5:{s:4:"data";s:33:"http://wordpress.org/news/?p=2579";s:7:"attribs";a:1:{s:0:"";a:1:{s:11:"isPermaLink";s:5:"false";}}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:373:"WordPress 3.6 Beta 2 is now available! This is software still in development and we really don’t recommend that you run it on a production site — set up a test site just to play with the new version. To test WordPress 3.6, try the WordPress Beta Tester plugin (you’ll want “bleeding edge nightlies”). Or you can download the beta here (zip). The [&#8230;]";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:32:"http://purl.org/dc/elements/1.1/";a:1:{s:7:"creator";a:1:{i:0;a:5:{s:4:"data";s:12:"Mark Jaquith";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:40:"http://purl.org/rss/1.0/modules/content/";a:1:{s:7:"encoded";a:1:{i:0;a:5:{s:4:"data";s:2057:"<p>WordPress 3.6 Beta 2 is now available!</p>
<p>This is software still in development and <strong>we <em>really</em> don’t recommend that you run it on a production site</strong> — set up a test site just to play with the new version. To test WordPress 3.6, try the <a href="http://wordpress.org/extend/plugins/wordpress-beta-tester/">WordPress Beta Tester</a> plugin (you’ll want “bleeding edge nightlies”). Or you can <a href="http://wordpress.org/wordpress-3.6-beta2.zip">download the beta here</a> (zip).</p>
<p>The longer-than-usual delay between beta 1 and beta 2 was due to poor user testing results with the Post Formats UI. Beta 2 contains a modified approach for format choosing and switching, which has done well in user testing. We&#8217;ve also made the Post Formats UI hide-able via Screen Options, and set a reasonable default based on what your theme supports.</p>
<p>There were a lot of bug fixes and polishing tweaks done for beta 2 as well, so definitely check it out if you had an issues with beta 1.</p>
<p>Plugin developers, theme developers, and WordPress hosts should be testing beta 2 extensively. The more you test the beta, the more stable our release candidates and our final release will be.</p>
<p>As always, if you think you’ve found a bug, you can post to the <a href="http://wordpress.org/support/forum/alphabeta">Alpha/Beta area</a> in the support forums. Or, if you’re comfortable writing a reproducible bug report, <a href="http://core.trac.wordpress.org/">file one on the WordPress Trac</a>. There, you can also find <a href="http://core.trac.wordpress.org/report/5">a list of known bugs</a> and <a href="http://core.trac.wordpress.org/query?status=closed&amp;group=component&amp;milestone=3.6">everything we&#8217;ve fixed</a> so far.</p>
<p>We&#8217;re looking forward to your feedback. If you find a bug, please report it, and if you’re a developer, try to help us fix it. We&#8217;ve already had more than 150 contributors to version 3.6 — it&#8217;s not too late to join in!</p>
";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:36:"http://wellformedweb.org/CommentAPI/";a:1:{s:10:"commentRss";a:1:{i:0;a:5:{s:4:"data";s:60:"http://wordpress.org/news/2013/04/wordpress-3-6-beta-2/feed/";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:38:"http://purl.org/rss/1.0/modules/slash/";a:1:{s:8:"comments";a:1:{i:0;a:5:{s:4:"data";s:1:"0";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}i:9;a:6:{s:4:"data";s:45:"
		
		
		
		
		
				
		

		
		
				
			
		
		";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:5:{s:0:"";a:7:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:42:"Summer Mentorship Programs: GSoC and Gnome";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:76:"http://wordpress.org/news/2013/04/summer-mentorship-programs-gsoc-and-gnome/";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:8:"comments";a:1:{i:0;a:5:{s:4:"data";s:85:"http://wordpress.org/news/2013/04/summer-mentorship-programs-gsoc-and-gnome/#comments";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:31:"Thu, 25 Apr 2013 03:18:41 +0000";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:8:"category";a:2:{i:0;a:5:{s:4:"data";s:9:"Community";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}i:1;a:5:{s:4:"data";s:11:"Development";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"guid";a:1:{i:0;a:5:{s:4:"data";s:33:"http://wordpress.org/news/?p=2573";s:7:"attribs";a:1:{s:0:"";a:1:{s:11:"isPermaLink";s:5:"false";}}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:358:"As an open source, free software project, WordPress depends on the contributions of hundreds of people from around the globe &#8212; contributions in areas like core code, documentation, answering questions in the support forums, translation, and all the other things it takes to make WordPress the best publishing platform it can be, with the most [&#8230;]";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:32:"http://purl.org/dc/elements/1.1/";a:1:{s:7:"creator";a:1:{i:0;a:5:{s:4:"data";s:8:"Jen Mylo";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:40:"http://purl.org/rss/1.0/modules/content/";a:1:{s:7:"encoded";a:1:{i:0;a:5:{s:4:"data";s:5071:"<p>As an open source, free software project, WordPress depends on the contributions of hundreds of people from around the globe &#8212; contributions in areas like core code, documentation, answering questions in the support forums, translation, and all the other things it takes to make WordPress the best publishing platform it can be, with the most supportive community. This year, we&#8217;re happy to be participating as a mentoring organization with two respected summer internship programs: <a href="http://www.google-melange.com/gsoc/homepage/google/gsoc2013">Google Summer of Code (GSoC)</a> and the Gnome Outreach Program for Women.</p>
<h3>Google Summer of Code</h3>
<p>GSoC is a summer internship program funded by Google specifically for college/university student developers to work on open source coding projects. We have participated in the Google Summer of Code program in the past, and have enjoyed the opportunity to work with students in this way. Some of our best core developers were GSoC students once upon a time!</p>
<p><a href="http://codex.wordpress.org/GSoC2013#Mentors">Our mentors</a>, almost 30 talented developers with experience developing WordPress, will provide students with guidance and feedback over the course of the summer, culminating in the release of finished projects at the end of the program if all goes well.</p>
<p>Students who successfully complete the program earn $5,000 for their summer efforts. Interested, or know a college student (newly accepted to college counts, too) who should be? All the information you need about our participation in the program, projects, mentors, and the application process is available on the <a href="http://codex.wordpress.org/GSoC2013">GSoC 2013 page in the Codex</a>.</p>
<h3>Gnome Outreach Program for Women</h3>
<p>It&#8217;s not news that women form a low percentage of contributors in most open source projects, and WordPress is no different. We have great women in the contributor community, including some in fairly visible roles, but we still have a lot of work to do to get a representative gender balance on par with our user base.</p>
<p>The Gnome Outreach Program for Women aims to provide opportunities for women to participate in open source projects, and offers a similar stipend, but there are three key differences between GSoC and Gnome aside from the gender requirement for Gnome.</p>
<ol>
<li><span style="font-size: 13px;line-height: 19px">The Gnome program allows intern projects in many areas of contribution, not just code. In other words, interns can propose projects like documentation, community management, design, translation, or pretty much any area in which we have people contributing (including code).</span></li>
<li><span style="font-size: 13px;line-height: 19px">The Gnome Outreach Program for Women doesn&#8217;t require interns to be college students, though students are definitely welcome to participate. This means that women in all stages of life and career can take the opportunity to try working with open source communities for the summer.</span></li>
<li><span style="font-size: 13px;line-height: 19px">We have to help raise the money to pay the interns. Google funds GSoC on its own, and we only have to provide our mentors&#8217; time. Gnome doesn&#8217;t have the same funding, so we need to pitch in to raise the money to cover our interns. If your company is interested in helping with this, please check out the program&#8217;s </span><a style="font-size: 13px;line-height: 19px" href="https://live.gnome.org/OutreachProgramForWomen#For_Organizations_and_Companies">sponsorship information</a><span style="font-size: 13px;line-height: 19px"> and follow the contact instructions to get involved. You can earmark donations to support WordPress interns, or to support the program in general. (Pick us, pick us! <img src=''http://wordpress.org/news/wp-includes/images/smilies/icon_smile.gif'' alt='':)'' class=''wp-smiley'' />  )</span></li>
</ol>
<p>The summer installment of the Gnome Outreach Program for Women follows the same schedule and general application format as GSoC, though there are more potential projects since it covers more areas of contribution. Women college students interested in doing a coding project are encouraged to apply for both programs to increase the odds of acceptance. All the information you need about our participation in the program, projects, mentors, and the application process is available on the <a href="http://codex.wordpress.org/Gnome_Summer_Program_for_Women">Gnome Outreach Program for Women page in the Codex</a>.</p>
<p>The application period just started, and it lasts another week (May 1 for Gnome, May 3 for GSoC), so if you think you qualify and are interested in getting involved, check out the information pages, get in touch, and apply… Good luck!</p>
<p><a href="http://codex.wordpress.org/GSoC2013">Google Summer of Code 2013 Information</a><br />
<a href="http://codex.wordpress.org/Gnome_Summer_Program_for_Women">Gnome Summer Outreach Program for Women 2013 Information</a></p>
";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:36:"http://wellformedweb.org/CommentAPI/";a:1:{s:10:"commentRss";a:1:{i:0;a:5:{s:4:"data";s:81:"http://wordpress.org/news/2013/04/summer-mentorship-programs-gsoc-and-gnome/feed/";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:38:"http://purl.org/rss/1.0/modules/slash/";a:1:{s:8:"comments";a:1:{i:0;a:5:{s:4:"data";s:1:"0";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}}}s:27:"http://www.w3.org/2005/Atom";a:1:{s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:0:"";s:7:"attribs";a:1:{s:0:"";a:3:{s:4:"href";s:31:"http://wordpress.org/news/feed/";s:3:"rel";s:4:"self";s:4:"type";s:19:"application/rss+xml";}}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:44:"http://purl.org/rss/1.0/modules/syndication/";a:2:{s:12:"updatePeriod";a:1:{i:0;a:5:{s:4:"data";s:6:"hourly";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:15:"updateFrequency";a:1:{i:0;a:5:{s:4:"data";s:1:"1";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}}}}}}}}s:4:"type";i:128;s:7:"headers";a:8:{s:6:"server";s:5:"nginx";s:4:"date";s:29:"Wed, 14 Aug 2013 11:36:15 GMT";s:12:"content-type";s:23:"text/xml; charset=UTF-8";s:10:"connection";s:5:"close";s:4:"vary";s:15:"Accept-Encoding";s:10:"x-pingback";s:36:"http://wordpress.org/news/xmlrpc.php";s:13:"last-modified";s:29:"Thu, 01 Aug 2013 21:49:34 GMT";s:4:"x-nc";s:11:"HIT lax 249";}s:5:"build";s:14:"20130708171016";}', 'no');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (156, '_transient_timeout_feed_mod_ac0b00fe65abe10e0c5b588f3ed8c7ca', '1376523376', 'no');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (157, '_transient_feed_mod_ac0b00fe65abe10e0c5b588f3ed8c7ca', '1376480176', 'no');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (158, '_transient_timeout_dash_4077549d03da2e451c8b5f002294ff51', '1376523376', 'no');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (159, '_transient_dash_4077549d03da2e451c8b5f002294ff51', '<div class="rss-widget"><ul><li><a class=''rsswidget'' href=''http://wordpress.org/news/2013/08/oscar/'' title=''The latest and greatest WordPress, version 3.6, is now live to the world and includes a beautiful new blog-centric theme, bullet-proof autosave and post locking, a revamped revision browser, native support for audio and video embeds, and improved integrations with Spotify, Rdio, and SoundCloud. Here’s a video that shows off some of the features using […]''>WordPress 3.6 “Oscar”</a> <span class="rss-date">August 1, 2013</span><div class=''rssSummary''>The latest and greatest WordPress, version 3.6, is now live to the world and includes a beautiful new blog-centric theme, bullet-proof autosave and post locking, a revamped revision browser, native support for audio and video embeds, and improved integrations with Spotify, Rdio, and SoundCloud. Here’s a video that shows off some of the features using […]</div></li><li><a class=''rsswidget'' href=''http://wordpress.org/news/2013/07/wordpress-3-6-release-candidate-2/'' title=''The second release candidate for WordPress 3.6 is now available for download and testing. We’re down to only a few remaining issues, and the final release should be available in a matter of days. In RC2, we’ve tightened up some aspects of revisions, autosave, and the media player, and fixed some bugs that were spotted […]''>WordPress 3.6 Release Candidate 2</a> <span class="rss-date">July 24, 2013</span><div class=''rssSummary''>The second release candidate for WordPress 3.6 is now available for download and testing. We’re down to only a few remaining issues, and the final release should be available in a matter of days. In RC2, we’ve tightened up some aspects of revisions, autosave, and the media player, and fixed some bugs that were spotted […]</div></li></ul></div>', 'no');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (160, '_transient_timeout_feed_b9388c83948825c1edaef0d856b7b109', '1376523376', 'no');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (161, '_transient_feed_b9388c83948825c1edaef0d856b7b109', 'a:4:{s:5:"child";a:1:{s:0:"";a:1:{s:3:"rss";a:1:{i:0;a:6:{s:4:"data";s:3:"
	
";s:7:"attribs";a:1:{s:0:"";a:1:{s:7:"version";s:3:"2.0";}}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:1:{s:0:"";a:1:{s:7:"channel";a:1:{i:0;a:6:{s:4:"data";s:72:"
		
		
		
		
		
		
				

		
		
		
		
		
		
		
		
		
		
		
		
		
		
		

	";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:2:{s:0:"";a:7:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:39:"WordPress Plugins » View: Most Popular";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:44:"http://wordpress.org/plugins/browse/popular/";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:39:"WordPress Plugins » View: Most Popular";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:8:"language";a:1:{i:0;a:5:{s:4:"data";s:5:"en-US";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:31:"Wed, 14 Aug 2013 11:04:02 +0000";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:9:"generator";a:1:{i:0;a:5:{s:4:"data";s:25:"http://bbpress.org/?v=1.1";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"item";a:15:{i:0;a:6:{s:4:"data";s:30:"
			
			
			
			
			
			
					";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:2:{s:0:"";a:5:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:7:"Akismet";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:45:"http://wordpress.org/plugins/akismet/#post-15";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:31:"Fri, 09 Mar 2007 22:11:30 +0000";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"guid";a:1:{i:0;a:5:{s:4:"data";s:32:"15@http://wordpress.org/plugins/";s:7:"attribs";a:1:{s:0:"";a:1:{s:11:"isPermaLink";s:5:"false";}}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:98:"Akismet checks your comments against the Akismet web service to see if they look like spam or not.";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:32:"http://purl.org/dc/elements/1.1/";a:1:{s:7:"creator";a:1:{i:0;a:5:{s:4:"data";s:14:"Matt Mullenweg";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}i:1;a:6:{s:4:"data";s:30:"
			
			
			
			
			
			
					";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:2:{s:0:"";a:5:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:14:"Contact Form 7";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:54:"http://wordpress.org/plugins/contact-form-7/#post-2141";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:31:"Thu, 02 Aug 2007 12:45:03 +0000";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"guid";a:1:{i:0;a:5:{s:4:"data";s:34:"2141@http://wordpress.org/plugins/";s:7:"attribs";a:1:{s:0:"";a:1:{s:11:"isPermaLink";s:5:"false";}}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:54:"Just another contact form plugin. Simple but flexible.";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:32:"http://purl.org/dc/elements/1.1/";a:1:{s:7:"creator";a:1:{i:0;a:5:{s:4:"data";s:16:"Takayuki Miyoshi";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}i:2;a:6:{s:4:"data";s:30:"
			
			
			
			
			
			
					";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:2:{s:0:"";a:5:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:24:"Jetpack by WordPress.com";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:48:"http://wordpress.org/plugins/jetpack/#post-23862";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:31:"Thu, 20 Jan 2011 02:21:38 +0000";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"guid";a:1:{i:0;a:5:{s:4:"data";s:35:"23862@http://wordpress.org/plugins/";s:7:"attribs";a:1:{s:0:"";a:1:{s:11:"isPermaLink";s:5:"false";}}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:104:"Supercharge your WordPress site with powerful features previously only available to WordPress.com users.";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:32:"http://purl.org/dc/elements/1.1/";a:1:{s:7:"creator";a:1:{i:0;a:5:{s:4:"data";s:24:"Michael Adams (mdawaffe)";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}i:3;a:6:{s:4:"data";s:30:"
			
			
			
			
			
			
					";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:2:{s:0:"";a:5:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:15:"NextGEN Gallery";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:55:"http://wordpress.org/plugins/nextgen-gallery/#post-1169";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:31:"Mon, 23 Apr 2007 20:08:06 +0000";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"guid";a:1:{i:0;a:5:{s:4:"data";s:34:"1169@http://wordpress.org/plugins/";s:7:"attribs";a:1:{s:0:"";a:1:{s:11:"isPermaLink";s:5:"false";}}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:122:"The most popular WordPress gallery plugin and one of the most popular plugins of all time with over 7.5 million downloads.";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:32:"http://purl.org/dc/elements/1.1/";a:1:{s:7:"creator";a:1:{i:0;a:5:{s:4:"data";s:9:"Alex Rabe";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}i:4;a:6:{s:4:"data";s:30:"
			
			
			
			
			
			
					";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:2:{s:0:"";a:5:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:22:"WordPress SEO by Yoast";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:53:"http://wordpress.org/plugins/wordpress-seo/#post-8321";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:31:"Thu, 01 Jan 2009 20:34:44 +0000";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"guid";a:1:{i:0;a:5:{s:4:"data";s:34:"8321@http://wordpress.org/plugins/";s:7:"attribs";a:1:{s:0:"";a:1:{s:11:"isPermaLink";s:5:"false";}}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:131:"Improve your WordPress SEO: Write better content and have a fully optimized WordPress site using the WordPress SEO plugin by Yoast.";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:32:"http://purl.org/dc/elements/1.1/";a:1:{s:7:"creator";a:1:{i:0;a:5:{s:4:"data";s:13:"Joost de Valk";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}i:5;a:6:{s:4:"data";s:30:"
			
			
			
			
			
			
					";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:2:{s:0:"";a:5:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:18:"WordPress Importer";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:59:"http://wordpress.org/plugins/wordpress-importer/#post-18101";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:31:"Thu, 20 May 2010 17:42:45 +0000";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"guid";a:1:{i:0;a:5:{s:4:"data";s:35:"18101@http://wordpress.org/plugins/";s:7:"attribs";a:1:{s:0:"";a:1:{s:11:"isPermaLink";s:5:"false";}}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:101:"Import posts, pages, comments, custom fields, categories, tags and more from a WordPress export file.";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:32:"http://purl.org/dc/elements/1.1/";a:1:{s:7:"creator";a:1:{i:0;a:5:{s:4:"data";s:14:"Brian Colinger";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}i:6;a:6:{s:4:"data";s:30:"
			
			
			
			
			
			
					";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:2:{s:0:"";a:5:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:14:"W3 Total Cache";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:55:"http://wordpress.org/plugins/w3-total-cache/#post-12073";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:31:"Wed, 29 Jul 2009 18:46:31 +0000";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"guid";a:1:{i:0;a:5:{s:4:"data";s:35:"12073@http://wordpress.org/plugins/";s:7:"attribs";a:1:{s:0:"";a:1:{s:11:"isPermaLink";s:5:"false";}}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:132:"Easy Web Performance Optimization (WPO) using caching: browser, page, object, database, minify and content delivery network support.";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:32:"http://purl.org/dc/elements/1.1/";a:1:{s:7:"creator";a:1:{i:0;a:5:{s:4:"data";s:16:"Frederick Townes";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}i:7;a:6:{s:4:"data";s:30:"
			
			
			
			
			
			
					";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:2:{s:0:"";a:5:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:19:"All in One SEO Pack";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:58:"http://wordpress.org/plugins/all-in-one-seo-pack/#post-753";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:31:"Fri, 30 Mar 2007 20:08:18 +0000";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"guid";a:1:{i:0;a:5:{s:4:"data";s:33:"753@http://wordpress.org/plugins/";s:7:"attribs";a:1:{s:0:"";a:1:{s:11:"isPermaLink";s:5:"false";}}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:86:"WordPress SEO plugin to automatically optimize your Wordpress blog for Search Engines.";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:32:"http://purl.org/dc/elements/1.1/";a:1:{s:7:"creator";a:1:{i:0;a:5:{s:4:"data";s:8:"uberdose";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}i:8;a:6:{s:4:"data";s:30:"
			
			
			
			
			
			
					";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:2:{s:0:"";a:5:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:22:"Advanced Custom Fields";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:63:"http://wordpress.org/plugins/advanced-custom-fields/#post-25254";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:31:"Thu, 17 Mar 2011 04:07:30 +0000";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"guid";a:1:{i:0;a:5:{s:4:"data";s:35:"25254@http://wordpress.org/plugins/";s:7:"attribs";a:1:{s:0:"";a:1:{s:11:"isPermaLink";s:5:"false";}}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:150:"Fully customise WordPress edit screens with powerful fields. Boasting a professional interface and a powerfull API, it’s a must have for any web dev";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:32:"http://purl.org/dc/elements/1.1/";a:1:{s:7:"creator";a:1:{i:0;a:5:{s:4:"data";s:12:"elliotcondon";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}i:9;a:6:{s:4:"data";s:30:"
			
			
			
			
			
			
					";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:2:{s:0:"";a:5:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:7:"Captcha";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:48:"http://wordpress.org/plugins/captcha/#post-26129";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:31:"Wed, 27 Apr 2011 05:53:50 +0000";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"guid";a:1:{i:0;a:5:{s:4:"data";s:35:"26129@http://wordpress.org/plugins/";s:7:"attribs";a:1:{s:0:"";a:1:{s:11:"isPermaLink";s:5:"false";}}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:79:"This plugin allows you to implement super security captcha form into web forms.";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:32:"http://purl.org/dc/elements/1.1/";a:1:{s:7:"creator";a:1:{i:0;a:5:{s:4:"data";s:11:"bestwebsoft";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}i:10;a:6:{s:4:"data";s:30:"
			
			
			
			
			
			
					";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:2:{s:0:"";a:5:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:12:"Contact Form";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:60:"http://wordpress.org/plugins/contact-form-plugin/#post-26890";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:31:"Thu, 26 May 2011 07:34:58 +0000";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"guid";a:1:{i:0;a:5:{s:4:"data";s:35:"26890@http://wordpress.org/plugins/";s:7:"attribs";a:1:{s:0:"";a:1:{s:11:"isPermaLink";s:5:"false";}}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:43:"Add Contact Form to your WordPress website.";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:32:"http://purl.org/dc/elements/1.1/";a:1:{s:7:"creator";a:1:{i:0;a:5:{s:4:"data";s:11:"bestwebsoft";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}i:11;a:6:{s:4:"data";s:30:"
			
			
			
			
			
			
					";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:2:{s:0:"";a:5:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:33:"WooCommerce - excelling eCommerce";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:52:"http://wordpress.org/plugins/woocommerce/#post-29860";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:31:"Mon, 05 Sep 2011 08:13:36 +0000";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"guid";a:1:{i:0;a:5:{s:4:"data";s:35:"29860@http://wordpress.org/plugins/";s:7:"attribs";a:1:{s:0:"";a:1:{s:11:"isPermaLink";s:5:"false";}}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:97:"WooCommerce is a powerful, extendable eCommerce plugin that helps you sell anything. Beautifully.";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:32:"http://purl.org/dc/elements/1.1/";a:1:{s:7:"creator";a:1:{i:0;a:5:{s:4:"data";s:9:"WooThemes";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}i:12;a:6:{s:4:"data";s:30:"
			
			
			
			
			
			
					";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:2:{s:0:"";a:5:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:19:"Google Analyticator";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:58:"http://wordpress.org/plugins/google-analyticator/#post-130";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:31:"Fri, 09 Mar 2007 22:31:18 +0000";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"guid";a:1:{i:0;a:5:{s:4:"data";s:33:"130@http://wordpress.org/plugins/";s:7:"attribs";a:1:{s:0:"";a:1:{s:11:"isPermaLink";s:5:"false";}}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:107:"Adds the necessary JavaScript code to enable Google Analytics. Includes widgets for Analytics data display.";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:32:"http://purl.org/dc/elements/1.1/";a:1:{s:7:"creator";a:1:{i:0;a:5:{s:4:"data";s:12:"cavemonkey50";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}i:13;a:6:{s:4:"data";s:30:"
			
			
			
			
			
			
					";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:2:{s:0:"";a:5:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:19:"Google XML Sitemaps";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:63:"http://wordpress.org/plugins/google-sitemap-generator/#post-132";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:31:"Fri, 09 Mar 2007 22:31:32 +0000";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"guid";a:1:{i:0;a:5:{s:4:"data";s:33:"132@http://wordpress.org/plugins/";s:7:"attribs";a:1:{s:0:"";a:1:{s:11:"isPermaLink";s:5:"false";}}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:105:"This plugin will generate a special XML sitemap which will help search engines to better index your blog.";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:32:"http://purl.org/dc/elements/1.1/";a:1:{s:7:"creator";a:1:{i:0;a:5:{s:4:"data";s:5:"Arnee";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}i:14;a:6:{s:4:"data";s:30:"
			
			
			
			
			
			
					";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:2:{s:0:"";a:5:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:18:"Better WP Security";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:59:"http://wordpress.org/plugins/better-wp-security/#post-21738";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:31:"Fri, 22 Oct 2010 22:06:05 +0000";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"guid";a:1:{i:0;a:5:{s:4:"data";s:35:"21738@http://wordpress.org/plugins/";s:7:"attribs";a:1:{s:0:"";a:1:{s:11:"isPermaLink";s:5:"false";}}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:107:"The easiest, most effective way to secure WordPress. Improve the security of any WordPress site in seconds.";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:32:"http://purl.org/dc/elements/1.1/";a:1:{s:7:"creator";a:1:{i:0;a:5:{s:4:"data";s:12:"ChrisWiegman";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}}}s:27:"http://www.w3.org/2005/Atom";a:1:{s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:0:"";s:7:"attribs";a:1:{s:0:"";a:3:{s:4:"href";s:45:"http://wordpress.org/plugins/rss/view/popular";s:3:"rel";s:4:"self";s:4:"type";s:19:"application/rss+xml";}}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}}}}}}}}s:4:"type";i:128;s:7:"headers";a:10:{s:6:"server";s:5:"nginx";s:4:"date";s:29:"Wed, 14 Aug 2013 11:36:16 GMT";s:12:"content-type";s:23:"text/xml; charset=UTF-8";s:10:"connection";s:5:"close";s:4:"vary";s:15:"Accept-Encoding";s:7:"expires";s:29:"Wed, 14 Aug 2013 11:39:02 GMT";s:13:"cache-control";s:0:"";s:6:"pragma";s:0:"";s:13:"last-modified";s:31:"Wed, 14 Aug 2013 11:04:02 +0000";s:4:"x-nc";s:11:"HIT lax 249";}s:5:"build";s:14:"20130708171016";}', 'no');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (162, '_transient_timeout_feed_mod_b9388c83948825c1edaef0d856b7b109', '1376523376', 'no');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (163, '_transient_feed_mod_b9388c83948825c1edaef0d856b7b109', '1376480176', 'no');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (164, '_transient_timeout_feed_867bd5c64f85878d03a060509cd2f92c', '1376523376', 'no');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (165, '_transient_feed_867bd5c64f85878d03a060509cd2f92c', 'a:4:{s:5:"child";a:1:{s:0:"";a:1:{s:3:"rss";a:1:{i:0;a:6:{s:4:"data";s:3:"


";s:7:"attribs";a:1:{s:0:"";a:1:{s:7:"version";s:3:"2.0";}}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:1:{s:0:"";a:1:{s:7:"channel";a:1:{i:0;a:6:{s:4:"data";s:61:"
	
	
	
	




















































";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:1:{s:0:"";a:5:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:16:"WordPress Planet";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:28:"http://planet.wordpress.org/";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:8:"language";a:1:{i:0;a:5:{s:4:"data";s:2:"en";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:47:"WordPress Planet - http://planet.wordpress.org/";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"item";a:50:{i:0;a:6:{s:4:"data";s:13:"
	
	
	
	
	
	
";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:2:{s:0:"";a:5:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:45:"WordPress.tv: Justin Briggs: SEO in WordPress";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"guid";a:1:{i:0;a:5:{s:4:"data";s:28:"http://wordpress.tv/?p=21177";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:62:"http://wordpress.tv/2013/08/13/justin-briggs-seo-in-wordpress/";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:646:"<div id="v-cvm7bvD7-1" class="video-player">
</div>
<br />  <a rel="nofollow" href="http://feeds.wordpress.com/1.0/gocomments/wptv.wordpress.com/21177/"><img alt="" border="0" src="http://feeds.wordpress.com/1.0/comments/wptv.wordpress.com/21177/" /></a> <img alt="" border="0" src="http://stats.wordpress.com/b.gif?host=wordpress.tv&blog=5089392&post=21177&subd=wptv&ref=&feed=1" width="1" height="1" /><div><a href="http://wordpress.tv/2013/08/13/justin-briggs-seo-in-wordpress/"><img alt="Justin Briggs: SEO in WordPress" src="http://videos.videopress.com/cvm7bvD7/video-d586dca899_scruberthumbnail_0.jpg" width="160" height="120" /></a></div>";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:31:"Tue, 13 Aug 2013 23:26:31 +0000";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:32:"http://purl.org/dc/elements/1.1/";a:1:{s:7:"creator";a:1:{i:0;a:5:{s:4:"data";s:12:"WordPress.tv";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}i:1;a:6:{s:4:"data";s:13:"
	
	
	
	
	
	
";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:2:{s:0:"";a:5:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:70:"WordPress.tv: Matt Mullenweg: 2012 Q&amp;A from WordCamp San Francisco";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"guid";a:1:{i:0;a:5:{s:4:"data";s:28:"http://wordpress.tv/?p=21284";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:82:"http://wordpress.tv/2013/08/13/matt-mullenweg-2012-qa-from-wordcamp-san-francisco/";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:704:"<div id="v-brloqePf-1" class="video-player">
</div>
<br />  <a rel="nofollow" href="http://feeds.wordpress.com/1.0/gocomments/wptv.wordpress.com/21284/"><img alt="" border="0" src="http://feeds.wordpress.com/1.0/comments/wptv.wordpress.com/21284/" /></a> <img alt="" border="0" src="http://stats.wordpress.com/b.gif?host=wordpress.tv&blog=5089392&post=21284&subd=wptv&ref=&feed=1" width="1" height="1" /><div><a href="http://wordpress.tv/2013/08/13/matt-mullenweg-2012-qa-from-wordcamp-san-francisco/"><img alt="Matt Mullenweg: 2012 Q&A from WordCamp San Francisco" src="http://videos.videopress.com/brloqePf/2012-wordcamp-state-of-the-word-qa-735m_std.original.jpg" width="160" height="120" /></a></div>";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:31:"Tue, 13 Aug 2013 20:49:53 +0000";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:32:"http://purl.org/dc/elements/1.1/";a:1:{s:7:"creator";a:1:{i:0;a:5:{s:4:"data";s:14:"blazestreaming";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}i:2;a:6:{s:4:"data";s:13:"
	
	
	
	
	
	
";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:2:{s:0:"";a:5:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:40:"WordPress.tv: Scott Berkun: Write or Die";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"guid";a:1:{i:0;a:5:{s:4:"data";s:28:"http://wordpress.tv/?p=21204";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:57:"http://wordpress.tv/2013/08/13/scott-berkun-write-or-die/";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:636:"<div id="v-0oXvgg9Y-1" class="video-player">
</div>
<br />  <a rel="nofollow" href="http://feeds.wordpress.com/1.0/gocomments/wptv.wordpress.com/21204/"><img alt="" border="0" src="http://feeds.wordpress.com/1.0/comments/wptv.wordpress.com/21204/" /></a> <img alt="" border="0" src="http://stats.wordpress.com/b.gif?host=wordpress.tv&blog=5089392&post=21204&subd=wptv&ref=&feed=1" width="1" height="1" /><div><a href="http://wordpress.tv/2013/08/13/scott-berkun-write-or-die/"><img alt="Scott Berkun: Write or Die" src="http://videos.videopress.com/0oXvgg9Y/video-6d3e837746_scruberthumbnail_0.jpg" width="160" height="120" /></a></div>";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:31:"Tue, 13 Aug 2013 20:06:25 +0000";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:32:"http://purl.org/dc/elements/1.1/";a:1:{s:7:"creator";a:1:{i:0;a:5:{s:4:"data";s:12:"WordPress.tv";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}i:3;a:6:{s:4:"data";s:13:"
	
	
	
	
	
	
";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:2:{s:0:"";a:5:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:49:"WPTavern: I’ll Be At WordCamp Grand Rapids 2013";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"guid";a:1:{i:0;a:5:{s:4:"data";s:31:"http://www.wptavern.com/?p=8405";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:98:"http://feedproxy.google.com/~r/WordpressTavern/~3/VQP6-QIyoTc/ill-be-at-wordcamp-grand-rapids-2013";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:1844:"<p><a href="http://i2.wp.com/www.wptavern.com/wp-content/uploads/2013/08/WCGrandRapids2013.jpg" rel="thumbnail"><img src="http://i2.wp.com/www.wptavern.com/wp-content/uploads/2013/08/WCGrandRapids2013.jpg?resize=255%2C187" alt="WordCamp Grand Rapids 2013 Logo" class="alignright size-full wp-image-8406" /></a>I&#8217;m happy to announce that I&#8217;ll be in attendance at <a href="http://2013.grandrapids.wordcamp.org/" title="http://2013.grandrapids.wordcamp.org/">WordCamp Grand Rapids 2013</a> next weekend August 24-25th. Not only will I be in attendance, but I&#8217;ve been selected to <a href="http://2013.grandrapids.wordcamp.org/session/qa-panel-commercial-themes-and-plugins/" title="http://2013.grandrapids.wordcamp.org/session/qa-panel-commercial-themes-and-plugins/">moderate a panel discussion</a> on commercial themes and plugins. The other speakers participating in the panel are Pippin Williamson, Adam Pickering, Daniel Espinoza, and Jake Caputo. This is a topic that is right up my alley and I feel like I&#8217;ll be able to ask the right kinds of questions that provide valuable insight to the audience. I&#8217;ll try my best not to make any inside jokes to Jake, considering <a href="http://www.designcrumbs.com/automatically-blackballed" title="http://www.designcrumbs.com/automatically-blackballed">the mess</a> that took place at the beginning of this year. </p>
<p>If you were in my shoes and were going to moderate a panel on Commercial Plugins and Themes, what sort of questions would you ask these individuals? I have a handful already but just curious as to what you&#8217;d ask them? </p>
<p>By the way, there are still tickets available to the event so if you&#8217;re on the fence about it, jump off and go!</p>
<img src="http://feeds.feedburner.com/~r/WordpressTavern/~4/VQP6-QIyoTc" height="1" width="1" />";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:31:"Tue, 13 Aug 2013 17:15:16 +0000";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:32:"http://purl.org/dc/elements/1.1/";a:1:{s:7:"creator";a:1:{i:0;a:5:{s:4:"data";s:6:"Jeffro";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}i:4;a:6:{s:4:"data";s:13:"
	
	
	
	
	
	
";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:2:{s:0:"";a:5:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:55:"WPTavern: WP.com Gets A Trophy Case – Is WP.org Next?";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"guid";a:1:{i:0;a:5:{s:4:"data";s:31:"http://www.wptavern.com/?p=8390";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:102:"http://feedproxy.google.com/~r/WordpressTavern/~3/DpzsJFviGuQ/wp-com-gets-a-trophy-case-is-wp-org-next";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:3959:"<p>Automattic employee Isaac Keyet published an <a href="https://twitter.com/isaackeyet/status/366975655642013696" title="https://twitter.com/isaackeyet/status/366975655642013696">interesting tweet</a> yesterday that showed off a WordPress.com Trophy case that was custom made. The trophy case displays all of your achievements on WordPress.com and looks like the following. </p>
<p><a href="http://i0.wp.com/www.wptavern.com/wp-content/uploads/2013/08/WPTrophyCase.jpg" rel="thumbnail"><img src="http://i0.wp.com/www.wptavern.com/wp-content/uploads/2013/08/WPTrophyCase.jpg?resize=300%2C243" alt="WP Trophy Case" class="aligncenter size-medium wp-image-8391" /></a></p>
<p>I find this to be particularly interesting because I remember Toni Schneider saying in a presentation or in an interview, one in which I can&#8217;t find where he talked about the future of WordPress.com and how they were going to try to gamify certain aspects of the publishing process. Gamify is <a href="http://en.wikipedia.org/wiki/Gamification" title="http://en.wikipedia.org/wiki/Gamification">defined by WikiPedia</a> as: &#8220;<em>Gamification is the use of game thinking and game mechanics in a non-game context to engage users and solve problems. Gamification is used in applications and processes to improve user engagement, Return on Investment, data quality, timeliness, and learning.</em>&#8221; <span id="more-8390"></span></p>
<p>Back in December of 2011, <a href="http://en.blog.wordpress.com/2011/12/12/get-instant-feedback-when-you-publish/" title="http://en.blog.wordpress.com/2011/12/12/get-instant-feedback-when-you-publish/">WordPress.com introduced</a> the first of possibly many enhancements around the gamification concept to encourage users to generate content. As soon as a post is published, the progress bar changes and each time a person publishes 5 posts, they are rewarded with an inspirational quote and the bar resets. </p>
<h2>Cool For WordPress.com But What About WordPress.org?</h2>
<p>I think the concept of having a trophy case showing off achievements is a great idea as well as a motivation factor to continue interacting with WordPress.com. However, I think the opportunities are endless if something like a trophy case was created for the WordPress.org project. Something that shows off badges or rewards for their first patch, their first commit, their first plugin review, so many support forum posts responses, etc. All of this information would then be tied into the WordPress.org profile which would really showcase the user&#8217;s activity across the project. I reached out to Otto of <a href="http://ottopress.com/" title="http://ottopress.com/">Ottopress.com</a> to see not only if this idea has been discussed before, but if some day it could become a reality. Here&#8217;s what he had to say.</p>
<blockquote><p>We&#8217;ve thought about adding badges to the profiles pages for quite sometime, but that&#8217;s one of those things where we need to get profiles themselves working better and collecting more data from all-the-things first. Eventually we&#8217;ll have something like that though. I want to be able to collect enough data to have badges for things like &#8220;attended WordCamp&#8221; and so on.</p></blockquote>
<p>I remember reading a Wired magazine article a few years ago that discussed the topic of everything in life being a game. Add a gaming concept to something and you magically have more engagement to try to earn badges as well as rewards that are meaningless to just about everyone other than the person that earned them. We&#8217;ve seen this work with FourSquare, Reddit, and other popular sites that have a lot of community interaction. I think it would be natural to see the gaming concept be part of the WordPress.org project. It would add a little more fun and spice to the act of contributing. </p>
<img src="http://feeds.feedburner.com/~r/WordpressTavern/~4/DpzsJFviGuQ" height="1" width="1" />";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:31:"Tue, 13 Aug 2013 11:00:58 +0000";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:32:"http://purl.org/dc/elements/1.1/";a:1:{s:7:"creator";a:1:{i:0;a:5:{s:4:"data";s:6:"Jeffro";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}i:5;a:6:{s:4:"data";s:13:"
	
	
	
	
	
	
";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:2:{s:0:"";a:5:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:55:"WordPress.tv: Aaron Hockley: WordPress Writing Workflow";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"guid";a:1:{i:0;a:5:{s:4:"data";s:28:"http://wordpress.tv/?p=21201";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:72:"http://wordpress.tv/2013/08/12/aaron-hockley-wordpress-writing-workflow/";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:660:"<div id="v-bvSUBlt4-1" class="video-player">
</div>
<br />  <a rel="nofollow" href="http://feeds.wordpress.com/1.0/gocomments/wptv.wordpress.com/21201/"><img alt="" border="0" src="http://feeds.wordpress.com/1.0/comments/wptv.wordpress.com/21201/" /></a> <img alt="" border="0" src="http://stats.wordpress.com/b.gif?host=wordpress.tv&blog=5089392&post=21201&subd=wptv&ref=&feed=1" width="1" height="1" /><div><a href="http://wordpress.tv/2013/08/12/aaron-hockley-wordpress-writing-workflow/"><img alt="Aaron Hockley: WordPress Writing Workflow" src="http://videos.videopress.com/bvSUBlt4/video-e79ca6ac24_std.original.jpg" width="160" height="120" /></a></div>";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:31:"Mon, 12 Aug 2013 19:59:40 +0000";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:32:"http://purl.org/dc/elements/1.1/";a:1:{s:7:"creator";a:1:{i:0;a:5:{s:4:"data";s:12:"WordPress.tv";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}i:6;a:6:{s:4:"data";s:13:"
	
	
	
	
	
	
";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:2:{s:0:"";a:5:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:51:"WordPress.tv: Morten Rand-Hendriksen: Why WordPress";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"guid";a:1:{i:0;a:5:{s:4:"data";s:28:"http://wordpress.tv/?p=21191";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:68:"http://wordpress.tv/2013/08/12/morten-rand-hendriksen-why-wordpress/";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:658:"<div id="v-XSCZ4hCo-1" class="video-player">
</div>
<br />  <a rel="nofollow" href="http://feeds.wordpress.com/1.0/gocomments/wptv.wordpress.com/21191/"><img alt="" border="0" src="http://feeds.wordpress.com/1.0/comments/wptv.wordpress.com/21191/" /></a> <img alt="" border="0" src="http://stats.wordpress.com/b.gif?host=wordpress.tv&blog=5089392&post=21191&subd=wptv&ref=&feed=1" width="1" height="1" /><div><a href="http://wordpress.tv/2013/08/12/morten-rand-hendriksen-why-wordpress/"><img alt="Morten Rand-Hendriksen: Why WordPress" src="http://videos.videopress.com/XSCZ4hCo/video-6c148a6723_scruberthumbnail_1.jpg" width="160" height="120" /></a></div>";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:31:"Mon, 12 Aug 2013 18:22:53 +0000";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:32:"http://purl.org/dc/elements/1.1/";a:1:{s:7:"creator";a:1:{i:0;a:5:{s:4:"data";s:12:"WordPress.tv";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}i:7;a:6:{s:4:"data";s:13:"
	
	
	
	
	
	
";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:2:{s:0:"";a:5:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:64:"WPTavern: Revamping The Content Creation Experience In WordPress";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"guid";a:1:{i:0;a:5:{s:4:"data";s:31:"http://www.wptavern.com/?p=8379";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:116:"http://feedproxy.google.com/~r/WordpressTavern/~3/0KgSde8Yifk/revamping-the-content-creation-experience-in-wordpress";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:6295:"<p>In one of the slides for Matt Mullenweg&#8217;s state of the WordPress Presentation at WordCamp San Francisco, there was a concept screenshot of the post writing panel. Some of those concepts can be <a href="http://melchoyce.com/wpadmin-ui/content-editing.html" title="http://melchoyce.com/wpadmin-ui/content-editing.html">viewed here </a> with the discussion surrounding those designs <a href="http://make.wordpress.org/ui/2013/08/08/proposal-improving-the-content-editing-experience/" title="http://make.wordpress.org/ui/2013/08/08/proposal-improving-the-content-editing-experience/">found on the WordPress UI blog</a>. <span id="more-8379"></span></p>
<div id="attachment_8380" class="wp-caption aligncenter"><a href="http://i0.wp.com/www.wptavern.com/wp-content/uploads/2013/08/ContentEditingProposal.png" rel="thumbnail"><img src="http://i2.wp.com/www.wptavern.com/wp-content/uploads/2013/08/ContentEditingProposal.png?resize=500%2C402" alt="ContentEditingProposal" class="size-large wp-image-8380" /></a><p class="wp-caption-text">Proposal To Revamp The Post Writing/Editing Interface</p></div>
<p>There are a number of reasons I&#8217;m excited to see all of this transpire. For starters, the WordPress community is finally getting the chance to reshape the direction of the User Interface. That&#8217;s not to say that developers couldn&#8217;t do that before but by using the P2 site, the commenting section along with being its own separate team, it just seems more inviting to participate versus everything transpiring on core and trac. Also, as far as I can tell,<a href="http://wordpress.org/news/2008/12/coltrane/" title="http://wordpress.org/news/2008/12/coltrane/"> WordPress 2.7 &#8220;Coltrane&#8221;</a> was the last time the post writing/editing panel received any attention.</p>
<p>The post writing screen is my home away from home. It&#8217;s where I spend the majority of my day writing, editing, and managing content. WordPress 2.7 was neat because it added widget functionality all across the board from the dashboard to the post writing screen. Just drag and drop boxes, arranging them in the places that made the most sense for my workflow. I&#8217;m a huge fan of things being modular but the more time I spend within the <strong>Add New Post</strong> screen, the more I want to see widgets disappear and have everything be either 0 or 1 click away. I use a 20 inch monitor and I&#8217;m wearing out my scroll wheel to view the categories widget in the sidebar or one of the widgets I have below the editor. This had me thinking about whether anyone had developed a plugin or alternative editing interface that combined the most used widgets into tabs. For example, the editor already has the <strong>Visual</strong> and <strong>Text</strong> tabs. How hard would it be to add the <strong>Categories</strong> as well as the <strong>Tags</strong> widgets as tabs? I thought it would be a good idea but then I came across the proposed editor by Mel Choyce and hers is so much better than I imagined. </p>
<p><a href="http://i1.wp.com/www.wptavern.com/wp-content/uploads/2013/08/TagsAndCategories.jpg" rel="thumbnail"><img src="http://i1.wp.com/www.wptavern.com/wp-content/uploads/2013/08/TagsAndCategories.jpg?resize=463%2C42" alt="TagsAndCategories" class="aligncenter size-full wp-image-8386" /></a></p>
<p>The most exciting change for me in her redesign is placing the Categories and Tags widget to the bottom border of the post editor. No more having to scroll around. They&#8217;re also in a position that matches my work flow. I generally write <strong>Post Title, Content, Tag it, then Categorize it</strong>. Considering those things are at the bottom of the editor, as well as the Publish button, I&#8217;m loving the looks of this interface already. I&#8217;m also a big fan of the publish button having its own spot versus being tied in with a widget or hidden in a box of options. While it&#8217;s being discussed, I would love to see the need for a Visual/Text tab to disappear. Instead, create the best of both worlds. Not sure if split-screen would be the best approach but I&#8217;d like to add code to one side and see the results as they&#8217;ll be seen by the public on the other while being able to use keyboard shortcuts in the live preview area as I can in the visual editor. Unfortunately, I think I&#8217;ll have to use a plugin to achieve this as I&#8217;m pretty sure this won&#8217;t be coming down the pike any time soon.</p>
<p>As for the content blocks, I&#8217;m not sure I can form an opinion on their use until after I&#8217;ve had a chance to use them in practice. In theory, it sounds like a good idea where each piece of content is a lego block and these content blocks are just other legos you can build on top of one another. </p>
<p><a href="http://i1.wp.com/www.wptavern.com/wp-content/uploads/2013/08/contentblocks.jpg" rel="thumbnail"><img src="http://i1.wp.com/www.wptavern.com/wp-content/uploads/2013/08/contentblocks.jpg?resize=278%2C359" alt="Content Blocks" class="aligncenter size-full wp-image-8385" /></a></p>
<p>The idea to format text after it&#8217;s been highlighted is excellent. The text needs to be highlighted anyways in order to apply formatting so this process enables the formatting bar to get out-of-the-way. Less buttons to see as I&#8217;m writing content. </p>
<p><a href="http://i1.wp.com/www.wptavern.com/wp-content/uploads/2013/08/EditHighlightedText.jpg" rel="thumbnail"><img src="http://i2.wp.com/www.wptavern.com/wp-content/uploads/2013/08/EditHighlightedText.jpg?resize=454%2C128" alt="Editing Highlighted Text" class="aligncenter size-full wp-image-8384" /></a></p>
<h2>Get Involved:</h2>
<p>You are highly encouraged to participate in the <a href="http://make.wordpress.org/ui/2013/08/08/proposal-improving-the-content-editing-experience/" title="http://make.wordpress.org/ui/2013/08/08/proposal-improving-the-content-editing-experience/">conversation on the P2 site</a> where these mockups are located. Overall, I wish I could use Mel&#8217;s first concept image as my Add New Post Screen right now! What do you think about the proposed changes to the content creation screen in WordPress?</p>
<img src="http://feeds.feedburner.com/~r/WordpressTavern/~4/0KgSde8Yifk" height="1" width="1" />";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:31:"Mon, 12 Aug 2013 17:36:50 +0000";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:32:"http://purl.org/dc/elements/1.1/";a:1:{s:7:"creator";a:1:{i:0;a:5:{s:4:"data";s:6:"Jeffro";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}i:8;a:6:{s:4:"data";s:13:"
	
	
	
	
	
	
";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:2:{s:0:"";a:5:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:78:"WordPress.tv: Helen Hou-Sandi: Custom Tailoring the WordPress Admin Experience";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"guid";a:1:{i:0;a:5:{s:4:"data";s:28:"http://wordpress.tv/?p=20974";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:95:"http://wordpress.tv/2013/08/11/helen-hou-sandi-custom-tailoring-the-wordpress-admin-experience/";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:708:"<div id="v-i8XP2O4i-1" class="video-player">
</div>
<br />  <a rel="nofollow" href="http://feeds.wordpress.com/1.0/gocomments/wptv.wordpress.com/20974/"><img alt="" border="0" src="http://feeds.wordpress.com/1.0/comments/wptv.wordpress.com/20974/" /></a> <img alt="" border="0" src="http://stats.wordpress.com/b.gif?host=wordpress.tv&blog=5089392&post=20974&subd=wptv&ref=&feed=1" width="1" height="1" /><div><a href="http://wordpress.tv/2013/08/11/helen-hou-sandi-custom-tailoring-the-wordpress-admin-experience/"><img alt="Helen Hou-Sandi: Custom Tailoring the WordPress Admin Experience" src="http://videos.videopress.com/i8XP2O4i/16-hou-sandi_scruberthumbnail_0.jpg" width="160" height="120" /></a></div>";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:31:"Mon, 12 Aug 2013 04:21:39 +0000";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:32:"http://purl.org/dc/elements/1.1/";a:1:{s:7:"creator";a:1:{i:0;a:5:{s:4:"data";s:12:"WordPress.tv";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}i:9;a:6:{s:4:"data";s:13:"
	
	
	
	
	
	
";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:2:{s:0:"";a:5:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:78:"WordPress.tv: Panel Discussion: Teaming Up: From Freelance to WordPress Agency";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"guid";a:1:{i:0;a:5:{s:4:"data";s:28:"http://wordpress.tv/?p=20975";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:94:"http://wordpress.tv/2013/08/11/panel-discussion-teaming-up-from-freelance-to-wordpress-agency/";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:707:"<div id="v-YZNN7MRr-1" class="video-player">
</div>
<br />  <a rel="nofollow" href="http://feeds.wordpress.com/1.0/gocomments/wptv.wordpress.com/20975/"><img alt="" border="0" src="http://feeds.wordpress.com/1.0/comments/wptv.wordpress.com/20975/" /></a> <img alt="" border="0" src="http://stats.wordpress.com/b.gif?host=wordpress.tv&blog=5089392&post=20975&subd=wptv&ref=&feed=1" width="1" height="1" /><div><a href="http://wordpress.tv/2013/08/11/panel-discussion-teaming-up-from-freelance-to-wordpress-agency/"><img alt="Panel Discussion: Teaming Up: From Freelance to WordPress Agency" src="http://videos.videopress.com/YZNN7MRr/16-mullenweg_scruberthumbnail_0.jpg" width="160" height="120" /></a></div>";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:31:"Sun, 11 Aug 2013 19:30:07 +0000";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:32:"http://purl.org/dc/elements/1.1/";a:1:{s:7:"creator";a:1:{i:0;a:5:{s:4:"data";s:12:"WordPress.tv";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}i:10;a:6:{s:4:"data";s:13:"
	
	
	
	
	
	
";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:2:{s:0:"";a:5:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:60:"WordPress.tv: Andrew Nacin: Current User Can Watch This Talk";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"guid";a:1:{i:0;a:5:{s:4:"data";s:28:"http://wordpress.tv/?p=20991";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:77:"http://wordpress.tv/2013/08/10/andrew-nacin-current-user-can-watch-this-talk/";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:662:"<div id="v-9UMawgAx-1" class="video-player">
</div>
<br />  <a rel="nofollow" href="http://feeds.wordpress.com/1.0/gocomments/wptv.wordpress.com/20991/"><img alt="" border="0" src="http://feeds.wordpress.com/1.0/comments/wptv.wordpress.com/20991/" /></a> <img alt="" border="0" src="http://stats.wordpress.com/b.gif?host=wordpress.tv&blog=5089392&post=20991&subd=wptv&ref=&feed=1" width="1" height="1" /><div><a href="http://wordpress.tv/2013/08/10/andrew-nacin-current-user-can-watch-this-talk/"><img alt="Andrew Nacin: Current User Can Watch This Talk" src="http://videos.videopress.com/9UMawgAx/18-nacin_std.original.jpg" width="160" height="120" /></a></div>";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:31:"Sat, 10 Aug 2013 17:54:05 +0000";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:32:"http://purl.org/dc/elements/1.1/";a:1:{s:7:"creator";a:1:{i:0;a:5:{s:4:"data";s:12:"WordPress.tv";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}i:11;a:6:{s:4:"data";s:13:"
	
	
	
	
	
	
";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:2:{s:0:"";a:5:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:86:"WordPress.tv: Ian Stewart: (What’s So Funny ‘Bout) Themes, Love, and Understanding";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"guid";a:1:{i:0;a:5:{s:4:"data";s:28:"http://wordpress.tv/?p=20994";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:93:"http://wordpress.tv/2013/08/10/ian-stewart-whats-so-funny-bout-themes-love-and-understanding/";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:706:"<div id="v-aejOr6S9-1" class="video-player">
</div>
<br />  <a rel="nofollow" href="http://feeds.wordpress.com/1.0/gocomments/wptv.wordpress.com/20994/"><img alt="" border="0" src="http://feeds.wordpress.com/1.0/comments/wptv.wordpress.com/20994/" /></a> <img alt="" border="0" src="http://stats.wordpress.com/b.gif?host=wordpress.tv&blog=5089392&post=20994&subd=wptv&ref=&feed=1" width="1" height="1" /><div><a href="http://wordpress.tv/2013/08/10/ian-stewart-whats-so-funny-bout-themes-love-and-understanding/"><img alt="Ian Stewart: (What’s So Funny ‘Bout) Themes, Love, and Understanding" src="http://videos.videopress.com/aejOr6S9/09-stewart_std.original.jpg" width="160" height="120" /></a></div>";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:31:"Sat, 10 Aug 2013 17:49:48 +0000";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:32:"http://purl.org/dc/elements/1.1/";a:1:{s:7:"creator";a:1:{i:0;a:5:{s:4:"data";s:12:"WordPress.tv";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}i:12;a:6:{s:4:"data";s:13:"
	
	
	
	
	
	
";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:2:{s:0:"";a:5:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:22:"Matt: Apple’s iWatch";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"guid";a:1:{i:0;a:5:{s:4:"data";s:21:"http://ma.tt/?p=42790";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:35:"http://ma.tt/2013/08/apples-iwatch/";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:198:"<p>Anil Dash has <a href="http://dashes.com/anil/2013/08/a-brief-history-of-apples-iwatch.html">A Brief History of Apple&#8217;s iWatch</a> &#8212; a must-read if you follow tech news like I do.</p>";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:31:"Fri, 09 Aug 2013 23:28:31 +0000";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:32:"http://purl.org/dc/elements/1.1/";a:1:{s:7:"creator";a:1:{i:0;a:5:{s:4:"data";s:4:"Matt";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}i:13;a:6:{s:4:"data";s:13:"
	
	
	
	
	
	
";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:2:{s:0:"";a:5:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:47:"WPTavern: Where Are They Now? – David Peralty";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"guid";a:1:{i:0;a:5:{s:4:"data";s:31:"http://www.wptavern.com/?p=8352";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:94:"http://feedproxy.google.com/~r/WordpressTavern/~3/OOq7ox_npy4/where-are-they-now-david-peralty";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:9770:"<p>David and I have an intertwined past as it relates to WordPress. While I was getting my feet wet writing about the project, David already had a few years of experience writing about WordPress on <a title="http://www.bloggingpro.com/" href="http://www.bloggingpro.com/">BloggingPro</a>. In fact, he has over 130 archived pages dedicated to his name on BloggingPro. Once I started writing about WordPress on WPTavern, David and I would cross each others paths more often until he became my co-host for WordPress Weekly between episodes&nbsp; 41 &#8211; 75. He now publishes his ramblings on <a href="http://peralty.com/" title="http://peralty.com/">Peralty.com</a>. Let&#8217;s find out what he&#8217;s been up to since those days in 2009. <span id="more-8352"></span></p>
<p><a href="http://i1.wp.com/www.wptavern.com/wp-content/uploads/2013/08/Screen-Shot-2013-08-09-at-2.48.14-PM.png" rel="thumbnail"><img src="http://i2.wp.com/www.wptavern.com/wp-content/uploads/2013/08/Screen-Shot-2013-08-09-at-2.48.14-PM.png?resize=402%2C162" alt="Peralty.com Logo" class="aligncenter size-full wp-image-8374" /></a></p>
<p><strong>Long time no talk. Tell me and the audience who you are what it is you&#8217;ve been up to lately?</strong></p>
<p>My name is David Peralty, and I&#8217;m a recovering blogaholic&#8230; The basic summary of who I am, that&#8217;s relevant here, is that I have been using WordPress since 0.72, was a full-time blogger for five years and created a lot of content about WordPress. Some of you might remember me from the WordPress Podcast or WordPress Weekly.<br />
Lately, I have been working for <a title="http://www.rocketgenius.com/" href="http://www.rocketgenius.com/">Rocketgenius</a>, doing this and that for their Gravity Forms project. I&#8217;m currently focused on helping with some basic marketing, tech support and working on a documentation refresh that will also eventually include screencasts.</p>
<p><strong>Why did you join the WPTavern forum way back in 2009?</strong></p>
<p>I had already started losing touch with the WordPress community back in 2009. Things were changing in my career that stopped me from having the time to research and keep up to date with what was happening and who the key players were, and I really disliked that change.</p>
<p>I&#8217;ve always been very passionate about WordPress, and when I started reading the content on WPTavern, I was excited. Here was someone who didn&#8217;t have an agenda. You weren&#8217;t trying to promote your own company, or be sensational just to build traffic. The forums quickly became a place where the &#8220;<em>best of the best</em>&#8221; congregated, and while I never really felt like part of that group, I watched everything happening.</p>
<p><strong>How did the WPTavern community help you progress with WordPress in the past 4 years?</strong></p>
<p>It kept me in the loop. It gave me a place that I knew I could come back to. I recognized a lot of names, and felt like it was a group of people who might just remember some of the contributions I made to the WordPress world. I didn&#8217;t realize it until I was out of the loop how much I would miss the interactions and community.</p>
<p>It wasn&#8217;t long after I joined that I started working for the government and then a private company, both of which were using WordPress, and so having knowledge of powerful plugins and upcoming developments kept me seeming fresh and useful to those organizations.</p>
<p><strong>When co-hosting WordPress Weekly, you couldn&#8217;t stop reading the ad copy for GravityForms. Tell us the story of how you became a RocketGenius employee.</strong></p>
<p>In January of 2012, I went to Cuba with my roommate and his friends. The trip was wonderful, and it wasn&#8217;t too expensive. Upon returning to work, I was brought into a meeting with the company I was working for. They let me know that they had made some business mistakes and that they were going to have to cut their staff in half if they were to survive. I was brought on board a year before that to help them with IT, web development and online marketing, but by the time of the meeting, I had optimized all three. For a staff of 30, I was barely kept busy. With a staff of 15, I was no longer needed. Initially, they told me that I had until the fall of 2012 to find a new job, but two weeks later, I was told that April would be my last month.</p>
<p>Immediately, I was sent into a panic. I e-mailed some people who I knew had strong business connections, as well as some people who ran businesses. I asked if any of them knew of anyone looking to hire. One of those people who I e-mailed was Carl Hancock of Rocketgenius.</p>
<div id="attachment_8375" class="wp-caption aligncenter"><a href="http://i2.wp.com/www.wptavern.com/wp-content/uploads/2013/08/Screen-Shot-2013-08-09-at-2.57.31-PM.png" rel="thumbnail"><img src="http://i1.wp.com/www.wptavern.com/wp-content/uploads/2013/08/Screen-Shot-2013-08-09-at-2.57.31-PM.png?resize=500%2C302" alt="David Peralty Checking Out Gravity Forms" class="size-large wp-image-8375" /></a><p class="wp-caption-text">David Gets His First Look At GravityForms</p></div>
<p>He asked me to send him my résumé and that he&#8217;d pass it around. I had met Carl at WordCamp Chicago 2009 where I got to demo Gravity Forms for the first time. Since that point, I had become one of their biggest fans, as you know. I wrote about it and mentioned it anywhere I could because I saw Gravity Forms as the first application that was connected to WordPress.</p>
<p>Carl contacted me back and offered me a job. They weren&#8217;t really looking to hire anyone, but they felt a connection to me, and my skills were enough that I could be useful to their organization. I&#8217;ve been with them for a little over a year now, and I&#8217;m even more of a fan of their product than I was before. Mostly because in working on the support side of things for the majority of the last year, I&#8217;ve learned more about how flexible and powerful it can be. I also have to say that support is rough.</p>
<p><strong>You&#8217;ve been writing about WordPress far longer than I have. Taking a moment to reflect, what are some of your general observations of the project?</strong></p>
<p>The race to supporting the least tech savvy user has always been a bit of a complaint of mine. I liked that it required some technical acumen to install, update and manage. I miss the days where I had to find ways to update hundreds of blogs using a bash script and reading through the logs it generated.</p>
<p>But the project never would have been as successful under my leadership, and so I&#8217;m glad that it didn&#8217;t fall on me. I think that WordPress&#8217; legacy code is currently its biggest potential downfall, and I hope they take the advice of some people smarter than I and look at releasing two branches for a year or two, one that supports legacy code and one that is a more modern rewrite. I know Matt himself would love to be involved in that. Build an application framework instead of trying to extend blogging software that probably still has some backwards compatible code from ten years ago hidden in it.</p>
<p>Like other pieces of software before them, the &#8220;world&#8221; is now theirs to lose. Some small upstart could become the new popular publishing system in the next 2-5 years if WordPress doesn&#8217;t continue to evolve to meet the needs of consumers, designers and developers.</p>
<p><strong>Back in the WordPress Weekly days, you were my cynical half. Has that changed at all?</strong></p>
<p>To be honest, I played it up a bit for the audience. Being the devil&#8217;s advocate meant that we could discuss things in more detail, and try to see things from all sides. I&#8217;ll admit that I still don&#8217;t like every move the project makes, and I have my more cynical moments, but I don&#8217;t think there are many people who are as big of a fan of WordPress as I am and I&#8217;m grateful to everyone that has ever submitted a line of code, or used the software. If WordPress had failed, my career would have been and would currently be, entirely different.</p>
<div class="aligncenter"><br /><a href="http://www.dailymotion.com/video/x9k7bb_wordcamp-chicago-walkaround-short_tech" target="_blank">WordCamp Chicago Walkaround Short</a> <i>by <a href="http://www.dailymotion.com/jacobsantos" target="_blank">jacobsantos</a></i></div>
<p><strong>Will you be attending any WordCamps in the near future?</strong><br />
I would like to. I am thinking of attending WordCamp Toronto this October. Beyond that, I&#8217;ll probably start looking at the mid 2014 schedule for the eastern seaboard of the U.S. as it starts coming out. Ideally, next year I&#8217;ll try to attend two or three, but I&#8217;m getting married in April 2014, and I want to dedicate my financial resources towards making that a nice event.</p>
<p><strong>Is there anything you’d like to say to the general WordPress Community?</strong></p>
<p>The WordPress community is so vast, and there are so many spectacular people in it, but please try to find and remember the people who helped build the software and community it is today. My biggest hope, since falling into the background, has been to have mattered. That my contribution had an effect.</p>
<p>Oh, and can someone explain to me why there still isn&#8217;t an interface for Custom Post Types as a core element in WordPress? Custom Post Types and Taxonomies are still so confusing to me. I don&#8217;t know why. I sometimes feel like I&#8217;m an old man and just can&#8217;t wrap my brain around these new fangled features.</p>
<img src="http://feeds.feedburner.com/~r/WordpressTavern/~4/OOq7ox_npy4" height="1" width="1" />";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:31:"Fri, 09 Aug 2013 19:20:04 +0000";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:32:"http://purl.org/dc/elements/1.1/";a:1:{s:7:"creator";a:1:{i:0;a:5:{s:4:"data";s:6:"Jeffro";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}i:14;a:6:{s:4:"data";s:13:"
	
	
	
	
	
	
";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:2:{s:0:"";a:5:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:42:"WP Android: Improved Categories Experience";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"guid";a:1:{i:0;a:5:{s:4:"data";s:35:"http://android.wordpress.org/?p=876";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:71:"http://android.wordpress.org/2013/08/09/improved-categories-experience/";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:1420:"<p>Today, we released an update to WordPress for Android that adds some nifty improvements to selecting and adding categories:</p>
<ul>
<li><strong>Removing categories:</strong> you can remove individual categories from a post instead of being forced to clear them out all at once.</li>
<li><strong>Sorted categories:</strong> the category selection view is properly sorted by sub categories.</li>
<li><strong>Adding categories:</strong> a new category will be properly inserted in the category list instead of at the bottom &#8212; and will be selected by default.</li>
</ul>
<p>Here are some screenshots of the new UI:</p>

<a href="http://android.wordpress.org/2013/08/09/improved-categories-experience/categories-edit-post/" title="categories-edit-post"><img /></a>
<a href="http://android.wordpress.org/2013/08/09/improved-categories-experience/categories-select/" title="categories-select"><img /></a>

<h3>What&#8217;s next?</h3>
<p>We&#8217;re getting closer to releasing some big updates, including Media Library support, better Account Setup, and a native WordPress.com Reader.</p>
<p>Any thoughts on the new categories experience? Drop a comment here or follow us <a href="http://twitter.com/wpandroid">@WPAndroid</a> to let us know!</p>
<br />  <img alt="" border="0" src="http://stats.wordpress.com/b.gif?host=android.wordpress.org&blog=9426921&post=876&subd=wpandroid&ref=&feed=1" width="1" height="1" />";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:31:"Fri, 09 Aug 2013 19:01:00 +0000";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:32:"http://purl.org/dc/elements/1.1/";a:1:{s:7:"creator";a:1:{i:0;a:5:{s:4:"data";s:3:"Dan";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}i:15;a:6:{s:4:"data";s:13:"
	
	
	
	
	
	
";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:2:{s:0:"";a:5:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:91:"WordPress.tv: Tammie Lister: Beyond the Default: Explorations and Experiments in BuddyPress";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"guid";a:1:{i:0;a:5:{s:4:"data";s:28:"http://wordpress.tv/?p=20995";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:107:"http://wordpress.tv/2013/08/09/tammie-lister-beyond-the-default-explorations-and-experiments-in-buddypress/";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:730:"<div id="v-XPmVn5d3-1" class="video-player">
</div>
<br />  <a rel="nofollow" href="http://feeds.wordpress.com/1.0/gocomments/wptv.wordpress.com/20995/"><img alt="" border="0" src="http://feeds.wordpress.com/1.0/comments/wptv.wordpress.com/20995/" /></a> <img alt="" border="0" src="http://stats.wordpress.com/b.gif?host=wordpress.tv&blog=5089392&post=20995&subd=wptv&ref=&feed=1" width="1" height="1" /><div><a href="http://wordpress.tv/2013/08/09/tammie-lister-beyond-the-default-explorations-and-experiments-in-buddypress/"><img alt="Tammie Lister: Beyond the Default: Explorations and Experiments in BuddyPress" src="http://videos.videopress.com/XPmVn5d3/01-lister_scruberthumbnail_2.jpg" width="160" height="120" /></a></div>";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:31:"Fri, 09 Aug 2013 16:30:28 +0000";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:32:"http://purl.org/dc/elements/1.1/";a:1:{s:7:"creator";a:1:{i:0;a:5:{s:4:"data";s:12:"WordPress.tv";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}i:16;a:6:{s:4:"data";s:13:"
	
	
	
	
	
	
";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:2:{s:0:"";a:5:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:73:"WordPress.tv: Mike Adams: Three Security Issues You Thought You’d Fixed";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"guid";a:1:{i:0;a:5:{s:4:"data";s:28:"http://wordpress.tv/?p=20971";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:87:"http://wordpress.tv/2013/08/09/mike-adams-three-security-issues-you-thought-youd-fixed/";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:691:"<div id="v-HMXwHIa3-1" class="video-player">
</div>
<br />  <a rel="nofollow" href="http://feeds.wordpress.com/1.0/gocomments/wptv.wordpress.com/20971/"><img alt="" border="0" src="http://feeds.wordpress.com/1.0/comments/wptv.wordpress.com/20971/" /></a> <img alt="" border="0" src="http://stats.wordpress.com/b.gif?host=wordpress.tv&blog=5089392&post=20971&subd=wptv&ref=&feed=1" width="1" height="1" /><div><a href="http://wordpress.tv/2013/08/09/mike-adams-three-security-issues-you-thought-youd-fixed/"><img alt="Mike Adams: Three Security Issues You Thought You’d Fixed" src="http://videos.videopress.com/HMXwHIa3/10-adams_scruberthumbnail_0.jpg" width="160" height="120" /></a></div>";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:31:"Fri, 09 Aug 2013 16:03:33 +0000";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:32:"http://purl.org/dc/elements/1.1/";a:1:{s:7:"creator";a:1:{i:0;a:5:{s:4:"data";s:12:"WordPress.tv";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}i:17;a:6:{s:4:"data";s:13:"
	
	
	
	
	
	
";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:2:{s:0:"";a:5:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:40:"Matt: Automattic’s Remote Work Culture";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"guid";a:1:{i:0;a:5:{s:4:"data";s:21:"http://ma.tt/?p=42788";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:53:"http://ma.tt/2013/08/automattics-remote-work-culture/";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:439:"<p>Business Insider has a fun article on <a href="http://www.businessinsider.com/automattics-awesome-remote-work-culture-2013-8">Automattic&#8217;s Awesome Remote Work Culture</a>. Includes some quotes from me about how we work, including &#8220;Rather than being anti-office, we&#8217;re more location agnostic&#8221; and the top five meetup locations so far (Lisbon, Portugal; Kauai; San Francisco; Amsterdam; Tybee Island, Georgia).</p>";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:31:"Fri, 09 Aug 2013 07:38:11 +0000";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:32:"http://purl.org/dc/elements/1.1/";a:1:{s:7:"creator";a:1:{i:0;a:5:{s:4:"data";s:4:"Matt";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}i:18;a:6:{s:4:"data";s:13:"
	
	
	
	
	
	
";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:2:{s:0:"";a:5:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:52:"WPTavern: Behind The Scenes Of The Collections Theme";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"guid";a:1:{i:0;a:5:{s:4:"data";s:31:"http://www.wptavern.com/?p=8360";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:104:"http://feedproxy.google.com/~r/WordpressTavern/~3/U1loUtDBEuc/behind-the-scenes-of-the-collections-theme";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:8962:"<p>The Theme Foundry recently released a brand new commercial theme into the market called <a title="http://thethemefoundry.com/blog/say-hello-to-collections/" href="http://thethemefoundry.com/wordpress/collections/">Collections</a>. Collections is a beautiful theme that puts all of the focus on the content. I&#8217;m used to seeing themes with a left or right sidebar with widgets in the footer but this theme doesn&#8217;t have those. This theme artfully showcases what&#8217;s possible with using Post Formats. I reached out to The Theme Foundry to see if they could answer a few questions regarding how this theme was conceptualized and built. <span id="more-8360"></span></p>
<p><a href="http://i0.wp.com/www.wptavern.com/wp-content/uploads/2013/08/CollectionsTheme1.jpg" rel="thumbnail"><img class="aligncenter size-full wp-image-8363" alt="Collections Theme Logo" src="http://i0.wp.com/www.wptavern.com/wp-content/uploads/2013/08/CollectionsTheme1.jpg?resize=245%2C129" /></a></p>
<p><strong>Who came up with the initial concept for Collections?</strong></p>
<p><strong>Drew:</strong> Believe it or not, we&#8217;ve been working on this theme on and off for two years. Back in 2011, when I first saw the <a title="https://www.icloud.com/" href="https://www.icloud.com/">iCloud website</a>, I wanted to build a theme with big bold elements to represent post formats. I also wanted it to have that real-time &#8220;application like&#8221; feel. I felt combining these two elements would make for a really special theme.</p>
<p>Around that time, I reached out to <a title="http://veerle.duoh.com/" href="http://veerle.duoh.com/">Veerle Pieters</a>. I knew she would be an awesome fit for this project. She&#8217;s an amazing designer with world-class illustration skills. Her unique talent and vision really brought this theme to life.</p>
<p>We actually started in quite a different direction initially. You can see some of the concepts in the <a title="http://dribbble.com/veerlepieters/projects/35773-The-Theme-Foundry" href="http://dribbble.com/veerlepieters/projects/35773-The-Theme-Foundry">project Veerle posted over on Dribbble</a>. We eventually scrapped the lighter vintage look and went with something darker and bolder. We just didn&#8217;t feel the vintage look was taking it far enough. Scott was instrumental in working with Veerle on the new darker concept, helping her polish the concept into some final mockups.</p>
<p><a href="http://i1.wp.com/www.wptavern.com/wp-content/uploads/2013/08/CollectionsTheme2.jpg" rel="thumbnail"><img class="aligncenter size-large wp-image-8364" alt="CollectionsTheme 2" src="http://i0.wp.com/www.wptavern.com/wp-content/uploads/2013/08/CollectionsTheme2.jpg?resize=500%2C264" /></a></p>
<p><strong>Can you provide more background information into the use of BackboneJS to power the theme versus more traditional methods?</strong></p>
<p><strong>Zack:</strong> From the outset, the goal was to give Collections a &#8220;desktop&#8221; application feel. We wanted fast and smooth page transitions. Using traditional techniques of building pages on the server and pushing them to the browser is inherently slow. <a title="http://backbonejs.org/" href="http://backbonejs.org/">Backbone.js</a> allows you to make a request for JSON data to the server, then render parts of the page using that data along with Javascript templates. This avoids the overhead of loading all of a page&#8217;s assets (e.g., JavaScript files, CSS files, images, etc.), re-painting the page with CSS, and loading boilerplate HTML. You get a nice speed bump with this process.</p>
<p>Backbone is not the only library or framework that provides this functionality. There are a host of other options out there, including <a title="https://github.com/defunkt/jquery-pjax" href="https://github.com/defunkt/jquery-pjax">PJAX</a>, <a title="http://emberjs.com/" href="http://emberjs.com/">Ember.js</a>, and <a title="http://angularjs.org/" href="http://angularjs.org/">AngularJS</a>. So why did we choose Backbone? First of all, Backbone is really flexible. It is a library that lacks a strong opinion. Actually building a theme like this requires mapping a server side application onto a client side application, which we knew would present a number of issues. We wanted a library that would be flexible enough to handle the WordPress requirement, and fortunately, Backbone provided that. Second, because it was included with WordPress 3.5, it is likely that Backbone will become the de facto standard for JavaScript apps within WordPress. By using Backbone, we will benefit from future improvements pushed by WordPress core, as well as benefit from the community that springs up around the technology. In essence, this means that we will be able to build better products for our customers.</p>
<p><strong>From the outside looking in, there are no left or right sidebars. Just content with comments. Was that the whole point of this theme or was that a conscious decision not to include those?</strong></p>
<p><strong>Scott:</strong> Widgets were never in the plans for this theme. Collections is built for sharing and browsing. It had to be visually stunning and unique. It had to feel like an application, not a website. Making a strong decision like this allowed us to focus on achieving that goal<strong>.</strong></p>
<p><strong>Did the decision to yank out the Post Format UI have any consequences on the design of this theme?</strong></p>
<p><strong>Scott:</strong> It was a big deal for us when the Post Format UI was pulled out of core. We were timing this theme to take advantage of the new UI, and believed it would be a great example of Post Formats. The sudden lack of a Post Format UI also made things much more difficult from a development standpoint.</p>
<p>With that being said, it didn&#8217;t impact or change the design at all. We had a strong vision and we&#8217;re determined to make it work with WordPress.</p>
<p><strong>Are you surprised at all by the large positive reaction to the design of this theme?</strong></p>
<p><strong>Drew:</strong> Every time we reviewed Collections as a team, we were struck by it, even after working on it for a long time. If you&#8217;ve been building themes for awhile, you know this sort of thing is rare. You&#8217;re usually sick of looking at a theme by the time you release it. Collections really felt special, but you never know how something will be received. We&#8217;re glad other people in the community feel the same way.</p>
<p><a href="http://i1.wp.com/www.wptavern.com/wp-content/uploads/2013/08/CollectionsTheme3.jpg" rel="thumbnail"><img class="aligncenter size-large wp-image-8365" alt="CollectionTheme3" src="http://i1.wp.com/www.wptavern.com/wp-content/uploads/2013/08/CollectionsTheme3.jpg?resize=500%2C339" /></a></p>
<p><strong>One of the features of this theme is special media handling. What&#8217;s so special about it?</strong></p>
<p><strong>Zack:</strong> Veerle designed Collections to highlight the content of a post format. Instead of lumping all of the content together, Collections aims to highlight the special post format content (e.g., a video in a video post). To do this, we needed to extract the special post format content from the actual content. We used some of the functions that were removed from WordPress core, and added our own techniques for grabbing the content. These techniques make it easier to display the content in a beautiful way (see the <a title="http://demo.thethemefoundry.com/collections-theme/type/audio/" href="http://demo.thethemefoundry.com/collections-theme/type/audio/">audio post format</a>). We also leveraged the new audio ID3 tag support included in WordPress 3.6. If you upload an audio file with artist, song, and cover image information, that is used to display the audio. We are really excited about this!</p>
<p><strong>Anything you can hint us to what&#8217;s coming down the pike?</strong></p>
<p><strong>Drew:</strong> I can&#8217;t share anything specific, but we&#8217;re really excited about the Backbone stuff we explored with this theme. We&#8217;d like to continue down that path and see how we can start using these approaches in all our new themes.</p>
<p>Other than that, we&#8217;re going to stick to our knitting. We&#8217;re focused on taking the time and effort to design and build truly premium quality WordPress themes. We&#8217;ve always valued quality over quantity, and that isn&#8217;t changing anytime soon.</p>
<h2>Want A Copy Of Collections?</h2>
<p>Special thanks to The Theme Foundry team for answering my questions. If you would like a chance at getting a copy of Collections without technical support, just the theme, leave a comment below with what you would like to see these folks tackle with their next WordPress theme. The winner will be chosen at random in a few days. </p>
<img src="http://feeds.feedburner.com/~r/WordpressTavern/~4/U1loUtDBEuc" height="1" width="1" />";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:31:"Thu, 08 Aug 2013 19:20:59 +0000";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:32:"http://purl.org/dc/elements/1.1/";a:1:{s:7:"creator";a:1:{i:0;a:5:{s:4:"data";s:6:"Jeffro";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}i:19;a:6:{s:4:"data";s:13:"
	
	
	
	
	
	
";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:2:{s:0:"";a:5:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:68:"WordPress.tv: Beau Lebens: Taking WordPress to the Front End with O2";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"guid";a:1:{i:0;a:5:{s:4:"data";s:28:"http://wordpress.tv/?p=20964";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:85:"http://wordpress.tv/2013/08/08/beau-lebens-taking-wordpress-to-the-front-end-with-o2/";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:685:"<div id="v-yRkSVGlQ-1" class="video-player">
</div>
<br />  <a rel="nofollow" href="http://feeds.wordpress.com/1.0/gocomments/wptv.wordpress.com/20964/"><img alt="" border="0" src="http://feeds.wordpress.com/1.0/comments/wptv.wordpress.com/20964/" /></a> <img alt="" border="0" src="http://stats.wordpress.com/b.gif?host=wordpress.tv&blog=5089392&post=20964&subd=wptv&ref=&feed=1" width="1" height="1" /><div><a href="http://wordpress.tv/2013/08/08/beau-lebens-taking-wordpress-to-the-front-end-with-o2/"><img alt="Beau Lebens: Taking WordPress to the Front End with O2" src="http://videos.videopress.com/yRkSVGlQ/13-lebens_scruberthumbnail_0.jpg" width="160" height="120" /></a></div>";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:31:"Thu, 08 Aug 2013 15:04:00 +0000";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:32:"http://purl.org/dc/elements/1.1/";a:1:{s:7:"creator";a:1:{i:0;a:5:{s:4:"data";s:12:"WordPress.tv";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}i:20;a:6:{s:4:"data";s:13:"
	
	
	
	
	
	
";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:2:{s:0:"";a:5:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:93:"WordPress.tv: Natalie MacLees: Setting Up Your WordPress Site: Six Stories of Joy and Despair";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"guid";a:1:{i:0;a:5:{s:4:"data";s:28:"http://wordpress.tv/?p=20904";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:109:"http://wordpress.tv/2013/08/08/natalie-maclees-setting-up-your-wordpress-site-six-stories-of-joy-and-despair/";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:735:"<div id="v-uY5AvpGM-1" class="video-player">
</div>
<br />  <a rel="nofollow" href="http://feeds.wordpress.com/1.0/gocomments/wptv.wordpress.com/20904/"><img alt="" border="0" src="http://feeds.wordpress.com/1.0/comments/wptv.wordpress.com/20904/" /></a> <img alt="" border="0" src="http://stats.wordpress.com/b.gif?host=wordpress.tv&blog=5089392&post=20904&subd=wptv&ref=&feed=1" width="1" height="1" /><div><a href="http://wordpress.tv/2013/08/08/natalie-maclees-setting-up-your-wordpress-site-six-stories-of-joy-and-despair/"><img alt="Natalie MacLees: Setting Up Your WordPress Site: Six Stories of Joy and Despair" src="http://videos.videopress.com/uY5AvpGM/03-maclees_scruberthumbnail_0.jpg" width="160" height="120" /></a></div>";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:31:"Thu, 08 Aug 2013 14:04:34 +0000";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:32:"http://purl.org/dc/elements/1.1/";a:1:{s:7:"creator";a:1:{i:0;a:5:{s:4:"data";s:12:"WordPress.tv";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}i:21;a:6:{s:4:"data";s:13:"
	
	
	
	
	
	
";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:2:{s:0:"";a:5:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:59:"WPTavern: A Different Perspective On WordCamp Columbus 2013";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"guid";a:1:{i:0;a:5:{s:4:"data";s:31:"http://www.wptavern.com/?p=8345";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:111:"http://feedproxy.google.com/~r/WordpressTavern/~3/U0N1WEXquhA/a-different-perspective-on-wordcamp-columbus-2013";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:1281:"<p>WordCamp Columbus Ohio 2013 has come and gone but I wanted to <a href="http://www.ez2use.biz/wordcamp-columbus-2013/" title="http://www.ez2use.biz/wordcamp-columbus-2013/">point you to an article</a> highlighting the experience from someone who was in a wheelchair. Her experience comes from a perspective that not all of us share. Thankfully, she had a great experience overall and was delighted to see that the room dedicated to the website accessibility session was filled to capacity, letting her know that it was an important subject on the minds of many.</p>
<blockquote><p>I did not feel lost in the crowd, but instead my individual needs were met. My husband and I are already planning on going next year. If you want to learn how to work with WordPress, I would recommend this conference.  From the perspective of someone with a disability, I felt included.</p></blockquote>
<p>I don&#8217;t know about you but I think it&#8217;s awesome that folks such as Raeanne Woodman can come to a WordCamp event and have such a great experience. I hope all WordCamp events strive to make everyone in attendance feel included instead of excluded. </p>
<div class="aligncenter"></div>
<img src="http://feeds.feedburner.com/~r/WordpressTavern/~4/U0N1WEXquhA" height="1" width="1" />";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:31:"Thu, 08 Aug 2013 11:00:39 +0000";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:32:"http://purl.org/dc/elements/1.1/";a:1:{s:7:"creator";a:1:{i:0;a:5:{s:4:"data";s:6:"Jeffro";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}i:22;a:6:{s:4:"data";s:13:"
	
	
	
	
	
	
";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:2:{s:0:"";a:5:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:56:"WPTavern: ManageWP Has Something Brewing – What Is It?";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"guid";a:1:{i:0;a:5:{s:4:"data";s:31:"http://www.wptavern.com/?p=8342";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:103:"http://feedproxy.google.com/~r/WordpressTavern/~3/cEbeiGuP9sE/managewp-has-something-brewing-what-is-it";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:1279:"<p>I recently stumbled upon a new project that ManageWP is creating called <a href="http://managewp.org/" title="http://managewp.org/">ManageWP.org</a>. There is not a lot of information regarding what the new project will be but judging by the images alone, my best guess would be a responsive, content aggregation website around a specific topic. Which topic that is, I don&#8217;t know. When I reached out to Vladimir Prelovac to see if he could give me any hints as to what the site would be about, the only thing he would tell me is that it would scratch an itch of his. Don&#8217;t all new projects scratch an itch? </p>
<div id="attachment_8343" class="wp-caption aligncenter"><a href="http://i2.wp.com/www.wptavern.com/wp-content/uploads/2013/08/managewporg.jpg" rel="thumbnail"><img src="http://i1.wp.com/www.wptavern.com/wp-content/uploads/2013/08/managewporg.jpg?resize=500%2C338" alt="ManageWP.org Project" class="size-large wp-image-8343" /></a><p class="wp-caption-text">What Could This New Project Be?</p></div>
<p>Let&#8217;s play a guessing game where you comment your best guest on what you think their new project is? Let&#8217;s see who can get the closest. </p>
<img src="http://feeds.feedburner.com/~r/WordpressTavern/~4/cEbeiGuP9sE" height="1" width="1" />";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:31:"Wed, 07 Aug 2013 21:16:04 +0000";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:32:"http://purl.org/dc/elements/1.1/";a:1:{s:7:"creator";a:1:{i:0;a:5:{s:4:"data";s:6:"Jeffro";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}i:23;a:6:{s:4:"data";s:13:"
	
	
	
	
	
	
";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:2:{s:0:"";a:5:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:50:"WPTavern: Plugin Review – Simple Comment Editing";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"guid";a:1:{i:0;a:5:{s:4:"data";s:31:"http://www.wptavern.com/?p=8336";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:98:"http://feedproxy.google.com/~r/WordpressTavern/~3/AfPG1PnIJT0/plugin-review-simple-comment-editing";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:3424:"<p>Long time readers of this website will know that I love everything about the <a href="http://wordpress.org/plugins/wp-ajax-edit-comments/" title="http://wordpress.org/plugins/wp-ajax-edit-comments/">Ajax Edit Comments</a> plugin by Ronald Huereca. In a nutshell, Ajax Edit Comments gave registered and anonymous users the opportunity to edit their own comments within a specific amount of time. The idea was inspired by Digg. Despite the vast array of configuration options AEC provided, Ronald has released a new, simplified version of the same plugin called <a href="http://wordpress.org/plugins/simple-comment-editing/" title="http://wordpress.org/plugins/simple-comment-editing/">Simple Comment Editing</a>. </p>
<div id="attachment_8337" class="wp-caption aligncenter"><a href="http://i2.wp.com/www.wptavern.com/wp-content/uploads/2013/08/SimpleCommentEditing1.jpg" rel="thumbnail"><img src="http://i0.wp.com/www.wptavern.com/wp-content/uploads/2013/08/SimpleCommentEditing1.jpg?resize=500%2C186" alt="Simple Comment Editing 1" class="size-large wp-image-8337" /></a><p class="wp-caption-text">Timer Showing Time Left To Edit Comment</p></div>
<div id="attachment_8338" class="wp-caption aligncenter"><a href="http://i1.wp.com/www.wptavern.com/wp-content/uploads/2013/08/SimpleCommentEditing2.jpg" rel="thumbnail"><img src="http://i1.wp.com/www.wptavern.com/wp-content/uploads/2013/08/SimpleCommentEditing2.jpg?resize=500%2C347" alt="Simple Comment Editing 2" class="size-large wp-image-8338" /></a><p class="wp-caption-text">The Comment Editing Interface</p></div>
<p>With Simple Comment Editing, Ronald has taken a new approach with the WordPress mantra of &#8220;<strong>Decisions, not options</strong>&#8220;. That&#8217;s why if you look around the back-end of WordPress for a link to configure the plugin, you won&#8217;t find it. This plugin contains no styles, performs comment editing inline, and defaults to a time limit of 5 minutes. However, for those that want to override some of the defaults, there are filters for that. </p>
<p>In my initial testing, the plugin performed flawlessly. It&#8217;s much quicker to edit comments inline versus the thickbox popup, it&#8217;s also easier on the eyes. I&#8217;m now torn between using this plugin or the full featured AEC which has some nice features such as <strong>Request Comment Deletion</strong> and a built-in spell checker via <strong>After The Deadline</strong>. While I sometimes hate the decisions, not options line of thinking, it works well in this instance. </p>
<p>So I renew my plea to all WordPress sites that enable commenting to please enable comment editing for anonymous users via the <a href="http://wordpress.org/plugins/simple-comment-editing/" title="http://wordpress.org/plugins/simple-comment-editing/">Simple Comment Editing</a> plugin or by some other means. I know comments should be proof-read before hitting the publish button but that happens less than it should. It&#8217;s incredibly annoying to hit the publish button, find one typo and have no recourse. If you&#8217;d like to contribute to this plugin whether it be patches, bug reports, or translations, you can <a href="https://github.com/ronalfy/simple-comment-editing" title="https://github.com/ronalfy/simple-comment-editing">view the plugin source on GitHub</a>. </p>
<img src="http://feeds.feedburner.com/~r/WordpressTavern/~4/AfPG1PnIJT0" height="1" width="1" />";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:31:"Wed, 07 Aug 2013 16:59:22 +0000";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:32:"http://purl.org/dc/elements/1.1/";a:1:{s:7:"creator";a:1:{i:0;a:5:{s:4:"data";s:6:"Jeffro";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}i:24;a:6:{s:4:"data";s:13:"
	
	
	
	
	
	
";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:2:{s:0:"";a:5:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:88:"WordPress.tv: Grant Landram: Bridging the Chasm: Working with Non-Technical Stakeholders";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"guid";a:1:{i:0;a:5:{s:4:"data";s:28:"http://wordpress.tv/?p=20946";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:104:"http://wordpress.tv/2013/08/07/grant-landram-bridging-the-chasm-working-with-non-technical-stakeholders/";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:725:"<div id="v-1tUgdIaQ-1" class="video-player">
</div>
<br />  <a rel="nofollow" href="http://feeds.wordpress.com/1.0/gocomments/wptv.wordpress.com/20946/"><img alt="" border="0" src="http://feeds.wordpress.com/1.0/comments/wptv.wordpress.com/20946/" /></a> <img alt="" border="0" src="http://stats.wordpress.com/b.gif?host=wordpress.tv&blog=5089392&post=20946&subd=wptv&ref=&feed=1" width="1" height="1" /><div><a href="http://wordpress.tv/2013/08/07/grant-landram-bridging-the-chasm-working-with-non-technical-stakeholders/"><img alt="Grant Landram: Bridging the Chasm: Working with Non-Technical Stakeholders" src="http://videos.videopress.com/1tUgdIaQ/13-landram_scruberthumbnail_0.jpg" width="160" height="120" /></a></div>";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:31:"Wed, 07 Aug 2013 13:57:04 +0000";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:32:"http://purl.org/dc/elements/1.1/";a:1:{s:7:"creator";a:1:{i:0;a:5:{s:4:"data";s:12:"WordPress.tv";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}i:25;a:6:{s:4:"data";s:13:"
	
	
	
	
	
	
";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:2:{s:0:"";a:5:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:34:"Peter Westwood: SSL all the things";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"guid";a:1:{i:0;a:5:{s:4:"data";s:34:"http://westi.wordpress.com/?p=6394";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:57:"http://westi.wordpress.com/2013/08/07/ssl-all-the-things/";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:1406:"<p>Security is important and one of the things I would like to see is if we can enforce a requirement for all requests that core makes back to WordPress.org for updates and information to be https. This is the a great step to a greater level of update verification to help detect man-in-the-middle attacks.</p>
<p>Making this switch is going to be a fun journey and we are bound to find that there are some setups that can&#8217;t/don&#8217;t/won&#8217;t support https with the WP_HTTP API.</p>
<p>So before we try switching to using https in trunk I&#8217;ve update the <a href="http://wordpress.org/plugins/wordpress-beta-tester/">Beta Tester plugin</a> so that it forces all requests to api.wordpress.org to happen over https. I&#8217;ve also updated the api so that if you make a https request it will return https references in the results.</p>
<p>Please go for and test this on your test installs and let us know of any issues you find here in the comments or <a href="http://core.trac.wordpress.org/ticket/18577">on the trac ticket</a>.</p>
<br />  <a rel="nofollow" href="http://feeds.wordpress.com/1.0/gocomments/westi.wordpress.com/6394/"><img alt="" border="0" src="http://feeds.wordpress.com/1.0/comments/westi.wordpress.com/6394/" /></a> <img alt="" border="0" src="http://stats.wordpress.com/b.gif?host=westi.wordpress.com&blog=15396&post=6394&subd=westi&ref=&feed=1" width="1" height="1" />";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:31:"Wed, 07 Aug 2013 13:25:03 +0000";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:32:"http://purl.org/dc/elements/1.1/";a:1:{s:7:"creator";a:1:{i:0;a:5:{s:4:"data";s:14:"Peter Westwood";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}i:26;a:6:{s:4:"data";s:13:"
	
	
	
	
	
	
";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:2:{s:0:"";a:5:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:76:"WordPress.tv: John James Jacoby: Beyond the Blog with BuddyPress and bbPress";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"guid";a:1:{i:0;a:5:{s:4:"data";s:28:"http://wordpress.tv/?p=20955";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:93:"http://wordpress.tv/2013/08/07/john-james-jacoby-beyond-the-blog-with-buddypress-and-bbpress/";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:701:"<div id="v-t2KGj3mQ-1" class="video-player">
</div>
<br />  <a rel="nofollow" href="http://feeds.wordpress.com/1.0/gocomments/wptv.wordpress.com/20955/"><img alt="" border="0" src="http://feeds.wordpress.com/1.0/comments/wptv.wordpress.com/20955/" /></a> <img alt="" border="0" src="http://stats.wordpress.com/b.gif?host=wordpress.tv&blog=5089392&post=20955&subd=wptv&ref=&feed=1" width="1" height="1" /><div><a href="http://wordpress.tv/2013/08/07/john-james-jacoby-beyond-the-blog-with-buddypress-and-bbpress/"><img alt="John James Jacoby: Beyond the Blog with BuddyPress and bbPress" src="http://videos.videopress.com/t2KGj3mQ/15-jacoby_scruberthumbnail_2.jpg" width="160" height="120" /></a></div>";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:31:"Wed, 07 Aug 2013 12:39:27 +0000";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:32:"http://purl.org/dc/elements/1.1/";a:1:{s:7:"creator";a:1:{i:0;a:5:{s:4:"data";s:12:"WordPress.tv";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}i:27;a:6:{s:4:"data";s:13:"
	
	
	
	
	
	
";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:2:{s:0:"";a:5:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:70:"WordPress.tv: Mike Schroder: Magical WordPress Management using WP-CLI";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"guid";a:1:{i:0;a:5:{s:4:"data";s:28:"http://wordpress.tv/?p=20973";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:87:"http://wordpress.tv/2013/08/06/mike-schroder-magical-wordpress-management-using-wp-cli/";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:691:"<div id="v-i5KPNtpI-1" class="video-player">
</div>
<br />  <a rel="nofollow" href="http://feeds.wordpress.com/1.0/gocomments/wptv.wordpress.com/20973/"><img alt="" border="0" src="http://feeds.wordpress.com/1.0/comments/wptv.wordpress.com/20973/" /></a> <img alt="" border="0" src="http://stats.wordpress.com/b.gif?host=wordpress.tv&blog=5089392&post=20973&subd=wptv&ref=&feed=1" width="1" height="1" /><div><a href="http://wordpress.tv/2013/08/06/mike-schroder-magical-wordpress-management-using-wp-cli/"><img alt="Mike Schroder: Magical WordPress Management using WP-CLI" src="http://videos.videopress.com/i5KPNtpI/16-schroder_scruberthumbnail_0.jpg" width="160" height="120" /></a></div>";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:31:"Wed, 07 Aug 2013 04:17:04 +0000";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:32:"http://purl.org/dc/elements/1.1/";a:1:{s:7:"creator";a:1:{i:0;a:5:{s:4:"data";s:12:"WordPress.tv";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}i:28;a:6:{s:4:"data";s:13:"
	
	
	
	
	
	
";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:2:{s:0:"";a:5:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:45:"WPTavern: Mollom – The Akismet Alternative?";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"guid";a:1:{i:0;a:5:{s:4:"data";s:31:"http://www.wptavern.com/?p=8326";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:92:"http://feedproxy.google.com/~r/WordpressTavern/~3/q2YEhlp6_V4/mollom-the-akismet-alternative";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:3223:"<p><a href="http://i0.wp.com/www.wptavern.com/wp-content/uploads/2013/08/Screen-Shot-2013-08-06-at-3.50.46-PM.png" rel="thumbnail"><img src="http://i0.wp.com/www.wptavern.com/wp-content/uploads/2013/08/Screen-Shot-2013-08-06-at-3.50.46-PM.png?resize=300%2C85" alt="Mollom Logo" class="alignright size-medium wp-image-8327" /></a>If we were playing a game of Family Feud and they asked the question, What word comes to mind when you hear about WordPress and Spam? I bet Akismet would be the top answer. However, Akismet is not for everyone. There are alternatives and today, I&#8217;m happy to report that one of those alternatives has a <a href="http://wordpress.org/plugins/mollom/" title="http://wordpress.org/plugins/mollom/">fresh new plugin for WordPress</a> built from the ground up. The service is called <a href="http://mollom.com" title="http://mollom.com">Mollom</a>. Mollom is a service managed by Acquia, a commercial open source software company providing products, services, and technical support for the open source Drupal social publishing system.</p>
<p>The service works in a similar fashion to Akismet in that it scans messages such as comments and determines one of three things. The message is bad, the message is good or sometimes, Mollom is unsure. When Mollom is unsure of a message, it presents a CAPTCHA to the user and if they pass, the comment gets pushed into the moderation queue, if they fail, the message is automatically deleted. Bryan House of Acquia does a better job of explaining the process. </p>
<div class="aligncenter"></div>
<p>The system is built around the Software As a Service concept meaning you can use it on Drupal, WordPress, and more platforms in the future. However, I think one of the coolest features of Mollom is their <a href="http://mollom.com/moderation" title="http://mollom.com/moderation">Content Moderation Platform</a>. Using their CMP, you can moderate multiple websites on different platforms from a single location. </p>
<p>While both <a href="http://akismet.com/plans/" title="http://akismet.com/plans/">Akismet</a> and <a href="http://mollom.com/pricing" title="http://mollom.com/pricing">Mollom</a> offer paid/free plans, Mollom&#8217;s plans are a bit more complicated to make sense of because of the additional features their service provides, such as the Content Moderation Platform. </p>
<p><a href="http://i2.wp.com/www.wptavern.com/wp-content/uploads/2013/08/Screen-Shot-2013-08-06-at-4.26.18-PM.png" rel="thumbnail"><img src="http://i2.wp.com/www.wptavern.com/wp-content/uploads/2013/08/Screen-Shot-2013-08-06-at-4.26.18-PM.png?resize=500%2C95" alt="Mollom Stats" class="aligncenter size-large wp-image-8329" /></a></p>
<p>I&#8217;m going to place the WPTavern site on the free Mollom plan and give the service a test run for a week or two. Once the test is over, I&#8217;ll report back my findings. I&#8217;d love to hear from anyone who is either already running Mollom in place of Akismet or will be joining me in testing out the service on their own site. </p>
<p>By the way, is comment spam synonymous with the colors green, black, and blue?</p>
<img src="http://feeds.feedburner.com/~r/WordpressTavern/~4/q2YEhlp6_V4" height="1" width="1" />";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:31:"Tue, 06 Aug 2013 20:40:09 +0000";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:32:"http://purl.org/dc/elements/1.1/";a:1:{s:7:"creator";a:1:{i:0;a:5:{s:4:"data";s:6:"Jeffro";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}i:29;a:6:{s:4:"data";s:13:"
	
	
	
	
	
	
";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:2:{s:0:"";a:5:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:56:"WordPress.tv: Eric Mann: Automated WordPress Development";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"guid";a:1:{i:0;a:5:{s:4:"data";s:28:"http://wordpress.tv/?p=20968";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:73:"http://wordpress.tv/2013/08/06/eric-mann-automated-wordpress-development/";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:659:"<div id="v-UHoaQs4G-1" class="video-player">
</div>
<br />  <a rel="nofollow" href="http://feeds.wordpress.com/1.0/gocomments/wptv.wordpress.com/20968/"><img alt="" border="0" src="http://feeds.wordpress.com/1.0/comments/wptv.wordpress.com/20968/" /></a> <img alt="" border="0" src="http://stats.wordpress.com/b.gif?host=wordpress.tv&blog=5089392&post=20968&subd=wptv&ref=&feed=1" width="1" height="1" /><div><a href="http://wordpress.tv/2013/08/06/eric-mann-automated-wordpress-development/"><img alt="Eric Mann: Automated WordPress Development" src="http://videos.videopress.com/UHoaQs4G/10-mann_scruberthumbnail_0.jpg" width="160" height="120" /></a></div>";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:31:"Tue, 06 Aug 2013 12:29:46 +0000";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:32:"http://purl.org/dc/elements/1.1/";a:1:{s:7:"creator";a:1:{i:0;a:5:{s:4:"data";s:12:"WordPress.tv";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}i:30;a:6:{s:4:"data";s:13:"
	
	
	
	
	
	
";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:2:{s:0:"";a:5:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:61:"WordPress.tv: Alison Barrett: Lessons Learned in Unit Testing";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"guid";a:1:{i:0;a:5:{s:4:"data";s:28:"http://wordpress.tv/?p=20966";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:78:"http://wordpress.tv/2013/08/05/alison-barrett-lessons-learned-in-unit-testing/";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:672:"<div id="v-RLkLgz2V-1" class="video-player">
</div>
<br />  <a rel="nofollow" href="http://feeds.wordpress.com/1.0/gocomments/wptv.wordpress.com/20966/"><img alt="" border="0" src="http://feeds.wordpress.com/1.0/comments/wptv.wordpress.com/20966/" /></a> <img alt="" border="0" src="http://stats.wordpress.com/b.gif?host=wordpress.tv&blog=5089392&post=20966&subd=wptv&ref=&feed=1" width="1" height="1" /><div><a href="http://wordpress.tv/2013/08/05/alison-barrett-lessons-learned-in-unit-testing/"><img alt="Alison Barrett: Lessons Learned in Unit Testing" src="http://videos.videopress.com/RLkLgz2V/10-barrett_scruberthumbnail_0.jpg" width="160" height="120" /></a></div>";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:31:"Tue, 06 Aug 2013 02:45:30 +0000";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:32:"http://purl.org/dc/elements/1.1/";a:1:{s:7:"creator";a:1:{i:0;a:5:{s:4:"data";s:12:"WordPress.tv";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}i:31;a:6:{s:4:"data";s:13:"
	
	
	
	
	
	
";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:2:{s:0:"";a:5:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:60:"WordPress.tv: Amy Hendrix: WordPress: It’s Made of People!";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"guid";a:1:{i:0;a:5:{s:4:"data";s:28:"http://wordpress.tv/?p=20960";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:72:"http://wordpress.tv/2013/08/05/amy-hendrix-wordpress-its-made-of-people/";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:665:"<div id="v-OETYjmAu-1" class="video-player">
</div>
<br />  <a rel="nofollow" href="http://feeds.wordpress.com/1.0/gocomments/wptv.wordpress.com/20960/"><img alt="" border="0" src="http://feeds.wordpress.com/1.0/comments/wptv.wordpress.com/20960/" /></a> <img alt="" border="0" src="http://stats.wordpress.com/b.gif?host=wordpress.tv&blog=5089392&post=20960&subd=wptv&ref=&feed=1" width="1" height="1" /><div><a href="http://wordpress.tv/2013/08/05/amy-hendrix-wordpress-its-made-of-people/"><img alt="Amy Hendrix: WordPress: It’s Made of People!" src="http://videos.videopress.com/OETYjmAu/20-hendrix_scruberthumbnail_1.jpg" width="160" height="120" /></a></div>";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:31:"Tue, 06 Aug 2013 01:23:25 +0000";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:32:"http://purl.org/dc/elements/1.1/";a:1:{s:7:"creator";a:1:{i:0;a:5:{s:4:"data";s:12:"WordPress.tv";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}i:32;a:6:{s:4:"data";s:13:"
	
	
	
	
	
	
";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:2:{s:0:"";a:5:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:64:"WPTavern: Pods – What Happened After The Kickstarter Campaign?";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"guid";a:1:{i:0;a:5:{s:4:"data";s:31:"http://www.wptavern.com/?p=8248";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:111:"http://feedproxy.google.com/~r/WordpressTavern/~3/M2EQD0UVFBk/pods-what-happened-after-the-kickstarter-campaign";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:11402:"<p><a href="http://i1.wp.com/www.wptavern.com/wp-content/uploads/2013/08/PodslogoDark.jpg" rel="thumbnail"><img src="http://i2.wp.com/www.wptavern.com/wp-content/uploads/2013/08/PodslogoDark.jpg?resize=197%2C77" alt="Pods Logo Dark" class="alignright size-full wp-image-8283" /></a>Recently, two WordPress development companies announced big name hires. The first was <a href="http://jaco.by/2013/07/31/i-dont-know-why-you-say-goodbye-i-say-hello/" title="http://jaco.by/2013/07/31/i-dont-know-why-you-say-goodbye-i-say-hello/">John James Jacoby leaving Automattic</a> to join the <a href="http://10up.com/blog/jjj-joins-10up/" title="http://10up.com/blog/jjj-joins-10up/">WordPress development agency 10UP</a>. The second, <a href="http://webdevstudios.com/2013/08/01/wds-welcomes-scott-kingsley-clark/" title="http://webdevstudios.com/2013/08/01/wds-welcomes-scott-kingsley-clark/">is Scott Kingsley Clark who has been hired by WebDevStudios</a> most widely known throughout the WordPress community as the man behind the popular <a href="http://pods.io/" title="http://pods.io/">Pods Framework</a> plugin. If you remember back in 2011, Scott put together a <a href="http://www.kickstarter.com/projects/sc0ttkclark/pods-development-framework-20" title="http://www.kickstarter.com/projects/sc0ttkclark/pods-development-framework-20">Kickstarter campaign</a> to fund the development of Pods 2.0. While he originally asked for $1,500 he managed to pull in over double that amount with $4,177. I reached out to Scott to not only talk about his new job, but what will be happening to his Pods Plugin. <span id="more-8248"></span></p>
<div id="attachment_8285" class="wp-caption aligncenter"><a href="http://i1.wp.com/www.wptavern.com/wp-content/uploads/2013/08/PodsKickstarter.jpg" rel="thumbnail"><img src="http://i2.wp.com/www.wptavern.com/wp-content/uploads/2013/08/PodsKickstarter.jpg?resize=248%2C300" alt="Pods KIckstarter Campaign" class="size-medium wp-image-8285" /></a><p class="wp-caption-text">Successful Campaign Numbers</p></div>
<p><strong>First off congratulations on being picked up by WDS, a great group of people. My first question is, can you give everyone an update as to what happened after Pods 2.0 was funded via Kickstarter in 2011. What happened to the money, how it was used and did you really meet the goal the campaign was created for?</strong></p>
<p>When I took over the Pods project, I had a lot of lofty goals. At the time, I was working from home doing various contracting gigs, but wanted to spend more time on the Pods project to get it to the next step, which was what Pods 2.0 was envisioned to be. Pods hadn&#8217;t received many donations and it wasn&#8217;t covering all the time I was spending on it, but I still put in 110% on it. For 2.0, one of the goals was revamping the UI entirely, nothing left behind. We needed a better field manager, content creation screen, and ensure it all felt like WordPress itself as much as possible.</p>
<p>There was a few other contributors with me who worked on the project off and on, but what we needed was a professional designer / UI person. We knew the only way to get one was to pay for it, and none of us could afford that sort of investment. I set out to take a few weeks off from my main gigs and commitments to work solely on getting Pods 2.0 out the door.</p>
<p>Unfortunately, I planned it out all wrong. I started as soon as the Kickstarter made its goal, I didn&#8217;t ask for enough cash to cover my time and the designer&#8217;s time, the Amazon/Kickstarter fees took a chunk out, and I had to wait a few weeks after the Kickstarter completed to get the money into my bank account. I found a designer but everyone was busy and couldn&#8217;t start anytime soon. I waited around for a few, but found that they couldn&#8217;t commit enough time to the project to get it to where we needed it in that short of a timeline. Instead of waiting for the right people and paying once, I hopped around a few and paid for the bits of work each did, but nothing concrete came out of it all.</p>
<p>By then it was too late, it was now approaching 2012, I was running out of steam to be able to carry it all on my shoulders again, and all my gigs that brought bread to the table began to pile up and need my attention again. I contacted Matt Mullenweg to get his input on how to grow the project and get more people involved. He was pretty busy, but when he followed up a few weeks later, he was very interested in helping me get back on track. He asked what we needed, I explained that I had been paying people out-of-pocket over time, and even had some developers helping pick up the slack working on monthly installments.</p>
<p><a href="http://i0.wp.com/www.wptavern.com/wp-content/uploads/2013/08/CreateNewPods.jpg" rel="thumbnail"><img src="http://i1.wp.com/www.wptavern.com/wp-content/uploads/2013/08/CreateNewPods.jpg?resize=500%2C239" alt="Create New Pods" class="aligncenter size-large wp-image-8286" /></a></p>
<p>Matt came up with a sponsorship arrangement that took care of the future ongoing costs to get things back on track. And just like that, Matt and Automattic had swooped in and saved the day. Over the next few months we were committing code left and right, I was speaking at WordCamp San Francisco about what I had learned about content types in WordPress, and we had a beta out shortly after.</p>
<p>Since then, we&#8217;ve continued development and have focused on a number of big features for Pods 2.1, 2.2, and 2.3. We&#8217;re currently in development with 2.4 now, with no plans to stop, and we&#8217;re steadily growing our contributor list. We recently launched our <a href="http://pods.io/" title="http://pods.io/">new site</a> with a huge docs section to help make it easier for people to get started with Pods.</p>
<p><strong>During the campaign you had one pledge of $1,000 or more which is the highest pledge available. The reward was to have a feature built into Pods that wasn&#8217;t already on the road map for 2.0. Can you tell us what that feature ended up being?</strong></p>
<p>That was pledged by one of my favorite clients, Gina and Anthony Nieves with MarkNet Group (<a href="http://marknetgroup.com/" title="http://marknetgroup.com/">http://marknetgroup.com/</a>), who graciously didn&#8217;t want anything new, they just wanted to help us continue the project and get Pods 2.0 out the door. I still to this day consider Gina a mentor whom I owe a lot to. I hope one day I can pay it all forward to someone else in a similar situation.</p>
<p><strong>Have you primarily made a living strictly from Pods development or have you worked with companies over the years as a consultant? Why the decision to work for one WordPress development agency?</strong></p>
<p>In the beginning, Pods never really got many donations, even before I took over. We still don&#8217;t get that many donations unfortunately, but Automattic&#8217;s sponsorship helps us keep things gliding forward swiftly and covers our time spent on support and code.</p>
<p>I&#8217;ve worked with a number of companies over the years while developing for Pods, each one has utilized Pods in some way and some have donated my development time towards the project. I even briefly had a trial run at Automattic but the timing was bad because we had just had our first daughter, I was still working a full-time contracting gig at the same time, and I just couldn&#8217;t give it the 100% that it deserved. I was out on my own from about 2009 to 2011, at which point I jumped back into a full-time gig to get insurance coverage for our growing family.</p>
<p>After our second daughter Violet was born in June of this year, I felt all of the memories flood back from when I was out on my own and spending more time with our first daughter Annabelle. That, along with buying our first house and my wife having some unfortunate complications postpartum and being unable to take the full load of watching both daughters, we decided it was time to give it a go again.</p>
<p>This time around, I thought hey, I know some distributed companies are getting really solid now, let me reach out and see if I can find myself the best of both worlds. I contacted Brad and very quickly he responded with enthusiasm. I knew right away after we started talking about how his company operates, the projects it works on, and the team of talented people who I already looked up to, that this was the place for me.</p>
<p><strong>Now that your officially an employee, fans and users want to know what plans if any do you have for the Pods Framework? Will development continue, will it be rolled into a WebDevStudios product or will development cease for a while?</strong></p>
<p>Pods isn&#8217;t going away, not any time soon. Automattic has made it possible for us to keep going full force and improve the project unilaterally. We&#8217;re looking for additional contributors to help with support and other areas, but we&#8217;re doing well with what we&#8217;ve got right now. I was able to take some of my income and the sponsorship funds to put one of our primary contributors into an indefinite monthly retainer. He&#8217;s currently helping improve our documentation, helping out with support, and helping fix bugs / triage our GitHub reports. Our next release will introduce Loop Fields functionality and some other cool stuff, keep an eye out for it!</p>
<p><a href="http://i1.wp.com/www.wptavern.com/wp-content/uploads/2013/08/PodsAutomattic.jpg" rel="thumbnail"><img src="http://i2.wp.com/www.wptavern.com/wp-content/uploads/2013/08/PodsAutomattic.jpg?resize=271%2C93" alt="Pods Automattic" class="aligncenter size-full wp-image-8287" /></a></p>
<p>There hasn&#8217;t been any discussion about rolling Pods into WebDevStudios in any way other than integrating it with their existing products and projects. Anything is possible in the future, but nothing will be done without fully understanding how it impacts Pods in the long-term. My goals that I will <strong>NOT</strong> stray from have remained: <strong>Keep Pods free for all, continue making it easier for people to develop with WordPress, and put any/all funds raised by the project back into it</strong>. In fact, I&#8217;ve been known to do contracting work and just tell them to donate it directly to the <a href="http://podsfoundation.org/donate/" title="http://podsfoundation.org/donate/">Pods Foundation</a>, a company I setup which accepts donations and keeps Pods alive for the long-term.</p>
<h2>How About That</h2>
<p>I want to thank Scott for candidly opening up regarding the troubles he experienced with planning, scheduling, and the allocation of funds after the successful Kickstarter campaign concluded. Until this interview, I was not aware that Matt Mullenweg had anything to do with supporting Scott and the Pods Framework plugin. Scott found himself between a rock and hard place and I think it&#8217;s awesome that after Scott got in touch with Matt, that he stepped up, came to an agreement with Scott and now the plugin along with development is rolling along nicely. I think Scott will be a nice fit for WebDevStudios. It will be interesting to see a couple of WDS client sites utilizing Pods in interesting ways, if they choose to go that route. </p>
<img src="http://feeds.feedburner.com/~r/WordpressTavern/~4/M2EQD0UVFBk" height="1" width="1" />";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:31:"Mon, 05 Aug 2013 23:15:25 +0000";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:32:"http://purl.org/dc/elements/1.1/";a:1:{s:7:"creator";a:1:{i:0;a:5:{s:4:"data";s:6:"Jeffro";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}i:33;a:6:{s:4:"data";s:13:"
	
	
	
	
	
	
";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:2:{s:0:"";a:5:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:28:"BuddyPress: BuddyPress 1.8.1";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"guid";a:1:{i:0;a:5:{s:4:"data";s:31:"http://buddypress.org/?p=169388";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:47:"http://buddypress.org/2013/08/buddypress-1-8-1/";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:1060:"<p>BuddyPress 1.8.1 is now available. This is a maintenance release, which features improved compatibility with WordPress 3.6, as well as fixes for some RSS feeds, the <code>meta_query</code> parameters in the Groups and Activity template loops, and the Groups Extension API. A complete list of closed tickets can be found at <a href="http://buddypress.trac.wordpress.org/query?group=status&milestone=1.8.1">the 1.8.1 milestone</a>, and a full changelog is at <a href="http://codex.buddypress.org/developer/releases/version-1-8-1/">http://codex.buddypress.org/developer/releases/version-1-8-1/</a>.</p>
<p>This is a recommended update for all installations of BuddyPress 1.5+.</p>
<p>Upgrade via your WordPress Dashboard &gt; Updates. You can also download the latest version at <a href="http://wordpress.org/plugins/buddypress/">http://wordpress.org/plugins/buddypress</a>.</p>
<p>Questions or comments? Check out our <a href="http://buddypress.org/support">support community</a> and <a href="http://buddypress.trac.wordpress.org">development tracker</a>.</p>";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:31:"Mon, 05 Aug 2013 20:15:29 +0000";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:32:"http://purl.org/dc/elements/1.1/";a:1:{s:7:"creator";a:1:{i:0;a:5:{s:4:"data";s:12:"Boone Gorges";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}i:34;a:6:{s:4:"data";s:13:"
	
	
	
	
	
	
";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:2:{s:0:"";a:5:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:60:"WPTavern: WordPress 3.8 – Taking The Default Theme Further";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"guid";a:1:{i:0;a:5:{s:4:"data";s:31:"http://www.wptavern.com/?p=8240";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:108:"http://feedproxy.google.com/~r/WordpressTavern/~3/UYjnsnT_u5w/wordpress-3-8-taking-the-default-theme-further";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:6234:"<p>One of the announcements from WordCamp San Francisco was the decision to use <a href="http://furtherdemo.wordpress.com/" title="http://furtherdemo.wordpress.com/">Further</a> as the default theme for WordPress 3.8 dubbed 2014. Since the day I discovered Further, I&#8217;ve been trying to figure out how I could make the theme work for WPTavern.com. The things I like most about it is the layout, the logo in the top left corner, the entire left hand column, and the 4-5 widget footer. Further was originally developed by Takashi Irie. Check out his <a href="http://themeshaper.com/2013/03/05/behind-the-design-of-the-further-theme/" title="http://themeshaper.com/2013/03/05/behind-the-design-of-the-further-theme/">behind the scenes post</a> on how the design came to be. Also, take a look around the ThemeShaper website as it was redesigned with Further.</p>
<p>Some of you may be wondering why the Further theme is not available for purchase on WordPress.com anymore. It&#8217;s officially been retired as it will be offered for free as the default theme in WordPress 3.8. While in San Francisco, I was able to learn that amongst all of the commercial themes available on WordPress.com, Further had the <strong>lowest</strong> refund rate. 2014 will be the first default theme to have a magazine type layout. I reached out to the team dedicated to the 2014 project and Lance Willet had this to say: <span id="more-8240"></span></p>
<p><strong>What are you folks aiming to do with 2014?</strong></p>
<p>The Twenty Fourteen team for 3.8 is me (Lance Willett) plus Konstantin Obenland and Takashi Irie. We&#8217;ll put our &#8220;core hats&#8221; on and keep everyone updated via the <a href="http://make.wordpress.org/core/" title="http://make.wordpress.org/core/">http://make.wordpress.org/core/</a> blog and hold weekly office hours in IRC to coördinate the project; just like Twenty Thirteen development in 3.6.</p>
<p>With Further as a great starting point, we aim to add a few additional features such as an Authors widget and a Contributors page template. Plus many bug fixes or small improvements as they come up during the 3.8 cycle.</p>
<p><strong>Why the decision to use Further and how different will it look from the Further we see today?</strong></p>
<p>Matt Mullenweg picked it with the primary criteria of &#8220;magazine theme&#8221; with a clean design focused on content and reading. We think it&#8217;s a great fit for a default theme because of its fresh design, great use of post formats, and amazing mobile styles.</p>
<p>Not much different. Probably most of the changes will be under the hood — improving the code quality and matching core standards better — and better supporting older browsers and adding various accessibility improvements like ensuring proper color contrast.</p>
<p>That said, any time a theme goes into the crucible of core development, it changes for the better. Looking at each line under a microscope, testing it out in every possible extreme situation. I&#8217;m confident we&#8217;ll all be proud of the result.</p>
<p><strong>How can people contribute to its development?</strong></p>
<p>Nothing to announce officially yet. The leadership team for 3.8, led by Matt, will be posting to the Make Core P2 soon, hopefully next week. At that time we&#8217;ll lay out the details of IRC office hours, checkpoints for keeping tabs on Twenty Fourteen development, and where people can best jump in and help.</p>
<p>For now, interested parties can <a href="http://core.trac.wordpress.org/query?status=accepted&status=assigned&status=new&status=reopened&status=reviewing&component=Bundled+Theme&summary=~Fourteen&group=milestone&col=id&col=summary&col=milestone&col=status&col=owner&col=type&col=priority&order=priority" title="http://core.trac.wordpress.org/query?status=accepted&status=assigned&status=new&status=reopened&status=reviewing&component=Bundled+Theme&summary=~Fourteen&group=milestone&col=id&col=summary&col=milestone&col=status&col=owner&col=type&col=priority&order=priority">bookmark this Trac view</a>: to watch the Twenty Fourteen tickets happen.</p>
<p>Folks can also ping me on Twitter, @<a href="http://twitter.com/simpledream" title="http://twitter.com/simpledream">simpledream</a> — and I&#8217;ll make sure to contact everyone when we&#8217;re ready to dive in.</p>
<h2>My Feedback On Further</h2>
<p>While I love the look and feel of Further, there are a couple of things that really turn me off. The first is the use of incredibly large featured images for blog posts. With the type of content this site produces, routinely finding images 600px and wider related to WP would be a challenge. I also don&#8217;t like the pattern image that is shown for posts that don&#8217;t use the featured image. Also, if you use a featured image that doesn&#8217;t fill that area, you see the image plus the pattern which is ugly. This is something that will be addressed in 2014. While the entire site is aligned to the left part of the screen, I can&#8217;t help but feel that the space on the right side of the screen is wasted and could be used for something else, such as a sidebar. However, I think the best use of this space would be to increase the width dedicated to the content section of the site. Also, it would be cool to see the entire site be responsive so that no matter what size screen the page is displayed on, it makes use of all available space. </p>
<p><a href="http://i2.wp.com/www.wptavern.com/wp-content/uploads/2013/08/FurtherFeaturedImages.jpg" rel="thumbnail"><img src="http://i2.wp.com/www.wptavern.com/wp-content/uploads/2013/08/FurtherFeaturedImages.jpg?resize=500%2C381" alt="Featured Image In Further" class="aligncenter size-large wp-image-8275" /></a></p>
<p>I love how it has pull quotes built-in and the right-hand sidebar takes care of content published with post formats. I&#8217;m excited to see what becomes of 2014 and how the general user base will manipulate the design. What are your thoughts on the use of Further as the default them in WordPress 3.8? What are some ideas or enhancements you would like to see incorporated? </p>
<img src="http://feeds.feedburner.com/~r/WordpressTavern/~4/UYjnsnT_u5w" height="1" width="1" />";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:31:"Mon, 05 Aug 2013 19:45:30 +0000";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:32:"http://purl.org/dc/elements/1.1/";a:1:{s:7:"creator";a:1:{i:0;a:5:{s:4:"data";s:6:"Jeffro";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}i:35;a:6:{s:4:"data";s:13:"
	
	
	
	
	
	
";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:2:{s:0:"";a:5:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:80:"WPTavern: The Daily Plugin “Power Stacks” – My Shortcodes with Random Text";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"guid";a:1:{i:0;a:5:{s:4:"data";s:31:"http://www.wptavern.com/?p=8096";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:122:"http://feedproxy.google.com/~r/WordpressTavern/~3/MpM3cwX5Udk/the-daily-plugin-power-stacks-my-shortcodes-with-random-text";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:9508:"<p>Today I am going to start what I hope is a semi-regularly occurring feature segment of The Daily Plugin series called &#8220;<em>Plugin Power Stacks</em>&#8221; where I will show a &#8220;<em>Trick</em>&#8221; or &#8220;<em>Hack</em>&#8221; for a few plugins that work together to get some added functionality out of your WordPress installation, whether that be in content creation, administration or user interaction. Today&#8217;s installment involves solving the two common problems when dealing with content that changes frequently or is date dependent, even if it&#8217;s just a sentence. <span id="more-8096"></span></p>
<p>If there are two things that I use frequently in my &#8220;<em>campaign-based</em>&#8221; sites it&#8217;s the ability to create my own shortcodes, and the ability to pull content or keywords at random as if I were to draw a name out of a hat, or as complex as 20 different products that people could buy, with full HTML code cycling at random and embedded with a single shortcode. Here are two plugins that I found to be absolutely <strong>DEADLY</strong> when power stacked together. I know there are many more possibilities and I hope those that read this will share their own 1-2 punch combos that you use as well.</p>
<p>Here&#8217;s today&#8217;s WordPress Plugin Tag Team of Doom: <strong>Random Text and My Shortcodes.</strong></p>
<div id="attachment_8174" class="wp-caption alignleft"><a href="http://profiles.wordpress.org/pantsonhead/"><img class=" wp-image-8174  " alt="Wordpress Developer PantsOnHead." src="http://i0.wp.com/www.wptavern.com/wp-content/uploads/2013/07/pantsonhead.jpeg?resize=90%2C90" /></a><p class="wp-caption-text"><a title="PantsOnHead" href="http://profiles.wordpress.org/pantsonhead/" target="_blank"><strong>PantsOnHead</strong></a></p></div>
<p><a title="Random Text WordPress Plugin" href="http://wordpress.org/plugins/randomtext/" target="_blank">Random Text</a> is from a developer named &#8220;PantsOnHead&#8221; from New Zealand. I&#8217;m not kidding. That&#8217;s the man&#8217;s name. But he might want to change that soon, because this plugin is killer and he needs to be recognized! This is one of the more colorful of profile images that I&#8217;ve seen in a while, so I just had to share. This plugin allows you to create random blocks of text or HTML that are called up by shortcode. You can add them based on their own unique category. For example, if I want to add a list of colors that I&#8217;d like to display at random, I can do it in a few different ways.</p>
<p><a href="http://i1.wp.com/www.wptavern.com/wp-content/uploads/2013/08/randomtext1-bulkinsert.png" rel="thumbnail"><img class="alignleft size-thumbnail wp-image-8262" alt="Random Text Plugin - Bulk Insert" src="http://i0.wp.com/www.wptavern.com/wp-content/uploads/2013/08/randomtext1-bulkinsert.png?resize=150%2C150" /></a>First I can add a list of brands one line at a time and select &#8220;<em>bulk add</em>&#8220;. Bulk add allows you to line delimit your entries and add a massive list all at once. As long as there is a hard-line break in what you are pasting, it will add in mass. This could include full HTML code with embedded images and links, or a full paragraph. It knows when to delimit the import when it detects a return to the next line. Another way to add content is one at a time, allowing for full pages and/or code inserts to come up at random based on a shortcode. I like to consider the categories as <strong>buckets</strong> from which to pull from in future posts.</p>
<p>Examples of some of the other basic content types I&#8217;ve also loaded into categories could include a &#8220;bucket&#8221; of first names that are gender specific, city names, pet names or even simple banner codes to display. On the more advanced end, you can include fully blown scripts for displaying just about anything you want at random. The shortcode is used by evoking something like [randomtext category="colors"] which would display the item in order of the list, whereas a shortcode callout like [randomtext category="colors" random="1"] would display the same list, but in random order. The real limitations that I found were when I needed to insert random items that needed to be included in quotes, such as alt tags or titles, the plugin had problems getting things lined up exactly as planned.</p>
<p>With that issue in mind, we now move to a solution in the plugin titled <strong><a title="My Shortcodes" href="http://wordpress.org/plugins/my-shortcodes/" target="_blank">My Shortcodes</a></strong> by <a title="David Cramer WordPress Profile" href="http://profiles.wordpress.org/desertsnowman/" target="_blank">David Cramer</a>. This plugin is very complex, and can even be used to <strong>output OTHER PLUGINS</strong> in the Pro version, but more on that later. Though I only used it in a limited way, My Shortcodes allows you to create amazing shortcodes of your own creation. This includes using other shortcodes within it&#8217;s code, which is the solution to our particular problem with Random Text.</p>
<p>Before I merged this particular plugin with Random Text, I used to use it to help with updating content that was date dependent. The first of every month I simply modify one shortcode that I created to reflect the current month. So in my content, I can simply use something like &#8220;This deal is good throughout the month of [month], [year] and well into [next-month] as well.&#8221; Instead of having to edit a hundred old posts to remain relevant, I can simply change the value of what [month] represents to reflect the current month.</p>
<p>This plugin is meant to be a fire-breathing dragon right out of the gate. With it you can create custom shortcode elements or even download and install shortcodes made by other My Shortcodes users. It features areas for HTML/text entry, java script input, custom PHP libraries, external/CDN css and java script sources. Talk about loaded with plenty of firepower! You create anything you need in any format, name a shortcode of your own choosing, and it works!</p>
<p>Returning to the combo with Random Text. What we are now able to do is add the previous shortcode of [randomtext category="colors" random="1"] and just use [color] instead. Nothing fancy there. But imagine when you have proper short codes and random text setup so you can create a fully css integrated panel with a background set to your chosen random color, and a buy button of the same shade. Or even a cycling of images with affiliate links embedded in them that display completely formatted. In my case, I use it in a simple form of &#8220;Choose from top brands like [store-topbrand],&nbsp;[store-topbrand] and&nbsp;[store-topbrand]&#8221; and it would output the top brands at random. If I chose to use an HTML coded link with proper description attributes, I could also use that in the &#8220;top brand&#8221; designator and it would like to the brand pages.</p>
<p>In the advanced text manipulation end, I use My Shortcodes to embed a sponsor block at the end of my show notes in my music podcast. Every one of the 13 sponsors that I have has random text content, from how I call something a &#8220;coupon&#8221; or &#8220;promo code&#8221; at random to the anchor text that is used to drive traffic to another page on my site. I start on the sentence level, then work to the whole paragraph. What can be randomized and pulled from the &#8220;bucket&#8221; is included as long as it makes sense. I can stuff one shortcode from Random Text into My Shortcodes and go back and forth again. Once the paragraph is finished with all the Random Text shortcodes woven in, I then create a single shortcode for the whole &#8220;block&#8221;.</p>
<p>Now, when I want to insert the entire sponsor block in my show notes, I simply insert [sponsor1-block] and the entire formatted paragraph is perfectly placed in line. It gets even deeper. If I add each one of my sponsor blocks back into Random Text, I can then create a shortcode that displays only one of my sponsors at a time, at random. Another benefit to this method is that if an affiliate link changes, I simply have to change it in one line in the admin panel and it&#8217;s fixed throughout.</p>
<p>I know that I cannot do the My Shortcodes proper justice as far as describing its full potential, but I can tell you that it allows me to create a lot of shortcuts for things that I normally would have to create a lot of content for, or around. It allows me to split test on a massive scale, and change things on the back-end with seamless integration. In its most advanced form though, it allows you to create actual plugins from the My Shortcode system, where you can create your own custom plugins based on the data that is output. Very cool indeed.</p>
<p>If you happen to use either of the plugins suggested today, please consider making a nice contribution to them in any way you can. They have created some really great, functional plugins that completely expand how you think about creating your content.</p>
<p>I am interested in the feedback of others out there about their own plugin &#8220;stacking&#8221;. Sometimes, just one plugin won&#8217;t get you &#8220;across the bridge&#8221; and you simply need two to get you there. It&#8217;s often tough to think of these power combos until a need arises, so the more we share, the more we learn.</p>
<img src="http://feeds.feedburner.com/~r/WordpressTavern/~4/MpM3cwX5Udk" height="1" width="1" />";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:31:"Mon, 05 Aug 2013 17:54:27 +0000";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:32:"http://purl.org/dc/elements/1.1/";a:1:{s:7:"creator";a:1:{i:0;a:5:{s:4:"data";s:12:"Marcus Couch";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}i:36;a:6:{s:4:"data";s:13:"
	
	
	
	
	
	
";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:2:{s:0:"";a:5:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:33:"Matt: Public-Private Surveillance";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"guid";a:1:{i:0;a:5:{s:4:"data";s:21:"http://ma.tt/?p=42785";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:49:"http://ma.tt/2013/08/public-private-surveillance/";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:205:"<p>Bruce Schneier on <a href="http://www.bloomberg.com/news/2013-07-31/the-public-private-surveillance-partnership.html">The Public-Private Surveillance Partnership</a>. Packed with good links as well.</p>";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:31:"Mon, 05 Aug 2013 04:15:20 +0000";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:32:"http://purl.org/dc/elements/1.1/";a:1:{s:7:"creator";a:1:{i:0;a:5:{s:4:"data";s:4:"Matt";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}i:37;a:6:{s:4:"data";s:13:"
	
	
	
	
	
	
";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:2:{s:0:"";a:5:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:76:"WordPress.tv: Will Norris: How WordPress Helped Me Learn Android Development";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"guid";a:1:{i:0;a:5:{s:4:"data";s:28:"http://wordpress.tv/?p=20956";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:93:"http://wordpress.tv/2013/08/04/will-norris-how-wordpress-helped-me-learn-android-development/";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:701:"<div id="v-tofd7POO-1" class="video-player">
</div>
<br />  <a rel="nofollow" href="http://feeds.wordpress.com/1.0/gocomments/wptv.wordpress.com/20956/"><img alt="" border="0" src="http://feeds.wordpress.com/1.0/comments/wptv.wordpress.com/20956/" /></a> <img alt="" border="0" src="http://stats.wordpress.com/b.gif?host=wordpress.tv&blog=5089392&post=20956&subd=wptv&ref=&feed=1" width="1" height="1" /><div><a href="http://wordpress.tv/2013/08/04/will-norris-how-wordpress-helped-me-learn-android-development/"><img alt="Will Norris: How WordPress Helped Me Learn Android Development" src="http://videos.videopress.com/tofd7POO/15-norris_scruberthumbnail_0.jpg" width="160" height="120" /></a></div>";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:31:"Sun, 04 Aug 2013 19:46:24 +0000";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:32:"http://purl.org/dc/elements/1.1/";a:1:{s:7:"creator";a:1:{i:0;a:5:{s:4:"data";s:12:"WordPress.tv";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}i:38;a:6:{s:4:"data";s:13:"
	
	
	
	
	
	
";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:2:{s:0:"";a:5:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:56:"WordPress.tv: Carrie Dils: Collaboration Not Competition";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"guid";a:1:{i:0;a:5:{s:4:"data";s:28:"http://wordpress.tv/?p=20949";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:73:"http://wordpress.tv/2013/08/04/carrie-dils-collaboration-not-competition/";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:659:"<div id="v-O7w8ZJEz-1" class="video-player">
</div>
<br />  <a rel="nofollow" href="http://feeds.wordpress.com/1.0/gocomments/wptv.wordpress.com/20949/"><img alt="" border="0" src="http://feeds.wordpress.com/1.0/comments/wptv.wordpress.com/20949/" /></a> <img alt="" border="0" src="http://stats.wordpress.com/b.gif?host=wordpress.tv&blog=5089392&post=20949&subd=wptv&ref=&feed=1" width="1" height="1" /><div><a href="http://wordpress.tv/2013/08/04/carrie-dils-collaboration-not-competition/"><img alt="Carrie Dils: Collaboration Not Competition" src="http://videos.videopress.com/O7w8ZJEz/15-dils_scruberthumbnail_0.jpg" width="160" height="120" /></a></div>";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:31:"Sun, 04 Aug 2013 18:54:57 +0000";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:32:"http://purl.org/dc/elements/1.1/";a:1:{s:7:"creator";a:1:{i:0;a:5:{s:4:"data";s:12:"WordPress.tv";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}i:39;a:6:{s:4:"data";s:13:"
	
	
	
	
	
	
";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:2:{s:0:"";a:5:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:75:"WordPress.tv: Michele Mizejewski: Positive User Experience: The Power of P2";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"guid";a:1:{i:0;a:5:{s:4:"data";s:28:"http://wordpress.tv/?p=20945";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:91:"http://wordpress.tv/2013/08/03/michele-mizejewski-positive-user-experience-the-power-of-p2/";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:702:"<div id="v-GL9TlPmc-1" class="video-player">
</div>
<br />  <a rel="nofollow" href="http://feeds.wordpress.com/1.0/gocomments/wptv.wordpress.com/20945/"><img alt="" border="0" src="http://feeds.wordpress.com/1.0/comments/wptv.wordpress.com/20945/" /></a> <img alt="" border="0" src="http://stats.wordpress.com/b.gif?host=wordpress.tv&blog=5089392&post=20945&subd=wptv&ref=&feed=1" width="1" height="1" /><div><a href="http://wordpress.tv/2013/08/03/michele-mizejewski-positive-user-experience-the-power-of-p2/"><img alt="Michele Mizejewski: Positive User Experience: The Power of P2" src="http://videos.videopress.com/GL9TlPmc/13-mizejewski_scruberthumbnail_3.jpg" width="160" height="120" /></a></div>";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:31:"Sat, 03 Aug 2013 17:50:35 +0000";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:32:"http://purl.org/dc/elements/1.1/";a:1:{s:7:"creator";a:1:{i:0;a:5:{s:4:"data";s:12:"WordPress.tv";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}i:40;a:6:{s:4:"data";s:13:"
	
	
	
	
	
	
";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:2:{s:0:"";a:5:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:86:"WordPress.tv: Shannon Smith: Big in Japan: A Guide for Themes and Internationalization";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"guid";a:1:{i:0;a:5:{s:4:"data";s:28:"http://wordpress.tv/?p=20944";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:102:"http://wordpress.tv/2013/08/03/shannon-smith-big-in-japan-a-guide-for-themes-and-internationalization/";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:719:"<div id="v-vztxAnwc-1" class="video-player">
</div>
<br />  <a rel="nofollow" href="http://feeds.wordpress.com/1.0/gocomments/wptv.wordpress.com/20944/"><img alt="" border="0" src="http://feeds.wordpress.com/1.0/comments/wptv.wordpress.com/20944/" /></a> <img alt="" border="0" src="http://stats.wordpress.com/b.gif?host=wordpress.tv&blog=5089392&post=20944&subd=wptv&ref=&feed=1" width="1" height="1" /><div><a href="http://wordpress.tv/2013/08/03/shannon-smith-big-in-japan-a-guide-for-themes-and-internationalization/"><img alt="Shannon Smith: Big in Japan: A Guide for Themes and Internationalization" src="http://videos.videopress.com/vztxAnwc/09-smith_scruberthumbnail_1.jpg" width="160" height="120" /></a></div>";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:31:"Sat, 03 Aug 2013 17:37:31 +0000";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:32:"http://purl.org/dc/elements/1.1/";a:1:{s:7:"creator";a:1:{i:0;a:5:{s:4:"data";s:12:"WordPress.tv";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}i:41;a:6:{s:4:"data";s:13:"
	
	
	
	
	
	
";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:2:{s:0:"";a:5:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:65:"WordPress.tv: Jerry Bates: How to Create a Custom Navigation Menu";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"guid";a:1:{i:0;a:5:{s:4:"data";s:28:"http://wordpress.tv/?p=18647";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:82:"http://wordpress.tv/2013/08/03/jerry-bates-how-to-create-a-custom-navigation-menu/";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:680:"<div id="v-zxSQ51fp-1" class="video-player">
</div>
<br />  <a rel="nofollow" href="http://feeds.wordpress.com/1.0/gocomments/wptv.wordpress.com/18647/"><img alt="" border="0" src="http://feeds.wordpress.com/1.0/comments/wptv.wordpress.com/18647/" /></a> <img alt="" border="0" src="http://stats.wordpress.com/b.gif?host=wordpress.tv&blog=5089392&post=18647&subd=wptv&ref=&feed=1" width="1" height="1" /><div><a href="http://wordpress.tv/2013/08/03/jerry-bates-how-to-create-a-custom-navigation-menu/"><img alt="Jerry Bates: How to Create a Custom Navigation Menu" src="http://videos.videopress.com/zxSQ51fp/video-e64c00e11a_std.original.jpg" width="160" height="120" /></a></div>";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:31:"Sat, 03 Aug 2013 12:49:39 +0000";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:32:"http://purl.org/dc/elements/1.1/";a:1:{s:7:"creator";a:1:{i:0;a:5:{s:4:"data";s:12:"WordPress.tv";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}i:42;a:6:{s:4:"data";s:13:"
	
	
	
	
	
	
";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:2:{s:0:"";a:5:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:31:"Matt: WordCamp SF Jazz Playlist";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"guid";a:1:{i:0;a:5:{s:4:"data";s:21:"http://ma.tt/?p=42782";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:40:"http://ma.tt/2013/08/wcsf-jazz-playlist/";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:356:"<p>A lot of people have been asking about the playlist from <a href="http://sf.wordcamp.org/">WordCamp San Francisco</a> last weekend, and thanks to some help from Rose here it is:</p>
<p></p>
<p>If you want to subscribe to it (or my other playlists on Spotify) I&#8217;ll be updating a bit throughout the year so we can have something fresh come 2014.</p>";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:31:"Fri, 02 Aug 2013 22:18:14 +0000";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:32:"http://purl.org/dc/elements/1.1/";a:1:{s:7:"creator";a:1:{i:0;a:5:{s:4:"data";s:4:"Matt";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}i:43;a:6:{s:4:"data";s:13:"
	
	
	
	
	
	
";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:2:{s:0:"";a:5:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:45:"Akismet: Akismet 2.5.9 Released for WordPress";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"guid";a:1:{i:0;a:5:{s:4:"data";s:31:"http://blog.akismet.com/?p=1034";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:72:"http://blog.akismet.com/2013/08/02/akismet-2-5-9-released-for-wordpress/";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:1289:"<p>In case you haven&#8217;t noticed from within your WordPress dashboard, <strong>Akismet 2.5.9</strong> is now available. It introduces the following very minor fixes:</p>
<ul>
<li>Update the &#8216;Already have a key&#8217; link to a redirect page rather than depend on Javascript (within the activation flow)</li>
<li>Fix some non-translatable strings to be translatable</li>
<li>Update activation banner on &#8216;Plugins&#8217; page to redirect user to the Akismet configuration page</li>
</ul>
<p>You won&#8217;t notice much of a difference, but please make sure that you update to the latest version. If you experience any problems with the upgrade, please don&#8217;t hesitate to <a href="http://akismet.com/contact/">get in touch</a> with our team.</p>
<p>And don&#8217;t forget &#8211; <a href="http://wordpress.org/news/2013/08/oscar/">WordPress 3.6 &#8220;Oscar&#8221;</a> is also now available!</p>
<p>Cheers!</p>
<br />  <a rel="nofollow" href="http://feeds.wordpress.com/1.0/gocomments/akismet.wordpress.com/1034/"><img alt="" border="0" src="http://feeds.wordpress.com/1.0/comments/akismet.wordpress.com/1034/" /></a> <img alt="" border="0" src="http://stats.wordpress.com/b.gif?host=blog.akismet.com&blog=116920&post=1034&subd=akismet&ref=&feed=1" width="1" height="1" />";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:31:"Fri, 02 Aug 2013 18:30:10 +0000";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:32:"http://purl.org/dc/elements/1.1/";a:1:{s:7:"creator";a:1:{i:0;a:5:{s:4:"data";s:7:"Anthony";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}i:44;a:6:{s:4:"data";s:13:"
	
	
	
	
	
	
";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:2:{s:0:"";a:5:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:87:"WordPress.tv: Josh Broton: Sticks, Spit &amp; Duct Tape: Advanced RWD Layout Techniques";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"guid";a:1:{i:0;a:5:{s:4:"data";s:28:"http://wordpress.tv/?p=20943";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:96:"http://wordpress.tv/2013/08/02/josh-broton-sticks-spit-duct-tape-advanced-rwd-layout-techniques/";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:711:"<div id="v-hj1mAGnL-1" class="video-player">
</div>
<br />  <a rel="nofollow" href="http://feeds.wordpress.com/1.0/gocomments/wptv.wordpress.com/20943/"><img alt="" border="0" src="http://feeds.wordpress.com/1.0/comments/wptv.wordpress.com/20943/" /></a> <img alt="" border="0" src="http://stats.wordpress.com/b.gif?host=wordpress.tv&blog=5089392&post=20943&subd=wptv&ref=&feed=1" width="1" height="1" /><div><a href="http://wordpress.tv/2013/08/02/josh-broton-sticks-spit-duct-tape-advanced-rwd-layout-techniques/"><img alt="Josh Broton: Sticks, Spit & Duct Tape: Advanced RWD Layout Techniques" src="http://videos.videopress.com/hj1mAGnL/09-broton_scruberthumbnail_1.jpg" width="160" height="120" /></a></div>";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:31:"Fri, 02 Aug 2013 15:36:52 +0000";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:32:"http://purl.org/dc/elements/1.1/";a:1:{s:7:"creator";a:1:{i:0;a:5:{s:4:"data";s:12:"WordPress.tv";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}i:45;a:6:{s:4:"data";s:13:"
	
	
	
	
	
	
";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:2:{s:0:"";a:5:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:71:"WordPress.tv: Stephanie Leary: Content Strategy: WordPress Case Studies";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"guid";a:1:{i:0;a:5:{s:4:"data";s:28:"http://wordpress.tv/?p=20909";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:87:"http://wordpress.tv/2013/08/02/stephanie-leary-content-strategy-wordpress-case-studies/";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:689:"<div id="v-ZFNDLrK4-1" class="video-player">
</div>
<br />  <a rel="nofollow" href="http://feeds.wordpress.com/1.0/gocomments/wptv.wordpress.com/20909/"><img alt="" border="0" src="http://feeds.wordpress.com/1.0/comments/wptv.wordpress.com/20909/" /></a> <img alt="" border="0" src="http://stats.wordpress.com/b.gif?host=wordpress.tv&blog=5089392&post=20909&subd=wptv&ref=&feed=1" width="1" height="1" /><div><a href="http://wordpress.tv/2013/08/02/stephanie-leary-content-strategy-wordpress-case-studies/"><img alt="Stephanie Leary: Content Strategy: WordPress Case Studies" src="http://videos.videopress.com/ZFNDLrK4/03-leary_scruberthumbnail_0.jpg" width="160" height="120" /></a></div>";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:31:"Fri, 02 Aug 2013 15:01:41 +0000";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:32:"http://purl.org/dc/elements/1.1/";a:1:{s:7:"creator";a:1:{i:0;a:5:{s:4:"data";s:12:"WordPress.tv";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}i:46;a:6:{s:4:"data";s:13:"
	
	
	
	
	
	
";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:2:{s:0:"";a:5:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:81:"Akismet: High Levels of Spam Continue — What We’re Doing and How You Can Help";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"guid";a:1:{i:0;a:5:{s:4:"data";s:30:"http://blog.akismet.com/?p=995";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:64:"http://blog.akismet.com/2013/08/02/high-levels-of-spam-continue/";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:4331:"<p>In <a title="A Spammy Year in Review - Akismet" href="http://blog.akismet.com/2012/12/21/a-spammy-year-in-review/">our 2012 year in review post</a>, we explained that, without surprise, spam levels were greatly on the rise. We are a bit beyond the halfway point of 2013 and wanted to post an update on what we&#8217;re currently seeing and to show just how true that ominous statement has turned out to be. We also wanted to share what we&#8217;re doing to combat the problem and how you can help. </p>
<h3>How much (more) spam?</h3>
<p>We have seen some significant year-over-year increases in the numbers of spam filtered by Akismet. Here is an illustration breaking down the daily averages by month for 2012 and 2013:</p>
<p><a href="http://akismet.files.wordpress.com/2013/07/graph.png"><img src="http://akismet.files.wordpress.com/2013/07/graph.png?w=600" alt="Akismet Daily Spam Averages by Month, 2012 - 2013" class="alignnone size-large wp-image-1020" /></a></p>
<p>As you can see, successfully combatting over 100 million daily pieces of spam is the new normal. As general spam levels rise, so may the chance that some unwanted items will squeeze through our filters to hit your dashboard and comment queues. This is where we need you to ensure that you mark any such comments as spam so that they&#8217;re reported back to Akismet. This helps our software learn, evolve, and make better decisions moving forward. Because spammers evolve just as often.</p>
<h3>What kind of spam?</h3>
<p>All kinds, of course. But if we had to pick a winner so far in 2013, we would probably go with the compliment spammers. There are lots of variations within this category, sure, but the overall tactic remains the same. And unfortunately, we often see that folks are actually recovering comments like this from their spam folders. On this front, <a href="http://blog.akismet.com/2007/11/27/it-really-is-spam/">Mark&#8217;s post from 2007</a> is still very relevant and worth a read. Here are some samples of compliment spam, if you&#8217;re curious: </p>
<blockquote><p>Interesting Findings of the Blog World » Chuck Norris wants a Bible Curriculum in the Public Schools (Gasp!)<br />
[...] Read the rest of this great post here [...]</p>
<p>Very interesting&#8230; as always!</p>
<p>For the most part I agree with you and enjoy reading your posts.</p>
<p>Hi, you have a jolly good post here, thanks for the good read</p>
<p>[...] Check it out! While looking through the blogosphere we stumbled on an interesting post today.</p>
</blockquote>
<h3>What should you do?</h3>
<p>Let Akismet work its magic and correct it only when you need to. If you do, at any given time, experience a small influx of missed spam, there&#8217;s no need to become alarmed. Take a look at the number of comments that Akismet <em><strong>did</strong></em> successfully catch during that same timeframe and examine the accuracy rate (this will help determine whether or not there is a technical problem). Then, of course, mark the comments as spam so that Akismet can process the data. Do <strong>not</strong> place the comments in the trash &#8212; if you find something incredibly out of place, please feel free to <a title="Contact Akismet Support" href="http://akismet.com/contact">get in touch</a>.</p>
<p>Finally, and most importantly, always remember that Akismet learns from user feedback via missed spam and false positive reports. This means that, when you see something that Akismet has flagged as spam, know that other bloggers have agreed with its opinion. Have you ever seen those advertisements that claim &#8220;9 out of 10 cats prefer this food!&#8221;? Well, when you notice a comment in your spam folder, think of it as &#8220;9 out of 10 bloggers say this is spam!&#8221; Don&#8217;t get fooled by the bad guys.</p>
<p>In the meantime, our awesome (and growing) team will continue working magic behind the scenes and ensuring that Akismet is your best weapon against spam.</p>
<br />  <a rel="nofollow" href="http://feeds.wordpress.com/1.0/gocomments/akismet.wordpress.com/995/"><img alt="" border="0" src="http://feeds.wordpress.com/1.0/comments/akismet.wordpress.com/995/" /></a> <img alt="" border="0" src="http://stats.wordpress.com/b.gif?host=blog.akismet.com&blog=116920&post=995&subd=akismet&ref=&feed=1" width="1" height="1" />";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:31:"Fri, 02 Aug 2013 13:08:39 +0000";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:32:"http://purl.org/dc/elements/1.1/";a:1:{s:7:"creator";a:1:{i:0;a:5:{s:4:"data";s:7:"Anthony";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}i:47;a:6:{s:4:"data";s:13:"
	
	
	
	
	
	
";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:2:{s:0:"";a:5:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:69:"WordPress.tv: WordCamp San Francisco 2013: Hallway Interviews Track 4";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"guid";a:1:{i:0;a:5:{s:4:"data";s:28:"http://wordpress.tv/?p=21005";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:86:"http://wordpress.tv/2013/08/02/wordcamp-san-francisco-2013-hallway-interviews-track-4/";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:688:"<div id="v-0EcSJgF0-1" class="video-player">
</div>
<br />  <a rel="nofollow" href="http://feeds.wordpress.com/1.0/gocomments/wptv.wordpress.com/21005/"><img alt="" border="0" src="http://feeds.wordpress.com/1.0/comments/wptv.wordpress.com/21005/" /></a> <img alt="" border="0" src="http://stats.wordpress.com/b.gif?host=wordpress.tv&blog=5089392&post=21005&subd=wptv&ref=&feed=1" width="1" height="1" /><div><a href="http://wordpress.tv/2013/08/02/wordcamp-san-francisco-2013-hallway-interviews-track-4/"><img alt="WordCamp San Francisco 2013: Hallway Interviews Track 4" src="http://videos.videopress.com/0EcSJgF0/video-27a4c1ba6a_std.original.jpg" width="160" height="120" /></a></div>";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:31:"Fri, 02 Aug 2013 12:12:08 +0000";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:32:"http://purl.org/dc/elements/1.1/";a:1:{s:7:"creator";a:1:{i:0;a:5:{s:4:"data";s:12:"WordPress.tv";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}i:48;a:6:{s:4:"data";s:13:"
	
	
	
	
	
	
";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:2:{s:0:"";a:5:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:32:"Donncha: Like a dog and his ball";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"guid";a:1:{i:0;a:5:{s:4:"data";s:29:"http://ocaoimh.ie/?p=89498487";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:53:"http://ocaoimh.ie/2013/08/02/like-a-dog-and-his-ball/";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:2050:"<p><img src="http://ocaoimh.ie/ocaoimh/2013/08/Like-a-dog-and-his-ball.jpg" alt="Like a dog and his ball" width="800" height="533" class="aligncenter size-full wp-image-89498488" /></p>
<p>That there is Oscar, my shih tzu. He <em>loves</em> chasing tennis balls but his activity these days is limited as he suffers from joint pains and has a heart complaint. I did however notice a spring in his step this morning and I think it may have to do with the newly released <a href="http://wordpress.org/news/2013/08/oscar/">WordPress 3.6</a> or &#8220;Oscar&#8221; as it has been named. Matt says the release was named after the famous jazz pianist Oscar Peterson but we all know the cute little dog that really inspired the naming of the release, now don&#8217;t we?</p>
<div id="v-UmhwbWJH-1" class="video-player"></div>
<p>Regardless of naming inspiration, the new version has fixed a ton of bugs, added new features and has the amazing Twenty Thirteen theme I&#8217;m really looking forward to trying out. Make sure you upgrade ASAP!</p>
<div align="center"><!--
				google_ad_client = "pub-1076796686536503";
			/* 336x280, created 22/05/09 */
			google_ad_slot = "6456264552";
			google_ad_width = 336;
			google_ad_height = 280;
			//-->
				</div>
<p><strong>Related Posts</strong><ul><li> <a href="http://ocaoimh.ie/2010/04/02/clean-ball-point-pen-lcd-easily/" rel="bookmark" title="Permanent Link: Clean ball point pen off your LCD easily">Clean ball point pen off your LCD easily</a></li><li> <a href="http://ocaoimh.ie/2003/08/15/that-baseball-game/" rel="bookmark" title="Permanent Link: That baseball game">That baseball game</a></li><li> <a href="http://ocaoimh.ie/2004/10/13/gimp-articles-panoramas-and-crystal-ball/" rel="bookmark" title="Permanent Link: GIMP Articles &#8211; Panoramas and Crystal Ball">GIMP Articles &#8211; Panoramas and Crystal Ball</a></li></ul></p><p><a href="http://ocaoimh.ie/2013/08/02/like-a-dog-and-his-ball/">Like a dog and his ball</a> originally appeared on <a href="http://ocaoimh.ie">Holy Shmoly!</a>.</p>";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:31:"Fri, 02 Aug 2013 11:29:36 +0000";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:32:"http://purl.org/dc/elements/1.1/";a:1:{s:7:"creator";a:1:{i:0;a:5:{s:4:"data";s:7:"Donncha";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}i:49;a:6:{s:4:"data";s:13:"
	
	
	
	
	
	
";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:2:{s:0:"";a:5:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:84:"Gravatar: Have a self-hosted WordPress site? Supercharge your Gravatars with Jetpack";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"guid";a:1:{i:0;a:5:{s:4:"data";s:31:"http://blog.gravatar.com/?p=450";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:57:"http://blog.gravatar.com/2013/08/01/gravatar-and-jetpack/";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:2412:"<p>We&#8217;ve written about Gravatar Hovercards <a href="http://blog.gravatar.com/2010/10/06/gravatar-hovercards-on-wordpress-com/" target="_blank">before</a> &#8212; the nifty pop-up that adds a name, bio, and link to more info when you hover over a Gravatar on <a href="http://wordpress.com" target="_blank">WordPress.com</a>. Hovercards are a great way to learn more about the people commenting on your site, and to share your own contact info.</p>
<p>But what about all the self-hosted WordPress sites? Are you stuck with simplified Gravatars if you&#8217;re not using WordPress.com?</p>
<p>Not if you have Jetpack installed!</p>
<p><a href="http://jetpack.me" target="_blank">Jetpack</a> is a powerful, multipurpose plugin brought to you by Automattic, the same great folks behind WordPress.com and Gravatar. It&#8217;s a single plugin that hooks into the power of the WordPress.com cloud to bring you dozens of features for which you&#8217;d normally need dozens of individual plugins: social sharing, robust stats, proofreading tools, extra sidebar widgets, photo galleries and carousels, contact forms, image optimization, and more &#8212; like Gravatar Hovercards.</p>
<p>Now, when you hover over a commenter&#8217;s Gravatar, you&#8217;ll learn more about them and how to find them in other online spaces:</p>
<p><img class="alignnone size-large wp-image-453" alt="Hovercard" src="http://gravatar.files.wordpress.com/2013/07/hovercard.png?w=660&h=369" width="660" height="369" /></p>
<p>Just install Jetpack and make sure the Gravatar Hovercards module is enabled to give your site visitors the tools to create deeper connections.</p>
<p>(If you&#8217;d like to do even more with Gravatars, the <a href="http://wordpress.org/plugins/" target="_blank">WordPress Plugin Directory</a> has several other well-rated plugins to enhance Gravatars &#8212; we like <a href="http://wordpress.org/plugins/hidpi-gravatars/" target="_blank">HiDPI Gravatar</a>, which uses Javascript to replace standard Gravatar images with retina-ready images.)</p>
<br />  <a rel="nofollow" href="http://feeds.wordpress.com/1.0/gocomments/gravatar.wordpress.com/450/"><img alt="" border="0" src="http://feeds.wordpress.com/1.0/comments/gravatar.wordpress.com/450/" /></a> <img alt="" border="0" src="http://stats.wordpress.com/b.gif?host=blog.gravatar.com&blog=1886259&post=450&subd=gravatar&ref=&feed=1" width="1" height="1" />";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:31:"Fri, 02 Aug 2013 04:39:24 +0000";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:32:"http://purl.org/dc/elements/1.1/";a:1:{s:7:"creator";a:1:{i:0;a:5:{s:4:"data";s:11:"michelle w.";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}}}}}}}}}}}}s:4:"type";i:128;s:7:"headers";a:9:{s:6:"server";s:5:"nginx";s:4:"date";s:29:"Wed, 14 Aug 2013 11:36:16 GMT";s:12:"content-type";s:8:"text/xml";s:14:"content-length";s:6:"136598";s:10:"connection";s:5:"close";s:4:"vary";s:15:"Accept-Encoding";s:13:"last-modified";s:29:"Wed, 14 Aug 2013 11:15:48 GMT";s:4:"x-nc";s:11:"HIT lax 249";s:13:"accept-ranges";s:5:"bytes";}s:5:"build";s:14:"20130708171016";}', 'no');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (166, '_transient_timeout_feed_mod_867bd5c64f85878d03a060509cd2f92c', '1376523376', 'no');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (167, '_transient_feed_mod_867bd5c64f85878d03a060509cd2f92c', '1376480176', 'no');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (168, '_transient_timeout_dash_aa95765b5cc111c56d5993d476b1c2f0', '1376523376', 'no');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (169, '_transient_dash_aa95765b5cc111c56d5993d476b1c2f0', '<div class="rss-widget"><ul><li><a class=''rsswidget'' href=''http://wordpress.tv/2013/08/13/justin-briggs-seo-in-wordpress/'' title=''     ''>WordPress.tv: Justin Briggs: SEO in WordPress</a></li><li><a class=''rsswidget'' href=''http://wordpress.tv/2013/08/13/matt-mullenweg-2012-qa-from-wordcamp-san-francisco/'' title=''     ''>WordPress.tv: Matt Mullenweg: 2012 Q&amp;A from WordCamp San Francisco</a></li><li><a class=''rsswidget'' href=''http://wordpress.tv/2013/08/13/scott-berkun-write-or-die/'' title=''     ''>WordPress.tv: Scott Berkun: Write or Die</a></li><li><a class=''rsswidget'' href=''http://feedproxy.google.com/~r/WordpressTavern/~3/VQP6-QIyoTc/ill-be-at-wordcamp-grand-rapids-2013'' title=''I’m happy to announce that I’ll be in attendance at WordCamp Grand Rapids 2013 next weekend August 24-25th. Not only will I be in attendance, but I’ve been selected to moderate a panel discussion on commercial themes and plugins. The other speakers participating in the panel are Pippin Williamson, Adam Pickering, Daniel Espinoza, and Jake Caputo. This is a topic that is right up my alley and I feel like I’ll be able to ask the right kinds of questions that provide valuable insight to the audience. I’ll try my best not to make any inside jokes to Jake, considering the mess that took place at the beginning of this year.  If you were in my shoes and were going to moderate a panel on Commercial Plugins and Themes, what sort of questions would you ask these individuals? I have a handful already but just curious as to what you’d ask them?  By the way, there are still tickets available to the event so if you’re on the fence about it, jump off and go! ''>WPTavern: I’ll Be At WordCamp Grand Rapids 2013</a></li><li><a class=''rsswidget'' href=''http://feedproxy.google.com/~r/WordpressTavern/~3/DpzsJFviGuQ/wp-com-gets-a-trophy-case-is-wp-org-next'' title=''Automattic employee Isaac Keyet published an interesting tweet yesterday that showed off a WordPress.com Trophy case that was custom made. The trophy case displays all of your achievements on WordPress.com and looks like the following.   I find this to be particularly interesting because I remember Toni Schneider saying in a presentation or in an interview, one in which I can’t find where he talked about the future of WordPress.com and how they were going to try to gamify certain aspects of the publishing process. Gamify is defined by WikiPedia as: “Gamification is the use of game thinking and game mechanics in a non-game context to engage users and solve problems. Gamification is used in applications and processes to improve user engagement, Return on Investment, data quality, timeliness, and learning.”  Back in December of 2011, WordPress.com introduced the first of possibly many enhancements around the gamification concept to encourage users to generate content. As soon as a post is published, the progress bar changes and each time a person publishes 5 posts, they are rewarded with an inspirational quote and the bar resets.  Cool For WordPress.com But What About WordPress.org? I think the concept of having a trophy case showing off achievements is a great idea as well as a motivation factor to continue interacting with WordPress.com. However, I think the opportunities are endless if something like a trophy case was created for the WordPress.org project. Something that shows off badges or rewards for their first patch, their first commit, their first plugin review, so many support forum posts responses, etc. All of this information would then be tied into the WordPress.org profile which would really showcase the user’s activity across the project. I reached out to Otto of Ottopress.com to see not only if this idea has been discussed before, but if some day it could become a reality. Here’s what he had to say. We’ve thought about adding badges to the profiles pages for quite sometime, but that’s one of those things where we need to get profiles themselves working better and collecting more data from all-the-things first. Eventually we’ll have something like that though. I want to be able to collect enough data to have badges for things like “attended WordCamp” and so on. I remember reading a Wired magazine article a few years ago that discussed the topic of everything in life being a game. Add a gaming concept to something and you magically have more engagement to try to earn badges as well as rewards that are meaningless to just about everyone other than the person that earned them. We’ve seen this work with FourSquare, Reddit, and other popular sites that have a lot of community interaction. I think it would be natural to see the gaming concept be part of the WordPress.org project. It would add a little more fun and spice to the act of contributing.  ''>WPTavern: WP.com Gets A Trophy Case – Is WP.org Next?</a></li></ul></div>', 'no');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (170, '_transient_timeout_feed_77fa140e07ce53fe8c87136636f83d72', '1376523377', 'no');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (171, '_transient_feed_77fa140e07ce53fe8c87136636f83d72', 'a:4:{s:5:"child";a:1:{s:0:"";a:1:{s:3:"rss";a:1:{i:0;a:6:{s:4:"data";s:3:"
	
";s:7:"attribs";a:1:{s:0:"";a:1:{s:7:"version";s:3:"2.0";}}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:1:{s:0:"";a:1:{s:7:"channel";a:1:{i:0;a:6:{s:4:"data";s:72:"
		
		
		
		
		
		
				

		
		
		
		
		
		
		
		
		
		
		
		
		
		
		

	";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:2:{s:0:"";a:7:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:33:"WordPress Plugins » View: Newest";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:40:"http://wordpress.org/plugins/browse/new/";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:33:"WordPress Plugins » View: Newest";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:8:"language";a:1:{i:0;a:5:{s:4:"data";s:5:"en-US";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:31:"Wed, 14 Aug 2013 11:14:47 +0000";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:9:"generator";a:1:{i:0;a:5:{s:4:"data";s:25:"http://bbpress.org/?v=1.1";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"item";a:15:{i:0;a:6:{s:4:"data";s:30:"
			
			
			
			
			
			
					";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:2:{s:0:"";a:5:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:14:"Easy Webtrends";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:55:"http://wordpress.org/plugins/easy-webtrends/#post-57032";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:31:"Fri, 09 Aug 2013 12:15:55 +0000";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"guid";a:1:{i:0;a:5:{s:4:"data";s:35:"57032@http://wordpress.org/plugins/";s:7:"attribs";a:1:{s:0:"";a:1:{s:11:"isPermaLink";s:5:"false";}}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:57:"Use Webtrends to track your visitors and their behaviour.";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:32:"http://purl.org/dc/elements/1.1/";a:1:{s:7:"creator";a:1:{i:0;a:5:{s:4:"data";s:10:"John Peden";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}i:1;a:6:{s:4:"data";s:30:"
			
			
			
			
			
			
					";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:2:{s:0:"";a:5:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:13:"Sticky Notice";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:54:"http://wordpress.org/plugins/sticky-notice/#post-56752";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:31:"Fri, 02 Aug 2013 01:54:46 +0000";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"guid";a:1:{i:0;a:5:{s:4:"data";s:35:"56752@http://wordpress.org/plugins/";s:7:"attribs";a:1:{s:0:"";a:1:{s:11:"isPermaLink";s:5:"false";}}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:88:"This adds a fixed semi-transparent highlighted text box in your site with your own text.";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:32:"http://purl.org/dc/elements/1.1/";a:1:{s:7:"creator";a:1:{i:0;a:5:{s:4:"data";s:8:"b0812015";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}i:2;a:6:{s:4:"data";s:30:"
			
			
			
			
			
			
					";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:2:{s:0:"";a:5:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:15:"Page Management";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:56:"http://wordpress.org/plugins/page-management/#post-56987";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:31:"Thu, 08 Aug 2013 10:46:42 +0000";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"guid";a:1:{i:0;a:5:{s:4:"data";s:35:"56987@http://wordpress.org/plugins/";s:7:"attribs";a:1:{s:0:"";a:1:{s:11:"isPermaLink";s:5:"false";}}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:146:"Page Management adds a checkbox on the wp-admin &#34;All Pages&#34; page so that you can view the main pages of your site without the child pages.";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:32:"http://purl.org/dc/elements/1.1/";a:1:{s:7:"creator";a:1:{i:0;a:5:{s:4:"data";s:19:"WordPressThemesShop";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}i:3;a:6:{s:4:"data";s:30:"
			
			
			
			
			
			
					";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:2:{s:0:"";a:5:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:9:"Quote Tag";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:50:"http://wordpress.org/plugins/quote-tag/#post-56985";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:31:"Thu, 08 Aug 2013 10:42:47 +0000";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"guid";a:1:{i:0;a:5:{s:4:"data";s:35:"56985@http://wordpress.org/plugins/";s:7:"attribs";a:1:{s:0:"";a:1:{s:11:"isPermaLink";s:5:"false";}}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:404:"<p>This plugin is to help you write proper, semantically correct html. When you activate the Quote Tag plugin  and  can be used to create short quotations within your WordPress Site.</p>
<p>When you activate this plugin, html like this Am I not destroying my enemies when I make friends with them? creates text like &#34;Am I not destroying my enemies when I make friends with them?&#34; in italics.
</p>";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:32:"http://purl.org/dc/elements/1.1/";a:1:{s:7:"creator";a:1:{i:0;a:5:{s:4:"data";s:19:"WordPressThemesShop";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}i:4;a:6:{s:4:"data";s:30:"
			
			
			
			
			
			
					";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:2:{s:0:"";a:5:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:29:"Linkedin Badge by Pixelpillow";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:70:"http://wordpress.org/plugins/linkedin-badge-by-pixelpillow/#post-57028";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:31:"Fri, 09 Aug 2013 10:11:59 +0000";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"guid";a:1:{i:0;a:5:{s:4:"data";s:35:"57028@http://wordpress.org/plugins/";s:7:"attribs";a:1:{s:0:"";a:1:{s:11:"isPermaLink";s:5:"false";}}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:68:"Add Linkedin badges to your website through a very simple shortcode.";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:32:"http://purl.org/dc/elements/1.1/";a:1:{s:7:"creator";a:1:{i:0;a:5:{s:4:"data";s:11:"Pixelpillow";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}i:5;a:6:{s:4:"data";s:30:"
			
			
			
			
			
			
					";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:2:{s:0:"";a:5:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:18:"Responsive Add Ons";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:59:"http://wordpress.org/plugins/responsive-add-ons/#post-56940";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:31:"Tue, 06 Aug 2013 22:08:27 +0000";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"guid";a:1:{i:0;a:5:{s:4:"data";s:35:"56940@http://wordpress.org/plugins/";s:7:"attribs";a:1:{s:0:"";a:1:{s:11:"isPermaLink";s:5:"false";}}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:92:"Adds Google, Yahoo and Bing verification codes and adds Site Statistics scripts to your site";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:32:"http://purl.org/dc/elements/1.1/";a:1:{s:7:"creator";a:1:{i:0;a:5:{s:4:"data";s:11:"CyberChimps";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}i:6;a:6:{s:4:"data";s:30:"
			
			
			
			
			
			
					";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:2:{s:0:"";a:5:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:6:"Zedity";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:47:"http://wordpress.org/plugins/zedity/#post-56952";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:31:"Wed, 07 Aug 2013 11:28:08 +0000";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"guid";a:1:{i:0;a:5:{s:4:"data";s:35:"56952@http://wordpress.org/plugins/";s:7:"attribs";a:1:{s:0:"";a:1:{s:11:"isPermaLink";s:5:"false";}}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:139:"Take your site or blog to the next level by adding multimedia content with unprecedented possibilities and flexibility, in just few clicks!";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:32:"http://purl.org/dc/elements/1.1/";a:1:{s:7:"creator";a:1:{i:0;a:5:{s:4:"data";s:5:"zuyoy";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}i:7;a:6:{s:4:"data";s:30:"
			
			
			
			
			
			
					";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:2:{s:0:"";a:5:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:10:"FormForAll";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:51:"http://wordpress.org/plugins/formforall/#post-56993";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:31:"Thu, 08 Aug 2013 16:42:38 +0000";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"guid";a:1:{i:0;a:5:{s:4:"data";s:35:"56993@http://wordpress.org/plugins/";s:7:"attribs";a:1:{s:0:"";a:1:{s:11:"isPermaLink";s:5:"false";}}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:94:"FormForAll plugin allows you to insert the best forms directly coming from the FormForAll API.";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:32:"http://purl.org/dc/elements/1.1/";a:1:{s:7:"creator";a:1:{i:0;a:5:{s:4:"data";s:10:"formforall";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}i:8;a:6:{s:4:"data";s:30:"
			
			
			
			
			
			
					";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:2:{s:0:"";a:5:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:35:"WooCommerce - Sisow Payment Options";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:62:"http://wordpress.org/plugins/sisow-for-woocommerce/#post-57026";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:31:"Fri, 09 Aug 2013 09:14:51 +0000";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"guid";a:1:{i:0;a:5:{s:4:"data";s:35:"57026@http://wordpress.org/plugins/";s:7:"attribs";a:1:{s:0:"";a:1:{s:11:"isPermaLink";s:5:"false";}}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:61:"Sisow Payment methods for WooCommerce 1.6 and WooCommerce 2.X";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:32:"http://purl.org/dc/elements/1.1/";a:1:{s:7:"creator";a:1:{i:0;a:5:{s:4:"data";s:5:"sisow";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}i:9;a:6:{s:4:"data";s:30:"
			
			
			
			
			
			
					";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:2:{s:0:"";a:5:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:15:"Simple Magazine";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:56:"http://wordpress.org/plugins/simple-magazine/#post-56894";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:31:"Mon, 05 Aug 2013 17:36:22 +0000";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"guid";a:1:{i:0;a:5:{s:4:"data";s:35:"56894@http://wordpress.org/plugins/";s:7:"attribs";a:1:{s:0:"";a:1:{s:11:"isPermaLink";s:5:"false";}}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:58:"A simple Wordpress plugin to create magazine style issues.";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:32:"http://purl.org/dc/elements/1.1/";a:1:{s:7:"creator";a:1:{i:0;a:5:{s:4:"data";s:13:"christofferok";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}i:10;a:6:{s:4:"data";s:30:"
			
			
			
			
			
			
					";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:2:{s:0:"";a:5:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:26:"Kickstarter Tracker Widget";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:67:"http://wordpress.org/plugins/kickstarter-tracker-widget/#post-56942";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:31:"Wed, 07 Aug 2013 01:16:03 +0000";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"guid";a:1:{i:0;a:5:{s:4:"data";s:35:"56942@http://wordpress.org/plugins/";s:7:"attribs";a:1:{s:0:"";a:1:{s:11:"isPermaLink";s:5:"false";}}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:75:"<p>A widget that displays a Kickstarter project&#039;s funding status.
</p>";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:32:"http://purl.org/dc/elements/1.1/";a:1:{s:7:"creator";a:1:{i:0;a:5:{s:4:"data";s:9:"charto911";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}i:11;a:6:{s:4:"data";s:30:"
			
			
			
			
			
			
					";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:2:{s:0:"";a:5:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:33:"iPhods iTunes Top Products Widget";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:78:"http://wordpress.org/plugins/iphods-itunes-top-products-rss-widget/#post-57023";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:31:"Fri, 09 Aug 2013 03:36:41 +0000";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"guid";a:1:{i:0;a:5:{s:4:"data";s:35:"57023@http://wordpress.org/plugins/";s:7:"attribs";a:1:{s:0:"";a:1:{s:11:"isPermaLink";s:5:"false";}}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:109:"This plugin is a simple plugin to generate widgets highlighting top products available on Apple iTunes Store.";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:32:"http://purl.org/dc/elements/1.1/";a:1:{s:7:"creator";a:1:{i:0;a:5:{s:4:"data";s:8:"bradmkjr";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}i:12;a:6:{s:4:"data";s:30:"
			
			
			
			
			
			
					";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:2:{s:0:"";a:5:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:19:"Popup with fancybox";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:60:"http://wordpress.org/plugins/popup-with-fancybox/#post-57022";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:31:"Fri, 09 Aug 2013 02:51:38 +0000";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"guid";a:1:{i:0;a:5:{s:4:"data";s:35:"57022@http://wordpress.org/plugins/";s:7:"attribs";a:1:{s:0:"";a:1:{s:11:"isPermaLink";s:5:"false";}}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:149:"This plugin allows you to create lightweight fancy box popup window in your blog with custom content. we can easily configure popup size and timeout.";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:32:"http://purl.org/dc/elements/1.1/";a:1:{s:7:"creator";a:1:{i:0;a:5:{s:4:"data";s:20:"gopiplus@hotmail.com";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}i:13;a:6:{s:4:"data";s:30:"
			
			
			
			
			
			
					";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:2:{s:0:"";a:5:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:10:"BotSmasher";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:51:"http://wordpress.org/plugins/botsmasher/#post-57086";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:31:"Mon, 12 Aug 2013 15:57:08 +0000";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"guid";a:1:{i:0;a:5:{s:4:"data";s:35:"57086@http://wordpress.org/plugins/";s:7:"attribs";a:1:{s:0:"";a:1:{s:11:"isPermaLink";s:5:"false";}}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:88:"BotSmasher stops spam by checking comments and registrations against the BotSmasher API.";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:32:"http://purl.org/dc/elements/1.1/";a:1:{s:7:"creator";a:1:{i:0;a:5:{s:4:"data";s:10:"Joe Dolson";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}i:14;a:6:{s:4:"data";s:30:"
			
			
			
			
			
			
					";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";s:5:"child";a:2:{s:0:"";a:5:{s:5:"title";a:1:{i:0;a:5:{s:4:"data";s:18:"Media Placeholders";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:59:"http://wordpress.org/plugins/media-placeholders/#post-57021";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:7:"pubDate";a:1:{i:0;a:5:{s:4:"data";s:31:"Fri, 09 Aug 2013 01:28:25 +0000";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:4:"guid";a:1:{i:0;a:5:{s:4:"data";s:35:"57021@http://wordpress.org/plugins/";s:7:"attribs";a:1:{s:0:"";a:1:{s:11:"isPermaLink";s:5:"false";}}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}s:11:"description";a:1:{i:0;a:5:{s:4:"data";s:140:"Redirect requests to non-existent uploaded images to a placeholder service like placehold.it or placekitten.com. For use during development.";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}s:32:"http://purl.org/dc/elements/1.1/";a:1:{s:7:"creator";a:1:{i:0;a:5:{s:4:"data";s:12:"Weston Ruter";s:7:"attribs";a:0:{}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}}}s:27:"http://www.w3.org/2005/Atom";a:1:{s:4:"link";a:1:{i:0;a:5:{s:4:"data";s:0:"";s:7:"attribs";a:1:{s:0:"";a:3:{s:4:"href";s:41:"http://wordpress.org/plugins/rss/view/new";s:3:"rel";s:4:"self";s:4:"type";s:19:"application/rss+xml";}}s:8:"xml_base";s:0:"";s:17:"xml_base_explicit";b:0;s:8:"xml_lang";s:0:"";}}}}}}}}}}}}s:4:"type";i:128;s:7:"headers";a:10:{s:6:"server";s:5:"nginx";s:4:"date";s:29:"Wed, 14 Aug 2013 11:36:17 GMT";s:12:"content-type";s:23:"text/xml; charset=UTF-8";s:10:"connection";s:5:"close";s:4:"vary";s:15:"Accept-Encoding";s:7:"expires";s:29:"Wed, 14 Aug 2013 11:49:47 GMT";s:13:"cache-control";s:0:"";s:6:"pragma";s:0:"";s:13:"last-modified";s:31:"Wed, 14 Aug 2013 11:14:47 +0000";s:4:"x-nc";s:11:"HIT lax 249";}s:5:"build";s:14:"20130708171016";}', 'no');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (172, '_transient_timeout_feed_mod_77fa140e07ce53fe8c87136636f83d72', '1376523377', 'no');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (173, '_transient_feed_mod_77fa140e07ce53fe8c87136636f83d72', '1376480177', 'no');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (175, '_transient_plugin_slugs', 'a:2:{i:0;s:19:"akismet/akismet.php";i:1;s:9:"hello.php";}', 'no');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (176, '_transient_timeout_dash_de3249c4736ad3bd2cd29147c4a0d43e', '1376523377', 'no');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (174, '_transient_timeout_plugin_slugs', '1376566579', 'no');
INSERT INTO wp_options (option_id, option_name, option_value, autoload) VALUES (178, 'recently_activated', 'a:0:{}', 'yes');


--
-- Name: wp_options_option_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wordpress
--

SELECT pg_catalog.setval('wp_options_option_id_seq', 178, true);


--
-- Data for Name: wp_postmeta; Type: TABLE DATA; Schema: public; Owner: wordpress
--

INSERT INTO wp_postmeta (meta_id, post_id, meta_key, meta_value) VALUES (1, 2, '_wp_page_template', 'default');


--
-- Name: wp_postmeta_meta_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wordpress
--

SELECT pg_catalog.setval('wp_postmeta_meta_id_seq', 2, true);


--
-- Data for Name: wp_posts; Type: TABLE DATA; Schema: public; Owner: wordpress
--

INSERT INTO wp_posts ("ID", post_author, post_date, post_date_gmt, post_content, post_title, post_excerpt, post_status, comment_status, ping_status, post_password, post_name, to_ping, pinged, post_modified, post_modified_gmt, post_content_filtered, post_parent, guid, menu_order, post_type, post_mime_type, comment_count, tsv) VALUES (0, 0, '0001-01-01 00:00:00', '0001-01-01 00:00:00', 'Top Level Post', 'Top Level Post', '', 'hidden', 'close', 'close', '', '', '', '', '0001-01-01 00:00:00', '0001-01-01 00:00:00', '', 0, 'http://[% HOST_NAME %]/?p=0', 0, 'post', '', 0, '''level'':2A,5B ''post'':3A,6B ''top'':1A,4B');
INSERT INTO wp_posts ("ID", post_author, post_date, post_date_gmt, post_content, post_title, post_excerpt, post_status, comment_status, ping_status, post_password, post_name, to_ping, pinged, post_modified, post_modified_gmt, post_content_filtered, post_parent, guid, menu_order, post_type, post_mime_type, comment_count, tsv) VALUES (1, 1, '2013-08-11 14:03:28', '2013-08-11 14:03:28', 'Welcome to WordPress. This is your first post. Edit or delete it, then start blogging!', 'Hello world!', '', 'publish', 'open', 'open', '', 'hello-world', '', '', '2013-08-11 14:03:28', '2013-08-11 14:03:28', '', 0, 'http://[% HOST_NAME %]/?p=1', 0, 'post', '', 1, '''blog'':17B ''delet'':13B ''edit'':11B ''first'':9B ''hello'':1A ''post'':10B ''start'':16B ''welcom'':3B ''wordpress'':5B ''world'':2A');
INSERT INTO wp_posts ("ID", post_author, post_date, post_date_gmt, post_content, post_title, post_excerpt, post_status, comment_status, ping_status, post_password, post_name, to_ping, pinged, post_modified, post_modified_gmt, post_content_filtered, post_parent, guid, menu_order, post_type, post_mime_type, comment_count, tsv) VALUES (3, 1, '2013-08-11 14:03:35', '0001-01-01 00:00:00', '', 'Auto Draft', '', 'auto-draft', 'open', 'open', '', '', '', '', '2013-08-11 14:03:35', '0001-01-01 00:00:00', '', 0, 'http://[% HOST_NAME %]/?p=3', 0, 'post', '', 0, NULL);
INSERT INTO wp_posts ("ID", post_author, post_date, post_date_gmt, post_content, post_title, post_excerpt, post_status, comment_status, ping_status, post_password, post_name, to_ping, pinged, post_modified, post_modified_gmt, post_content_filtered, post_parent, guid, menu_order, post_type, post_mime_type, comment_count, tsv) VALUES (2, 1, '2013-08-11 14:03:28', '2013-08-11 14:03:28', 'This is an example page. It''s different from a blog post because it will stay in one place and will show up in your site navigation (in most themes). Most people start with an About page that introduces them to potential site visitors. It might say something like this:

<blockquote>Hi there! I''m a bike messenger by day, aspiring actor by night, and this is my blog. I live in Los Angeles, have a great dog named Jack, and I like pi&#241;a coladas. (And gettin'' caught in the rain.)</blockquote>

...or something like this:

<blockquote>The XYZ Doohickey Company was founded in 1971, and has been providing quality doohickeys to the public ever since. Located in Gotham City, XYZ employs over 2,000 people and does all kinds of awesome things for the Gotham community.</blockquote>

As a new WordPress user, you should go to <a href="http://[% HOST_NAME %]/wp-admin/">your dashboard</a> to delete this page and create new pages for your content. Have fun!', 'Sample Page', '', 'publish', 'open', 'open', '', 'sample-page', '', '', '2013-08-11 14:03:28', '2013-08-11 14:03:28', '', 0, 'http://[% HOST_NAME %]/?page_id=2', 0, 'page', '', 0, '''000'':125B ''1971'':105B ''2'':124B ''actor'':63B ''angel'':75B ''aspir'':62B ''awesom'':132B ''bike'':58B ''blog'':13B,70B ''caught'':90B ''citi'':120B ''colada'':87B ''communiti'':137B ''compani'':101B ''content'':159B ''creat'':154B ''dashboard'':148B ''day'':61B ''delet'':150B ''differ'':10B ''dog'':79B ''doohickey'':100B,111B ''employ'':122B ''ever'':115B ''exampl'':6B ''found'':103B ''fun'':161B ''gettin'':89B ''go'':145B ''gotham'':119B,136B ''great'':78B ''hi'':53B ''introduc'':41B ''jack'':81B ''kind'':130B ''like'':51B,84B,96B ''live'':72B ''locat'':117B ''los'':74B ''m'':56B ''messeng'':59B ''might'':48B ''name'':80B ''navig'':29B ''new'':140B,155B ''night'':65B ''one'':20B ''page'':2A,7B,39B,152B,156B ''peopl'':34B,126B ''pi'':85B ''place'':21B ''post'':14B ''potenti'':44B ''provid'':109B ''public'':114B ''qualiti'':110B ''rain'':93B ''sampl'':1A ''say'':49B ''show'':24B ''sinc'':116B ''site'':28B,45B ''someth'':50B,95B ''start'':35B ''stay'':18B ''theme'':32B ''thing'':133B ''user'':142B ''visitor'':46B ''wordpress'':141B ''xyz'':99B,121B');


--
-- Name: wp_posts_ID_seq; Type: SEQUENCE SET; Schema: public; Owner: wordpress
--

SELECT pg_catalog.setval('"wp_posts_ID_seq"', 4, true);


--
-- Data for Name: wp_term_relationships; Type: TABLE DATA; Schema: public; Owner: wordpress
--

INSERT INTO wp_term_relationships (object_id, term_taxonomy_id, term_order) VALUES (1, 1, 0);


--
-- Name: wp_term_relationships_object_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wordpress
--

SELECT pg_catalog.setval('wp_term_relationships_object_id_seq', 2, true);


--
-- Data for Name: wp_term_taxonomy; Type: TABLE DATA; Schema: public; Owner: wordpress
--

INSERT INTO wp_term_taxonomy (term_taxonomy_id, term_id, taxonomy, description, parent, count) VALUES (1, 1, 'category', '', 0, 1);


--
-- Name: wp_term_taxonomy_term_taxonomy_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wordpress
--

SELECT pg_catalog.setval('wp_term_taxonomy_term_taxonomy_id_seq', 2, true);


--
-- Data for Name: wp_terms; Type: TABLE DATA; Schema: public; Owner: wordpress
--

INSERT INTO wp_terms (term_id, name, slug, term_group) VALUES (1, 'Uncategorized', 'uncategorized', 0);


--
-- Name: wp_terms_term_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wordpress
--

SELECT pg_catalog.setval('wp_terms_term_id_seq', 2, true);


--
-- Data for Name: wp_usermeta; Type: TABLE DATA; Schema: public; Owner: wordpress
--

INSERT INTO wp_usermeta (umeta_id, user_id, meta_key, meta_value) VALUES (1, 1, 'first_name', '');
INSERT INTO wp_usermeta (umeta_id, user_id, meta_key, meta_value) VALUES (2, 1, 'last_name', '');
INSERT INTO wp_usermeta (umeta_id, user_id, meta_key, meta_value) VALUES (3, 1, 'nickname', 'admin');
INSERT INTO wp_usermeta (umeta_id, user_id, meta_key, meta_value) VALUES (4, 1, 'description', '');
INSERT INTO wp_usermeta (umeta_id, user_id, meta_key, meta_value) VALUES (5, 1, 'rich_editing', 'true');
INSERT INTO wp_usermeta (umeta_id, user_id, meta_key, meta_value) VALUES (6, 1, 'comment_shortcuts', 'false');
INSERT INTO wp_usermeta (umeta_id, user_id, meta_key, meta_value) VALUES (7, 1, 'admin_color', 'fresh');
INSERT INTO wp_usermeta (umeta_id, user_id, meta_key, meta_value) VALUES (8, 1, 'use_ssl', '0');
INSERT INTO wp_usermeta (umeta_id, user_id, meta_key, meta_value) VALUES (9, 1, 'show_admin_bar_front', 'true');
INSERT INTO wp_usermeta (umeta_id, user_id, meta_key, meta_value) VALUES (10, 1, 'wp_capabilities', 'a:1:{s:13:"administrator";b:1;}');
INSERT INTO wp_usermeta (umeta_id, user_id, meta_key, meta_value) VALUES (11, 1, 'wp_user_level', '10');
INSERT INTO wp_usermeta (umeta_id, user_id, meta_key, meta_value) VALUES (12, 1, 'dismissed_wp_pointers', 'wp330_toolbar,wp330_saving_widgets,wp340_choose_image_from_library,wp340_customize_current_theme_link,wp350_media,wp360_revisions,wp360_locks');
INSERT INTO wp_usermeta (umeta_id, user_id, meta_key, meta_value) VALUES (13, 1, 'show_welcome_panel', '1');
INSERT INTO wp_usermeta (umeta_id, user_id, meta_key, meta_value) VALUES (14, 1, 'wp_dashboard_quick_press_last_post_id', '3');


--
-- Name: wp_usermeta_umeta_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wordpress
--

SELECT pg_catalog.setval('wp_usermeta_umeta_id_seq', 15, true);


--
-- Data for Name: wp_users; Type: TABLE DATA; Schema: public; Owner: wordpress
--

INSERT INTO wp_users ("ID", user_login, user_pass, user_nicename, user_email, user_url, user_registered, user_activation_key, user_status, display_name) VALUES (1, 'admin', '$P$BKTIDO45z7SmRfTa4e2sxlnVJvuVNF0', 'admin', 'admin@admin.admin', '', '2013-08-11 14:03:28', '', 0, 'admin');
INSERT INTO wp_users ("ID", user_login, user_pass, user_nicename, user_email, user_url, user_registered, user_activation_key, user_status, display_name) VALUES (0, '', 'BC79E45E176C17939C05B89B4D292A11', 'root', '', '', '0001-01-01 00:00:00', '', 0, 'Администрация');


--
-- Name: wp_users_ID_seq; Type: SEQUENCE SET; Schema: public; Owner: wordpress
--

SELECT pg_catalog.setval('"wp_users_ID_seq"', 2, true);


--
-- Name: wp_commentmeta_pkey; Type: CONSTRAINT; Schema: public; Owner: wordpress; Tablespace: 
--

ALTER TABLE ONLY wp_commentmeta
    ADD CONSTRAINT wp_commentmeta_pkey PRIMARY KEY (meta_id);


--
-- Name: wp_comments_pkey; Type: CONSTRAINT; Schema: public; Owner: wordpress; Tablespace: 
--

ALTER TABLE ONLY wp_comments
    ADD CONSTRAINT wp_comments_pkey PRIMARY KEY ("comment_ID");


--
-- Name: wp_links_pkey; Type: CONSTRAINT; Schema: public; Owner: wordpress; Tablespace: 
--

ALTER TABLE ONLY wp_links
    ADD CONSTRAINT wp_links_pkey PRIMARY KEY (link_id);


--
-- Name: wp_options_pkey; Type: CONSTRAINT; Schema: public; Owner: wordpress; Tablespace: 
--

ALTER TABLE ONLY wp_options
    ADD CONSTRAINT wp_options_pkey PRIMARY KEY (option_id);


--
-- Name: wp_postmeta_pkey; Type: CONSTRAINT; Schema: public; Owner: wordpress; Tablespace: 
--

ALTER TABLE ONLY wp_postmeta
    ADD CONSTRAINT wp_postmeta_pkey PRIMARY KEY (meta_id);


--
-- Name: wp_posts_pkey; Type: CONSTRAINT; Schema: public; Owner: wordpress; Tablespace: 
--

ALTER TABLE ONLY wp_posts
    ADD CONSTRAINT wp_posts_pkey PRIMARY KEY ("ID");


--
-- Name: wp_term_relationships_pkey; Type: CONSTRAINT; Schema: public; Owner: wordpress; Tablespace: 
--

ALTER TABLE ONLY wp_term_relationships
    ADD CONSTRAINT wp_term_relationships_pkey PRIMARY KEY (object_id, term_taxonomy_id);


--
-- Name: wp_term_taxonomy_pkey; Type: CONSTRAINT; Schema: public; Owner: wordpress; Tablespace: 
--

ALTER TABLE ONLY wp_term_taxonomy
    ADD CONSTRAINT wp_term_taxonomy_pkey PRIMARY KEY (term_taxonomy_id);


--
-- Name: wp_terms_pkey; Type: CONSTRAINT; Schema: public; Owner: wordpress; Tablespace: 
--

ALTER TABLE ONLY wp_terms
    ADD CONSTRAINT wp_terms_pkey PRIMARY KEY (term_id);


--
-- Name: wp_usermeta_pkey; Type: CONSTRAINT; Schema: public; Owner: wordpress; Tablespace: 
--

ALTER TABLE ONLY wp_usermeta
    ADD CONSTRAINT wp_usermeta_pkey PRIMARY KEY (umeta_id);


--
-- Name: wp_users_pkey; Type: CONSTRAINT; Schema: public; Owner: wordpress; Tablespace: 
--

ALTER TABLE ONLY wp_users
    ADD CONSTRAINT wp_users_pkey PRIMARY KEY ("ID");


--
-- Name: commentmeta_comment_id_idx; Type: INDEX; Schema: public; Owner: wordpress; Tablespace: 
--

CREATE INDEX commentmeta_comment_id_idx ON wp_commentmeta USING btree (comment_id);


--
-- Name: commentmeta_meta_key_idx; Type: INDEX; Schema: public; Owner: wordpress; Tablespace: 
--

CREATE INDEX commentmeta_meta_key_idx ON wp_commentmeta USING btree (meta_key);


--
-- Name: commentmeta_meta_value_as_bigint_idx; Type: INDEX; Schema: public; Owner: wordpress; Tablespace: 
--

CREATE INDEX commentmeta_meta_value_as_bigint_idx ON wp_commentmeta USING btree (((meta_value)::bigint));


--
-- Name: commentmeta_meta_value_as_numeric_idx; Type: INDEX; Schema: public; Owner: wordpress; Tablespace: 
--

CREATE INDEX commentmeta_meta_value_as_numeric_idx ON wp_commentmeta USING btree (((meta_value)::numeric));


--
-- Name: commentmeta_meta_value_as_timestamp_idx; Type: INDEX; Schema: public; Owner: wordpress; Tablespace: 
--

CREATE INDEX commentmeta_meta_value_as_timestamp_idx ON wp_commentmeta USING btree (((meta_value)::timestamp without time zone));


--
-- Name: commentmeta_meta_value_as_timestamptz_idx; Type: INDEX; Schema: public; Owner: wordpress; Tablespace: 
--

CREATE INDEX commentmeta_meta_value_as_timestamptz_idx ON wp_commentmeta USING btree (((meta_value)::timestamp with time zone));


--
-- Name: comments_comment_approved_date_gmt_idx; Type: INDEX; Schema: public; Owner: wordpress; Tablespace: 
--

CREATE INDEX comments_comment_approved_date_gmt_idx ON wp_comments USING btree (comment_approved, comment_date_gmt);


--
-- Name: comments_comment_date_gmt_idx; Type: INDEX; Schema: public; Owner: wordpress; Tablespace: 
--

CREATE INDEX comments_comment_date_gmt_idx ON wp_comments USING btree (comment_date_gmt);


--
-- Name: comments_comment_parent_idx; Type: INDEX; Schema: public; Owner: wordpress; Tablespace: 
--

CREATE INDEX comments_comment_parent_idx ON wp_comments USING btree (comment_parent);


--
-- Name: comments_comment_post_id_idx; Type: INDEX; Schema: public; Owner: wordpress; Tablespace: 
--

CREATE INDEX comments_comment_post_id_idx ON wp_comments USING btree ("comment_post_ID");


--
-- Name: meta_key_like_attribute_idx; Type: INDEX; Schema: public; Owner: wordpress; Tablespace: 
--

CREATE INDEX meta_key_like_attribute_idx ON wp_postmeta USING btree ((((meta_key)::text ~ '^attribute_pa_'::text)));


--
-- Name: meta_key_like_keywords_idx; Type: INDEX; Schema: public; Owner: wordpress; Tablespace: 
--

CREATE INDEX meta_key_like_keywords_idx ON wp_postmeta USING btree ((((meta_key)::text ~ '-keywords$'::text)));


--
-- Name: meta_key_like_seofield_idx; Type: INDEX; Schema: public; Owner: wordpress; Tablespace: 
--

CREATE INDEX meta_key_like_seofield_idx ON wp_postmeta USING btree ((((meta_key)::text ~ '^seo-'::text)));


--
-- Name: meta_value_as_bigint_idx; Type: INDEX; Schema: public; Owner: wordpress; Tablespace: 
--

CREATE INDEX meta_value_as_bigint_idx ON wp_postmeta USING btree (((meta_value)::bigint));


--
-- Name: meta_value_as_numeric_idx; Type: INDEX; Schema: public; Owner: wordpress; Tablespace: 
--

CREATE INDEX meta_value_as_numeric_idx ON wp_postmeta USING btree (((meta_value)::numeric));


--
-- Name: meta_value_as_text512_idx; Type: INDEX; Schema: public; Owner: wordpress; Tablespace: 
--

CREATE INDEX meta_value_as_text512_idx ON wp_postmeta USING btree (fn.__particular__text__512__idx(meta_value));


--
-- Name: meta_value_as_timestamp_idx; Type: INDEX; Schema: public; Owner: wordpress; Tablespace: 
--

CREATE INDEX meta_value_as_timestamp_idx ON wp_postmeta USING btree (((meta_value)::timestamp without time zone));


--
-- Name: meta_value_as_timestamptz_idx; Type: INDEX; Schema: public; Owner: wordpress; Tablespace: 
--

CREATE INDEX meta_value_as_timestamptz_idx ON wp_postmeta USING btree (((meta_value)::timestamp with time zone));


--
-- Name: postmeta_meta_key_idx; Type: INDEX; Schema: public; Owner: wordpress; Tablespace: 
--

CREATE INDEX postmeta_meta_key_idx ON wp_postmeta USING btree (meta_key);


--
-- Name: postmeta_post_id_idx; Type: INDEX; Schema: public; Owner: wordpress; Tablespace: 
--

CREATE INDEX postmeta_post_id_idx ON wp_postmeta USING btree (post_id);


--
-- Name: posts_post_author_idx; Type: INDEX; Schema: public; Owner: wordpress; Tablespace: 
--

CREATE INDEX posts_post_author_idx ON wp_posts USING btree (post_author);


--
-- Name: posts_post_name_idx; Type: INDEX; Schema: public; Owner: wordpress; Tablespace: 
--

CREATE INDEX posts_post_name_idx ON wp_posts USING btree (post_name);


--
-- Name: posts_post_parent_idx; Type: INDEX; Schema: public; Owner: wordpress; Tablespace: 
--

CREATE INDEX posts_post_parent_idx ON wp_posts USING btree (post_parent);


--
-- Name: posts_type_status_date_idx; Type: INDEX; Schema: public; Owner: wordpress; Tablespace: 
--

CREATE INDEX posts_type_status_date_idx ON wp_posts USING btree (post_type, post_status, post_date, "ID");


--
-- Name: usermeta_meta_key_idx; Type: INDEX; Schema: public; Owner: wordpress; Tablespace: 
--

CREATE INDEX usermeta_meta_key_idx ON wp_usermeta USING btree (meta_key);


--
-- Name: usermeta_meta_value_as_bigint_idx; Type: INDEX; Schema: public; Owner: wordpress; Tablespace: 
--

CREATE INDEX usermeta_meta_value_as_bigint_idx ON wp_usermeta USING btree (((meta_value)::bigint));


--
-- Name: usermeta_meta_value_as_numeric_idx; Type: INDEX; Schema: public; Owner: wordpress; Tablespace: 
--

CREATE INDEX usermeta_meta_value_as_numeric_idx ON wp_usermeta USING btree (((meta_value)::numeric));


--
-- Name: usermeta_meta_value_as_timestamp_idx; Type: INDEX; Schema: public; Owner: wordpress; Tablespace: 
--

CREATE INDEX usermeta_meta_value_as_timestamp_idx ON wp_usermeta USING btree (((meta_value)::timestamp without time zone));


--
-- Name: usermeta_meta_value_as_timestamptz_idx; Type: INDEX; Schema: public; Owner: wordpress; Tablespace: 
--

CREATE INDEX usermeta_meta_value_as_timestamptz_idx ON wp_usermeta USING btree (((meta_value)::timestamp with time zone));


--
-- Name: usermeta_user_id_idx; Type: INDEX; Schema: public; Owner: wordpress; Tablespace: 
--

CREATE INDEX usermeta_user_id_idx ON wp_usermeta USING btree (user_id);


--
-- Name: wp_commentmeta_comment_id_idx; Type: INDEX; Schema: public; Owner: wordpress; Tablespace: 
--

CREATE INDEX wp_commentmeta_comment_id_idx ON wp_commentmeta USING btree (comment_id);


--
-- Name: wp_commentmeta_meta_key_idx; Type: INDEX; Schema: public; Owner: wordpress; Tablespace: 
--

CREATE INDEX wp_commentmeta_meta_key_idx ON wp_commentmeta USING btree (meta_key);


--
-- Name: wp_comments_comment_approved_comment_date_gmt_idx; Type: INDEX; Schema: public; Owner: wordpress; Tablespace: 
--

CREATE INDEX wp_comments_comment_approved_comment_date_gmt_idx ON wp_comments USING btree (comment_approved, comment_date_gmt);


--
-- Name: wp_comments_comment_date_gmt_idx; Type: INDEX; Schema: public; Owner: wordpress; Tablespace: 
--

CREATE INDEX wp_comments_comment_date_gmt_idx ON wp_comments USING btree (comment_date_gmt);


--
-- Name: wp_comments_comment_parent_idx; Type: INDEX; Schema: public; Owner: wordpress; Tablespace: 
--

CREATE INDEX wp_comments_comment_parent_idx ON wp_comments USING btree (comment_parent);


--
-- Name: wp_comments_comment_post_ID_idx; Type: INDEX; Schema: public; Owner: wordpress; Tablespace: 
--

CREATE INDEX "wp_comments_comment_post_ID_idx" ON wp_comments USING btree ("comment_post_ID");


--
-- Name: wp_links_link_visible_idx; Type: INDEX; Schema: public; Owner: wordpress; Tablespace: 
--

CREATE INDEX wp_links_link_visible_idx ON wp_links USING btree (link_visible);


--
-- Name: wp_options_option_name_unq; Type: INDEX; Schema: public; Owner: wordpress; Tablespace: 
--

CREATE UNIQUE INDEX wp_options_option_name_unq ON wp_options USING btree (option_name);


--
-- Name: wp_postmeta_meta_key_idx; Type: INDEX; Schema: public; Owner: wordpress; Tablespace: 
--

CREATE INDEX wp_postmeta_meta_key_idx ON wp_postmeta USING btree (meta_key);


--
-- Name: wp_postmeta_post_id_idx; Type: INDEX; Schema: public; Owner: wordpress; Tablespace: 
--

CREATE INDEX wp_postmeta_post_id_idx ON wp_postmeta USING btree (post_id);


--
-- Name: wp_posts_post_author_idx; Type: INDEX; Schema: public; Owner: wordpress; Tablespace: 
--

CREATE INDEX wp_posts_post_author_idx ON wp_posts USING btree (post_author);


--
-- Name: wp_posts_post_name_idx; Type: INDEX; Schema: public; Owner: wordpress; Tablespace: 
--

CREATE INDEX wp_posts_post_name_idx ON wp_posts USING btree (post_name);


--
-- Name: wp_posts_post_parent_idx; Type: INDEX; Schema: public; Owner: wordpress; Tablespace: 
--

CREATE INDEX wp_posts_post_parent_idx ON wp_posts USING btree (post_parent);


--
-- Name: wp_posts_post_type_idx; Type: INDEX; Schema: public; Owner: wordpress; Tablespace: 
--

CREATE INDEX wp_posts_post_type_idx ON wp_posts USING btree (post_type);


--
-- Name: wp_posts_post_type_post_status_post_date_ID_idx; Type: INDEX; Schema: public; Owner: wordpress; Tablespace: 
--

CREATE INDEX "wp_posts_post_type_post_status_post_date_ID_idx" ON wp_posts USING btree (post_type, post_status, post_date, "ID");


--
-- Name: wp_term_relationships_term_taxonomy_id_idx; Type: INDEX; Schema: public; Owner: wordpress; Tablespace: 
--

CREATE INDEX wp_term_relationships_term_taxonomy_id_idx ON wp_term_relationships USING btree (term_taxonomy_id);


--
-- Name: wp_term_taxonomy_taxonomy_idx; Type: INDEX; Schema: public; Owner: wordpress; Tablespace: 
--

CREATE INDEX wp_term_taxonomy_taxonomy_idx ON wp_term_taxonomy USING btree (taxonomy);


--
-- Name: wp_term_taxonomy_term_id_taxonomy_unq; Type: INDEX; Schema: public; Owner: wordpress; Tablespace: 
--

CREATE UNIQUE INDEX wp_term_taxonomy_term_id_taxonomy_unq ON wp_term_taxonomy USING btree (term_id, taxonomy);


--
-- Name: wp_terms_name_idx; Type: INDEX; Schema: public; Owner: wordpress; Tablespace: 
--

CREATE INDEX wp_terms_name_idx ON wp_terms USING btree (name);


--
-- Name: wp_terms_slug_unq; Type: INDEX; Schema: public; Owner: wordpress; Tablespace: 
--

CREATE UNIQUE INDEX wp_terms_slug_unq ON wp_terms USING btree (slug);


--
-- Name: wp_usermeta_meta_key_idx; Type: INDEX; Schema: public; Owner: wordpress; Tablespace: 
--

CREATE INDEX wp_usermeta_meta_key_idx ON wp_usermeta USING btree (meta_key);


--
-- Name: wp_usermeta_user_id_idx; Type: INDEX; Schema: public; Owner: wordpress; Tablespace: 
--

CREATE INDEX wp_usermeta_user_id_idx ON wp_usermeta USING btree (user_id);


--
-- Name: wp_users_user_login_idx; Type: INDEX; Schema: public; Owner: wordpress; Tablespace: 
--

CREATE INDEX wp_users_user_login_idx ON wp_users USING btree (user_login);


--
-- Name: wp_users_user_nicename_idx; Type: INDEX; Schema: public; Owner: wordpress; Tablespace: 
--

CREATE INDEX wp_users_user_nicename_idx ON wp_users USING btree (user_nicename);


--
-- Name: update_text_search_vector; Type: TRIGGER; Schema: public; Owner: wordpress
--

CREATE TRIGGER update_text_search_vector BEFORE INSERT OR UPDATE OF post_content, post_title ON wp_posts FOR EACH ROW EXECUTE PROCEDURE fn.post_tsv();


--
-- Name: wp_commentmeta_comment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wordpress
--

ALTER TABLE ONLY wp_commentmeta
    ADD CONSTRAINT wp_commentmeta_comment_id_fkey FOREIGN KEY (comment_id) REFERENCES wp_comments("comment_ID") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: wp_comments_comment_post_ID_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wordpress
--

ALTER TABLE ONLY wp_comments
    ADD CONSTRAINT "wp_comments_comment_post_ID_fkey" FOREIGN KEY ("comment_post_ID") REFERENCES wp_posts("ID") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: wp_postmeta_post_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wordpress
--

ALTER TABLE ONLY wp_postmeta
    ADD CONSTRAINT wp_postmeta_post_id_fkey FOREIGN KEY (post_id) REFERENCES wp_posts("ID") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: wp_posts_post_author_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wordpress
--

ALTER TABLE ONLY wp_posts
    ADD CONSTRAINT wp_posts_post_author_fkey FOREIGN KEY (post_author) REFERENCES wp_users("ID") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: wp_posts_post_parent_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wordpress
--

ALTER TABLE ONLY wp_posts
    ADD CONSTRAINT wp_posts_post_parent_fkey FOREIGN KEY (post_parent) REFERENCES wp_posts("ID") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: wp_term_relationships_object_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wordpress
--

ALTER TABLE ONLY wp_term_relationships
    ADD CONSTRAINT wp_term_relationships_object_id_fkey FOREIGN KEY (object_id) REFERENCES wp_posts("ID") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: wp_term_relationships_term_taxonomy_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wordpress
--

ALTER TABLE ONLY wp_term_relationships
    ADD CONSTRAINT wp_term_relationships_term_taxonomy_id_fkey FOREIGN KEY (term_taxonomy_id) REFERENCES wp_term_taxonomy(term_taxonomy_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: wp_term_taxonomy_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wordpress
--

ALTER TABLE ONLY wp_term_taxonomy
    ADD CONSTRAINT wp_term_taxonomy_term_id_fkey FOREIGN KEY (term_id) REFERENCES wp_terms(term_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: wp_usermeta_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: wordpress
--

ALTER TABLE ONLY wp_usermeta
    ADD CONSTRAINT wp_usermeta_user_id_fkey FOREIGN KEY (user_id) REFERENCES wp_users("ID") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

