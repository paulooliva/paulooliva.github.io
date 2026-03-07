program Parasutista(input,output);

(*
  RUN AWAY!
  CERC 1999, Martin Straka
*)

const MAX   = 30000;
      PI    = 3.141592653589793238;
      BOUND = 1000000;

type TPoint = record
      x,y   : Real;
     end;

type TEdge  = record
      s,e      : TPoint;
      TSum     : integer;
      triangle : array[0..4] of Integer;
     end;

var P1,P2,P3    : array[1..MAX] of TPoint;
    Edge        : array[1..MAX] of TEdge;
    ESum        : Integer;
    Sum         : Integer;
    pp1,pp2,pp3,pp4 : TPoint;
    id          : Integer;
    i           : Integer;
    a,b,c,temp,
    min         : TPoint;
    k,k1,y,x    : Real;
    points      : array[0..MAX] of TPoint;
    mpoints     : array[0..MAX] of TPoint;
    Psum        : Integer;
    N           : Integer;
    I1,I2,M     : Integer;
    BX,BY       : Integer;
    B2X,B2Y	: Integer;
    MPoint      : TPoint;
    MDist,D     : Real;

(* ------------------------------------------------------------- *)

function Distance(P1,P2 : TPoint) : Real;
begin
 Distance := sqrt((P1.x-P2.x)*(P1.x-P2.x) + (P1.y-P2.y)*(P1.y-P2.y));
end;

(* ------------------------------------------------------------- *)

function FindEdge(s,e : TPoint) : Integer;
var i,j  : Integer;
    temp : TPoint;
label FE;
begin
 if (e.y<s.y) then
  begin
   temp:=s; s:=e; e:=temp;
  end;
 if (s.y = e.y) then
  begin
   if (s.x>e.x) then
    begin
     temp:=s; s:=e; e:=temp;
    end;
  end;

 FindEdge := -1;

 for i:=0 to ESum-1 do
  begin
   if (Edge[i].s.x = s.x) and (Edge[i].e.x = e.x) then
   if (Edge[i].s.y = s.y) and (Edge[i].e.y = e.y) then
    begin
     FindEdge:=i;
     (* Exit; *)
     goto FE;
    end;
  end;
 FE:
end;

(* ------------------------------------------------------------- *)

procedure AddEdge(s,e : TPoint; TriIndex : Integer);
var i,j  : Integer;
    temp : TPoint;
begin
 i:=FindEdge(s,e);
 if (i <> -1) then
  begin
   Edge[i].triangle[edge[i].TSum] := TriIndex;
   Edge[i].TSum                   := Edge[i].TSum+1;
  end
  else
   begin
    if e.y < s.y then
     begin
      temp:=s; s:=e; e:=temp;
     end;
    if (s.y = e.y) then
     if (s.x>e.x) then
      begin
       temp:=s; s:=e; e:=temp;
      end;

    Edge[ESum].s.x         := s.x;
    Edge[ESum].s.y         := s.y;
    Edge[ESum].e.x         := e.x;
    Edge[ESum].e.y         := e.y;
    Edge[ESum].TSum        := 1;
    Edge[ESum].triangle[0] := TriIndex;
    ESum := ESum + 1;
   end;
end;

(* ------------------------------------------------------------- *)

procedure DeleteEdge(s,e : TPoint; TriIndex : Integer);
var i,j  : Integer;
    temp : TPoint;
begin
 i:=FindEdge(s,e);
 if (i <> -1) then
  begin
   for j:=0 to Edge[i].TSum-1 do
    begin
     if Edge[i].triangle[j] = TriIndex then
      begin
       Edge[i].TSum        := Edge[i].TSum - 1;
       Edge[i].triangle[j] := Edge[i].triangle[Edge[i].TSum];
       if Edge[i].TSum = 0 then
        begin
         ESum    := ESum-1;
         Edge[i] := Edge[ESum];
        end;
      end;
    end;
  end;
end;

(* ------------------------------------------------------------- *)

procedure AddTriangle(Index : Integer);
begin
 AddEdge(P1[Index],P2[Index],Index);
 AddEdge(P1[Index],P3[Index],Index);
 AddEdge(P2[Index],P3[Index],Index);
end;

(* ------------------------------------------------------------- *)

