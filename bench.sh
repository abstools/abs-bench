#!/usr/bin/bash

DIRS="synthetic_seq synthetic_par"
BACKENDS="maude java erlang haskell"

twd=$PWD;

for backend in $BACKENDS; do
  echo "prog,exitstatus,realtime(s),usertime(s),systemtime(s),cpupercent,maxmemory(KB),contextswitches(forced), contextswitches(coop),pagefaults" > results_$backend.csv
done

for dir in $DIRS; do
   cd $twd
   for file in `ls $dir/*.abs`; do
    base=$(basename ${file%.abs})
    cd $twd/gen/$dir/$base/maude/
    echo 'Benchmarking' ${file%.*} 'for maude'; 
    /usr/bin/time -o $twd/results_maude.csv -a -f "${file%.*},%x,%e,%U,%S,%P,%M,%c,%w,%F" -- maude run.maude <<< "rew start ." > ${base}.stdout 2> ${base}.stderr
    cd $twd/gen/$dir/$base/java/
    echo 'Benchmarking' ${file%.*} 'for java'; 
    /usr/bin/time -o $twd/results_java.csv -a -f "${file%.*},%x,%e,%U,%S,%P,%M,%c,%w,%F" -- java -Xss10m ${base}.Main > ${base}.stdout 2> ${base}.stderr
    cd $twd/gen/$dir/$base/erl/
    echo 'Benchmarking' ${file%.*} 'for erlang'; 
    /usr/bin/time -o $twd/results_erlang.csv -a -f "${file%.*},%x,%e,%U,%S,%P,%M,%c,%w,%F" -- ./run > ${base}.stdout 2> ${base}.stderr;
    cd $twd/gen/$dir/$base/haskell/
    echo 'Benchmarking' ${file%.*} 'for haskell'; 
    /usr/bin/time -o $twd/results_haskell.csv -a -f "${file%.*},%x,%e,%U,%S,%P,%M,%c,%w,%F" -- ./run -t > ${base}.stdout 2> ${base}.stderr;
   done
done
