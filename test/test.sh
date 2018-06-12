for folder in test/*/; do
    for filename in $folder*.lgl; do
        echo $filename
        cat $filename | jbuilder exec bin/ex.bc a > "${filename%.*lgl}.out"
    done
done
for folder in test/fails/*/; do
    for filename in $folder*.lgl; do
        echo $filename
        cat $filename | jbuilder exec bin/ex.bc 2> "${filename%.*lgl}.out"
    done
done