procedure DeleteTriangle(Index : Integer);
begin
 DeleteEdge(P1[Index],P2[Index],Index);
 DeleteEdge(P1[Index],P3[Index],Index);
 DeleteEdge(P2[Index],P3[Index],Index);
end;

(* ------------------------------------------------------------- *)

function Cross(x1,y1,x2,y2 : Real) : Integer;
var v : Real;
label CE;
begin
 v := x1*y2-x2*y1;
 Cross := 1;
 if (abs(v) < 0.0001) then
  begin
   Cross := 0;
   (* Exit; *)
   goto CE;
  end;

 if (v<0) then
  begin
   Cross := -1;
   (* Exit; *)
   goto CE;
  end;
CE:
end;

(* ------------------------------------------------------------- *)

function Theta(x,y : Real) : Real;
var Angle : Real;
begin
 if y = 0 then
  begin
   Theta := 0;
  end
   else
    begin
     Angle := ArcTan(x/y);
     while (Angle<0) do     Angle := Angle+PI*2;
     while (Angle>=PI*2) do Angle := Angle-PI*2;
     Theta := Angle;
    end;
end;

(* ------------------------------------------------------------- *)

procedure Add1(Index : Integer;pp1,pp2,pp3 : TPoint);
var i    : Integer;
    tp1,
    tp2,
    tp3,
    temp : TPoint;
begin
 tp1 := pp1; tp2 := pp2; tp3 := pp3;
(*
 writeln('add1-pp1',pp1.x:20:5,pp1.y:20:5);
 writeln('add1-pp2',pp2.x:20:5,pp2.y:20:5);
 writeln('add1-pp3',pp3.x:20:5,pp3.y:20:5);
*)

 if tp2.y >= tp1.y then
  begin
   if ((tp2.y = tp1.y) and (tp2.x < tp1.x)) or (tp2.y > tp1.y) then
    begin
     temp:=tp2;tp2:=tp1;tp1:=temp;
    end;
  end;
 if tp3.y >= tp1.y then
  begin
   if ((tp3.y = tp1.y) and (tp3.x < tp1.x)) or (tp3.y > tp1.y) then
    begin
     temp:=tp3;tp3:=tp1;tp1:=temp;
    end;
  end;

 if theta(tp2.x-tp1.x,tp2.y-tp1.y) > theta(tp3.x-tp1.x,tp3.y-tp1.y) then
  begin
   temp:=tp3;tp3:=tp2;tp2:=temp;
  end;

 if (Index<Sum) then DeleteTriangle(Index);
 P1[Index] := tp1;
 P2[Index] := tp2;
 P3[Index] := tp3;

(*
 writeln('add1',tp3.x:10:1,tp3.y:10:1);
*)
 AddTriangle(Index);
end;

(* ------------------------------------------------------------- *)

procedure Add2(pp1,pp2,pp3 : TPoint);
var i    : Integer;
    tp1,
    tp2,
    tp3,
    temp : TPoint;
begin
 tp1 := pp1; tp2 := pp2; tp3 := pp3;
(*
 writeln('add2-pp1',pp1.x:20:5,pp1.y:20:5);
 writeln('add2-pp2',pp2.x:20:5,pp2.y:20:5);
 writeln('add2-pp3',pp3.x:20:5,pp3.y:20:5);
*)

 if tp2.y >= tp1.y then
  begin
   if ((tp2.y = tp1.y) and (tp2.x < tp1.x)) or (tp2.y > tp1.y) then
    begin
     temp:=tp2;tp2:=tp1;tp1:=temp;
    end;
  end;
 if tp3.y >= tp1.y then
  begin
   if ((tp3.y = tp1.y) and (tp3.x < tp1.x)) or (tp3.y > tp1.y) then
    begin
     temp:=tp3;tp3:=tp1;tp1:=temp;
    end;
  end;

 if theta(tp2.x-tp1.x,tp2.y-tp1.y) > theta(tp3.x-tp1.x,tp3.y-tp1.y) then
  begin
   temp:=tp3;tp3:=tp2;tp2:=temp;
  end;

 P1[Sum] := tp1;
 P2[Sum] := tp2;
 P3[Sum] := tp3;

 AddTriangle(Sum);
 Sum := Sum+1;
end;

(* ------------------------------------------------------------- *)

