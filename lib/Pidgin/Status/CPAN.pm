package Pidgin::Status::CPAN;
use Moose;
use Pidgin::Status::CPAN::Manager;
use utf8; 

our $VERSION       = '0.01';
our $AUTHORITY     = 'cpan:JROCKWAY';
our $RANDOM_NUMBER = 42;

has 'status_manager' => (
    isa     => 'Pidgin::Status::CPAN::Manager',
    is      => 'ro',
    default => sub { Pidgin::Status::CPAN::Manager->new },
    handles => [qw/restore_message set_message/],
);

has 'format_string' => (
    isa     => 'Str',
    is      => 'ro',
    default => '⚙ Now installing: %author - %dist',
);

sub installing {
    my ($self, $author, $dist) = @_;
    my $message = $self->_format($author, $dist);
    $self->set_message($message);
}

sub _format {
    my ($self, $author, $dist) = @_;
    my $message = $self->format_string;
    $message =~ s/\%\%/%/g; # Foo %% => Foo %
    $message =~ s/\%author/$author/g; # Foo %author = Foo PAUSE_ID
    $message =~ s/\%dist/$dist/g;
    return $message;
}

sub done {
    my $self = shift;
    $self->restore_message;
}

1;

__END__

=head1 NAME

Pidgin::Status::CPAN - set your Pidgin status message to the CPAN
module you're currently installing

=head1 SYNOPSIS

Most music players offer a feature that allows you to use the name of
the song you're currently listening to as your Pidgin (IM) status
message.  For example, if you're listening to "Ashcroft's Army" by
"John McCuteheon", your IM status will be something like:

    ♪ Now playing: John McCuteheon - Ashcroft's Army

I've never been much of a fan of telling people what music I listen
to, so I decided to implement a similar concept for currently
installing CPAN modules.  This module will transform a module
installation request like:

    $ cpanp install Angerwhale

into the IM status message:

    ⚙ Now installing: JROCKWAY - Angerwhale

Now you can treat CPAN authors like the celebrities they are and share
your unique taste in CPAN modules with others.  Fun!

Additionally, when you're done installing that module, the status will
revert back to whatever it was before.  There's also a rate-limiting
feature, so your status will only change every 30 seconds.  This is to
prevent some brain-dead IM protocols killing your connection when you
install a bunch of small CPAN modules.

=head1 SETUP

See L<CPANPLUS::Dist::PidginStatusMessage> for information on how to
use this module with L<CPANPLUS|CPANPLUS>.  To use it with the regular
CPAN shell, write an adaptor like
C<CPANPLUS::Dist::PidginStatusMessage> :).

=head1 AUTHOR

Jonathan Rockway C<< <jrockway@cpan.org> >>

=head1 LICENSE AND COPYRIGHT

This module is free software and may be redistributed under the same
terms as Perl itself.
