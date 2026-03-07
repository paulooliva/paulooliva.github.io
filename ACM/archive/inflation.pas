
{$I-}
program inflation;

Uses Crt;

Const cr=#13; lf=#10;

type sign=(pos,neg);
type ptr=^digit;
     digit=record
            l,r:ptr; (* left and right pointers *)
            d:byte;  (* digit                   *)
           end;
type bignum=record
             size:longint; (* number of digits                   *)
             s:sign;       (* signal                             *)
             msd:ptr;      (* pointer to most significant digit  *)
             lsd:ptr;      (* pointer to least significant digit *)
            end;

var n1,n2,res:bignum;
    operator:char;
    filein,fileout:text;

Procedure add_big(n1,n2:bignum; var r:bignum);
var aux,carry:integer;
    pa,pb,pn:ptr;
begin
(* first, determine the number that has more
   digits. The pointer pa points to it, and
   pb points to the other number *)
  if n1.size >= n2.size
  then begin
        r:=n1;
        pa:=n1.lsd;
        pb:=n2.lsd;
       end
  else begin
        r:=n2;
        pa:=n2.lsd;
        pb:=n1.lsd;
       end;
  carry:=0;
(* now, add the two numbers. The result is
   stored in pa, and the space used by pb
   is recycled after the digits are precessed *)
  repeat
    aux:=pa^.d+pb^.d+carry;
    if aux > 9
    then begin
          carry := 1;
          pa^.d:=aux-10;
         end
    else begin
          carry:=0;
          pa^.d:=aux;
         end;
    pn:=pb;
    pa:=pa^.l;
    pb:=pb^.l;
    if pn<>nil then dispose(pn);
 until pb=nil;
(* pb was processed. Now we have aditional digits
   in pa; process them while a carry is propagated *)
  while (carry=1) and (pa<>nil)
  do begin
       aux:=pa^.d+carry;
       if aux > 9
       then begin
             carry:=1;
             pa^.d:=aux-10;
            end
       else begin
             carry:=0;
             pa^.d:=aux;
            end;
       pa:=pa^.l;
     end;
(* pa was processed. See if we still have a carry, and
   add a new digit *)
  if carry=1
  then begin
        new(pn);
        r.msd^.l:=pn;
        pn^.d:=1;
        pn^.l:=nil;
        pn^.r:=r.msd;
        r.msd:=pn;
        r.size:=r.size+1;
       end;
end; (* big_add *)

Procedure sub_big(n1,n2:bignum; var r:bignum);
var aux,borrow:integer;
    pa,pb,pn:ptr;
begin
(* n1 is greater than n2 (or equal). The pointer
   pa points to n2, and pb points to n2 *)
  r:=n1;
  pa:=n1.lsd;
  pb:=n2.lsd;
  borrow:=0;
(* now, subtract the two numbers. The result is
   stored in pa, and the space used by pb
   is recycled after the digits are precessed *)
  repeat
     aux:=pa^.d-pb^.d-borrow;
     if aux < 0
     then begin
          borrow:=1;
          pa^.d:=aux+10;
          end
     else begin
          borrow:=0;
          pa^.d:=aux;
          end;
    pn:=pb;
    pa:=pa^.l;
    pb:=pb^.l;
    if pn<>nil then dispose(pn);
 until pb=nil;
(* pb was processed. Now we have aditional digits
   in pa; process them while a borrow is propagated *)
  while (borrow=1) and (pa<>nil)
  do begin
       aux:=pa^.d-borrow;
       if aux <0
       then begin
             borrow:=1;
             pa^.d:=aux+10;
            end
       else begin
             borrow:=0;
             pa^.d:=aux;
            end;
       pa:=pa^.l;
     end;
(* pa was processed. We never have a borrow out    *)
(* leading zeros are handled by the output routine *)
end; (* big_sub *)

Function greater(n1,n2:bignum):boolean;
var not_equal:boolean;
    p1,p2:ptr;
begin
  if n1.size<>n2.size
  then greater:=(n1.size > n2.size)
  else begin
        not_equal:=false;
        p1:=n1.msd;
        p2:=n2.msd;
        repeat
          if p1^.d=p2^.d
          then begin
                p1:=p1^.r;
                p2:=p2^.r;
              end
          else begin
                 not_equal:=true;
                 greater:=(p1^.d>p2^.d);
               end;
        until not_equal or (p1=nil);
        if (p1=nil) then greater:=true;
       end;
