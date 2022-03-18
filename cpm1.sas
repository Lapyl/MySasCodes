filename filin url "https://lipy.us/data/test.csv";
/* filename filout url "/home/u50393074/output/Anim.gif"; */
libname odsout "/home/u50393074/output";

proc import datafile=filin out=work.cpm1 dbms=csv replace; getnames=no; run;

data cpm2; set work.cpm1;
	where not missing(var1) and not missing(var2);
	Month = substr(trim(var1),3,2);	DateHr = substr(trim(var1),5,4);
	Minute = substr(trim(var1),9,2); CPM = var2; run;

proc sort data=cpm2; by DateHr Month Minute; run;

ods graphics / imagefmt=GIF width=6in height=4in;
options papersize=('6 in','4 in')	nodate nonumber
	animduration=0.5 animloop=yes noanimoverlay	printerpath=gif animation=start;
ods printer file=filout;

proc sgplot data=cpm2; by DateHr; series x=Minute y=CPM / group=Month;
   	xaxis integer values=(1 to 24); yaxis min=0 max=30 grid; run;

options printerpath=gif animation=stop;
ods printer close;
