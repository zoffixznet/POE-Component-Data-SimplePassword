package POE::Component::Data::SimplePassword;

use warnings;
use strict;

our $VERSION = '0.0101';

use POE;
use base 'POE::Component::NonBlockingWrapper::Base';
use Data::SimplePassword;

sub _methods_define {
    return ( make_password => '_wheel_entry' );
}

sub make_password {
    $poe_kernel->post( shift->{session_id} => make_password => @_ );
}

sub _process_request {
    my ( $self, $in_ref ) = @_;

    my $obj = Data::SimplePassword->new;
    $in_ref->{chars}  ||= [ 0..9, 'a'..'z', 'A'..'Z' ];
    $in_ref->{length} ||= 8;

    $obj->chars( @{ $in_ref->{chars} } );
    $in_ref->{out} = $obj->make_password( $in_ref->{length} );
}

1;
__END__

=head1 NAME

POE::Component::Data::SimplePassword - POE wrapper around Data::SimplePassword

=head1 SYNOPSIS

    use strict;
    use warnings;
    use POE qw/Component::Data::SimplePassword/;

    my $poco = POE::Component::Data::SimplePassword->spawn;

    POE::Session->create( package_states => [ main => [qw(_start results)] ], );

    $poe_kernel->run;

    sub _start {
        $poco->make_password( { event => 'results', } );
    }

    sub results {
        print "Password: $_[ARG0]->{out}\n";
        $poco->shutdown;
    }

Using event based interface is also possible of course.

=head1 DESCRIPTION

The module is a non-blocking wrapper around L<Data::SimplePassword> (although, the
primary purpose was an event based interface)
which provides interface to generate random passwords.

=head1 CONSTRUCTOR

=head2 C<spawn>

    my $poco = POE::Component::Data::SimplePassword->spawn;

    POE::Component::Data::SimplePassword->spawn(
        alias => 'pass',
        options => {
            debug => 1,
            trace => 1,
            # POE::Session arguments for the component
        },
        debug => 1, # output some debug info
    );

The C<spawn> method returns a
POE::Component::Data::SimplePassword object. It takes a few arguments,
I<all of which are optional>. The possible arguments are as follows:

=head3 C<alias>

    ->spawn( alias => 'pass' );

B<Optional>. Specifies a POE Kernel alias for the component.

=head3 C<options>

    ->spawn(
        options => {
            trace => 1,
            default => 1,
        },
    );

B<Optional>.
A hashref of POE Session options to pass to the component's session.

=head3 C<debug>

    ->spawn(
        debug => 1
    );

When set to a true value turns on output of debug messages. B<Defaults to:>
C<0>.

=head1 METHODS

=head2 C<make_password>

    $poco->make_password( {
            event       => 'event_for_output',
            chars       => [ 0..9, 'A'..'Z', 'a'..'z' ],
            length      => 10,
            _blah       => 'pooh!',
            session     => 'other',
        }
    );

Takes a hashref as an argument, does not return a sensible return value.
See C<make_password> event's description for more information.

=head2 C<session_id>

    my $poco_id = $poco->session_id;

Takes no arguments. Returns component's session ID.

=head2 C<shutdown>

    $poco->shutdown;

Takes no arguments. Shuts down the component.

=head1 ACCEPTED EVENTS

=head2 C<make_password>

    $poe_kernel->post( pass => make_password => {
            event       => 'event_for_output',
            chars       => [ 0..9, 'A'..'Z', 'a'..'z' ],
            length      => 10,
            _blah       => 'pooh!',
            session     => 'other',
        }
    );

Instructs the component to generate a random password. Takes a hashref as an
argument, the possible keys/value of that hashref are as follows:

=head3 C<event>

    { event => 'results_event', }

B<Mandatory>. Specifies the name of the event to emit when results are
ready. See OUTPUT section for more information.

=head3 C<chars>

    { chars => [ 0..9, 'A'..'Z', 'a'..'z' ], }

B<Optional>. Takes an arrayref of characters as a value. Specifies what characters to
use to generate the password. B<Defaults to:> C<[ 0..9, 'a'..'z', 'A'..'Z' ]>

=head3 C<length>

    { length => 10, }

B<Optional>. Specifies the length in bytes of the password to be generated. B<Defaults to:>
C<8>

=head3 C<session>

    { session => 'other' }

    { session => $other_session_reference }

    { session => $other_session_ID }

B<Optional>. Takes either an alias, reference or an ID of an alternative
session to send output to.

=head3 user defined

    {
        _user    => 'random',
        _another => 'more',
    }

B<Optional>. Any keys starting with C<_> (underscore) will not affect the
component and will be passed back in the result intact.

=head2 C<shutdown>

    $poe_kernel->post( pass => 'shutdown' );

Takes no arguments. Tells the component to shut itself down.

=head1 OUTPUT

    $VAR1 = {
        'out' => 'lYIXaKNP',
        'length' => 8,
        'chars' => [
            'X',
            'Y',
            'Z'
        ],
        '_blah' => 'foos'
    };

The event handler set up to handle the event which you've specified in
the C<event> argument to C<make_password()> method/event will recieve input
in the C<$_[ARG0]> in a form of a hashref. The possible keys/value of
that hashref are as follows:

=head2 C<out>

    { 'out' => 'lYIXaKNP', }

The C<out> key will contain the generated password.

=head2 C<length>

    { 'length' => 8, }

The C<length> key will contain the length of the generated password.

=head2 C<chars>

    {
        'chars' => [
            'X',
            'Y',
            'Z'
        ],
    }

The C<chars> key will contain an arrayref of characters that could be used to generate the
password, in other words this is the value of the C<chars> argument to C<make_password()>
event/method.

=head2 user defined

    { '_blah' => 'foos' }

Any arguments beginning with C<_> (underscore) passed into the C<make_password()>
event/method will be present intact in the result.

=head1 SEE ALSO

L<POE>, L<Data::SimplePassword>

=head1 AUTHOR

'Zoffix, C<< <'zoffix at cpan.org'> >>
(L<http://zoffix.com/>, L<http://haslayout.net/>, L<http://zofdesign.com/>)

=head1 BUGS

Please report any bugs or feature requests to C<bug-poe-component-data-simplepassword at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=POE-Component-Data-SimplePassword>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc POE::Component::Data::SimplePassword

You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=POE-Component-Data-SimplePassword>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/POE-Component-Data-SimplePassword>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/POE-Component-Data-SimplePassword>

=item * Search CPAN

L<http://search.cpan.org/dist/POE-Component-Data-SimplePassword>

=back

=head1 COPYRIGHT & LICENSE

Copyright 2008 'Zoffix, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.


=cut

