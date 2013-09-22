package KossyExample1::Model;
use strict;
use warnings;
use utf8;
use DBI;
use Teng;
use Teng::Schema::Loader;
use DateTime::Format::MySQL;

# SQLiteへの接続
sub connect_sqlite {
    my $class = shift;
    my $dbname = shift;
    my $source = "dbi:SQLite:dbname=$dbname";
    my $user = '';
    my $passwd = '';
    DBI->connect($source, $user, $passwd, {
        AutoCommit => 1,
        PrintError => 0,
        RaiseError => 1,
        ShowErrorStatement => 1,
        AutoInactiveDestroy => 1,
        sqlite_unicode => 1,
        sqlite_use_immediate_transaction => 1,
    });
}

# MySQLへの接続
sub connect_mysql {
    my ($class, $dbinfo, $user, $passwd) = @_;
    my $source = "dbi:mysql:$dbinfo";
    DBI->connect($source, $user, $passwd, {
        AutoCommit => 1,
        PrintError => 0,
        RaiseError => 1,
        ShowErrorStatement => 1,
        AutoInactiveDestroy => 1,
        mysql_enable_utf8 => 1,
        mysql_auto_reconnect => 0,
    });
}

sub new {
    my ($class, $dbh) = @_;
    
    # スキーマ書くのが面倒なので自動作成
    my $teng = Teng::Schema::Loader->load(
        dbh => $dbh,
        # 適当な名前を指定すると内部的にダミークラスを作ってくれて上手くいく
        namespace => 'MyApp::DB',
    );
    
    # *_at系は自動変換する。
    foreach my $table (values %{$teng->{tables}}) {
        $table->add_deflator(
            qr{^.+_at$} => sub {
                DateTime::Format::MySQL->format_datetime($_[0]);
            }
        );
        $table->add_inflator(
            qr{^.+_at$} => sub {
                DateTime::Format::MySQL->parse_datetime($_[0]);
            }
        );
    }
    
    $teng;
}

1;