function Inside(p:TPoint) : Integer;
var i : Integer;
label IE;
begin
 Inside := -1;

 for i:=0 to Sum-1 do
  begin
   if Cross(P2[i].x-P1[i].x,P2[i].y-P1[i].y, p.x-P2[i].x, p.y-P2[i].y)<=0 then
   if Cross(P3[i].x-P2[i].x,P3[i].y-P2[i].y, p.x-P3[i].x, p.y-P3[i].y)<=0 then
   if Cross(P1[i].x-P3[i].x,P1[i].y-P3[i].y, p.x-P1[i].x, p.y-P1[i].y)<=0 then
    begin
     Inside := i;
    (* Exit; *)
     goto IE;
    end;
  end;
 IE:
end;

(* ------------------------------------------------------------- *)

procedure FindCenter(d,e,f : TPoint; var ret : TPoint);
var dx1,dx2,dy1,dy2 : Real;
    a,b,c,p,q,r     : Real;
    temp            : TPoint;
label FCE;
begin
 dx1 := e.x - d.x;
 dy1 := e.y - d.y;

 
 if (dx1 <> 0) and (dy1 <> 0) then
  begin
   a := dx1; b := dy1;
   c := -a*((e.x+d.x)/2)-b*((e.y+d.y)/2);
  end
  else if dx1 <> 0 then
   begin
    b:=0; a:=1; c:=-(e.x+d.x)/2;
   end
   else
    begin
     a:=0; b:=1; c := -(e.y+d.y)/2;
    end;

 dx2 := f.x-e.x;   dy2 := f.y-e.y;
 if (dx2<>0) and (dy2 <> 0) then
  begin
   p := dx2; q := dy2;
   r := -p*((e.x+f.x)/2)-q*((e.y+f.y)/2);
  end
  else
   if dx2 <> 0 then
    begin
     q:=0; p:=1; r := -(e.x+f.x)/2;
    end
     else
      begin
       p:=0; q:=1; r := -(e.y+f.y)/2;
      end;

 if abs(a*q-b*p)<0.0001 then 
  begin
   ret.x:=0;
   ret.y:=0;
  end
   else 
    begin
     ret.x := (b*r-c*q)/(a*q-b*p);
     ret.y := (c*p-a*r)/(a*q-b*p);
    end;
    
 FCE:
end;

(* ------------------------------------------------------------- *)

procedure Balance(s,e : TPoint);
var Index       : Integer;
    ret,temp    : TPoint;
    center      : TPoint;
    i,j,id1,id2 : Integer;
    p,q         : array[0..2] of TPoint;
begin
 Index:=FindEdge(s,e);
 if Index <> -1 then
  begin
   if Edge[Index].TSum = 2 then
    begin
     id1 := edge[index].triangle[0];
     id2 := edge[index].triangle[1];

     p[0]:=p1[id1]; p[1]:=p2[id1]; p[2]:=p3[id1];
     q[0]:=p1[id2]; q[1]:=p2[id2]; q[2]:=p3[id2];

     for i:=1 to 2 do
      begin
       if (p[i].x = s.x) and (p[i].y = s.y) then
        begin
         temp:=p[0];p[0]:=p[i];p[i]:=temp;
        end;
       if (q[i].x = s.x) and (q[i].y = s.y) then
        begin
         temp:=q[0];q[0]:=q[i];q[i]:=temp;
        end;
      end;

     for i:=2 to 2 do
      begin
       if (p[i].x = e.x) and (p[i].y = e.y) then
        begin
         temp:=p[1];p[1]:=p[i];p[i]:=temp;
        end;
       if (q[i].x = e.x) and (q[i].y = e.y) then
        begin
         temp:=q[1];q[1]:=q[i];q[i]:=temp;
        end;
      end;

      FindCenter(p[0],p[1],p[2],center);
      if Distance(center,p[0]) > Distance(center,q[2]) then
       begin
	Add1(id1,p[0],p[2],q[2]);
	Add1(id2,p[1],p[2],q[2]);

	Balance(p[0],p[2]);
	Balance(p[1],p[2]);
	Balance(q[0],q[2]);
	Balance(q[1],q[2]);
      end;

    end;
  end;
end;

(* ------------------------------------------------------------- *)

