use strict;
use warnings;
package HTML::Widget::Plugin::Password;
# ABSTRACT: for SECRET input
$HTML::Widget::Plugin::Password::VERSION = '0.200';
use parent 'HTML::Widget::Plugin::Input';

# =head1 SYNOPSIS
#
#   $widget_factory->password({
#     id    => 'user_secret',
#     value => "not visible in html",
#   });
#
# =head1 DESCRIPTION
#
# This plugin provides a widget for password-entry inputs.
#
# =cut

use HTML::Element;

# =head1 METHODS
#
# =head2 C< provided_widgets >
#
# This plugin provides the following widgets: password
#
# =cut

sub provided_widgets { [ input => 'password' ] }

# =head2 C< password >
#
# This method returns a password-entry widget.
#
# In addition to the generic L<HTML::Widget::Plugin> attributes, the following
# are valid arguments:
#
# =over
#
# =item value
#
# This is the widget's initial value.  The value is eaten and displayed as a
# series of spaces, if the value is defined.
#
# =back
#
# =cut

# =head2 C< rewrite_arg >
#
# The password plugin's rewrite_arg replaces any non-empty value with a string of
# spaces so that passwords are not inadvertantly sent as plain text.
#
# =cut

sub rewrite_arg {
  my ($self, $arg) = @_;

  $arg = $self->SUPER::rewrite_arg($arg);

  $arg->{attr}{type} = "password";

  $arg->{attr}{value} = q{ } x 8
    if defined $arg->{attr}{value} and length $arg->{attr}{value};

  return $arg;
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

HTML::Widget::Plugin::Password - for SECRET input

=head1 VERSION

version 0.200

=head1 SYNOPSIS

  $widget_factory->password({
    id    => 'user_secret',
    value => "not visible in html",
  });

=head1 DESCRIPTION

This plugin provides a widget for password-entry inputs.

=head1 METHODS

=head2 C< provided_widgets >

This plugin provides the following widgets: password

=head2 C< password >

This method returns a password-entry widget.

In addition to the generic L<HTML::Widget::Plugin> attributes, the following
are valid arguments:

=over

=item value

This is the widget's initial value.  The value is eaten and displayed as a
series of spaces, if the value is defined.

=back

=head2 C< rewrite_arg >

The password plugin's rewrite_arg replaces any non-empty value with a string of
spaces so that passwords are not inadvertantly sent as plain text.

=head1 AUTHOR

Ricardo SIGNES

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2005 by Ricardo SIGNES.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
