use strict;
use warnings;
package HTML::Widget::Plugin::Input;
{
  $HTML::Widget::Plugin::Input::VERSION = '0.101';
}
use parent 'HTML::Widget::Plugin';
# ABSTRACT: the most basic input widget


use HTML::Element;


sub provided_widgets { qw(input hidden) }


sub _attribute_args { qw(disabled type value size maxlength) }
sub _boolean_args   { qw(disabled) }

sub input {
  my ($self, $factory, $arg) = @_;

  $self->build($factory, $arg);
}


sub hidden {
  my ($self, $factory, $arg) = @_;

  $arg->{attr}{type} = 'hidden';

  $self->build($factory, $arg);
}


sub build {
  my ($self, $factory, $arg) = @_;

  $arg->{attr}{name} = $arg->{attr}{id} unless defined $arg->{attr}{name};

  my $widget = HTML::Element->new('input');

  $widget->attr($_ => $arg->{attr}{$_}) for keys %{ $arg->{attr} };
  return $widget->as_XML;
}

1;

__END__

=pod

=head1 NAME

HTML::Widget::Plugin::Input - the most basic input widget

=head1 VERSION

version 0.101

=head1 SYNOPSIS

  $widget_factory->input({
    id    => 'flavor',   # if "name" isn't given, id will be used for name
    size  => 25,
    value => $default_flavor,
  });

...or...

  $widget_factory->hidden({
    id    => 'flavor',   # if "name" isn't given, id will be used for name
    value => $default_flavor,
  });

=head1 DESCRIPTION

This plugin provides a basic input widget.

=head1 METHODS

=head2 C< provided_widgets >

This plugin provides the following widgets: input, hidden

=head2 C< input >

This method returns a basic one-line text-entry widget.

In addition to the generic L<HTML::Widget::Plugin> attributes, the following
are valid arguments:

=over

=item value

This is the widget's initial value.

=item type

This is the type of input widget to be created.  You may wish to use a
different plugin, instead.

=back

=head2 C< hidden >

This method returns a hidden input that is not displayed in the rendered HTML.
Its arguments are the same as those to C<input>.

This method may later be factored out into a plugin.

=head2 C< build >

  my $widget = $class->build($factory, $arg);

This method does the actual construction of the input based on the args
collected by the widget-constructing method.  It is primarily here for
subclasses to exploit.

=head1 AUTHOR

Ricardo SIGNES

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2005 by Ricardo SIGNES.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
