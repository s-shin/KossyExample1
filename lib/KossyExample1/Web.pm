package KossyExample1::Web;

use strict;
use warnings;
use utf8;
use DateTime;
use Kossy;
use KossyExample1::Model;

get '/' => [qw/set_title/] => sub {
    my ( $self, $c )  = @_;
    #$c->stash->{site_name} = __PACKAGE__;
    #$c->render('index.tx');
    $c->redirect('/notes');
};

#-----------------------------------
# 簡単にRESTチックに実装

# 手抜きデバッグ用。
sub debug_print { print STDOUT $_[0]; }
sub debug_say { print STDOUT $_[0], "\n"; }
sub debug_bar { debug_say '================================'; }

# とりあえず流用
filter 'set_title' => sub {
    my $app = shift;
    sub {
        my ( $self, $c )  = @_;
        $c->stash->{site_name} = "Simple Note";
        $app->($self,$c);
    }
};

# flashミドルウェア。
# $cにflash相当のものがないのでインスタンス変数で代用。
filter 'flash' => sub {
    my $app = shift;
    sub {
        my ($self, $c) = @_;
        $c->stash->{flash} = $self->{flash};
        $self->{flash} = {};
        $app->($self, $c);
    }
};

# モデル（Tengインスタンス）の取得。
sub model {
    my $self = shift;
    # TODO: MySQLへの対応。
    $self->{__model} ||= KossyExample1::Model->new(
        exists $ENV{MYSQL_USER}
        ? KossyExample1::Model->connect_mysql(
            "kossy_example_1", $ENV{MYSQL_USER}, $ENV{MYSQL_PASSWORD})
        : KossyExample1::Model->connect_sqlite(
            "db/development.sqlite3")
    );
    $self->{__model}
}

get '/notes' => [qw/set_title flash/] => sub {
    my ($self, $c) = @_;
    my $note_itr = $self->model->search("notes", {});
    $c->render('notes/index.tx', {note_itr => $note_itr});
};

get '/notes/:id' => [qw/set_title flash/] => sub {
    my ($self, $c) = @_;
    my $note = $self->model->single("notes", {id => $c->args->{id}});
    $c->render('notes/show.tx', {note => $note});
};

post '/notes' => [qw/set_title flash/] => sub {
    my ($self, $c) = @_;
    
    # 内容を保存する
    my $content = $c->req->param('content');
    $self->model->insert("notes", {
        content => $content,
        created_at => DateTime->now(time_zone => 'local'),
    });
    
    $self->{flash} = {
        result => "Save successful!",
    };
    $c->redirect('/notes');
};

1;

