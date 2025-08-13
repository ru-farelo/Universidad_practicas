(*1*)
let f n = if n mod 2 = 0 then n / 2 else 3 * n + 1;;
(*2*)
let rec orbit n = if n = 1 then print_int 1
else (print_int n;print_string ", ";orbit (f n));;
(*3*)
let rec length n = if n = 1 then 0 else (+) 1 (length (f n));;
(*4*)
let rec top n = if n = 1 then 1 else max n (top (f n));;
(*5*)
let rec length'n'top n = if n = 1 then (0,1) else
let (length,top) = length'n'top(f n) in (length + 1, max top n);;
(*6*)
let rec longest_in n m = if n = m then m else
  let longest = longest_in (n+1) m in
  if length n >= length longest
then n else longest;;
(*7*)
let rec highest_in n m = if n = m then m else
 let highest = highest_in (n+1) m in
 if  length n <= length highest
then m else  highest ;;



