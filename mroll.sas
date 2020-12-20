data ABCDEFGHIJ;
	input Aaaaaaaaaa $ Bbbbbbbbbb $ Cccccccccc $ Dddddddddd Eeeeeeeeee Ffffffffff;
datalines;
AAA BBB CCC -36 81 -88
AAA BBB CCC1 99 7 -72
AAA BBB1 CCC 82 88 -99
AAA BBB1 CCC1 -36 70 -47
AAA1 BBB CCC 37 -19 -71
AAA1 BBB CCC1 9 1 -62
AAA1 BBB1 CCC 89 -51 12
AAA1 BBB1 CCC1 -69 -85 -79
AAA BBB CCC 62 -85 32
AAA BBB CCC2 -34 -85 51
AAA BBB2 CCC -75 -9 -62
AAA BBB2 CCC2 -15 79 -74
AAA2 BBB CCC -6 -68 52
AAA2 BBB CCC2 18 40 -13
AAA2 BBB2 CCC 14 88 -53
AAA2 BBB2 CCC2 66 -81 31
AAA BBB CCC 89 54 81
AAA BBB CCC1 -48 49 -27
AAA BBB1 CCC 2 1 84
AAA BBB1 CCC1 -60 -71 5
AAA1 BBB CCC -9 -12 69
AAA1 BBB CCC1 -19 92 -19
AAA1 BBB1 CCC -47 1 1
AAA1 BBB1 CCC1 -22 45 35
;
run;

%macro mroll(mTab, mGrp, mSum);

	%let zn = %sysfunc(countw(&mGrp," "));
	%do i = 1 %to (2**&zn);
		data &mTab.0; set &mTab;
			%do j = 1 %to &zn;
				%if %eval(%sysfunc(int(&i/(2**(&zn-&j))))) = %eval(2 * %sysfunc(int(&i/(2**(&zn-&j+1))))) %then %do;
					%scan(&mGrp,&j," ") = "";
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

%mroll(ABCDEFGHIJ, Aaaaaaaaaa Bbbbbbbbbb Cccccccccc, Dddddddddd Eeeeeeeeee Ffffffffff)
