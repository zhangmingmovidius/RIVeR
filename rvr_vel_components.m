function [S C]=rvr_vel_components(Leftmargin,Rightmargin,VE,VN)


r = vrrotvec([1 0 0],...
    [Rightmargin(1)-Leftmargin(1) Rightmargin(2)-Leftmargin(2) 0]);

teta=rad2deg(r(4));

if  (Rightmargin(2)-Leftmargin(2))<0
    teta=360-teta;
end

tetarad=deg2rad(teta);

Vx=VN.*sin(tetarad)+VE.*cos(tetarad);
Vy=VN.*cos(tetarad)-VE.*sin(tetarad);

C=Vx;%crossflow
S=Vy;%streamwise



