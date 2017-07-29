function rvr_edit_pt_gui(PathName,list_pt,units,HX,HY,Him_out,Hroi,st)

fig=gcf;
gray = get(0,'DefaultUIControlBackgroundColor');
wfig=800;
hfig=660;

set(fig,'Position',[0 0 wfig hfig],...
    'Color',gray,...
    'Name','RIVeR - Edit Time series point(s)',...
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
for i=1:size(list_pt,1)
    try%put the list name of all Cross Section
        List{i} = list_pt{i,3}{1};
    catch
        List{i} = list_pt{i,3};
    end
    list_pt{i,3}=List{i} ;
end

PopupMenu=uicontrol('Position',[10 hfig-45 100 21],...
    'Style','popupmenu',...
    'String',List,...
    'CallBack', @PopupMenuCallBack,...
    'Tag','popuplist');

% BtnImport=uicontrol('Position',[140 hfig-45 100 21],...
%     'Style','pushbutton',...
%     'String','Import Bathymetry',...
%     'CallBack', @BtnImportCallBack);

BtnDelete=uicontrol('Position',[62 hfig-23 50 21],...
    'Style','pushbutton',...
    'String','Delete',...
    'CallBack', @BtnDeleteCallBack);

AxesU = axes(...    % Axes for plotting the selected plot
    'Parent', fig, ...
    'Units', 'normalized', ...
    'HandleVisibility','callback', ...
    'Position',[0.07 0.56 0.4 0.32],...
    'tag','axevelu');

AxesV = axes(...    % Axes for plotting the selected plot
    'Parent', fig, ...
    'Units', 'normalized', ...
    'HandleVisibility','callback', ...
    'Position',[0.07 0.13 0.4 0.32],...
    'tag','axevelv');

AxesHImage = axes(...    % Axes for plotting the selected plot
    'Parent', fig, ...
    'Units', 'normalized', ...
    'HandleVisibility','callback', ...
    'Position',[0.55 0.13 0.4 0.75],...
    'tag','axehimage');

txt_units=uicontrol('Position',[254 10 22 21],...
    'Style','text',...
    'Enable','off',...
    'Tag','txt_units',...
    'String',units);

%put teh data into the figure
structgui=struct('list_pt',[],...
    'PathName',PathName,...
    'units',units,...
    'HX',HX,...
    'HY',HY,...
    'Him_out',Him_out,...
    'Hroi',Hroi,...
    'st',st);
structgui.list_pt=list_pt;
guidata(fig,structgui);
dispresults


function dispresults
fig=gcf;
data = guidata(fig);
units=data.units;
HX=data.HX;
HY=data.HY;
Him_out=data.Him_out;
Hroi=data.Hroi;
st=data.st;
list_pt=data.list_pt;
% txt_dis=findobj('tag','txt_dis');
% set(txt_dis,'String','');
% get the handles of velocity axes
AxeVelU = findobj(gcf,'tag','axevelu');
axes(AxeVelU);
hold off
xlabel('Time', 'FontSize', 11);
ylabel(['U Velocity in [' units '/s]'], 'FontSize', 11);
grid on
set(gca,'tag','axevelu')

AxeVelV = findobj(gcf,'tag','axevelv');
axes(AxeVelV);
hold off;
xlabel('Time in [s]', 'FontSize', 11);
ylabel(['V Velocity in [' units '/s]'], 'FontSize', 11);
grid on
set(gca,'tag','axevelv')

allpoints = findobj(gcf,'tag','popuplist');
id_point=get(allpoints,'Value');
point=data.list_pt{id_point,2};

% length_cs=pdist(section);
% %calculate the velocity profile and plot it
% [cx_U, cy_U, c_U] =improfile(X_rec,Y_rec,U_rec,section(:,1),section(:,2),50,'nearest');
% [cx_V, cy_V, c_V] =improfile(X_rec,Y_rec,V_rec,section(:,1),section(:,2),50,'nearest');
% c_Mag=(c_U.^2+c_V.^2).^0.5;
% distance=linspace(0,length_cs,size(cx_U,1));
AxeVelU = findobj(gcf,'tag','axevelu');
axes(AxeVelU);
u=data.list_pt{id_point,4};
t=[1:length(u)]*st/1000;
plot(t,u)
hold on
xlabel('Time in [s]', 'FontSize', 11);
ylabel(['U Velocity in [' units '/s]'], 'FontSize', 11);
grid on
xlim([1 length(u)]*st/1000)
set(gca,'tag','axevelu')

AxeVelV= findobj(gcf,'tag','axevelv');
axes(AxeVelV);
v=data.list_pt{id_point,5};
t=[1:length(v)]*st/1000;
plot(t,v)
hold on
xlabel('Time in [s]', 'FontSize', 11);
ylabel(['V Velocity in [' units '/s]'], 'FontSize', 11);
grid on
xlim([1 length(v)]*st/1000)
set(gca,'tag','axevelv')

%plot the rectified image
AxeHimage = findobj(gcf,'tag','axehimage');
axes(AxeHimage);
hold off
pcolor(HX,HY,uint8(Him_out));shading interp; axis image; colormap('gray');
axis equal
hold on
point=list_pt{id_point,2};
plot(point(1),point(2),'x','Color',[0.8 0 0])
plot(point(1),point(2),'o','Color',[0.8 0 0])
plot(Hroi(1,:),Hroi(2,:),'Color',[0.85 0.33 0.1])
axis off
set(gca,'tag','axehimage')


function BtnDeleteCallBack(hObject,eventdata)
allsections = findobj(gcf,'tag','popuplist');
id_section=get(allsections,'Value');
fig=gcf;
data = guidata(fig);
list_pt=data.list_pt;
l=1:size(list_pt,1);
list_pt=list_pt(l(l~=id_section),:);
structgui.list_pt=list_pt;

%find the parent figure
AllF=findall(0,'Type','figure');
rivergui=AllF(end,:);
structgui=struct('list_pt',[]);
structgui.list_pt=list_pt;
guidata(rivergui,structgui);
guidata(fig,structgui);
cmdClose_Callback
function PopupMenuCallBack(hObject,eventdata)
dispresults;
function cmdClose_Callback(hObject,varargin)
fig=gcf;
data = guidata(fig);
list_pt=data.list_pt;
%find the parent figure
AllF=findall(0,'Type','figure');
rivergui=AllF(end,:);
structgui=struct('list_pt',[]);
structgui.list_pt=list_pt;
guidata(rivergui,structgui);
close(fig)

function copy2clipboard_Callback(hObject,varargin)
fig=gcf;
data = guidata(fig);
st=data.st;
allpoints = findobj(gcf,'tag','popuplist');
id_point=get(allpoints,'Value');
u=data.list_pt{id_point,4};
v=data.list_pt{id_point,5};
t=[1:length(u)]*st/1000;

tocopy=[t' u' v'];

clipboard('copy',tocopy)

% AxeVel = findobj(gcf,'tag','axevel');
% axes(AxeVel);
% plot(distance,c_Mag)
% hold on
% min_cs=min(distance);
% max_cs=max(distance);
% line([min_cs min_cs],get(gca,'YLim'),'Color',[0.93 0.69 0.13]);
% line([max_cs max_cs],get(gca,'YLim'),'Color',[0.93 0.69 0.13]);
% xlabel(['Distance in [' units ']'], 'FontSize', 11);
% ylabel(['Velocity in [' units '/s]'], 'FontSize', 11);
% grid on
% limit_axes=get(gca,'xlim');
% set(gca,'tag','axevel')

%plot the rectified image
% AxeHimage = findobj(gcf,'tag','axehimage');
% axes(AxeHimage);
% hold off
% pcolor(HX,HY,uint8(Him_out));shading interp; axis image; colormap('gray');
% axis equal
% hold on
% plot(Hroi(1,:),Hroi(2,:),'Color',[0.85 0.33 0.1])
% set(gca,'tag','axehimage')
% %plot the section
% plot(section(:,1),section(:,2),'Color',[0.93 0.69 0.13])
% axis off
%import the bathymetry profile and plot it
% try
%     bath=data.list_pt{id_section,4};
%     existbath=logical(1);
%     if isempty(bath)
%         existbath=logical(0);
%     end
%     
% catch
%     existbath=logical(0);
% end
% 
% if existbath ==1 %if the bathymetry has been imported
% %     radio_stage= findobj(gcf,'tag','radio_stage');
% %     radio_width= findobj(gcf,'tag','radio_width');
% %     def_stage= findobj(gcf,'tag','def_stage');
% %     radio_stage_value=get(radio_stage,'Value');
% %     radio_width_value=get(radio_width,'Value');
% %     def_stage_string=get(def_stage,'String');
% %     set(radio_stage,'Enable','on');
% %     set(radio_width,'Enable','on');
%     try
%         shift_bath=data.list_pt{id_section,5};
%         if isempty(shift_bath)==1
%             shift_bath=0;
%         end
%     catch
%         shift_bath=0;
%     end
%     
%     [wstage, warea]=rvr_calculate_area(bath,length_cs,radio_stage_value,radio_width_value,def_stage_string,jSlider);
%     
% %     set(def_stage,'String',num2str(wstage))
%     dist=bath(:,1);
%     level=bath(:,2);
% %     
% %     %shift to the origin of the section
% %     dist=dist-warea(1,1)+shift_bath;
% %     warea(:,1)=warea(:,1)-warea(1,1)+shift_bath;
% %     AxeBath= findobj(gcf,'tag','axebath');
% %     axes(AxeBath);
% %     hold off
% %     % plot(dist,level,'k')
% %     
% %     plot(dist,level,'-k');hold on;fill(warea(:,1),warea(:,2),[0 0.45 0.75]);
% %     %     text(warea(end,1),wstage,[' \leftarrow ' num2str(wstage)])
% %     grid on
% %     %plot the limits from the velocity profile
% %     line([min_cs min_cs],get(gca,'YLim'),'Color',[0.93 0.69 0.13]);
% %     line([max_cs max_cs],get(gca,'YLim'),'Color',[0.93 0.69 0.13]);
% %     
% %     xlabel(['Distance in [' units ']'], 'FontSize', 11);
% %     ylabel(['Level in [' units ']'], 'FontSize', 11);
% %     grid on
% %     %fixes the limites of the bath axes
% %     
% %     set(gca,'xlim',limit_axes);
% %     set(gca,'tag','axebath')
% %     
% %     radio_width=findobj('Tag','radio_width');
% %     radio_stage=findobj('Tag','radio_stage');
% %     
% %     %save the bathymetry in 5th column of list_pt.
% %     list_pt{id_section,6}=warea;
% %     data.list_pt=list_pt;
% %     guidata(fig,data);
%     
%     %calculate the discharge
% %    [Q,A]=rvr_calculate_q(warea,[distance' c_Mag]);
% %    set(txt_dis,'String',sprintf('Discharge Q: %.1f m%c/s',Q,179));
%     
% 
% 
% end


