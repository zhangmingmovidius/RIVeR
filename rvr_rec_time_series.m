function [u v]=rvr_rec_time_series(resultslist,new_pt,st,H)


for i=1:size(resultslist,2)
X=resultslist{1,i};
Y=resultslist{2,i};
U=resultslist{3,i};
V=resultslist{4,i};

Uts(i) = interp2(X,Y,U,new_pt(1),new_pt(2));
Vts(i) = interp2(X,Y,V,new_pt(1),new_pt(2));
end

X1=new_pt(1);
X2=Uts+new_pt(1);

Y1=new_pt(2);
Y2=Vts+new_pt(2);

COOR1=[X1;Y1;1];
COOR2=[X2;Y2;ones(1,length(Uts))];

coor1=rvr_trans2rw(COOR1,H);
coor2=rvr_trans2rw(COOR2,H);

x1=coor1(1,:);
y1=coor1(2,:);
x2=coor2(1,:);
y2=coor2(2,:);

u=x2-x1;
v=y2-y1;

u=1000*u./(st);
v=1000*v./(st);




