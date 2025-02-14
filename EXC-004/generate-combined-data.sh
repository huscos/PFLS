if [  -d ./COMBINED-DATA ]; then
        rm -rf COMBINED-DATA
        mkdir COMBINED-DATA

    else mkdir COMBINED-DATA
fi

for dir in ./RAW-DATA/*/
do 
        MAG_COUNT=1
    BIN_COUNT=1

        for file in "$dir"bins/*.fasta
        do 
                XXX=$(grep "$(basename "$dir" /)" './RAW-DATA/sample-translation.txt' | awk '{print $2}')

        if [[ "$file" != "${dir}bins/bin-unbinned.fasta" ]] 
        then
                
                comp=$(grep "$(basename "$file" .fasta)" "${dir}/checkm.txt" |  awk '{print $13}')
                cont=$(grep "$(basename "$file" .fasta)" "${dir}/checkm.txt" |  awk '{print $14}')

                if (( $(echo "$comp >= 50.00" | bc -l) )) && (( $(echo "$cont <= 5.00" | bc -l) ))
                then
                        YYY="MAG"
                ZZZ=$(printf "%03d" $MAG_COUNT) 
                ((MAG_COUNT++))  
            else
                YYY="BIN"
                ZZZ=$(printf "%03d" $BIN_COUNT)
                ((BIN_COUNT++))  

                fi

                echo "${XXX}_${YYY}_${ZZZ}.fa"
                cp "$file" "./COMBINED-DATA/${XXX}_${YYY}_${ZZZ}.fa"


        fi

                if [[ "$file" == "${dir}bins/bin-unbinned.fasta" ]]
                then
                echo "${XXX}_UNBINNED.fa"

                cp "$file" "./COMBINED-DATA/${XXX}_UNBINNED.fa"
                
        fi


        done
  
for checkm in "$dir"checkm.txt
do
                XXX=$(grep "$(basename "$dir" /)" './RAW-DATA/sample-translation.txt' | awk '{print $2}')

                        echo "$XXX-CHECKM.txt"

                        cp "$checkm" "./COMBINED-DATA/${XXX}-CHECKM.txt"
        done

for gtdb in "$dir"gtdb.gtdbtk.tax
do
                XXX=$(grep "$(basename "$dir" /)" './RAW-DATA/sample-translation.txt' | awk '{print $2}')

                        echo "$XXX-GTDB-TAX.txt"

                        cp "$gtdb" "./COMBINED-DATA/${XXX}-GTDB-TAX.txt"
        done











done

for fa in ./COMBINED-DATA/*.fa
do
        FILENAME=$(basename "$fa" .fa)  # Extract filename without .fa
    awk -v prefix="$FILENAME" '{if ($0 ~ /^>/) print ">" prefix "_" sprintf("%05d", ++i); else print}' "$fa" > "$fa.tmp" && mv "$fa.tmp" "$fa"

done
