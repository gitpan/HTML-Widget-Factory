use 5.006;
use strict;
use warnings;

package HTML::Widget::Factory;

=head1 NAME

HTML::Widget::Factory - churn out HTML widgets

=head1 VERSION

version 0.070

=cut

our $VERSION = '0.070';

=head1 SYNOPSIS

 my $factory = HTML::Widget::Factory->new();

 my $html = $factory->select({
   name    => 'flavor',
   options => [
     [ minty => 'Peppermint',     ],
     [ perky => 'Fresh and Warm', ],
     [ super => 'Red and Blue',   ],
   ],
   value   => 'minty',
 });

=head1 DESCRIPTION

HTML::Widget::Factory provides a simple, pluggable system for constructing HTML
form controls.

=cut

use Module::Pluggable
  search_path => [ qw(HTML::Widget::Plugin) ],
  sub_name    => '_default_plugins',
  except      => qr/^HTML::Widget::Plugin::Debug/;

use Package::Generator;
use Package::Reaper;

=head1 METHODS

Most of the useful methods in an HTML::Widget::Factory object will be installed
there by its plugins.  Consult the documentation for the HTML::Widget::Plugin
modules.

=head2 new

  my $factory = HTML::Widget::Factory->new(\%arg);

This constructor returns a new widget factory.

The only valid arguments are C<plugins> and C<extra_plugins>, which provide
arrayrefs of plugins to be used.  If C<plugins> is not given, the default
plugin list is used; this is generated by finding all modules beginning with
HTML::Widget::Plugin.  The plugins in C<extra_plugins> are loaded in addition
to these.

=cut

sub __new_class {
  my ($class) = @_;
  $class = ref $class if ref $class;

  my $obj_class = Package::Generator->new_package({
    base => "$class\::GENERATED",
    isa  => $class,
  });
}

sub __mix_in {
  my ($class, @plugins) = @_;

  for my $plugin (@plugins) {
    unless ($plugin =~ /::(__)?GENERATED\1::/ and
              Package::Generator->package_exists($plugin)) {
      eval "require $plugin; 1" or die $@; ## no critic Carp
    }
    $plugin->import({ into => $class });
  }
}

my @_default_plugins;
my $_default_class;
BEGIN {
  @_default_plugins = __PACKAGE__->_default_plugins;

  $_default_class = __PACKAGE__->__new_class;

  $_default_class->__mix_in(@_default_plugins);
}

sub new {
  my ($class, $arg) = @_;
  $arg ||= {};

  my $obj_class = $_default_class;
  my $reaper;

  my @plugins = $arg->{plugins} ? @{ $arg->{plugins} } : @_default_plugins;

  if ($arg->{plugins} or $arg->{extra_plugins}) {
    $obj_class = $class->__new_class;

    push @plugins, @{ $arg->{extra_plugins} } if $arg->{extra_plugins};

    $obj_class->__mix_in(@plugins);

    $reaper = Package::Reaper->new($obj_class);
  }

  # for some reason PPI/Perl::Critic think this is multiple statements:
  bless { ## no critic
    ($reaper ? (reaper => $reaper) : ()),
    plugins => \@plugins,
  } => $obj_class;
}

=head2 provides_widget

  if ($factory->provides_widget($name)) { ... }

This method returns true if the given name is a widget provided by the factory.
This, and not C<can> should be used to determine whether a factory can provide
a given widget.

=cut

sub provides_widget {
  my ($class, $name) = @_;
  $class = ref $class if ref $class;

  for (Class::ISA::self_and_super_path($class)) {
    no strict 'refs';
    my %pw = %{"$_\::_provided_widgets"};
    return 1 if exists $pw{ $name };
  }

  return;
}

=head2 provided_widgets

  for my $name ($fac->provided_widgets) { ... }

This method returns an unordered list of the names of the widgets provided by
this factory.

=cut

sub provided_widgets {
  my ($class) = @_;
  $class = ref $class if ref $class;

  my %provided;

  for (Class::ISA::self_and_super_path($class)) {
    no strict 'refs';
    my %pw = %{"$_\::_provided_widgets"};
    @provided{ keys %pw } = (1) x (keys %pw);
  }

  return keys %provided;
}


=head2 plugins

This returns a list of the plugins loaded by the factory.

=cut

sub plugins { @{ $_[0]->{plugins} } }

=head1 TODO

=over

=item * fixed_args for args that are fixed, like (type => 'checkbox')

=item * a simple way to say "only include this output if you haven't before"

This will make it easy to do JavaScript inclusions: if you've already made a
calendar (or whatever) widget, don't bother including this hunk of JS, for
example.

=item * giving the constructor a data store

Create a factory that has a CGI.pm object and let it default values to the
param that matches the passed name.

=item * include id attribute where needed

=item * optional labels (before or after control, or possibly return a list)

=back

=head1 SEE ALSO

=over

=item L<HTML::Widget::Plugin>

=item L<HTML::Widget::Plugin::Input>

=item L<HTML::Widget::Plugin::Submit>

=item L<HTML::Widget::Plugin::Link>

=item L<HTML::Widget::Plugin::Image>

=item L<HTML::Widget::Plugin::Password>

=item L<HTML::Widget::Plugin::Select>

=item L<HTML::Widget::Plugin::Multiselect>

=item L<HTML::Widget::Plugin::Checkbox>

=item L<HTML::Widget::Plugin::Radio>

=item L<HTML::Widget::Plugin::Button>

=item L<HTML::Widget::Plugin::Textarea>

=item L<HTML::Element>

=back

=head1 AUTHOR

Ricardo SIGNES <C<rjbs @ cpan.org>>

Development was sponsored by Listbox and Pobox between 2005 and 2007.

=head1 COPYRIGHT

Copyright (C) 2005-2007, Ricardo SIGNES.  This is free software, released under
the same terms as perl itself.

=cut

1;
