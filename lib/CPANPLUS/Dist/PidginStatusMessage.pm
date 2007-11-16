package CPANPLUS::Dist::PidginStatusMessage;
use Moose;
use Pidgin::Status::CPAN;

extends 'CPANPLUS::Dist::Base';

has 'pidgin_status' => (
    isa     => 'Pidgin::Status::CPAN',
    is      => 'rw',
    #default => sub { Pidgin::Status::CPAN->new },
    handles => {
        set_pidgin_installing => 'installing',
        set_pidgin_done       => 'done',
    },
);

before 'init' => sub {
    my $self = shift; # hack around the fact that new never gets called
    $self->pidgin_status(Pidgin::Status::CPAN->new);
};

before 'prepare' => sub {
    my $self = shift;
    $self->pidgin_status->installing($self->parent->author->cpanid,
                                     $self->parent->module);
};

after 'install' => sub {
    my $self = shift;
    $self->pidgin_status->done;
};

sub DESTROY {
    my $self = shift;
    $self->pidgin_status->done; # restore status no matter what
}

1;

__END__

=head1 NAME

CPANPLUS::Dist::PidginStatusMessage - cpanplus interface for
Pidgin::Status::CPAN

=head1 SYNOPSIS

To use this module, type this at the CPANPLUS prompt:

    s conf dist_type CPANPLUS::Dist::PidginStatusMessage; s save; 

Then you can use CPANPLUS normally, and it will update Pidgin for you.

=head1 BUGS

Due to the internals of CPANPLUS, this kills other dist modules like
DEB and PAR, so if you want those to work, don't use this module.

=head1 SEE ALSO

L<Pidgin::Status::CPAN>
