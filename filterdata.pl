#!/bin/perl
my $outputFile=shift(@ARGV);
my %dataHash;
my @rs=qw(rs1801133	rs12762303	rs2259816	rs6538697	rs4769874	rs9579646	rs4646903	rs13306294	rs688	rs9818870	rs2569190	rs730012	rs10455872	rs3798220	rs2070744	rs662	rs705379	rs705381	rs854560	rs854572	rs1800977	rs2230806);
my @filters;

foreach $x (@ARGV){
	for ($y=0; $y<@rs; $y++){ 
		if($x eq @rs[$y]){
			push(@filters, $y);
		}
	}
}

open(DATF, "data.dat") || die "Can't find file $!";
print "Proccesing data.dat \n";
while(<DATF>){
	chomp $_; 
    my @fields=split(/\t/, $_);
    my $stringFields;

    #remove and store id
    my $id = shift(@fields);
	
	foreach $x (@filters){
		$stringFields.="\t".$fields[$x];	
	}
	$dataHash{$id}=$stringFields;
}
close(DATF);

open(ANOT, "anotations.dat") || die "Can't find file $!";
print "Proccesing anotations.dat \n";
while(<ANOT>){
	chomp $_;
    my @fields=split("\t", $_);
    
    #remove and store id
    my $id = shift(@fields);
   	if($fields[1] eq 1){
   		$fields[1]='M';
   	}
   	else{
   		$fields[1]='F';	
   	}
    my $stringFields=join("\t",@fields);
	$anotHash{$id}=$stringFields;
}
close(DATF);

open (OUTPD, '>>'.$outputFile);

my $argStr=join("\t",@ARGV);
print OUTPD "ID\tAge\tGender\tbmi\tStatus\t".$argStr."\n";

for (keys %dataHash) { 
	print OUTPD $_ . "\t" . $anotHash{$_} . "\t" . $dataHash{$_} . "\n";
}
print $outputFile. " is created succesfully. \n";
exit;