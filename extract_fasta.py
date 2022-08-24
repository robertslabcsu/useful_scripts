from Bio import SeqIO                                                               
import argparse

parser = argparse.ArgumentParser()

parser.add_argument("-id",dest="id",help="List of IDs")
parser.add_argument("-f",dest="file",help="Big fasta")
parser.add_argument("-out",dest="out",help="Output",default="output.txt")
args = parser.parse_args()

def extract(ids,fasta,filtered):
    wanted = [line.strip() for line in open(ids)]
    seqiter = SeqIO.parse(open(fasta), 'fasta')
    SeqIO.write((seq for seq in seqiter if seq.id in wanted), filtered, "fasta")

extract(args.id,args.file,args.out)