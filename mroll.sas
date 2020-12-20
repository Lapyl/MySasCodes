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
		data &mTab.0; set &mTab;
			%do j = 1 %to &zn;
				%if %eval(%sysfunc(int((&i-0.5)/2**(&j-1)))) = %eval(2 * %sysfunc(int((&i-0.5)/2**(&j)))) %then %do;
					%let zc = %scan(&mGrp,&j," ");
					&zc = "";
				%end;
			%end;
		run;
		proc sort data=&mTab.0; by &mGrp;
		run;
		proc summary data=&mTab.0;
			var &mSum;
			output out=&mTab.1 sum=;
			by &mGrp;
		run;
		%if &i > 1 %then %do;
			proc append base=&mTab.2 data=&mTab.1; run;
		%end;
		%else %do;
			data &mTab.2; set &mTab.1; run;
		%end;
	%end;
	proc delete data=&mTab.0; run;
	proc delete data=&mTab.1; run;
	data &mTab.2 (rename=(_FREQ_=freq) drop=_TYPE_); set &mTab.2; run;
	proc sort data=&mTab.2; by &mGrp; run;
	proc print data=&mTab.2; run;
	
%mend mroll;

%mroll(A, a b c, d e f)
