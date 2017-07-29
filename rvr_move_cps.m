 function shifted_CPs=rvr_move_cps(CPs,pt_V1,pt_V2,pt_V3,pt_L,pt_R,pt_topo)
%CPs original Control Points

%pt_V1,pt_V2 and pt_V3 are the horizontal and vertical Vanishing points
%coordinates of the image

%pt_L and pt_R are the points that define a section (Left and Right respectively) at the original CPs level 

%pt_topo is a ppoint that is both at the water level and on the section

shifted_CPs=[];
%shift all CP
for i=1:4
shi_CP=shift_CP(pt_L,pt_R,CPs(1:2,i)',pt_topo,pt_V1,pt_V2,pt_V3);
shifted_CPs=[shifted_CPs;shi_CP];
end

function pt_CP_shifted=shift_CP(pt_I,pt_D,pt_CP,pt_topo,pt_V1,pt_V2,pt_V3)

%V1 y V2 puntos de fuga plano horizontal
%V3 punto de fuga vertical



eq_I_D = rvr_find_eq(pt_I,pt_D); %ecaucion margen Izquierda margen derecha
eq_topo_V3=rvr_find_eq(pt_V3, pt_topo); 

pt_ori_topo=rvr_intersec(eq_I_D,eq_topo_V3);

eq_ori_topo_V2=rvr_find_eq(pt_ori_topo,pt_V2);
eq_CP_V1=rvr_find_eq(pt_V1,pt_CP);

pt_ori_topo_front=rvr_intersec(eq_CP_V1,eq_ori_topo_V2);

eq_ori_topo_front_V3=rvr_find_eq(pt_ori_topo_front,pt_V3);
eq_topo_V2=rvr_find_eq(pt_topo,pt_V2);

pt_ori_topo_front_shifted=rvr_intersec(eq_ori_topo_front_V3,eq_topo_V2);

eq_CP_shifted_V1=rvr_find_eq(pt_ori_topo_front_shifted,pt_V1);
eq_CP_V3=rvr_find_eq(pt_CP,pt_V3);

pt_CP_shifted=rvr_intersec(eq_CP_shifted_V1,eq_CP_V3);
