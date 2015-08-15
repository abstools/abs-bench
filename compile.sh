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
   echo 'Compiling' ${file%.*} 'to haskell'; 
   absc -haskell -d gen/${file%.*}/haskell ${file} ; 
   cd gen/${file%.*}/haskell/ ; ./compile_main_module > /dev/null ; 
  done
done
