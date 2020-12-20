data A;
	input a $ b $ c $ d e f;
datalines;
a1 b1 c1 1 2 3
a1 b1 c2 2 3 4
a1 b2 c1 3 4 5
a1 b2 c2 4 5 6
a2 b1 c1 2 3 4
a2 b1 c2 3 4 5
a2 b2 c1 4 5 6
a2 b2 c2 5 6 7
;
run;

%macro mroll(mTab, mGrp, mSum);

	%let zn = %sysfunc(countw(&mGrp," "));
	%do i = 1 %to 2**&zn;
		data X; set &mTab;
			%do j = 1 %to &zn;
				%if %eval(%sysfunc(int((&i-0.5)/2**(&j-1)))) = %eval(2 * %sysfunc(int((&i-0.5)/2**(&j)))) %then %do;
					%let zc = %scan(&mGrp,&j," ");
					&zc = "";
				%end;
			%end;
		run;
		proc sort data=X;
			by &mGrp;
		run;
		proc summary data=X;
			var &mSum;
			output out=Y sum=;
			by &mGrp;
		run;
		%if &i > 1 %then %do;
			proc append base=Y data=Z;
			run;
		%end;
		%else;
			data Z; set Y;
			run;
		%end;
	%end;
	proc sort data=Z; by &mGrp;	run;
	proc print data=Z; run;
	
%mend mroll;

%mroll(A, a b c, d e f)
