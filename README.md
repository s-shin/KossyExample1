# KossyExample1

## Usage

First, setup the database with the commands below.

    [SQLite]
    $ perl db/setup_sqlite 1
    
    [MySQL]
    $ (Create DB 'kossy_example_1' in the local MySQL server.)
    $ MYSQL_USER=... MYSQL_PASSWORD=... perl db/setup_mysql 1
  
Then, run.
 
    [SQLite]
    $ plackup app.psgi
    
    [MySQL]
    $ MYSQL_USER=... MYSQL_PASSWORD=... plackup app.psgi

## Dependencies

* Kossy
* DBI
* DBD::mysql or DBD::SQLite
* Teng
* DateTime::Format::MySQL

