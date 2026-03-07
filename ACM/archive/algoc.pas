{$I-}
program algoc;

Uses Crt;

type bt=array[1..32] of boolean;

var n,i:integer;
    bits:bt;
    num_bits:integer;
    arqin,arqout:text;

(* This is not an efficient or a beautiful program - it is
   a didatic one.

   We known that a computer represents number in two's complement:

              n-1         n-2               2
   n =  b   .2    + b   .2    + ... + b .2  + b .2 + b
         n-1         n-2                 2       1      0

   or, replacing the powers of two by multiplication by two


   n = (( ... ((b   .2+b   ).2+b   )+ ... +b ).2+b ).2 + b
                 n-1    n-2     n-3         2     1       0

   Thus, if n=16 then we have for example
         0000000000000101 for 5,
         0000000000001011 for 11
         0111111111111111 for 32767

   Negative numbers are represented in two's complement

            n
   - a  =  2  - |a|


   And if n=16 then we have, for example
       -1 = 65536 - 1 = 65535 = 1111111111111111
       -2 = 65536 - 2 = 65534 = 1111111111111110
   -32768 = 65536 - 32768 = 32768 = 1000000000000000


   In our case, we are interessed in the minimal number of
   bits needed to represent the number, and thus the leading
   signal bits (zeros if the number is positive or all
   leading ones except the rightmost if the number is negative)
   can be ignored, and thus we have the following
   examples (with signal bits replaced by
   a dot :

   1  = ...............1
   5  = .............101
   7  = .............111
   11 = ............1011
   -1 = ...............1
   -2 = ..............10
   -5 = ............1011
-32768= 1000000000000000

    We use the above representation to write the ALGOC
    program. If the minimal representation needs n bits,
    then we have n-1 DUP operations. We only have to
    determine the INC operations (one for each bit that
    is set, except the leftmost one - this bit is handled
    by the PLUSONE / MINUSONE instruction)
                                                  *)

Procedure convert(n:integer;var nb:integer;var bts:bt);
begin
  nb:=0;
  while (n<>-1) and (n<>1)
  do begin
     nb:=nb+1;
     if (n mod 2)=0
     then bts[nb]:=false
     else begin
          bts[nb]:=true;
          n:=n-1;   (* revert the effect of the INC operation *)
          end;
     n:=n div 2;
     end;
end;

begin
  assign(arqin,'algoc.in');
  reset(arqin);
  assign(arqout,'algoc.out');
  rewrite(arqout);

  repeat

(* read one number *)
    readln(arqin,n);

(* if not zero, process it *)
    if n<>0
    then begin
         writeln(arqout,'Constant ',n);

         convert(n,num_bits,bits);


         if n<0
         then writeln(arqout,'MINUSONE')
         else writeln(arqout,'PLUSONE');


         for i:=num_bits downto 1
         do begin
            writeln(arqout,'DUP');
            if bits[i] then writeln(arqout,'INC');
            end;

         writeln(arqout);

         end;
  until n=0;
close(arqin);
close(arqout);
end.

