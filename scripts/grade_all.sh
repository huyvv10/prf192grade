#!/bin/bash

total_score=0
total_tests=0

for q in Q*
do
  echo "===== $q ====="

  if [ ! -f "$q/main.c" ]; then
    echo "Missing main.c"
    continue
  fi

  gcc "$q/main.c" -o "$q/main"

  if [ $? -ne 0 ]; then
    echo "Compile Error"
    continue
  fi

  score=0
  total=$(ls $q/testcases/input*.txt 2>/dev/null | wc -l)

  for input in $q/testcases/input*.txt
  do
    id=$(basename $input | grep -o '[0-9]*')
    expected="$q/testcases/output$id.txt"

    "$q/main" < $input > output.txt

    diff -q output.txt $expected > /dev/null

    if [ $? -eq 0 ]; then
      echo "Test $id: PASS"
      score=$((score+1))
    else
      echo "Test $id: FAIL"
    fi
  done

  echo "Score $q: $score/$total"

  total_score=$((total_score + score))
  total_tests=$((total_tests + total))
done

echo "======================="
echo "FINAL SCORE: $total_score/$total_tests"
