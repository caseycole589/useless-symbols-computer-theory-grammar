use 5.020;
use strict;
use warnings;
use Data::Dumper; #for printing hash of array elements

open(my $file, '<', 'input.txt') or die 'cant open the file for some reason';
my (%useless,@terminal,$starting_input,%hash);
$starting_input = 1;

while (<$file>){
   	#split key and value by regex first word any about of space then --> 
	#plus any amount of space then word 
	chomp($_); #get rid of newline	
	my ($key, $value) = split /\s*-->\s*/,$_,2;
	next if  $key eq "";  	

	#show the original
    say "key $key --> $value"; 

	$key =~ s/^\s+//; #remove white space
	$starting_input = $key if $starting_input == 1;
	
	#going to try to make  hashes with array elements 
	push @{$hash{$key}}, $value;   		
}
#print out resulting hash in the form of Key => all the assosiated with it;
print Dumper \%hash;


#step one get rid of sybmols thant dont dervie terminal string


#iterate through the keys
for my $key (keys %hash){
	#print "$key";
	check_for_keys_not_reachable ($key,%hash);
	for my $value ( @{$hash{$key}} ){
		#splits all values by , : " " puts them in array
		my @values_check = split /[,]|[:]|[" "]/,$value;
		#push single values
		push @terminal, $values_check[0] if @values_check == 1;
	}	
}
remove_useless_decend();

#get rid of now able to get decendants
sub remove_useless_decend{
	for my $key (keys %useless){
		for my $values (@{$useless{$key}}){
			my @values_check = split /[,]|[:]|[" "]/,$values;
			for my $var (@values_check){
				if(exists $hash{$var}){
					push @{$useless{$var}}, @{$hash{$var}};
					delete $hash{$var};
					delete $hash{$key};
				}
			}
		}
	}
}

sub check_for_keys_not_reachable {
	my $check_key = shift;
	my %check_hash = @_;
	my $count = 0;

	for my $key (keys %check_hash) {
		for my $value (@{$check_hash{$key}}) {
			#if key occurs in any values add to count
     		$count += 1 if index($value, $check_key) != -1;
		}
	}

	#check for whether its the starting input
	if($count == 0) {
		if ($check_key ne $starting_input) {
			push @{$useless{$check_key}}, @{$check_hash{$check_key}};
		}
	}
}
