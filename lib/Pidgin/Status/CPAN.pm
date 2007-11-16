package Pidgin::Status::CPAN;

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
revert back to whatever it was before.

=head1 AUTHOR

Jonathan Rockway C<< <jrockway@cpan.org> >>

=head1 LICENSE AND COPYRIGHT

This module is free software and may be redistributed under the same
terms as Perl itself.
