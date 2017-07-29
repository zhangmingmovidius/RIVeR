function [X_rec Y_rec U_rec V_rec]=rvr_rec_res(results,H,Hroi,st,res);

X=results{1};
Y=results{2};
U=results{3};
V=results{4};


w=size(X,2);
h=size(X,1);


X1=X;
X2=U+X1;

Y1=Y;
Y2=V+Y1;

X1vec=reshape(X1,w*h,1);
X2vec=reshape(X2,w*h,1);
Y1vec=reshape(Y1,w*h,1);
Y2vec=reshape(Y2,w*h,1);

COOR1=[X1vec';Y1vec';ones(1,w*h)];
COOR2=[X2vec';Y2vec';ones(1,w*h)];

coor1=rvr_trans2rw(COOR1,H);
coor2=rvr_trans2rw(COOR2,H);

x1=coor1(1,:);
y1=coor1(2,:);
x2=coor2(1,:);
y2=coor2(2,:);

u=x2-x1;
v=y2-y1;

%filter results outside Hroi
[id_in,on] = inpolygon(x1',y1',Hroi(1,:)',Hroi(2,:)');
u(id_in==0)=nan;
v(id_in==0)=nan;
dumx1=x1;
dumy1=y1;
dumx1(id_in==0)=nan;
dumy1(id_in==0)=nan;
%remesh the results
XX=min(dumx1):(max(dumx1)-min(dumx1))/(res(1)-1):max(dumx1);
YY=min(dumy1):(max(dumy1)-min(dumy1))/(res(2)-1):max(dumy1);
[X_rec Y_rec]=meshgrid(XX,YY);

Fu=scatteredInterpolant(x1',y1',u','linear','none');
Fv=scatteredInterpolant(x1',y1',v','linear','none');

UU=Fu(X_rec,Y_rec);
VV=Fv(X_rec,Y_rec);

U_rec=1000*UU./(st);
V_rec=1000*VV./(st);
% 
% figure; quiver(X,Y,U,V)
% figure; quiver(x1,y1,u,v)
% figure; quiver(XX,YY,UU,VV)
end

