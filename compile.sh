DIRS="synthetic_seq synthetic_par"

twd=$PWD

for dir in $DIRS; do
  cd $twd
  for file in `ls ${dir}/*.abs`; do
   cd $twd
   mkdir -p gen/${file%.*}/maude; 
   echo 'Compiling' ${file%.*} 'to maude'; 
   absc -maude ${file} -o gen/${file%.*}/maude/run.maude ; 
   mkdir -p gen/${file%.*}/java; 
   echo 'Compiling' ${file%.*} 'to java'; 
   absc -java -d gen/${file%.*}/java ${file} ; 
   echo 'Compiling' ${file%.*} 'to erlang'; 
   absc -erlang $file ; 
   rm -rf gen/${file%.*}/erl; 
   mv gen/erl gen/${file%.*}; 
   if [[ $dir =~ _par$ ]]; then
       echo 'Compiling' ${file%.*} 'to haskell (SMP)'; 
       absc -haskell --smp -d gen/${file%.*}/haskell ${file} ; # enable smp for haskell
   else
       echo 'Compiling' ${file%.*} 'to haskell'; 
       absc -haskell -d gen/${file%.*}/haskell ${file} ; 
   fi;
   cd gen/${file%.*}/haskell/ ; ./compile_main_module > /dev/null ; 
  done
done
