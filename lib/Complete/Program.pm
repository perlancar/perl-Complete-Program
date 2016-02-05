package Complete::Program;

# DATE
# VERSION

use 5.010001;
use strict;
use warnings;

use Complete::Common qw(:all);

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT_OK = qw(
                       complete_program
               );

our %SPEC;

$SPEC{':package'} = {
    v => 1.1,
    summary => 'Completion routines related to program names',
};

$SPEC{complete_program} = {
    v => 1.1,
    summary => 'Complete program name found in PATH',
    description => <<'_',

Windows is supported, on Windows PATH will be split using /;/ instead of /:/.

_
    args => {
        word     => { schema=>[str=>{default=>''}], pos=>0, req=>1 },
    },
    result_naked => 1,
    result => {
        schema => 'array',
    },
};
sub complete_program {
    require Complete::Util;

    my %args = @_;
    my $word     = $args{word} // "";

    my @dirs = split(($^O =~ /Win32/ ? qr/;/ : qr/:/), $ENV{PATH});
    my @all_progs;
    for my $dir (@dirs) {
        opendir my($dh), $dir or next;
        for (readdir($dh)) {
            push @all_progs, $_ if !(-d "$dir/$_") && (-x _);
        }
    }

    Complete::Util::complete_array_elem(
        word => $word, array => \@all_progs,
    );
}

1;
# ABSTRACT:

=head1 DESCRIPTION


=head1 SEE ALSO

L<Complete>

Other C<Complete::*> modules.
