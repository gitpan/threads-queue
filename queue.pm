package threads::queue;

use 5.7.2;
use strict;
use warnings;

use threads::shared;

our $VERSION = '0.01';

sub new {
    my $class = shift;
    my @self;
    tie @self, 'threads::shared';
    @self = @_;
    return bless \@self, $class;
}

sub dequeue {
    my $q = shift;
    lock($q);
    cond_wait $q until @$q;
    my $return = shift @$q;
    unlock($q);
    return $return;
}

sub dequeue_nb {
    my $q = shift;
    my $return;
    lock($q);
    if (@$q) {
        $return = shift @$q;
    } else {
	$return = undef;
    }
    unlock($q);
    return $return;
}

sub enqueue {
    my $q = shift;
    lock($q);
    push(@$q, @_) and cond_broadcast $q;
    unlock($q);
}

sub pending {
    my $q = shift;
    lock($q);
    my $return = @$q;
    unlock($q);
    return $q;
}





1;

# Below is stub documentation for your module. You better edit it!

=head1 NAME

threads::queue - thread queue

=head1 SYNOPSIS

  use threads::queue;
  my $queue = threads::queue->new("entry1", 4, 20);
  $queue->enqueue("bar");
  my $entry = $queue->dequeue();
  my $entry = $queue->dequeue_nb();
  my $entries = $queue->pending();  

=head1 ABSTRACT

This module implments a threadsafe queue.

=head1 DESCRIPTION

This module implements a threadsafe queue.


=head1 SEE ALSO

threads::shared

=head1 AUTHOR

Arthur Bergman, arthur at contiller.se

=head1 COPYRIGHT AND LICENSE

Copyright 2001 by Arthur Bergman

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself. 

=cut
