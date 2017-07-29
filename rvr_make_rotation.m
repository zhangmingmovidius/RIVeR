function rotM=rvr_make_rotation(new_dir,M)
%rotate the Real World control points
new_tan=(new_dir(2,1)-new_dir(1,1))/(new_dir(2,2)-new_dir(1,2));
rot_angle=atan(new_tan);
R=rotz(radtodeg(rot_angle));
rotM=R*M;

% figure; plot(M(1,:),M(2,:))
% hold on; plot(rotM(1,:),rotM(2,:))
% axis equal