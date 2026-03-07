program museum;

Uses Crt;

type mus=array[1..100,1..100]
         of record  w:boolean; (* true if has a work from the artist *)
                    v:integer; (* shortest path to this point;
                                  add one if a exchanged has ocurred *)
                    end;
     path=array[1..5000]       (* if we have 10000 points,
                                  this is the longest path possible *)
         of record px,py:byte; end;

var m:mus;                     (* the museum *)
    p,pa:path;                 (* working path and best path *)
    pt,                        (* pointer to path list *)
    works,                     (* number of works from the desired artist *)
    count,                     (* number of works in the current path *)
    pa_count:integer;          (* number of works in the best path *)
    found,                     (* if a path exists or not *)
    changed,                   (* if a change ocurred in the current path *)
    pa_changed:boolean;        (* if a change ocurred in the best path *)
    cx,cy,                     (* coordinates of the change in curr. path *)
    pa_cx,pa_cy:byte;          (* coordinates of the change in best path *)
    X,Y,pX,pY:byte;            (* dimensions of the museum *)
    file_in,file_out:text;     (* input and output files *)
    work:char;                 (* character of the desired artist *)

Procedure read_museum;
var aux:char;
    i,j:integer;
Begin
    for j:=1 to Y          (* clear the museum *)
    do for i:=1 to X
       do begin
          m[i,j].w:=false;
          m[i,j].v:=10001; (* the initial path value is an impossible one;
                              it is bigger than the museum *)
          end;
    works:=0;

    for j:=Y downto 1
    do begin
       for i:=1 to X
       do begin
          read(file_in,aux);   (* read a character                    *)
          if (aux=work)        (* updates the museum if it is from    *)
          then begin           (* the artist                          *)
               m[i,j].w:=true;
               works:=works+1;
               end;
          end;
       readln(file_in);
       end;

(* Just a debug routine to see if we are reading correct *)
(*  writeln(file_out,X,' ',Y,' --> ',works);
    for j:=Y downto 1
    do begin
       for i:=1 to X
       do if m[i,j].w then write(file_out,'o')
                      else write(file_out,'.');
       writeln(file_out);
       end;   *)
End;

