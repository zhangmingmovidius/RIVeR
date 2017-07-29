function rvr_edit_cs_gui(PathName,list_cs,units,X_rec, Y_rec, U_rec, V_rec,HX,HY,Him_out,Hroi)

fig=gcf;
gray = get(0,'DefaultUIControlBackgroundColor');
wfig=800;
hfig=600;

set(fig,'Position',[0 0 wfig hfig],...
    'Color',gray,...
    'Name','RIVeR - Edit Cross Section(s)',...
    'CreateFcn',{@movegui,'center'},...
    'ToolBar','none',...
    'MenuBar','none',...
    'IntegerHandle','off',...
    'Tag','fig_crs',...
    'Resize','off',...
    'CloseRequestFcn',@cmdClose_Callback); %#ok<NOPRT>




mh = uimenu(fig,'Label','File');
% uimenu(mh,'Label','Export data to workspace','Callback',@export2workspace_Callback);
uimenu(mh,'Label','Copy to clipboard','Callback',@copy2clipboard_Callback);


uicontrol('Position',[10 hfig-30 200 21],...
    'Style','text',...
    'String','Section:', ...
    'HorizontalAlignment','left')
List=[];
for i=1:size(list_cs,1)
    try%put the list name of all Cross Section
        List{i} = list_cs{i,3}{1};
    catch
        List{i} = list_cs{i,3};
    end
    list_cs{i,3}=List{i} ;
end

PopupMenu=uicontrol('Position',[10 hfig-45 100 21],...
    'Style','popupmenu',...
    'String',List,...
    'CallBack', @PopupMenuCallBack,...
    'Tag','popuplist');

BtnImport=uicontrol('Position',[140 hfig-45 100 21],...
    'Style','pushbutton',...
    'String','AreaComp2',...
    'CallBack', @BtnImportCallBack);

BtnDelete=uicontrol('Position',[62 hfig-23 50 21],...
    'Style','pushbutton',...
    'String','Delete',...
    'CallBack', @BtnDeleteCallBack);



AxesVelocity = axes(...    % Axes for plotting the selected plot
    'Parent', fig, ...
    'Units', 'normalized', ...
    'HandleVisibility','callback', ...
    'Position',[0.07 0.56 0.4 0.32],...
    'tag','axevel');



AxesHImage = axes(...    % Axes for plotting the selected plot
    'Parent', fig, ...
    'Units', 'normalized', ...
    'HandleVisibility','callback', ...
    'Position',[0.55 0.13 0.4 0.75],...
    'tag','axehimage');

txt_velstation=uicontrol('Position',[10 150 100 30],...
    'Style','text',...
    'Tag','txt_velstation',...
    'String','Velocity Profile Station:');

velstation=uicontrol('Position',[40 130 40 21],...
    'Style','edit',...
    'Tag','velstation',...
    'String','0',...
    'CallBack', @BtnvelstationCallBack);

d = [ ];
cnames = {'Station','Stage','Velocity'};


% Create the uitable
t=findobj('Tag','table');
t = uitable(fig,'Data',d,...
    'ColumnName',cnames,...
    'Enable','on',...
    'ColumnEditable',[false, false,true],...
    'CellSelectionCallback',@(src,evnt)set(src,'UserData',evnt.Indices),...
    'Tag','table',...
    'Position',[100 15 280 270]);
velstation=uicontrol('Position',[40 130 40 21],...
    'Style','edit',...
    'Tag','velstation',...
    'String','0',...
    'CallBack', @BtnvelstationCallBack);

Check_interpolate=uicontrol('Position',[250 hfig-45 200 21],...
    'Style','checkbox',...
    'String','Extrapolate Velocity to Edges',...
    'Tag','interpolate',...
    'CallBack', @check_interpolate);

