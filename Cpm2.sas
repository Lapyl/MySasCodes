filename filin url "https://lipy.us/data/test.csv";
/* filename filou url "/home/u50393074/output/Anim.gif"; */
libname odsout "/home/u50393074/output";

proc import datafile=filin out=cpm1 dbms=csv replace;
	getnames=no; run;

data cpm2; set cpm1;
	where not missing(var1) and not missing(var2);
	rename var2=CPM; run;

proc sort data=cpm2; by var1; run;

data cpm3; set cpm2;
	Date=input(input(compress("20220"||substr(compress(var1),1,5)),$8.),yymmdd8.);
	HrMS=input(input(substr(compress(var1),4,6),$6.),hhmmss6.);
	Hour=input(input(substr(compress(var1),4,2),$2.),2.);
	Minu=input(input(substr(compress(var1),6,2),$2.),2.);
	Seco=input(input(substr(compress(var1),8,2),$2.),2.);
	format CPM 2. Date date10. HrMS time8. Hour 2. Minu 2. Seco 2.;
	drop var1;
	run;

proc sql;
	create table cpm4 as
	select Date, Hour, Minu, min(CPM) as CPMn, max(CPM) as CPMx
	from cpm3
	where Date > 0
	group by Date, Hour, Minu;
quit;

ods graphics / imagefmt=GIF width=6in height=4in;
options papersize=('6 in','4 in')	nodate nonumber
	animduration=0.5 animloop=yes noanimoverlay	printerpath=gif animation=start;
ods printer file=filou;

proc sgplot data=cpm4; by Date; series x=Minu y=CPMx / group=Hour;
   	xaxis integer values=(1 to 60); yaxis min=0 max=30 grid; run;

options printerpath=gif animation=stop;
ods printer close;

/*
proc timeseries data=cpm4 out=cpm5 outseason=season outtrend=trend;
	id var3 interval=day accumulate=total; var var2; run;
*/