Procedure search_path(count,pt,posX,posY:integer;exch:boolean);
var i:integer;
begin
  if exch               (* If we are trying an exchange,  *)
  then begin            (* record its position in cx, cy  *)
       changed:=true;   (* and add a penalty of one       *)
       cx:=posX;        (* to the path (var. count)       *)
       cy:=posY;
       count:=count+1;
       end;

  pt:=pt+1;              (* add point to the currect path          *)
  p[pt].px:=posX;
  p[pt].py:=posY;
  m[posX,posY].v:=count; (* shortest path to this point, until now *)

  if (posX<X)            (* if not in the last column, prepare     *)
  then count:=count+1;   (* for the next column                    *)

  if (posX=X)            (* we reached the last column             *)
  then begin             (* let's see if we found a better path    *)
       if (count < pa_count)
          and
          (not(changed) or
          (changed and (count<=works))  (* if we exchange, we must have *)
          )                             (* enough works from the artist *)
       then begin        (* found a better path than the current one    *)
            found:=true;
            for i:=1 to pt do pa[i]:=p[i];
            pa_count:=count;
            pa_changed:=changed;
            if changed
            then begin
                 pa_cx:=cx;
                 pa_cy:=cy;
                 end;
            end;
       end
  else begin   (* posX < X *)

  (* We do a recursive search, until we reach the last column or a *)
  (* dead end. It doesn't care which one ends the recursion,       *)
  (* because every time we reach the last column we test the path  *)
  (* against the current "best path".                              *)
  (* The recursion ensures that we test every path.                *)

  (* To avoid testing a path multiple times, each square has a     *)
  (* "reachability" value (v). We only test a path again if our    *)
  (* current value (count) is better (lower) than the reachability *)
  (* for a given square.                                           *)

  (* We search for a path in four directions: forward (X+1),       *)
  (* upward (Y+1), downward (Y-1) and backward (X-1). Note that    *)
  (* the reachability value prevents us from testing the square    *)
  (* we came from.                                                 *)

       if posX<X
       then if m[posX+1,posY].w  (* has a work from the artist ?  *)
            then begin           (* yes, try the path             *)
                 if (m[posX+1,posY].v>count)
                 then search_path(count,pt,posX+1,posY,false)
                 end
            else if not(changed)  (* no, try an exchange          *)
                 then search_path(count,pt,posX+1,posY,true);

       if (posX>1)
       then if m[posX-1,posY].w
            then begin
                 if (m[posX-1,posY].v>count)
                 then search_path(count,pt,posX-1,posY,false)
                 end
            else if not(changed)
                 then search_path(count,pt,posX-1,posY,true);

       if (posY<Y)
       then if m[posX,posY+1].w
            then begin
                 if (m[posX,posY+1].v>count)
                 then search_path(count,pt,posX,posY+1,false);
                 end
            else if not(changed)
                 then search_path(count,pt,posX,posY+1,true);

       if (posY>1)
       then if m[posX,posY-1].w
            then begin
                 if (m[posX,posY-1].v>count)
                 then search_path(count,pt,posX,posY-1,false);
                 end
            else if not(changed)
                 then search_path(count,pt,posX,posY-1,true);

       end;  (* posX < X *)

  (* if we tried a path with an exchange, undo this exchange, *)
  (* because the recursion has already tested all possible    *)
  (* paths derived from this exchange.                        *)
  if exch then changed:=false;

end; (* search_path *)

Procedure find_path;
var i,j,pbx,pby:integer;
Begin
  found:=false;
  pa_count:=5001; (* we begin with an impossible path *)

  if works<Y      (* first, let's see if we have enough works *)
  then writeln(file_out,'No path')
  else begin
       for pY:=Y downto 1  (* search in the first column *)
       do begin
          pX:=1;
          pt:=0;
          count:=0;
          if m[1,pY].w
          then begin       (* found a work, try the path *)
               changed:=false;
               search_path(count,pt,pX,pY,false);
               end
          else begin       (* no work, try an exchange   *)
               search_path(count,pt,pX,pY,true);
               end;
          end;

       if found
       then begin
            if pa_changed
            then begin
                   for i:=1 to pa_count
                   do m[pa[i].px,pa[i].py].w:=false;
                   for i:=1 to X
                   do for j:=1 to Y
                      do if m[i,j].w
                         then begin
                               pbx:=i;
                               pby:=j;
                              end;
                   write(file_out,'Exchange (',pa_cx,',',pa_cy,') ');
                   writeln(file_out,'and (',pbx,',',pby,')');
                 end
            else begin
                   writeln(file_out,'No exchange');
                   pa_count:=pa_count+1;
                 end;
            for i:=1 to pa_count
            do writeln(file_out,pa[i].px,' ',pa[i].py)
            end
       else writeln(file_out,'No path');
       end;

(* For debug purpouses - the reachability values *)
(*  writeln(file_out,X,' ',Y,' --> ',works);
    for j:=Y downto 1
    do begin
       for i:=1 to X
       do if m[i,j].v < 10001
          then write(file_out,m[i,j].v:5)
          else write(file_out,' xxxx');
       writeln(file_out);
       end;  *)

    writeln(file_out);
End; (* find_path *)

Begin
assign(file_in,'museum.in');
reset(file_in);
assign(file_out,'museum.out');
rewrite(file_out);
repeat
   readln(file_in,X,Y);
   if (X<>0) or (Y<>0)
   then begin
          readln(file_in,work);
          read_museum;
          find_path;
        end;
until (X=0) and (Y=0);
close(file_in);
close(file_out);
End.