% Create the uitable
results=[0 1 0];
cnames_res = {'mean Vs','Vm/Vs','Q'};
t_results = uitable(fig,'Data',results,...
    'ColumnName',cnames_res,...
    'RowName',[],...
    'Enable','on',...
    'ColumnEditable',[false, true,false],...
    'CellSelectionCallback',@(src,evnt)set(src,'UserData',evnt.Indices),...
    'Tag','table_results',...
    'Position',[470 hfig-65 228 40],...
    'celleditcallback', @ChangealphaCallback);



%put teh data into the figure
structgui=struct('list_cs',[],...
    'PathName',PathName,...
    'units',units,...
    'X_rec',X_rec,...
    'Y_rec',Y_rec,...
    'U_rec',U_rec,...
    'V_rec',V_rec,...
    'HX',HX,...
    'HY',HY,...
    'Him_out',Him_out,...
    'Hroi',Hroi);
structgui.list_cs=list_cs;
guidata(fig,structgui);
dispresults


function dispresults
fig=gcf;
data = guidata(fig);
X_rec=data.X_rec;
Y_rec=data.Y_rec;
U_rec=data.U_rec;
V_rec=data.V_rec;
units=data.units;
HX=data.HX;
HY=data.HY;
Him_out=data.Him_out;
Hroi=data.Hroi;
list_cs=data.list_cs;
txt_dis=findobj('tag','txt_dis');
check_interpolate=findobj('tag','interpolate');
check_interpolate=check_interpolate(1);
set(txt_dis,'String','');
t_results=findobj('Tag','table_results');
t_results=t_results(1);
velstation=findobj('Tag','velstation');
velstation= velstation(1);
% get the handles of velocity axes
AxeVel = findobj(gcf,'tag','axevel');
axes(AxeVel);
hold off
xlabel(['Distance in [' units ']'], 'FontSize', 11);
ylabel(['Velocity in [' units '/s]'], 'FontSize', 11);
grid on
set(gca,'tag','axevel')

allsections = findobj(gcf,'tag','popuplist');
id_section=get(allsections,'Value');
section=data.list_cs{id_section,2};

if size(list_cs(id_section,:),2)>5
    set(t_results,'Data',[0 list_cs{id_section,6} 0] );
    set(check_interpolate,'Value',list_cs{id_section,7});
    set(velstation,'String',num2str(list_cs{id_section,8}));
end



length_cs=pdist(section);
%calculate the velocity profile and plot it
[cx_U, cy_U, c_U] =improfile(X_rec,Y_rec,U_rec,section(:,1),section(:,2),50,'nearest');
[cx_V, cy_V, c_V] =improfile(X_rec,Y_rec,V_rec,section(:,1),section(:,2),50,'nearest');
c_Mag=(c_U.^2+c_V.^2).^0.5;
distance=linspace(0,length_cs,size(cx_U,1));
East=cx_U;
North=cy_U;
VE=c_U;
VN=c_V;
Magnitud=c_Mag;

%calculate Streamwise and Croswise component of the Cross section
[S, C]=rvr_vel_components([East(1) North(1)],[East(end) North(end)],VE,VN);


%get the velocity Profile stage (where starts the velocity profile)
velstation=findobj('Tag','velstation')
velstation= velstation(1);
velstation=str2double( get(velstation,'String'));



