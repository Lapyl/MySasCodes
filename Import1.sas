filename fil1 url "https://lipy.us/data/Mont.csv";
filename fil2 url "https://lipy.us/data/2022_1_GMC_37074B313530AA_YorbaLinda_3389_w11780.txt";
filename fil3 temp;

data dat1;
infile fil1 dlm=',' dsd firstobs=2;
input A B C;
run;

data dat2;
infile fil2 dlm=',' dsd firstobs=2;
length a $ 10;
input a $ b @@;
run;

data dat3;
infile fil2 dlm=" " dsd termstr="," truncover firstobs=2;
length a 10 b 2;
input a b;
run;

data dat4;
infile fil2 dlm=',' dsd recfm=n;
input var1-var10000;
run;

/*
data _null_;
    infile fil2 termstr=',';
    file fil3 dlm=' ';
    do _i = 1 to 1;
        input line $;
        putlog line;
        put line @;
    end;
    put;
run;

data dat5;
  infile fil3 dlm=' ' firstobs=5;
  input a b;
run;
*/
