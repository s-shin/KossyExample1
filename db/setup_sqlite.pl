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

my $dbh = KossyExample1::Model->connect_sqlite(
    "$FindBin::Bin/development.sqlite3");

# テーブルの作成
if ($create_table) {
    $dbh->do(q{
        CREATE TABLE notes (
            id INTEGER PRIMARY KEY,
            content TEXT NOT NULL,
            created_at TEXT,
            updated_at TEXT
        )
    });
}

# モデル（Tengインスタンス）の作成
my $model = KossyExample1::Model->new($dbh);

# 試し書き込み
my $now = DateTime->now(time_zone => 'local');
my $row = $model->insert(notes => +{
    content => "Hello, world! こんにちは、世界！",
    created_at => $now,
    updated_at => $now,
});

# 試し読みだし
my $note = $model->single(notes => +{id => 1});
print Dumper($note->get_columns);
print $note->created_at, "\n";
