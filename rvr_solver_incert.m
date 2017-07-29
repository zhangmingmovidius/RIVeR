function [X Y]=rvr_solver_incert(L12, L23, L34, L41, L13, L24);;
%stop RIVeR @ l. 218
%"[X Y fake_scale L]=rvr_solver(PathName_CP,units);"
X1=[];
Y1=[];
X2=[];
Y2=[];
X3=[];
Y3=[];
X4=[];
Y4=[];


for i=1:size(L12,1)

l12=L12(i);
l23=L23(i);
l34=L34(i);
l41=L41(i);
l13=L13(i);
l24=L24(i);
    

X1=[X1; 0];
Y1=[Y1; 0];
X2=[X2; l12];
Y2=[Y2; 0];

w0 = [1;1;1;1];
options=optimset('MaxFunEvals' , 5000,'MaxIter' , 5000);
warning('off')
[w,fval] = fsolve(@myfun,w0,options);
warning('on')
X3=[X3; w(1)];
Y3=[Y3; w(2)];
X4=[X4; w(3)];
Y4=[Y4; w(4)];

end

X=[X1 X2 X3 X4];
Y=[Y1 Y2 Y3 Y4];


    function F = myfun(x)
                
        F = [x(1)^2 + x(2)^2 - l13^2;
            x(3)^2 + x(4)^2 - l41^2;
            (x(1)-l12)^2+x(2)^2-l23^2;
            (x(1)-x(3))^2+(x(2)-x(4))^2-l34^2;
            (l12-x(3))^2+x(4)^2-l24^2];
    end
end