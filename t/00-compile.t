use strict;
use warnings;

# This test was generated via Dist::Zilla::Plugin::Test::Compile 2.018

use Test::More 0.88;



use Capture::Tiny qw{ capture };

my @module_files = qw(
HTML/Widget/Factory.pm
HTML/Widget/Plugin.pm
HTML/Widget/Plugin/Attrs.pm
HTML/Widget/Plugin/Button.pm
HTML/Widget/Plugin/Checkbox.pm
HTML/Widget/Plugin/Image.pm
HTML/Widget/Plugin/Input.pm
HTML/Widget/Plugin/Link.pm
HTML/Widget/Plugin/Multiselect.pm
HTML/Widget/Plugin/Password.pm
HTML/Widget/Plugin/Radio.pm
HTML/Widget/Plugin/Select.pm
HTML/Widget/Plugin/Submit.pm
HTML/Widget/Plugin/Textarea.pm
);

my @scripts = qw(

);

# no fake home requested

my @warnings;
for my $lib (@module_files)
{
    my ($stdout, $stderr, $exit) = capture {
        system($^X, '-Mblib', '-e', qq{require q[$lib]});
    };
    is($?, 0, "$lib loaded ok");
    warn $stderr if $stderr;
    push @warnings, $stderr if $stderr;
}



is(scalar(@warnings), 0, 'no warnings found') if $ENV{AUTHOR_TESTING};



done_testing;
