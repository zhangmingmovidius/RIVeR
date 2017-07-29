function [V1 V2]=rvr_calc_vanish(H)

A=[0;0];
B=[1;0];
C=[1;1];
D=[0;1];
l_one=[1 1 1 1];

Bf=[A B C D];
Bf=[Bf;l_one];

X=rvr_trans2pix(Bf,H);

a=X(:,1);
b=X(:,2);
c=X(:,3);
d=X(:,4);

%punto de funga Horizontal 1
 eq_ab=rvr_find_eq(a,b);
 eq_cd=rvr_find_eq(c,d);
 V1=rvr_intersec(eq_ab,eq_cd);
 
%punto de fuga Horizontal 2 
 eq_ad=rvr_find_eq(a,d);
 eq_bc=rvr_find_eq(b,c);
 V2=rvr_intersec(eq_ad,eq_bc);







