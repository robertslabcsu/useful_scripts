def sequence_parser(input_file, output_file):
    try:
        fin = open(input_file)
        fout = open(output_file,'w')
    except:
        return -1
    with fin,fout:
        d = {}
        for line in fin:
            line = line.rstrip().split(",")
            fout.write(f">{line[0]}\n{line[1]}\n")
            
sequence_parser("co236_typeIII_proteins.csv","co236_typeIII_proteins.fasta")
sequence_parser("co237_typeIII_proteins.csv","co237_typeIII_proteins.fasta")
