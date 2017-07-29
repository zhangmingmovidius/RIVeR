function [Q]=rvr_calculate_q(station,stage,velocity,alpha);

max_bath=max(stage);


a=(2*max_bath-(stage(1:end-1)+stage(2:end))) .* diff(station) ./2;%mini areas
meanv=mean([velocity(1:end-1),velocity(2:end)],2);%mean velocity of each area
q=a.*meanv;%discharge of each area
Q=nansum(q);
Q=Q*alpha;



% max_bath=max(bathymetry(:,2));
% A=trapz(bathymetry(:,1),max_bath-bathymetry(:,2));
% 
% %make a comon grid for velocity and bathymetry
% dist=[bathymetry(:,1);velocity_sup(:,1)];
% dist=unique(sort(dist));%new mesh
% 
% bath=interp1(bathymetry(:,1),bathymetry(:,2),dist);%remesh bath profile
% vel=interp1(velocity_sup(:,1),velocity_sup(:,2),dist); %remesh vel profile
% 
% %replace nan by 0 on margins of teh velocity profile
% if isnan(vel(1))==1
%     vel(1)=0;
% end
% if isnan(vel(end))==1
%     vel(end)=0;
% end
% 
% %extrapolate to the margins
% vel(isnan(vel)) = interp1(dist(~isnan(vel)),vel(~isnan(vel)) , dist(isnan(vel))); 
% 
% %estimate discharge
% 
% a=(2*max_bath-(bath(1:end-1)+bath(2:end))) .* diff(dist) ./2;%mini areas
% meanv=mean([vel(1:end-1),vel(2:end)],2);%mean velocity of each area
% q=a.*meanv;%discharge of each area
% 
% Q=nansum(q);