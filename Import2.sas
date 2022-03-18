filename fil1 url "https://lipy.us/data/Mont2.csv";

proc import datafile=fil1 dbms=csv out=work.dat2 replace; getnames=no; run;

proc print data=dat2 (obs=6) noobs; run;
	
title "CPM vs MDhms";
proc sgplot data=work.dat2 (firstobs=1 obs=15);
  series x=var1 y=var2 / markers;
run;
title;
