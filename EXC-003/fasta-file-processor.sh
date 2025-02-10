if [ $1 = '-h' ]
then
        echo 'This programm accepts any FASTA file as a parameter, and produces a short report about its sequences, including their number, total length, length of the longest, length of the shortest, their average and finally their GC content (%)'
        exit

elif    [ $# -ne '1' ]
        then
                echo 'This program requires one and only one parameter (FASTA file)'
		exit

        elif  ! file $1 | grep -q 'ASCII text'
        then    echo 'This programm requires a FASTA file'
                exit

        elif    [[ "$(head -c 1 "$1")" != '>' ]]
        then
                echo 'The parameter should be a Fasta file'
                        exit

fi

#############

numseq=$(grep '>' $1  | wc -l)

lenseq=$(awk '/>/ {if (seq) print seq; print; seq=""; next} {seq=seq $0} END {print seq}' $1 | grep -v '>' | awk '{print length}' | awk ' {total += $1} END { print total }')

longestseq=$(awk '/>/ {if (seq) print seq; print; seq=""; next} {seq=seq $0} END {print seq}' $1 | grep -v '>' | awk '{print length}' | sort -n | tail -n 1)
shortestseq=$(awk '/>/ {if (seq) print seq; print; seq=""; next} {seq=seq $0} END {print seq}' $1 | grep -v '>' | awk '{print length}' | sort -n | head -n 1)
avgseq=$((lenseq/numseq))


C_count=$(grep -v '>' $1 | grep -o 'C' | wc -l)

G_count=$(grep -v '>' $1 | grep -o 'G' | wc -l)

A_count=$(grep -v '>' $1 | grep -o 'A' | wc -l)

T_count=$(grep -v '>' $1 | grep -o 'T' | wc -l)

GC=$((C_count+G_count))
AT=$((A_count+T_count))
both=$((GC+AT))

CG_percent=$(echo "scale=2; $GC / $both * 100" | bc -l )


echo "FASTA File Statistics:"
echo "----------------------"
echo "Number of sequences: $numseq"
echo "Total length of sequences: $lenseq"
echo "Length of the longest sequence: $longestseq"
echo "Length of the shortest sequence: $shortestseq"
echo "Average sequence length: $avgseq"
echo "GC Content (%): $(echo $CG_percent | awk 'BEGIN{FS="."}{print $1}')"
