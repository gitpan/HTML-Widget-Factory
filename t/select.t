#!perl -T
use Test::More 'no_plan';
use HTML::TreeBuilder;

BEGIN { use_ok("HTML::Widget::Factory"); }

my $widget = HTML::Widget::Factory->new;

isa_ok($widget, 'HTML::Widget::Factory');

can_ok($widget, 'select');

{ # make a select field with AoA options
  my $html = $widget->select({
    options => [
      [ minty => 'Peppermint',     ],
      [ perky => 'Fresh and Warm', ],
      [ super => 'Red and Blue',   ],
    ],
    name  => 'flavor',
    value => 'minty',
  });

  my $tree = HTML::TreeBuilder->new_from_content($html);
  
  my ($select) = $tree->look_down(_tag => 'select');

  isa_ok($select, 'HTML::Element');

  is(
    $select->attr('name'),
    'flavor',
    "got correct input name",
  );
}

{ # make a select field with hash options
  my $html = $widget->select({
    options => {
      minty => 'Peppermint',
      perky => 'Fresh and Warm',
      super => 'Red and Blue',
    },
    name  => 'flavor',
    value => 'minty',
  });

  my $tree = HTML::TreeBuilder->new_from_content($html);
  
  my ($select) = $tree->look_down(_tag => 'select');

  isa_ok($select, 'HTML::Element');

  is(
    $select->attr('name'),
    'flavor',
    "got correct input name",
  );

  my @options = $select->look_down(_tag => 'option');

  is(@options, 3, "we created three options");
  
  my @selected = $select->look_down(sub { $_[0]->attr('selected') });

  is(@selected, 1, "only one option is selected");

  is(
    $selected[0]->attr('value'),
    'minty',
    "the selected one is the one we wanted to be selected",
  );
}

{ # make a select field with hash options
  my $html = $widget->select({
    options  => [ qw(red orange yellow green blue indigo violet) ],
    name     => 'color',
    disabled => 'yup',
  });

  my $tree = HTML::TreeBuilder->new_from_content($html);
  
  my ($select) = $tree->look_down(_tag => 'select');

  isa_ok($select, 'HTML::Element');

  is(
    $select->attr('name'),
    'color',
    "got correct input name",
  );

  is(
    $select->attr('disabled'),
    'disabled',
    "disabled set true as a bool",
  );

  my @selected = $select->look_down(sub { $_[0]->attr('selected') });

  is(@selected, 0, "we didn't pre-select anything");
}