end; (* greater *)

Procedure add(n1,n2:bignum; var r:bignum);
(* Adds r := n2 + n1 *)
begin
  if n1.s=pos
  then begin
       if n2.s=pos
       then begin               (* n1 and n2 are positive *)
             add_big(n1,n2,r);
             r.s:=pos;
            end
       else begin               (* n1 is positive and n2 is negative *)
            if greater(n1,n2)          (* n1 >= n2 ? *)
            then begin
                  sub_big(n1,n2,r);
                  r.s:=pos;
                 end
            else begin
                  sub_big(n2,n1,r);
                  r.s:=neg;
                 end;
            end;
       end
  else begin
       if n2.s=neg
       then begin               (* n1 and n2 are negative *)
             add_big(n1,n2,r);
             r.s:=neg;
            end
       else begin               (* n1 is negative and n2 is positive *)
            if greater(n1,n2)          (* n1 >= n2 ? *)
            then begin
                  sub_big(n1,n2,r);
                  r.s:=neg;
                 end
            else begin
                  sub_big(n2,n1,r);
                  r.s:=pos;
                 end;
            end;
       end
end; (* add *)

Procedure read_char(var ch:char);
begin
  repeat
    read(filein,ch);
  until (ch<>cr) and (ch<>lf);
end;

Procedure read_num(var n:bignum);
var ch:char;
    aux:integer;
    size:longint;
    pn:ptr;
begin
 size:=0;
 read_char(ch);
 while ch=' ' do read_char(ch);
 if ch='-'
 then begin
       n.s:=neg;
       read_char(ch);
      end
 else n.s:=pos;
 if ch<>'#'
 then begin
        new(pn);
        n.msd:=pn;
        n.lsd:=pn;
        pn^.l:=nil;
        pn^.r:=nil;
        size:=1;          (* we have at least one digit *)
        pn^.d:=ord(ch)-ord('0');
        read_char(ch);
        while (ch<>'$')
        do begin
             size:=size+1;
             new(pn);
             n.lsd^.r:=pn;
             pn^.l:=n.lsd;
             pn^.r:=nil;
             pn^.d:=ord(ch)-ord('0');
             n.lsd:=pn;
             read_char(ch);
           end;
      end;
 n.size:=size;
end;  (* read_num *)

Procedure read_op(var op:char);
var ch:char;
begin
 read_char(ch);
 while ch=' ' do read_char(ch);
 operator:=ch;
end;

Procedure write_num(n:bignum);
var i:integer;
    zero:boolean;
    paux,pn:ptr;
(* Prints a number, from left (most significant
   digit) to right (least significant digit). This
   is done following the chain pointed by msd *)
begin
  zero:=true;
  pn:=n.msd;
  i:=0;
  if n.s=neg
  then begin
        write(fileout,'-');
        i:=1;
       end;
(* Skip leadind zeros *)
  while (pn^.d=0) and (pn<>n.lsd)
  do begin
      paux:=pn;
      pn:=pn^.r;
      dispose(paux);
     end;
(* now, print the number, 60 digits per row *)
  repeat
    write(fileout,pn^.d:1);
    i:=i+1;
    if i=60
    then begin
           writeln(fileout);
           i:=0;
         end;
    paux:=pn;
    pn:=pn^.r;
    if paux<>nil then dispose(paux);
  until pn=nil;
  if i>0 then writeln(fileout);
end;

begin
  assign(filein,'inflatio.in');
  reset(filein);
  assign(fileout,'inflatio.out');
  rewrite(fileout);

  repeat

(* read one number *)
    read_num(n1);
    if n1.size<>0
    then begin
(* read the operator and the second number *)
           read_op(operator);
           read_num(n2);
(* transform a subtraction in an addition,
   changing the sign from the second operand *)
           if operator='-'
           then if n2.s=pos
                then n2.s:=neg
                else n2.s:=pos;
(* Add the two numbers   *)
           add(n1,n2,res);
           write_num(res);
           writeln(fileout);
         end;
    until n1.size=0;
close(filein);
close(fileout);
end.
