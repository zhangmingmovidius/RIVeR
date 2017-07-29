%%
    function [Bi]=rvr_trans2rw(x,H)
        %         H=retr('H');
        Bi=inv(H)*x;
        Bi=Bi(1:2,:)./(ones(2,1)*Bi(3,:));
   