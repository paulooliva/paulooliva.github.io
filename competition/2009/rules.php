<html>
 <head>
  <title>II SEECS Programming Competition - 2009</title>
 </head>
 <body>

<?php
require_once('prepend.inc');
$auth_protected = 1;
$lhs = 'profskills_comps';
$page_title = 'Programming Competition Rules - 2009';
page_iheader(2,$lhs,$page_title,'more the merrier','');
$flipflop = 0;
?>

<h3> Rules of Competition </h3>

<ol>
  <li> <span style="font-weight: bold;">Each team will have access to one machine</span>. While one person is coding a solution for one
problem, the other two could be thinking about the solutions to the other problems, and even
writing down the solutions on paper, to speed up the implementation of the next problem. <br> <br> </li>

  <li> <span style="font-weight: bold;">During the competition all teams will be given a set of six
problems </span>. The teams will have to work out the solutions to as many as possible of 
these problems as possible, and implement their solutions. <br> <br> </li>

  <li> <span style="font-weight: bold;">Your program should consist of a single file, and should read from the standard input and give the solution on the standard output</span>. Check the sample solutions in the main page of the competition!  <br> <br> </li>

  <li> <span style="font-weight: bold;">The team solving most problems will win</span>. In case of a draw, the team with least
total time wins. The total time is calculated as follows: If a problem is correctly submitted
after T minutes and after being incorrectly submitted N times, the total time for that problem
will be "T + 15 x N". The total time for the team is the sum of the total time for each problem
correctly submitted. <br> <br> </li>

  <li> <span style="font-weight: bold;">Machines will be running Linux (Java 1.6.X) and will have Eclipse installed. A local copy of the Java API will also be available. </span>  <br> <br> </li>

  <li> <span style="font-weight: bold;">Machines will not be connected to the internet</span>. You are, however, allowed to bring printed material (e.g. books and printouts). You will be given a USB memory stick at
the beginning of the competition. After solving each problem you should save your solution on the
memory stick provided, and hand it out to one of the organisers, who will check your solution and
give back an answer in a matter of minutes. The four possible answer you will get are: "CORRECT", "COMPILE ERROR", "RUN TIME ERROR", "WRONG ANSWER". <br> <br> </li>

  <li> <span style="font-weight: bold;">There will be a score board during the competition</span>. This will show which teams solved which problems so far. The board will be frozen 30 minutes before the end of the competition. Any problems solved during this last 30 minutes will not appear in the board. In this way you will only know who is the winner once this is announced in the closing ceremony. <br> <br> </li>

  <li> The competition organisers reserve the right to modify the rules or
cancel the competition at any stage, if deemed necessary in their
opinion. This competition is administered by the Department of Computer
Science, Queen Mary, University of London. The decision of Queen Mary,
University of London is final in every situation including any not
covered above. Contestants will be deemed to have accepted these rules
and to agree to be bound by them when entering the competition. <br> <br> </li>

</ol>
<p><a href="index.php">&lt;&lt; Back</a></p>
  <?php
page_ifooter(2);
?>

</body>
</html>
