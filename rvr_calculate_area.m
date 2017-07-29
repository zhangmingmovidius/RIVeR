function [wstage, warea]=rvr_calculate_area(bath,length_cs,radio_stage_value,radio_width_value,def_stage_string,jRangeSlider)
% figure; hold on
if radio_stage_value==0 && radio_width_value==1
    
    %look for the section lenght in the bathymetry and define the water
    %stage
    for i=1:size(bath,1)
        shift_lenght=bath(i,1)+length_cs;
        associated_y=interp1(bath(:,1),bath(:,2),shift_lenght,'Linear');
        diffy(i)=abs(associated_y-bath(i,2));
        %     plot([bath(i,1) bath(i,1)+length_cs],[bath(i,2) bath(i,2)])
    end
    [M,Id] = min(diffy);
    wstage=bath(Id,2);
    [xout,yout] =intersections(bath(:,1),bath(:,2),bath(:,1),wstage*ones(size(bath,1),1));
    
    %     figure; plot(bath(:,1),bath(:,2));hold on;a= area(warea(:,1),warea(:,2),wstage)
end
if radio_stage_value==1 && radio_width_value==0
    get(jRangeSlider,'Maximum');
    get(jRangeSlider,'Minimum');
    set(jRangeSlider,'MajorTickSpacing',5, 'MinorTickSpacing',1, 'PaintTicks',true, 'PaintLabels',true);
    wstage=str2double(def_stage_string);
    [xout,yout] =intersections(bath(:,1),bath(:,2),bath(:,1),wstage*ones(size(bath,1),1));
    
end
%new points that mark the area's limit
x_left=xout(1);
x_right=xout(2);

%remove the points that are above the water stage
warea(:,1)=bath((bath(:,2)<wstage),1);
warea(:,2)=bath((bath(:,2)<wstage),2);
warea=[x_left wstage ; warea; x_right wstage];