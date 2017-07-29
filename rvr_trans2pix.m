    function [Bi]=rvr_trans2pix(x,H)
        %         H=retr('H');
        Bi=(H)*x;
        Bi=Bi(1:2,:)./(ones(2,1)*Bi(3,:));
 