procedure Put(X,Y:Real);
var i : Integer;
label PE;
begin
 if (X<0) or (X>BX) or (Y<0) or (Y>BY) then goto PE;
 (* Exit;*)

 for i:=0 to PSum-1 do
  begin
   if (points[i].x = X) and (points[i].y = Y) then
    (* Exit; *)
    goto PE;
  end;

 points[PSum].x:=X;
 points[PSum].y:=Y;
 PSum:=PSum+1;
 PE:
end;

(* ------------------------------------------------------------- *)

function MinDistance( P : TPoint): Real;
var ii    : integer;
    D,MD : Real;
begin
 MD:=1000000000;
 for ii:=0 to M-1 do
  begin
   D := Distance(P,MPoints[ii]);
   if (D<MD) then MD:=D;
  end;
 MinDistance:=MD;
end;

(* ------------------------------------------------------------- *)

begin
 Readln(N);
 for I1:=1 to N do
 begin
  Readln(BX,BY,M);

  (* --- triangle init ----- *)

  ESum:=0;
  Sum :=0;
  PSum:=0;

  pp1.x:= BOUND;    pp1.y:=-1*BOUND;
  pp2.x:=-1*BOUND;  pp2.y:= BOUND;
  pp3.x:= BOUND;    pp3.y:= BOUND;

  Add2(pp1,pp2,pp3);

  i:=0;
  for I2:=1 to M do
   begin
    Readln(pp1.x,pp1.y);
    pp4:=pp1;
    
    MPoints[i]:=pp1;
    id:=Inside(pp1);

    a:=P1[id];
    b:=P2[id];
    c:=P3[id];

    Add1(id,a,b,pp1);
    
    Add2(b,c,pp4);
    Add2(a,c,pp4);

    Balance(a,b);
    Balance(b,c);
    Balance(a,c);
    i:=i+1;
   end;


  for i:=1 to ESum-1 do
   begin
    if Edge[i].TSum = 2 then
     begin
      id:=Edge[i].triangle[0];
      FindCenter(P1[id],P2[id],P3[id],pp2);
      id:=Edge[i].triangle[1];
      FindCenter(P1[id],P2[id],P3[id],pp3);

(*
      writeln('1',pp2.x:20:1,pp2.y:20:1);
      writeln('2',pp3.x:20:1,pp3.y:20:1);
*)
      
      if (pp2.x<=0) or (pp2.x>=BX) or
         (pp3.x<=0) or (pp3.x>=BX) or
         (pp2.y<=0) or (pp2.y>=BY) or
         (pp3.y<=0) or (pp3.y>=BY) then
          begin
           k1 := (pp2.x - pp3.x);
           if k1<>0 then
            begin
             k:=(pp2.y-pp3.y)/k1;
(*
     	     Writeln('2',k*BX-k*pp2.x+pp2.y:10:1);
	     Writeln('3',k:10,BX:10,pp2.x:10:1,pp2.y:10:1,pp3.x:10:1,k1:10:1);
*)
             Put(0,k*BX-k*pp2.x+pp2.y); 
             Put(BX,k*BX-k*pp2.x+pp2.y);
            end
             else 
              begin
               Put(pp2.x,BY);
               Put(pp2.x,0);
              end;
           if pp2.y-pp3.y = 0 then
             begin
              Put(BX,pp2.y);
              Put(0,pp3.y);
             end; 
          end;

       if (pp2.x>=0) and (pp2.x<=BX) and
          (pp2.y>=0) and (pp2.y<=BY) then Put(pp2.x,pp2.y);

       if (pp3.x>=0) and (pp3.x<=BX) and
          (pp3.y>=0) and (pp3.y<=BY) then Put(pp3.x,pp3.y);
     end else 
      begin
      end;
   end;

  Put(0,0);
  Put(BX,0);
  Put(BX,BY);
  Put(0,BY);

  MDist:=0;
  MPoint.x:=0;
  MPoint.y:=0;
  for i:=0 to PSum-1 do
   begin
    D:=MinDistance(points[i]);

(*
    Writeln(D:10:1,Points[i].x:10:1,Points[i].y:10:1);
*)
    if D >= MDist then
     begin
      MPoint := Points[i];
      MDist  := D;
     end;
   end;

  Writeln('The safest point is (',MPoint.x:1:1,', ',MPoint.y:1:1,').');
 end;
end.
