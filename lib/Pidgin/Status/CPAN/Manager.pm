package Pidgin::Status::CPAN::Manager;
use Moose;
use Net::DBus;
require Net::DBus::RemoteObject;

has 'status_name' => (
    is       => 'ro',
    isa      => 'Str',
    required => 0,
    default  => 'CPAN Install Status',
);

has 'purple' => (
    is       => 'rw',
    isa      => 'Net::DBus::RemoteObject',
    required => 0,
    default  => \&_get_purple,
    lazy     => 0, # want to die ASAP if they don't have pidgin
);

has 'managed_status' => (
    is  => 'rw',
    isa => 'Int',
);

has 'saved_status' => (
    is  => 'rw',
    isa => 'Int',
);

sub BUILD {
    my $self = shift;
    my ($current, $managed) = $self->_get_statuses;
    $self->saved_status($current);
    $self->managed_status($managed);
    return $self;
}

sub set_message {
    my ($self, $message) = @_;
    $self->_change_managed_message($message);
    $self->_set_status($self->managed_status);
}

sub restore_message {
    my $self = shift;
    $self->_set_status($self->saved_status);
}

sub _change_managed_message {
    my ($self, $message) = @_;
    $self->purple->PurpleSavedstatusSetMessage($self->managed_status, $message);
}

sub _set_status {
    my $self   = shift;
    my $status = shift;

    return $self->purple->PurpleSavedstatusActivate($status);
}

sub _get_statuses {
    my $self   = shift;
    my $purple = $self->purple;
    
    # copied from the (python) amarok <-> pidgin plugin
    my $managed_status = $purple->PurpleSavedstatusFind($self->status_name);
    my $current_status = $purple->PurpleSavedstatusGetCurrent;
    if(!$managed_status){
        my $type = $purple->PurpleSavedstatusGetType($current_status);
        $managed_status = $purple->PurpleSavedstatusNew($self->status_name,
                                                        $type);
    }
    # it won't be current for long, so the rest of the app refers to current
    # as saved_status
    return ($current_status, $managed_status);
}

sub _get_purple {
    my $dbus = Net::DBus->session 
      or die q{no session dbus};
    
    my $gaim = $dbus->get_service('im.pidgin.purple.PurpleService') 
      or die q{can't find pidgin on the dbus};
        
    my $purple = $gaim->get_object('/im/pidgin/purple/PurpleObject')
      or die q{can't get the PurpleObejct};

    return $purple;
}

# remove the CPAN status from pidgin's saved status menu
sub DEMOLISH {
    my $self = shift;
    $self->purple->PurpleSavedstatusDelete($self->status_name);
}

1;
__END__

=head1 NAME

Pidgin::Status::CPAN::Manager - manage pidgin statuses for Pidgin::Status::CPAN

=head1 SYNOPSIS

    my $ps = Pidgin::Status::CPAN::Manager->new;
    $ps->set_message('Now compiling: FOOBAR - Foo::Bar');
    $ps->set_message('Now compiling: BOOK - Acme::Metasyntactic');
    $ps->restore_message; # whatever the message was before

=head1 METHODS

=head2 set_message

Set the Pidgin status message

=head2 restore_message

Restore the message to what it was when C<new> was called

=head1 SEE ALSO

Pidgin::Status::CPAN
