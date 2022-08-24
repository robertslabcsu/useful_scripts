#!/usr/bin/env bash

for line in *.fna
do
    java -jar AnnoTALEcli-1.5.jar predict g="$line" outdir="tales_$line"
done

for line in tales_*/TALE_DNA_sequences.fasta
do
    newline=$(echo "$line" | cut -f 1 -d "/")
    mv $line $newline
done

### Next part is for TALE class assign

for line in *.fasta
do
    java -jar AnnoTALEcli-1.5.jar assign c=class_build.xml t="$line" outdir="assign_$line"
done