%add velocity in table
if size(list_cs(id_section,:),2)>3
    
    
    %add a part of the station in case the velocity profile larger
    if min(list_cs{id_section,4})>min(distance'+velstation) && max(list_cs{id_section,4})>max(distance'+velstation)
        tramo1=min(distance'+velstation):0.1:min(list_cs{id_section,4});
        if length(tramo1)>1
            new_prog=[tramo1(1:end-1)'; list_cs{id_section,4}];
            new_stage=[nan*tramo1(1:end-1)'; list_cs{id_section,5}]
        else
            new_prog=[tramo1; list_cs{id_section,4}];
            new_stage=[nan*tramo1; list_cs{id_section,5}]
        end
    elseif max(list_cs{id_section,4})<max(distance'+velstation) && min(list_cs{id_section,4})<=min(distance'+velstation)
        tramo2=max(list_cs{id_section,4}):0.1:max(distance'+velstation);
        if length(tramo2)>1
            new_prog=[list_cs{id_section,4};tramo2(2:end)'];
            new_stage=[list_cs{id_section,5};nan*tramo2(2:end)'];
        else
            new_prog=[list_cs{id_section,4};tramo2];
            new_stage=[list_cs{id_section,5};nan*tramo2];
        end
        
    elseif min(list_cs{id_section,4})>min(distance'+velstation) && max(list_cs{id_section,4})<max(distance'+velstation)
        tramo1=min(distance'+velstation):0.1:min(list_cs{id_section,4});
        tramo2=max(list_cs{id_section,4}):0.1:max(distance'+velstation);
        if length(tramo1)>1
            new_prog=[tramo1(1:end-1)'; list_cs{id_section,4}];
            new_stage=[nan*tramo1(1:end-1)'; list_cs{id_section,5}]
        else
            new_prog=[tramo1; list_cs{id_section,4}];
            new_stage=[nan*tramo1; list_cs{id_section,5}];
        end
        if length(tramo2)>1
            new_prog=[new_prog;tramo2(2:end)'];
            new_stage=[new_stage;nan*tramo2(2:end)'];
        else
            new_prog=[new_prog;tramo2];
            new_stage=[new_stage;nan*tramo2];
        end
    else % if velcoity profile in winthin the bathymetry
        new_prog=list_cs{id_section,4};
        new_stage=list_cs{id_section,5};
    end
    
    
    newS=interp1(distance'+velstation,S,new_prog); %streamwise component on the stage mesh
    d=[new_prog(isnan(new_stage)==0),new_stage(isnan(new_stage)==0),newS(isnan(new_stage)==0)];%in the table only stage with now nan
else
    d=[distance'+velstation S*0 S];
end

%extrapolate velocity profile to edges if necesarly
if get(check_interpolate,'Value')==1
    if isnan(newS(new_prog==0))==1
        newS(new_prog==0)=0;
        try
        newS_extrap=inpaint_nans(newS,2);
        catch
        end
    end
    if isnan(newS(new_prog==max(list_cs{id_section,4})))==1
        newS(new_prog==max(list_cs{id_section,4}))=0;
        try
        newS_extrap=inpaint_nans(newS,2);
        catch
        end
    end
    
end



t=findobj('Tag','table');
t=t(1);
set(t,'Data',d,...
    'Enable','on',...
    'ColumnEditable',[false, false,true],...
    'CellSelectionCallback',@(src,evnt)set(src,'UserData',evnt.Indices),...
    'Tag','table',...
    'Position',[100 15 280 270]);

%plot velocity profile
AxeVel = findobj(gcf,'tag','axevel');
axes(AxeVel);

if size(list_cs(id_section,:),2)>3
    hold off
    %     prog_vel_profil=list_cs{id_section,4}+velstation; %this is the station of velovity profile
    if get(check_interpolate,'Value')==1 && exist('newS_extrap')==1
        plot3(new_prog(new_prog<=max(list_cs{id_section,4})& new_prog>=min(list_cs{id_section,4})),...
            newS_extrap(new_prog<=max(list_cs{id_section,4})& new_prog>=min(list_cs{id_section,4})),...
            newS_extrap(new_prog<=max(list_cs{id_section,4})& new_prog>=min(list_cs{id_section,4}))*0+max(list_cs{id_section,5}),'g')
        hold on
    end
    %plot what will be used for Discharge caclculation
    plot3(new_prog(new_prog<=max(list_cs{id_section,4})& new_prog>=min(list_cs{id_section,4})),...
        newS(new_prog<=max(list_cs{id_section,4})& new_prog>=min(list_cs{id_section,4})),...
        newS(new_prog<=max(list_cs{id_section,4})& new_prog>=min(list_cs{id_section,4}))*0+max(list_cs{id_section,5}))
    hold on
    %plot what won't be used for Discharge caclculation in red
    plot3(new_prog(new_prog>max(list_cs{id_section,4})),...
        newS(new_prog>max(list_cs{id_section,4})),...
        newS(new_prog>max(list_cs{id_section,4}))*0+max(list_cs{id_section,5}),'r')
    
    plot3(new_prog(new_prog<min(list_cs{id_section,4})),...
        newS(new_prog<min(list_cs{id_section,4})),...
        newS(new_prog<min(list_cs{id_section,4}))*0+max(list_cs{id_section,5}),'r')
    
    %plot bathymetry
    plot3(new_prog,new_prog*0,new_stage,'Linewidth',2,'Color',[0 0 0])
    grid on
    plot3(list_cs{id_section,4},list_cs{id_section,4}*0,list_cs{id_section,4}*0+max(list_cs{id_section,5}),'k--')
    xlabel(['Station in [' units ']'], 'FontSize', 11);
    ylabel(['Velocity in [' units '/s]'], 'FontSize', 11);
    zlabel(['Stage in [' units ']'], 'FontSize', 11);
    rotate3d on
    
    
    %calculate mean superficial velocity and discharge
    d_results=get(t_results,'Data');
    alpha=d_results(2); %get coeficient alpha
    
    
    if get(check_interpolate,'Value')==1 && exist('newS_extrap')==1
        Vms=nanmean(newS_extrap);
        Q=rvr_calculate_q(new_prog,new_stage,newS_extrap,alpha);
        
    else
        Vms=nanmean(newS);
        Q=rvr_calculate_q(new_prog,new_stage,newS,alpha);
    end
    
    %export the results to table results
    d_results=[Vms alpha Q];
    set(t_results,'Data',d_results);
    
    %save the parameters in list_cs
    list_cs{id_section,6}=alpha;
    list_cs{id_section,7}=get(check_interpolate,'Value');
    list_cs{id_section,8}=velstation;
    data.list_cs=list_cs;
    guidata(gcf,data);
    
%     AllF=findall(0,'Type','figure');
%     rivergui=AllF(end,:);
%     structgui=struct('list_cs',[]);
%     structgui.list_cs=list_cs;
%     guidata(rivergui,structgui);
%     guidata(fig,structgui);
    
else
    hold off
    rotate3d off
    plot(distance+velstation,S)
    hold on
    xlabel(['Station in [' units ']'], 'FontSize', 11);
    ylabel(['Velocity in [' units '/s]'], 'FontSize', 11);
    grid on
    stem(distance+velstation,S,'Marker','.','Color',[0 0.45 0.74])
end
set(gca,'tag','axevel')

%plot the rectified image
AxeHimage = findobj(gcf,'tag','axehimage');
axes(AxeHimage);
hold off
pcolor(HX,HY,uint8(Him_out));shading interp; axis image; colormap('gray');
axis equal
hold on
plot(Hroi(1,:),Hroi(2,:),'Color',[0.85 0.33 0.1])
set(gca,'tag','axehimage')
%plot the section
plot(section(:,1),section(:,2),'Color',[0.93 0.69 0.13])
axis off


function BtnImportCallBack(hObject,eventdata)
fig=gcf;
data = guidata(fig);
list_cs=data.list_cs;
allsections = findobj(gcf,'tag','popuplist');
id_section=get(allsections,'Value');


dummy1=figure('Tag','dummy1','Visible','off');
dummy2=figure('Tag','dummy2','Visible','off');
StageAreaRating_export
waitfor(dummy1);
if isempty(findobj('tag','dummy2'))==0
    data_areacomp = guidata(dummy2)
    close(dummy2)
    stationOut=data_areacomp.stationOut;
    stageOut=data_areacomp.stageOut;
    
    %place stage and section in list_cs
    list_cs{id_section,4}=stationOut;
    list_cs{id_section,5}=stageOut;
    data.list_cs=list_cs;
    
    %export updated list to the figure
    guidata(fig,data);
    dispresults
    
end

function BtnDeleteCallBack(hObject,eventdata)
allsections = findobj(gcf,'tag','popuplist');
id_section=get(allsections,'Value');
fig=gcf;
data = guidata(fig);
list_cs=data.list_cs;
l=1:size(list_cs,1);
list_cs=list_cs(l(l~=id_section),:);
structgui.list_cs=list_cs;

%find the parent figure
AllF=findall(0,'Type','figure');
rivergui=AllF(end,:);
structgui=struct('list_cs',[]);
structgui.list_cs=list_cs;
guidata(rivergui,structgui);
guidata(fig,structgui);
cmdClose_Callback


function PopupMenuCallBack(hObject,eventdata)
dispresults;

function check_interpolate(hObject,eventdata)
fig=gcf;
check_interpolate=findobj('Tag','interpolate');
check_interpolate=check_interpolate(1);
data = guidata(fig);
list_cs=data.list_cs;
allsections = findobj(gcf,'tag','popuplist');
id_section=get(allsections,'Value');
list_cs{id_section,7}=get(check_interpolate,'Value');
data.list_cs=list_cs;
guidata(gcf,data);
dispresults;

function BtnvelstationCallBack(hObject,eventdata)
fig=gcf;
velstation=findobj('Tag','velstation');
velstation=velstation(1);
data = guidata(fig);
list_cs=data.list_cs;
allsections = findobj(gcf,'tag','popuplist');
id_section=get(allsections,'Value');
list_cs{id_section,8}=str2num(get(velstation,'String'));
data.list_cs=list_cs;
guidata(gcf,data);
dispresults;





function ChangealphaCallback(hObject,eventdata)
fig=gcf;
t_results=findobj('Tag','table_results');
t_results=t_results(1);
data = guidata(fig);
list_cs=data.list_cs;
allsections = findobj(gcf,'tag','popuplist');
id_section=get(allsections,'Value');
tt=get(t_results,'Data');
list_cs{id_section,6}=tt(2);
data.list_cs=list_cs;
guidata(gcf,data);
dispresults;






function cmdClose_Callback(hObject,varargin)
fig=gcf;
data = guidata(fig);
list_cs=data.list_cs;
%find the parent figure
AllF=findall(0,'Name','RIVeR_GUI');
rivergui=AllF(end,:);
structgui=struct('list_cs',[]);
structgui.list_cs=list_cs;
guidata(rivergui,structgui);
close(fig)

function copy2clipboard_Callback(hObject,varargin)
fig=gcf;
data = guidata(fig);
X_rec=data.X_rec;
Y_rec=data.Y_rec;
U_rec=data.U_rec;
V_rec=data.V_rec;
units=data.units;
HX=data.HX;
HY=data.HY;
Him_out=data.Him_out;
Hroi=data.Hroi;
list_cs=data.list_cs;
txt_dis=findobj('tag','txt_dis');
set(txt_dis,'String','');

allsections = findobj(gcf,'tag','popuplist');
id_section=get(allsections,'Value');
section=data.list_cs{id_section,2};

length_cs=pdist(section);
%calculate the velocity profile and plot it
[cx_U, cy_U, c_U] =improfile(X_rec,Y_rec,U_rec,section(:,1),section(:,2),50,'nearest');
[cx_V, cy_V, c_V] =improfile(X_rec,Y_rec,V_rec,section(:,1),section(:,2),50,'nearest');
c_Mag=(c_U.^2+c_V.^2).^0.5;
distance=linspace(0,length_cs,size(cx_U,1));

East=cx_U;
North=cy_U;
VE=c_U;
VN=c_V;
Magnitud=c_Mag;

%calculate Streamwise and Croswise component of the Cross section
[S, C]=rvr_vel_components([East(1) North(1)],[East(end) North(end)],VE,VN);

tocopy=[distance' S C];

clipboard('copy',tocopy)




