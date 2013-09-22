use strict;
use warnings;
use utf8;
use DBI;
use DateTime;
use FindBin;
use lib "$FindBin::Bin/../lib";
use KossyExample1::Model;
use Data::Dumper;

my $create_table = shift;

my $dbh = KossyExample1::Model->connect_mysql(
    "kossy_example_1", $ENV{MYSQL_USER}, $ENV{MYSQL_PASSWORD});

if ($create_table) {
    $dbh->do(q{
        CREATE TABLE notes (
            id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
            content TEXT NOT NULL,
            created_at DATETIME
        )
    });
}

my $model = KossyExample1::Model->new($dbh);

$model->fast_insert(notes => +{
    content => "Hello, world! こんにちは、世界！",
    created_at => DateTime->now(time_zone => 'local'),
});

my $note = $model->single(notes => +{id => 1});
print Dumper($note->get_columns);
print $note->created_at, "\n";

