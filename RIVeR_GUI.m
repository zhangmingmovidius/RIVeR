function varargout = RIVeR_GUI(varargin)
% RIVER_GUI MATLAB code for RIVeR_GUI.fig
%      RIVER_GUI, by itself, creates a new RIVER_GUI or raises the existing
%      singleton*.
%
%      H = RIVER_GUI returns the handle to a new RIVER_GUI or the handle to
%      the existing singleton*.
%
%      RIVER_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RIVER_GUI.M with the given input arguments.
%
%      RIVER_GUI('Property','Value',...) creates a new RIVER_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before RIVeR_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to RIVeR_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help RIVeR_GUI

% Last Modified by GUIDE v2.5 06-Feb-2017 14:51:01


% address = java.net.InetAddress.getLocalHost;
% IPaddress = char(address.getHostAddress);
% compu_CETA=strncmpi(IPaddress, '172.16.13', 9);
% iptsetpref('ImshowBorder','loose');
% fecha='01-04-2017'; %dd-mm-yyyy
% x=securitydate(fecha);
% if x==0 %&& compu_CETA==1%this code stops if not working in CETA
%     if exist('kml.m','file')==0
%     cdbckup=pwd;
%     addpath([cdbckup '\rafael-aero-kml-toolbox-37e5b7a'])
%     kml.install;
%     end
%     if exist('export_fig.m','file')==0
%     cdbckup=pwd;
%     addpath([cdbckup '\export_fig'])
%     end
    % Begin initialization code - DO NOT EDIT
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
        'gui_Singleton',  gui_Singleton, ...
        'gui_OpeningFcn', @RIVeR_GUI_OpeningFcn, ...
        'gui_OutputFcn',  @RIVeR_GUI_OutputFcn, ...
        'gui_LayoutFcn',  [] , ...
        'gui_Callback',   []);
    if nargin && ischar(varargin{1})
        gui_State.gui_Callback = str2func(varargin{1});
    end
    
    if nargout
        [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
    else
        gui_mainfcn(gui_State, varargin{:});
    end
% end
% End initialization code - DO NOT EDIT


% --- Executes just before RIVeR_GUI is made visible.
function RIVeR_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);
handles=guihandles(hObject);
setappdata(0,'hgui',gcf);
clc
addpath(fullfile(pwd, 'export_fig'));
t=findobj('tag','txt_tip');
set(t,'String','')
% set(handles.popup_results,'String',{'Vectors';...
%     'Velocity magnitude';...
%     'Vector and magnitude';...
%     'Trajectories (PTV only)'});
set(handles.popup_results,'String',{'Vectors';...
    'Velocity magnitude';... 
    'Vectors & Colors';...
    'Trajectories (PTV only)'});
set(handles.popup_results,'Enable','off');
set(handles.slider_rec,'Enable','off');
set(handles.txt_slider,'String','N/A','Enable','off');
warning off
load('rvr_logo.mat')
get_axes_right
imshow(RIVeR_solo);%display the original Image
axis image
set(gca,'Tag','axes_right')


% UIWAIT makes RIVeR_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = RIVeR_GUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function extract_im_Callback(hObject, eventdata, handles)
PathName=retr('PathName');
if isempty(PathName)==1
    PathName=pwd;
end

[FileName,PathName,FilterIndex] = uigetfile({'*.avi;*.mp4;*.mov;*.dns;*.wmv'},'Select a video',PathName);
if FileName==0
else
    uimakeframes_v2(PathName,FileName)
end

function load_session_Callback(hObject, eventdata, handles)
%cargar la session de PIV o PTV
[FileName,PathName] = uigetfile('*.mat','Select PIV/PTV session');
if FileName~=0
    load([PathName FileName], 'resultslist')
    load([PathName FileName], 'resultslistptv')
    load([PathName FileName], 'PFdata_hgui')
    try
        filename=PFdata_hgui.filename;
    catch
    end
    load([PathName FileName], 'filename')
    log_text = {'Current directory:';...
        PathName;...
        'Session loaded:';...
        FileName};
    % ----------------------------
    statusLogging(handles.LogWindow, log_text)
    
    try%if PIV
        resultslist=resultslist;
    catch%if PTV
        resultslist=PFdata_hgui.resultslist;
        resultslistptv=PFdata_hgui.resultslistptv;
        filename=PFdata_hgui.filename;
        put('resultslistptv',resultslistptv);
    end
    put('FileName',FileName);
    put('PathName',PathName);
    put('filename',filename);
    put('resultslist',resultslist);
    try
        put('resultslistptv',resultslistptv);
    catch
    end
end

function load_cuda_Callback(hObject, eventdata, handles)
[FileName,PathName] = uigetfile('*.mat','CUDA results');
if FileName~=0
    load([PathName FileName])
    log_text = {'Current directory:';...
        PathName;...
        'CUDA Session loaded:';...
        FileName};
    % ----------------------------
    statusLogging(handles.LogWindow, log_text)
   
    x=1:size(ux,2);
    y=1:size(ux,1);
    
    [XOF YOF]=meshgrid(x, y);
    
    resultslist{1,1}=XOF;
    resultslist{2,1}=YOF;
    resultslist{3,1}=double(ux);
    resultslist{4,1}=double(uy);
   
        
    put('FileName',FileName);
    put('PathName',PathName);
    put('resultslist',resultslist);

end


function load_bckg_Callback(hObject, eventdata, handles)
PathName=retr('PathName');
select_background = questdlg('Choose Background Image:', ...
    'Background Image','Select','Automatic','Automatic');

switch select_background
    case 'Select'
        [FileName_Im,PathName_Im] = uigetfile([PathName '*.jpg'],'Select Image to rectify (for display)');
        if FileName_Im~=0
            log_text = {'Background Image loaded:';...
                [PathName_Im FileName_Im]};
            statusLogging(handles.LogWindow, log_text)
            put('FileName_Im',FileName_Im);
            put('PathName_Im',PathName_Im);
        end
    case 'Automatic'
        auto_bckgrd=rvr_auto_bckgrd(PathName);
        imwrite(auto_bckgrd,[PathName 'RIVeR_background.jpg']);
        log_text = {'Automatic Background Image generated.'};
        statusLogging(handles.LogWindow, log_text)
        put('FileName_Im','RIVeR_background.jpg');
        put('PathName_Im',PathName);
        
end

function load_cp_Callback(hObject, eventdata, handles)
PathName=retr('PathName');
[FileName_CP,PathName_CP] = uigetfile([PathName '*.jpg'],'Select Image with Control Points (CPs)on');
log_text = {'Control Points Image loaded:';...
    [PathName_CP FileName_CP]};
statusLogging(handles.LogWindow, log_text)
put('FileName_CP',FileName_CP);
put('PathName_CP',PathName_CP);


function define_cps_Callback(hObject, eventdata, handles)
warning off
PathName_CP=retr('PathName_CP');
FileName_CP=retr('FileName_CP');
units=check_unit;

get_axes_left
imshow([PathName_CP FileName_CP]);%display the original Image
set(gca,'Tag','axes_left')

%Real World Coordinates
X=[];
Y=[];
%Pixel Coordinates
x=[];
y=[];
text_tip('LEFT-click to ZOOM-IN RIGHT-click to select')
for i=1:4
    
    [xCoor yCoor]=rvr_ginput(1);
    hold on
    if i==1
        plot(xCoor,yCoor,'o','LineWidth',2,'Color',[0.9 0 0]);
    else
        plot(xCoor,yCoor,'o','LineWidth',2,'Color',[0 0.45 0.74]);
    end
    plot(xCoor,yCoor,'.k')
    x=[x xCoor];
    y=[y yCoor];
end

text_tip('');

% plot([x(1) x(2)],[y(1) y(2)],'LineWidth',2,'Color',[0 0.45 0.74]);
% plot([x(2) x(3)],[y(2) y(3)],'LineWidth',2,'Color',[0.85 0.33 0.1]);
% plot([x(3) x(4)],[y(3) y(4)],'LineWidth',2,'Color',[0.93 0.69 0.13]);
% plot([x(4) x(1)],[y(4) y(1)],'LineWidth',2,'Color',[0.49 0.18 0.56]);
% plot([x(1) x(3)],[y(1) y(3)],'LineWidth',2,'Color',[0.47 0.67 0.19]);
% plot([x(2) x(4)],[y(2) y(4)],'LineWidth',2,'Color',[0.3 0.75 0.93]);
plot([x(1) x(2)],[y(1) y(2)],'b','LineWidth',2);
plot([x(2) x(3)],[y(2) y(3)],'r','LineWidth',2);
plot([x(3) x(4)],[y(3) y(4)],'g','LineWidth',2);
plot([x(4) x(1)],[y(4) y(1)],'k','LineWidth',2);
plot([x(1) x(3)],[y(1) y(3)],'m','LineWidth',2);
plot([x(2) x(4)],[y(2) y(4)],'c','LineWidth',2);

units=check_unit;

[X Y L]=rvr_solver(PathName_CP,units);


%Reshape input to compute homography
m(1,:)=x;
m(2,:)=y;
m(3,:)=1;

M(1,:)=X;
M(2,:)=Y;
M(3,:)=1;

put('M',M);
put('m',m);

%make a backup
mbck_up=m;
put('mbck_up',mbck_up);

%copy axes in invisble figure
% ca=gca;
% new_fig('fig_length',ca)
% recenter_axes;

log_text = {['Control Points Coordinates:'];...
    ['X=[' num2str(m(1,:)) ']' ];...
    ['Y=[' num2str(m(2,:)) ']' ];...
    'Real World distances:';
    ['1-2: ' L{1} ' ' units];...
    ['2-3: ' L{2} ' ' units];...
    ['3-4: ' L{3} ' ' units];...
    ['4-1: ' L{4} ' ' units];...
    ['1-3: ' L{5} ' ' units];...
    ['2-4: ' L{6} ' ' units]};

vq=[];
put('vq',vq);
put('L',L);


statusLogging(handles.LogWindow, log_text)

function define_roi_Callback(hObject, eventdata, handles)
warning off
PathName_CP=retr('PathName_CP');
FileName_CP=retr('FileName_CP');
try
    Img=rgb2gray(imread([PathName_CP FileName_CP]));
catch
    Img=imread([PathName_CP FileName_CP]);
end

get_axes_left
imshow([PathName_CP FileName_CP]);%display the original Image
set(gca,'Tag','axes_left')

text_tip('Select the area you want to rectify');

%define ROI
[mask,ximask,yimask]=roipoly;
I(1,:)=ximask;
I(2,:)=yimask;
I(3,:)=1;
Imask=I;
put('Imask',Imask)
%shade everything outside ROI
Img_roi=shade_out_roi(Img,I);
put('Img_roi',Img_roi)
plotroi;

text_tip('');

log_text = {['Region Of Interest defined:'];...
    ['X=[' num2str(I(1,1:4)) ']'];...
    ['Y=[' num2str(I(2,1:4)) ']']};
statusLogging(handles.LogWindow, log_text)


function define_time_Callback(hObject, eventdata, handles)
promptTime = {'sampling time in [ms]'};
dlg_title_Time = 'sampling time';
num_lines_Time = 1;
def_Coor = {'100'};
options.Resize='on';
options.WindowStyle='normal';

answer_Time = inputdlg(promptTime,dlg_title_Time,num_lines_Time,def_Coor,options);
st=str2double(answer_Time{1});
put('st',st);
log_text = {['Sampling time defined: ' num2str(st) 'ms']};
statusLogging(handles.LogWindow, log_text)

function rectify_it_Callback(hObject, eventdata, handles)
%make the rectification with initial data In case orientation has been
%modified
% rotM=[];
% put('rotM',rotM);
rectify_res

function define_dir_Callback(hObject, eventdata, handles)
Him_out=retr('Him_out');
Hroi=retr('Hroi');
HX=retr('HX');
HY=retr('HY');
M=retr('M');
rotM=retr('rotM');
if isempty(rotM)==0
    M=rotM;
end
%plot actual Y direction and get the new one
plot_rec_bck(HX,HY,Him_out,Hroi)
x(1)=HX(1,round(size(HX,2)/2));
x(2)=x(1);
y(1)=HY(10,1);
y(2)=HY(end-10,1);
h = imline(gca, x, y)
new_dir = wait(h);
delete(h);
rotM=rvr_make_rotation(new_dir,M);
put('rotM',rotM)
rectify_it_Callback([],[],[])

function sliderdisp
handles=gethand;
warning off
resultslist=retr('resultslist');
resultslistptv=retr('resultslistptv');
filename=retr('filename');
st=retr('st');
H=retr('H');
Him_out=retr('Him_out');
Hroi=retr('Hroi');
HX=retr('HX');
HY=retr('HY');
id_result=get(handles.slider_rec, 'value');
set(handles.popup_results,'Enable','on');
set(handles.slider_rec,'Enable','on');
try
    cm=check_mean(filename);
catch
    cm=0;
end
if id_result==size(resultslist,2) && cm==1
    set(handles.txt_slider,'String',['Result: ' num2str(id_result) '/' num2str(size(resultslist,2)) ' (Mean)'] ,...
        'Enable','on',...
        'BackgroundColor',[0 1 0],...
        'Position',[1 32.5000 23 1.2308]);
else
    set(handles.txt_slider,'String',['Result: ' num2str(id_result) '/' num2str(size(resultslist,2))] ,...
        'Enable','on',...
        'BackgroundColor',[0.9400 0.9400 0.9400],...
        'Position',[1 32.5000 25 1.2308]);
    
end

%get mesh definition form GUI
m=str2double(get(handles.m_val,'String'));%number of elments on x
n=str2double(get(handles.n_val,'String'));%number of elments on y
res_rec=[m n]; %results resolution on x and y respectively


    %recttify results
    [X_rec Y_rec U_rec V_rec]=rvr_rec_res(resultslist(:,id_result),H,Hroi,st,res_rec);
    Mag_rec=(U_rec.^2+V_rec.^2).^0.5;
    
    %choose what to plot
    deriv=get(handles.popup_results, 'value');
    
    %shading outside Hroi
    Him_out=shade_out_Hroi(HX,HY,Him_out,Hroi);
    if deriv==1
        scale=str2double(get(handles.size_val,'String'));
        plot_rec_bck(HX,HY,Him_out,Hroi)
        RGB=color_vector;
        quiver(X_rec, Y_rec, U_rec, V_rec,scale,'Color',RGB)
        set(gca,'Tag','axes_right')
    end
    
    if deriv==2
        [imageData alpha]=getfigure(HX,HY,Him_out,Hroi,X_rec,Y_rec,Mag_rec);
        get_axes_right
        h=imshow(imageData);
        set(h, 'AlphaData', alpha);
        set(gca,'Tag','axes_right')
    end
    if deriv==3
        [imageData alpha]=getfigure_colarrows(HX,HY,Him_out,Hroi,X_rec,Y_rec,U_rec,V_rec);
        get_axes_right
        h=imshow(imageData);
        set(h, 'AlphaData', alpha);
        set(gca,'Tag','axes_right')
    end
    if deriv==4
        id_traj=get(handles.id_traj, 'String');
        %     pcolor(HX,HY,uint8(Him_out));shading interp; axis image; colormap('gray');
        %     hold on
        if id_result~=1
            if isempty(id_traj)==1
                clear id_traj
                id_traj=[];
            else
                id_traj=eval(id_traj);
            end
            
            [H_traj id_traj no_id]=rvr_rec_traj(id_result,resultslistptv,st,H,Hroi,id_traj);
            
            [imageData alpha]=getfigure_traj(HX,HY,H_traj,id_traj,no_id,Him_out,Hroi);
            get_axes_right
            h=imshow(imageData);
            set(h, 'AlphaData', alpha)
            set(gca,'Tag','axes_right')
            
            set(handles.id_traj, 'String',['[' num2str(min(id_traj)) ':' num2str(max(id_traj)) ']']);
            put('H_traj',H_traj);
            put('id_traj',id_traj);
        end
    end





function rectify_res
handles=gethand;
warning off
Imask=retr('Imask');
m=retr('m');
M=retr('M');
rotM=retr('rotM');
H=retr('H');
if isempty(H)==1
    firsttime=logical(1);
else
    firsttime=logical(0);
end
% PathName=retr('PathName');
% PathName_CP=retr('PathName_CP');
% FileName_CP=retr('FileName_CP');
PathName_Im=retr('PathName_Im');
FileName_Im=retr('FileName_Im');
resultslist=retr('resultslist');
% st=retr('st');

%Compute Homography matrix
log_text = {'Computation of the Homography matrix...'};
statusLogging(handles.LogWindow, log_text)
if isempty(rotM)==1
    [H,Hnorm,inv_Hnorm] = compute_homography(m,M);
else
    [H,Hnorm,inv_Hnorm] = compute_homography(m,rotM);%if rotation has been made
end
put('H',H);

if firsttime==1
    Hbckup=H; %backup H
    put('Hbckup',Hbckup);
end

log_text = {'done !'};
statusLogging(handles.LogWindow, log_text)

%rectify background Image
im=imread([PathName_Im FileName_Im]);
[Him_out,HX,HY,Hroi]=rvr_rec_im(im,Imask,H);
put('Him_out',Him_out);
put('HX',HX);
put('HY',HY);
put('Hroi',Hroi);

%set the slider
try
set(handles.slider_rec, 'value',1, ...
    'enable','on',...
    'min', 1,...
    'max',size(resultslist,2),...
    'sliderstep', [1/(size(resultslist,2)-1) 1/(size(resultslist,2)-1)*10]);
catch
    set(handles.slider_rec, 'value',1, ...
    'enable','on',...
    'min', 1,...
    'max',size(resultslist,2))
end

sliderdisp


function put(name, what)
hgui=getappdata(0,'hgui');
setappdata(hgui, name, what);

function var = retr(name)
hgui=getappdata(0,'hgui');
var=getappdata(hgui, name);

function handles=gethand
hgui=getappdata(0,'hgui');
handles=guihandles(hgui);

function export_Callback(hObject, eventdata, handles)

function SaveLog_Callback(hObject, eventdata, handles)
save_log(handles);

function ClearLog_Callback(hObject, eventdata, handles)
set(handles.LogWindow,'string','')

function get_axes_left
h=findobj('Type','axes','Tag','axes_left');
axes(h)
set(gca,'Visible','on')
hold off

function get_axes_right
h=findobj('Type','axes','Tag','axes_right');
axes(h)
set(gca,'Visible','on')
hold off

function new_fig(name_figure,current_axes)
delete(findobj('Name',name_figure));
figure('Name',name_figure)
h=gcf;
colormap('gray');
s = copyobj(current_axes,h)

function recenter_axes
pos_axes=get(gca,'Position');
set(gca,'Position',[0 0 pos_axes(3) pos_axes(4)]);

function text_tip(var)
t=findobj('tag','txt_tip');
set(t,'String', var)

function out=shade_out_roi(Img,I)
x=1:size(Img,2);
y=1:size(Img,1);
[X Y]=meshgrid(x,y);
lX=reshape(X,size(Img,1)*size(Img,2),1);
lY=reshape(Y,size(Img,1)*size(Img,2),1);
lImg=reshape(Img,size(Img,1)*size(Img,2),1);
[ind,on] = inpolygon(lX,lY,I(1,:)',I(2,:)');
out=Img;
out(ind==0)=out(ind==0)-70;

function out=shade_out_Hroi(HX,HY,Him_out,Hroi)
lX=reshape(HX,size(Him_out,1)*size(Him_out,2),1);
lY=reshape(HY,size(Him_out,1)*size(Him_out,2),1);
lImg=reshape(Him_out,size(Him_out,1)*size(Him_out,2),1);
[ind,on] = inpolygon(lX,lY,Hroi(1,:)',Hroi(2,:)');
out=Him_out;
out(ind==0)=out(ind==0)-70;

function plotroi
Img_roi=retr('Img_roi');
get_axes_left
imshow(Img_roi);
Imask=retr('Imask');
hold on
plot(Imask(1,:),Imask(2,:),'Color',[0.85 0.33 0.1])
set(gca,'Tag','axes_left')

function plot_rec_bck(HX,HY,Him_out,Hroi)
get_axes_right
pcolor(HX,HY,uint8(Him_out));shading interp; axis image; colormap('gray');
axis equal
hold on
plot(Hroi(1,:),Hroi(2,:),'Color',[0.85 0.33 0.1])
plotruller(HX, HY)
axis off
set(gca,'Tag','axes_right')

function slider_rec_Callback(hObject, eventdata, handles)
Value=get(handles.slider_rec, 'value');
Value=round(Value);
set(handles.slider_rec,'value',Value);
sliderdisp

function plotruller(HX,HY)
units=check_unit;
Xlim=get(gca,'XLim');
Ylim=get(gca,'YLim');
dx=(Xlim(2)-Xlim(1));
dy=(Ylim(2)-Ylim(1));
roundTargets = [0.25 0.5 1 1.5 2 2.5 3 4 5 10 15 20 30 50 100 200];
dist_Rounded = interp1(roundTargets,roundTargets,dx/4,'nearest');

beginx=HX(1,10);
beginy=HY(30,1);
line([beginx beginx+dist_Rounded],[beginy beginy],'LineWidth',2,'Color',[1 1 1])
line([beginx beginx],[beginy HY(35,1);],'LineWidth',2,'Color',[1 1 1])
line([beginx+dist_Rounded beginx+dist_Rounded],[beginy HY(35,1);],'LineWidth',2,'Color',[1 1 1])
text(beginx,HY(50,1),[num2str(dist_Rounded) ' ' units],...
    'Fontsize',12,...
    'Color',[1 1 1],...
    'FontWeight','bold')

function units=check_unit
handles=gethand;
isuni_si=get(handles.unit_si,'Checked');
if strcmp(isuni_si,'on')==1
    units='m';
else
    units='ft';
end

function duplicate_axe
Xlim=get(gca,'XLim');
Ylim=get(gca,'YLim');
freezeColors
ax2 = axes('Position',get(gca,'Position'),...
    'Color','none',...
    'XColor','k','YColor','k',...
    'Tag','duplicate');
axis off
axis equal
set(ax2, 'box','off','XTickLabel',[],'XTick',[],'YTickLabel',[],'YTick',[])

xlim(Xlim)
ylim(Ylim)

function [imageData, alpha]=getfigure(HX,HY,Him_out,Hroi,X_rec,Y_rec,Z_rec);
handles=gethand;
H=figure('Visible','off','Position',[160   368   732   465]);
pcolor(HX,HY,uint8(Him_out));shading interp; axis image; colormap('gray');
axis equal
hold on
plot(Hroi(1,:),Hroi(2,:),'Color',[0.85 0.33 0.1])
axis off
%     set(gca,'LooseInset',get(gca,'TightInset'))

duplicate_axe
hold on
h=pcolor(X_rec, Y_rec,Z_rec);
set(h,'AlphaData',double(~isnan(Z_rec)))
shading flat
selected_cmap=get(handles.rvr_colormap,'Value');
auto_c=get(handles.chk_auto,'Value');
if auto_c==1
    set(handles.limc_min,'String',num2str(min(min(Z_rec))));
    set(handles.limc_max,'String',num2str(max(max(Z_rec))));
else
    min_colorbar=str2num(get(handles.limc_min,'String'));
    max_colorbar=str2num(get(handles.limc_max,'String'));
    caxis([min_colorbar max_colorbar])
end
if selected_cmap ==1
    load('CC_cool.mat');
    colormap(CC_cool)
end
if selected_cmap ==2
    colormap('parula')
end
if selected_cmap ==3
    colormap('jet')
end
if selected_cmap ==4
    load('hsbmap.mat');
    colormap(hsb)
end
if selected_cmap ==5
    colormap('hot')
end
if selected_cmap ==6
    colormap('cool')
end
if selected_cmap ==7
    colormap('Spring')
end
if selected_cmap ==8
    colormap('Summer')
end
if selected_cmap ==9
    colormap('Autumn')
end
if selected_cmap ==10
    colormap('Winter')
end
if selected_cmap ==11
    colormap('Gray')
end
if selected_cmap ==12
    colormap('Bone')
end
if selected_cmap ==13
    colormap('Copper')
end
originalSize = get(gca, 'Position');
set(findobj(gcf, 'type','axes'), 'Visible','off')
Bara_color=colorbar('location','EastOutside');
plotruller(HX, HY)

set(Bara_color,'FontSize',12)
set(gca,'Position',originalSize);
PosHini=get(H,'Position');
[imageData, alpha] = export_fig(gcf,'-transparent','-r350');
close(H)

function [imageData, alpha]=getfigure_traj(HX,HY,H_traj,id_traj,no_id,Him_out,Hroi);
handles=gethand;
H=figure('Visible','off','Position',[160   368   732   465]);
pcolor(HX,HY,uint8(Him_out));shading interp; axis image; colormap('gray');
axis equal
hold on
plot(Hroi(1,:),Hroi(2,:),'Color',[0.85 0.33 0.1])
axis off


duplicate_axe
hold on

min_colorbar=str2double(get(handles.limc_min,'String'));
max_colorbar=str2double(get(handles.limc_max,'String'));


for i=id_traj
    if isempty(find(no_id==i, 1))==1 %only if the Id exist
        x=H_traj{i}(:,1);
        y=H_traj{i}(:,2);
        z=0*H_traj{i}(:,1);
        c=H_traj{i}(:,3);
        
        c(c<min_colorbar)=min_colorbar;
        c(c>max_colorbar)=max_colorbar;
        
        h = surface(...
            'XData',[x(:) x(:)],...
            'YData',[y(:) y(:)],...
            'ZData',[z(:) z(:)],...
            'CData',[c(:) c(:)],...
            'FaceColor','none',...
            'EdgeColor','flat',...
            'Marker','none');
    end
end


selected_cmap=get(handles.rvr_colormap,'Value');
auto_c=get(handles.chk_auto,'Value');
caxis([min_colorbar max_colorbar])

if selected_cmap ==1
    load('CC_cool.mat');
    colormap(CC_cool)
end
if selected_cmap ==2
    colormap('parula')
end
if selected_cmap ==3
    colormap('jet')
end
if selected_cmap ==4
    load('hsbmap.mat');
    colormap(hsb)
end
if selected_cmap ==5
    colormap('hot')
end
if selected_cmap ==6
    colormap('cool')
end
if selected_cmap ==7
    colormap('Spring')
end
if selected_cmap ==8
    colormap('Summer')
end
if selected_cmap ==9
    colormap('Autumn')
end
if selected_cmap ==10
    colormap('Winter')
end
if selected_cmap ==11
    colormap('Gray')
end
if selected_cmap ==12
    colormap('Bone')
end
if selected_cmap ==13
    colormap('Copper')
end
originalSize = get(gca, 'Position');
set(findobj(gcf, 'type','axes'), 'Visible','off')
Bara_color=colorbar('location','EastOutside');
plotruller(HX, HY)

set(Bara_color,'FontSize',12)
set(gca,'Position',originalSize);
PosHini=get(H,'Position');
[imageData, alpha] = export_fig(gcf,'-transparent','-r350');
close(H)

function [imageData, alpha]=getfigure_colarrows(HX,HY,Him_out,Hroi,X_rec,Y_rec,U_rec,V_rec);
handles=gethand;
H=figure('Visible','off','Position',[160   368   732   465]);
pcolor(HX,HY,uint8(Him_out));shading interp; axis image; colormap('gray');
axis equal
hold on
plot(Hroi(1,:),Hroi(2,:),'Color',[0.85 0.33 0.1])
axis off

duplicate_axe
hold on

Z_rec=(U_rec.^2+V_rec.^2).^0.5;
selected_cmap=get(handles.rvr_colormap,'Value');
auto_c=get(handles.chk_auto,'Value');

if auto_c==1
    set(handles.limc_min,'String',num2str(min(min(Z_rec))));
    set(handles.limc_max,'String',num2str(max(max(Z_rec))));
end
    min_colorbar=str2num(get(handles.limc_min,'String'));
    max_colorbar=str2num(get(handles.limc_max,'String'));
    caxis([min_colorbar max_colorbar])

if selected_cmap ==1
    load('CC_cool.mat');
    cmap=CC_cool;
end
if selected_cmap ==2
    cmap=parula;
end
if selected_cmap ==3
    cmap=jet;
end
if selected_cmap ==4
    load('hsbmap.mat');
    cmap=hsb;
end
if selected_cmap ==5
    cmap=hot;
end
if selected_cmap ==6
    cmap=cool;
end
if selected_cmap ==7
    cmap=Spring;
end
if selected_cmap ==8
    cmap=Summer;
end
if selected_cmap ==9
    cmap=Autumn;
end
if selected_cmap ==10
   cmap=Winter;
end
if selected_cmap ==11
    cmap=Gray;
end
if selected_cmap ==12
    cmap=Bone;
end
if selected_cmap ==13
    cmap=Copper;
end

rvr_quiverc(X_rec, Y_rec,U_rec,V_rec,min_colorbar,max_colorbar,cmap);

originalSize = get(gca, 'Position');
set(findobj(gcf, 'type','axes'), 'Visible','off')
Bara_color=colorbar('location','EastOutside');
caxis([min_colorbar max_colorbar])
colormap(cmap)
plotruller(HX, HY)

set(Bara_color,'FontSize',12)
set(gca,'Position',originalSize);
PosHini=get(H,'Position');
[imageData, alpha] = export_fig(gcf,'-transparent','-r350');
close(H)


function out=color_vector
handles=gethand;
R=str2num(get(handles.R_vec, 'String'))/255;
G=str2num(get(handles.G_vec, 'String'))/255;
B=str2num(get(handles.B_vec, 'String'))/255;
out=[R G B];

function chk_auto_Callback(hObject, eventdata, handles)
handles=gethand;
auto_c=get(handles.chk_auto,'Value');
if auto_c==1
    set(handles.limc_min,'Enable','off');
    set(handles.limc_max,'Enable','off');
else
    set(handles.limc_min,'Enable','on');
    set(handles.limc_max,'Enable','on');
end
sliderdisp

function show_cps_Callback(hObject, eventdata, handles)
handles=gethand;
HX=retr('HX');
HY=retr('HY');
Him_out=retr('Him_out');
Hroi=retr('Hroi');
cps_on=get(handles.show_cps,'Value');
if cps_on==1
    disp_cps
else
    get_axes_left
    plotroi
    set(gca,'Tag','axes_left')
    
    get_axes_right
    Him_out=shade_out_Hroi(HX,HY,Him_out,Hroi);
    plot_rec_bck(HX,HY,Him_out,Hroi)
    set(gca,'Tag','axes_right')
end

function disp_cps
m=retr('m');
M=retr('M');
rotM=retr('rotM');
HX=retr('HX');
HY=retr('HY');
Him_out=retr('Him_out');
Hroi=retr('Hroi');

get_axes_left
plotroi
set(gca,'Tag','axes_left')
hold on
plot(m(1,:),m(2,:),'.','Color',[0.93 0.69 0.13])
for i=1:size(m,2)
    text(m(1,i)+15,m(2,i),['CP_' num2str(i)],'Color',[0.93 0.69 0.13],'FontSize',10,'FontWeight','bold')
end

get_axes_right
Him_out=shade_out_Hroi(HX,HY,Him_out,Hroi);
plot_rec_bck(HX,HY,Him_out,Hroi)
set(gca,'Tag','axes_right')
hold on
if isempty(rotM)==1
    plot(M(1,:),M(2,:),'.','Color',[0.93 0.69 0.13])
    for i=1:size(M,2)
        text(M(1,i),M(2,i),['CP_' num2str(i)],'Color',[0.93 0.69 0.13],'FontSize',10,'FontWeight','bold')
    end
else
    plot(rotM(1,:),rotM(2,:),'.','Color',[0.93 0.69 0.13])
    for i=1:size(rotM,2)
        text(rotM(1,i)+15,rotM(2,i),['CP_' num2str(i)],'Color',[0.93 0.69 0.13],'FontSize',10,'FontWeight','bold')
    end
end

function popup_results_Callback(hObject, eventdata, handles)
sliderdisp

function limc_min_Callback(hObject, eventdata, handles)
sliderdisp

function limc_max_Callback(hObject, eventdata, handles)
sliderdisp

function R_vec_Callback(hObject, eventdata, handles)
sliderdisp

function G_vec_Callback(hObject, eventdata, handles)
sliderdisp

function B_vec_Callback(hObject, eventdata, handles)
sliderdisp

function rvr_colormap_Callback(hObject, eventdata, handles)
sliderdisp

function m_val_Callback(hObject, eventdata, handles)
sliderdisp

function n_val_Callback(hObject, eventdata, handles)
sliderdisp

function size_val_Callback(hObject, eventdata, handles)
sliderdisp

function id_traj_Callback(hObject, eventdata, handles)
sliderdisp

function cm=check_mean(filename)
lastname=filename{end,1};
k = strfind(lastname,'MEAN');
if isempty(k)==1
    cm=logical(0);
else
    cm=logical(1);
end

function about_Callback(hObject, eventdata, handles)
iptsetpref('ImshowBorder','tight');
img=imread('RIVeR.png');
fig_splash=figure;
imshow(img);
set(fig_splash, 'Name', 'About - RIVeR',...
    'ToolBar', 'none',...
    'MenuBar', 'none',...
    'NumberTitle','off',...
    'Resize', 'off')
iptsetpref('ImshowBorder','loose');
btn_aply = uicontrol('Style', 'pushbutton', 'String', 'Copy adress',...
    'Position', [190 140 80 20],...
    'Callback', @aply_email);

function workflow_Callback(hObject, eventdata, handles)
handles=gethand;
Him_out=retr('Him_out');
M=retr('M');
FileName_CP=retr('FileName_CP');
FileName_Im=retr('FileName_Im');
st=retr('st');
if isempty(Him_out)==1
    set(handles.define_dir,'Enable','off');
    set(handles.shift_plane,'Enable','off');
else
    set(handles.define_dir,'Enable','on');
    set(handles.shift_plane,'Enable','on');
end
if isempty(FileName_CP)==1
    set(handles.cp_definition,'Enable','off');
    set(handles.define_roi,'Enable','off');
else
    set(handles.cp_definition,'Enable','on');
    set(handles.define_roi,'Enable','on');
end
if isempty(FileName_CP)==1 || isempty(M)==1 || isempty(FileName_Im)==1 || isempty(st)==1
    set(handles.rectify_it,'Enable','off');
else
    set(handles.rectify_it,'Enable','on');
end

function crosssection_Callback(hObject, eventdata, handles)
handles=gethand;
Him_out=retr('Him_out');
M=retr('M');
list_cs=retr('list_cs');
% if  isempty(M)==1 || isempty(Him_out)==1
if  isempty(Him_out)==1
    set(handles.addcs,'Enable','off');
    set(handles.edit_cs,'Enable','off');
else
    set(handles.addcs,'Enable','on');
    set(handles.edit_cs,'Enable','on');
end
if isempty(list_cs)==1
    set(handles.edit_cs,'Enable','off');
else
    set(handles.edit_cs,'Enable','on');
end


function unit_si_Callback(hObject, eventdata, handles)
handles=gethand;
set(handles.unit_imp,'Checked','off');
set(handles.unit_si,'Checked','on');
sliderdisp

function unit_imp_Callback(hObject, eventdata, handles)
handles=gethand;
set(handles.unit_imp,'Checked','on');
set(handles.unit_si,'Checked','off');
sliderdisp

function addcs_orig_Callback(hObject, eventdata, handles)
list_cs=retr('list_cs');
H=retr('H');
HX=retr('HX');
HY=retr('HY');
Him_out=retr('Him_out');
Hroi=retr('Hroi');


%plot the section on the left
get_axes_left
plotroi
set(gca,'Tag','axes_left')
hold on
h=imline(gca);
new_cs = wait(h);
delete(h);
plot(new_cs(:,1),new_cs(:,2),'Color',[0.93 0.69 0.13]);

%rectify the new cross-section
Hnew_cs=rvr_trans2rw([new_cs'; 1 1],H)';

%plot the section on the right
get_axes_right

set(gca,'Tag','axes_right')
Him_out=shade_out_Hroi(HX,HY,Him_out,Hroi);
plot_rec_bck(HX,HY,Him_out,Hroi)
set(gca,'Tag','axes_right')
hold on
plot(Hnew_cs(:,1),Hnew_cs(:,2),'Color',[0.93 0.69 0.13]);

%ask for a name
promptCS = {'Name'};
dlg_title_CS = 'Name of Section';
def_Coor = {['CS_' num2str(size(list_cs,1))]};
options.Resize='on';
options.WindowStyle='normal';
answer_name = inputdlg(promptCS,dlg_title_CS,1,def_Coor,options);

if isempty(answer_name)==0
    %put the section in the section  list
    list_cs{end+1,1}=new_cs;
    list_cs{end,2}=Hnew_cs;
    list_cs{end,3}=answer_name;
    
    put('list_cs',list_cs);
    
    %call edit section
    edit_cs_Callback
else
end

function addcs_rec_Callback(hObject, eventdata, handles)
list_cs=retr('list_cs');
H=retr('H');
HX=retr('HX');
HY=retr('HY');
Him_out=retr('Him_out');
Hroi=retr('Hroi');

%plot the section on the right
get_axes_right

set(gca,'Tag','axes_right')
Him_out=shade_out_Hroi(HX,HY,Him_out,Hroi);
plot_rec_bck(HX,HY,Him_out,Hroi)
set(gca,'Tag','axes_right')
hold on
h=imline(gca);
Hnew_cs = wait(h);
delete(h);
plot(Hnew_cs(:,1),Hnew_cs(:,2),'Color',[0.93 0.69 0.13]);

%un-rectify the new cross-section
new_cs=rvr_trans2pix([Hnew_cs'; 1 1],H)';

%plot the section on the left
get_axes_left
plotroi
set(gca,'Tag','axes_left')
hold on

plot(new_cs(:,1),new_cs(:,2),'Color',[0.93 0.69 0.13]);

%ask for a name
promptCS = {'Name'};
dlg_title_CS = 'Name of Section';
def_Coor = {['CS_' num2str(size(list_cs,1))]};
options.Resize='on';
options.WindowStyle='normal';
answer_name = inputdlg(promptCS,dlg_title_CS,1,def_Coor,options);

if isempty(answer_name)==0
    
    %put the section in the section  list
    list_cs{end+1,1}=new_cs;
    list_cs{end,2}=Hnew_cs;
    list_cs{end,3}=answer_name;
    
    put('list_cs',list_cs);
    
    %call edit section
    edit_cs_Callback
else
end

function edit_cs_Callback(hObject, eventdata, handles)
handles=gethand;
PathName=retr('PathName');
list_cs=retr('list_cs');
H=retr('H');
Hroi=retr('Hroi');
HX=retr('HX');
HY=retr('HY');
Him_out=retr('Him_out');
st=retr('st');
resultslist=retr('resultslist');
id_result=get(handles.slider_rec, 'value');
units=check_unit;
m=str2double(get(handles.m_val,'String'));%number of elments on x
n=str2double(get(handles.n_val,'String'));%number of elments on y
res_rec=[m n];

%calculate the current rectified velocity field
[X_rec Y_rec U_rec V_rec]=rvr_rec_res(resultslist(:,id_result),H,Hroi,st,res_rec);


gray = get(0,'DefaultUIControlBackgroundColor');
wfig=800;
hfig=660;
fig = figure;
rvr_edit_cs_gui(PathName,list_cs,units,X_rec, Y_rec, U_rec, V_rec,HX,HY,Him_out,Hroi)
waitfor(fig)
data = guidata(gcf);
try
    list_cs=data.list_cs;
    put('list_cs',list_cs);
catch
end







function slider_rec_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_rec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function LogWindow_Callback(hObject, eventdata, handles)

function LogWindow_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LogWindow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function file_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function popup_results_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_results (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes during object creation, after setting all properties.
function rvr_colormap_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rvr_colormap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function limc_min_CreateFcn(hObject, eventdata, handles)
% hObject    handle to limc_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function limc_max_CreateFcn(hObject, eventdata, handles)
% hObject    handle to limc_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





% --- Executes during object creation, after setting all properties.
function B_vec_CreateFcn(hObject, eventdata, handles)
% hObject    handle to B_vec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





% --- Executes during object creation, after setting all properties.
function G_vec_CreateFcn(hObject, eventdata, handles)
% hObject    handle to G_vec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes during object creation, after setting all properties.
function R_vec_CreateFcn(hObject, eventdata, handles)
% hObject    handle to R_vec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes during object creation, after setting all properties.
function n_val_CreateFcn(hObject, eventdata, handles)
% hObject    handle to n_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





% --- Executes during object creation, after setting all properties.
function m_val_CreateFcn(hObject, eventdata, handles)
% hObject    handle to m_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes during object creation, after setting all properties.
function size_val_CreateFcn(hObject, eventdata, handles)
% hObject    handle to size_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function info_Callback(hObject, eventdata, handles)
% hObject    handle to info (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function settings_Callback(hObject, eventdata, handles)
% hObject    handle to settings (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




function addcs_Callback(hObject, eventdata, handles)
% hObject    handle to addcs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function shift_plane_Callback(hObject, eventdata, handles)
handles=gethand;
mbck_up=retr('mbck_up');
Hbckup=retr('Hbckup');
H=retr('H');
PathName_CP=retr('PathName_CP');
FileName_CP=retr('FileName_CP');
m=retr('m');

H=Hbckup;
m=mbck_up;
rotM=[];
put('m',m);
put('rotM',rotM);
put('H',H);

%get the internal parameters of the camera
intParam=rvr_select_camera;

[V1 V2]=rvr_calc_vanish(H);
choice_load_newI = questdlg('Would you like to load another picture to select the WS ?', ...
    'Select WS', ...
    'Yes','No','No');
switch choice_load_newI
    case 'Yes'
        [FileName_CP_WS,PathName_CP_WS] = uigetfile([PathName_CP '*.jpg'],'Select Image with point on WS');
        im2disp=[PathName_CP_WS FileName_CP_WS];
    case 'No'
        im2disp=[PathName_CP FileName_CP];
end

get_axes_left
imshow(im2disp);%display the original Image
set(gca,'Tag','axes_left')

%select a section that is at the Control points Level
uiwait(msgbox('Select the Cross Section (same level as the CPs) from the Left bank to the Right bank'));
text_tip('LEFT-click to ZOOM-IN RIGHT-click to select')
pt_I=rvr_ginput(1);
hold on
plot(pt_I(1), pt_I(2),'.k')
plot(pt_I(1), pt_I(2),'o','Linewidth',2,'Color',[0.93 0.69 0.13])
pt_D=rvr_ginput(1);
plot(pt_D(1), pt_D(2),'.k')
plot(pt_D(1), pt_D(2),'o','Linewidth',2,'Color',[0.93 0.69 0.13])
plot([pt_I(1) pt_D(1)],[pt_I(2) pt_D(2)],'Linewidth',2,'Color',[0.93 0.69 0.13])
text_tip('')

%select a point that is on both the WS and the Cross Section
uiwait(msgbox('Select a point that is on both the WS and the Cross Section'));
pt_topo=rvr_ginput(1);
hold on
plot(pt_topo(1),pt_topo(2),'xc','LineWidth',2);
plot(pt_topo(1),pt_topo(2),'.k');
text_tip('')

log_text = {'Control points vertical shifting:'};
statusLogging(handles.LogWindow, log_text)

%calculate the third Vanishing point V3
V3=rvr_compute_v3([V1';1],[V2';1],intParam);

%shift the control points to Water level
shifted_CPs=rvr_move_cps(m,V1,V2,V3,pt_I,pt_D,pt_topo)';

get_axes_left
imshow(im2disp);%display the original Image
set(gca,'Tag','axes_left')
hold on
plot([shifted_CPs(1,:) shifted_CPs(1,1)],[shifted_CPs(2,:) shifted_CPs(2,1)],'Color',[0.9 0 0])
plot([m(1,:) m(1,1)], [m(2,:) m(2,1)],'--k','LineWidth',1)
plot([m(1,1) shifted_CPs(1,1)], [m(2,1) shifted_CPs(2,1)],'--k','LineWidth',1)
plot([m(1,2) shifted_CPs(1,2)], [m(2,2) shifted_CPs(2,2)],'--k','LineWidth',1)
plot([m(1,3) shifted_CPs(1,3)], [m(2,3) shifted_CPs(2,3)],'--k','LineWidth',1)
plot([m(1,4) shifted_CPs(1,4)], [m(2,4) shifted_CPs(2,4)],'--k','LineWidth',1)

m(1:2,:)=shifted_CPs;
put('m',m);

log_text = {'done !'};
statusLogging(handles.LogWindow, log_text)
rectify_res


function reset_para_Callback(hObject, eventdata, handles)
handles=gethand;
log_text = {'Reseting rectification parameters'};
statusLogging(handles.LogWindow, log_text)
mbck_up=retr('mbck_up');
Hbckup=retr('Hbckup');
m=mbck_up;
put('m',m);
rotM=[];
put('rotM',rotM);
H=Hbckup;
put('H',H);
% rectify_res
log_text = {'done !'};
statusLogging(handles.LogWindow, log_text)
rectify_res


% --------------------------------------------------------------------
function cp_definition_Callback(hObject, eventdata, handles)



% --------------------------------------------------------------------
function define_coord_Callback(hObject, eventdata, handles)
warning off
PathName_CP=retr('PathName_CP');
FileName_CP=retr('FileName_CP');
units=check_unit;

get_axes_left
imshow([PathName_CP FileName_CP]);%display the original Image
set(gca,'Tag','axes_left')

M=retr('M');
rvr_add_cps(M);
f=findobj('Tag','fig_cps');
waitfor(f)
dummy=findobj('Tag','dummy');
data = guidata(dummy);
delete(findobj('Tag','dummy'))
M=data.M;
utmzone=data.utmzone;
put('M',M)
put('utmzone',utmzone)

%select points on Image
x=[];
y=[];
text_tip('LEFT-click to ZOOM-IN RIGHT-click to select')
for i=1:size(M,2)
    
    [xCoor yCoor]=rvr_ginput(1);
    hold on
    if i==1
        plot(xCoor,yCoor,'o','LineWidth',2,'Color',[0.9 0 0]);
    else
        plot(xCoor,yCoor,'o','LineWidth',2,'Color',[0 0.45 0.74]);
    end
    plot(xCoor,yCoor,'.k')
    x=[x xCoor];
    y=[y yCoor];
end

m=[x;y;ones(1,length(x))];
put('m',m);
text_tip('');


function watch_googleearth_Callback(hObject, eventdata, handles)
resultslist=retr('resultslist');
filename=retr('filename');
PathName=retr('PathName');
st=retr('st');
H=retr('H');
Him_out=retr('Him_out');
Hroi=retr('Hroi');
HX=retr('HX');
HY=retr('HY');
id_result=get(handles.slider_rec, 'value');
units=check_unit;
m=str2double(get(handles.m_val,'String'));%number of elments on x
n=str2double(get(handles.n_val,'String'));
selected_cmap=get(handles.rvr_colormap,'Value');
utmzone=retr('utmzone');
load('CC_cool.mat');
%get mesh definition form GUI
m=str2double(get(handles.m_val,'String'));%number of elments on x
n=str2double(get(handles.n_val,'String'));%number of elments on y
res_rec=[m n]; %results resolution on x and y respectively
auto_c=get(handles.chk_auto,'Value');
scale=str2double(get(handles.size_val,'String'));
RGB=color_vector;


%recttify results
[X_rec Y_rec U_rec V_rec]=rvr_rec_res(resultslist(:,id_result),H,Hroi,st,res_rec);
Mag_rec=(U_rec.^2+V_rec.^2).^0.5;

%choose what to plot
deriv=get(handles.popup_results, 'value');

if deriv==1
    k = kml([PathName 'GoogleEarth\Velocity_Vectors_' num2str(id_result)]);
    
    mn=m*n;
    [Lat, Lon]=utm2deg(reshape(X_rec,mn,1),reshape(Y_rec,mn,1),repmat(utmzone, mn, 1));
    
    %get the color
    colorhex = reshape(sprintf('%02X',fliplr(RGB)*255.'),6,[]).';
    colorhex=['FF' colorhex];
    
    k.quiver(reshape(Lon,m,n), reshape(Lat,m,n) ,U_rec,V_rec,...
        'name',['Velocity_Vectors_' num2str(id_result)],...
        'altitude',0,...
        'scale',0.00000001,...
        'color',colorhex,...
        'altitudeMode','clampToGround');
    k.run
    
end

if deriv==2
    
    
    if selected_cmap ==1
        load('CC_cool.mat');
        CC=CC_cool;
    end
    if selected_cmap ==2
        CC=parula;
    end
    if selected_cmap ==3
        CC=jet;
    end
    if selected_cmap ==4
        load('hsbmap.mat');
        CC=hsb;
    end
    if selected_cmap ==5
        CC=hot;
    end
    if selected_cmap ==6
        CC=cool;
    end
    if selected_cmap ==7
        CC=spring;
    end
    if selected_cmap ==8
        CC=summer;
    end
    if selected_cmap ==9
        CC=autumn;
    end
    if selected_cmap ==10
        CC=winter;
    end
    if selected_cmap ==11
        CC=gray;
    end
    if selected_cmap ==12
        CC=bone;
    end
    if selected_cmap ==13
        CC=copper;
    end
    
    
    
    
    if auto_c==1
        min_colorbar=min(min(Mag_rec));
        max_colorbar=max(max(Mag_rec));
    else
        min_colorbar=str2num(get(handles.limc_min,'String'));
        max_colorbar=str2num(get(handles.limc_max,'String'));
    end
    
    k = kml([PathName 'GoogleEarth\Velocity_Magnitud_' num2str(id_result)]);
    
    mn=m*n;
    [Lat, Lon]=utm2deg(reshape(X_rec,mn,1),reshape(Y_rec,mn,1),repmat(utmzone, mn, 1));
    
    
    k.contourf(reshape(Lon,m,n),reshape(Lat,m,n),Mag_rec,CC,'name','Velocity Magnitud','numberOfLevels',64)
    k.colorbar([min_colorbar max_colorbar],CC)
    k.run
    
end



function addcs_coo_Callback(hObject, eventdata, handles)
list_cs=retr('list_cs');
H=retr('H');
HX=retr('HX');
HY=retr('HY');
Him_out=retr('Him_out');
Hroi=retr('Hroi');

rvr_add_sec

f=findobj('Tag','fig_crs');
waitfor(f)

dummy=findobj('Tag','dummy');
data = guidata(dummy);
delete(findobj('Tag','dummy'))
CS=data.CS;
utmzone=data.utmzone;

Hnew_cs=CS(1:2,:);

%plot the section on the right
get_axes_right
Him_out=shade_out_Hroi(HX,HY,Him_out,Hroi);
plot_rec_bck(HX,HY,Him_out,Hroi)
hold on
plot(Hnew_cs(:,1),Hnew_cs(:,2),'Color',[0.93 0.69 0.13]);
set(gca,'Tag','axes_right')

%un-rectify the new cross-section
new_cs=rvr_trans2pix([Hnew_cs'; 1 1],H)';

%plot the section on the left
get_axes_left
plotroi
set(gca,'Tag','axes_left')
hold on

plot(new_cs(:,1),new_cs(:,2),'Color',[0.93 0.69 0.13]);

%ask for a name
promptCS = {'Name'};
dlg_title_CS = 'Name of Section';
def_Coor = {['CS_' num2str(size(list_cs,1))]};
options.Resize='on';
options.WindowStyle='normal';
answer_name = inputdlg(promptCS,dlg_title_CS,1,def_Coor,options);

if isempty(answer_name)==0
    
    %put the section in the section  list
    list_cs{end+1,1}=new_cs;
    list_cs{end,2}=Hnew_cs;
    list_cs{end,3}=answer_name;
    
    put('list_cs',list_cs);
    
    %call edit section
    edit_cs_Callback
else
end


% --------------------------------------------------------------------
function save_project_Callback(hObject, eventdata, handles)

    handles=gethand;
    warning off
    PathName=retr('PathName');
    PathName_CP=retr('PathName_CP');
    FileName_CP=retr('FileName_CP');
    resultslist=retr('resultslist');
    resultslistptv=retr('resultslistptv');
    filename=retr('filename');
    st=retr('st');
    H=retr('H');
    Him_out=retr('Him_out');
    Hroi=retr('Hroi');
    HX=retr('HX');
    HY=retr('HY');
    Imask=retr('Imask');
    Img_roi=retr('Img_roi');
    list_cs=retr('list_cs');
    list_pt=retr('list_pt');
    id_result=get(handles.slider_rec, 'value');
    set(handles.popup_results,'Enable','on');
    set(handles.slider_rec,'Enable','on');
    m=str2double(get(handles.m_val,'String'));%number of elments on x
    n=str2double(get(handles.n_val,'String'));%number of elments on y
    deriv=get(handles.popup_results, 'value');
    scale=str2double(get(handles.size_val,'String'));
    units=check_unit;
    
    data.PathName=PathName;
    data.PathName_CP=PathName_CP;
    data.FileName_CP=FileName_CP;
    data.resultslist=resultslist;
    data.filename=filename;
    data.st=st;
    data.H=H;
    data.Him_out=Him_out;
    data.Hroi=Hroi;
    data.HX=HX;
    data.HY=HY;
    data.Imask=Imask;
    data.Img_roi=Img_roi;
    data.list_cs=list_cs;
    data.list_pt=list_pt;
    data.id_result=id_result;
    data.m=m;%number of elments on x
    data.n=n;%number of elments on y
    data.deriv=deriv;
    data.scale=scale;
    data.units=check_unit;
    data.LogWindow=get(handles.LogWindow,'string');
    
    [filename,pathname]=uiputfile({'*.rvr'},'Save Project',[PathName 'RIVeR_project.rvr']);
    if isempty(filename)~=1
        save([pathname filename], '-struct', 'data')
    end


function open_project_Callback(hObject, eventdata, handles)
handles=gethand;
warning off
[filename,pathname]=uigetfile({'*.rvr'},'Open Project');
[pathstr,name,ext] = fileparts([pathname filename]);
movefile([pathname filename],[pathname name '.mat']);
data=load([pathname name '.mat']);
movefile([pathname name '.mat'],[pathname filename]);

PathName=data.PathName;
PathName_CP=data.PathName_CP;
FileName_CP=data.FileName_CP;
resultslist=data.resultslist;
% resultslistptv=data.resultslistptv;
filename=data.filename;
st=data.st;
H=data.H;
Him_out=data.Him_out;
Hroi=data.Hroi;
HX=data.HX;
HY=data.HY;
Imask=data.Imask;
Img_roi=data.Img_roi;
list_cs=data.list_cs;
list_pt=data.list_pt;
id_result=data.id_result;
m=data.m;%number of elments on x
n=data.n;%number of elments on y
deriv=data.deriv;
scale=data.scale;

LogWindowText=data.LogWindow;

set(handles.LogWindow,'string',LogWindowText);
put('PathName',PathName);
put('FileName_CP',FileName_CP);
put('PathName_CP',PathName_CP);
put('resultslist',resultslist);
try
put('resultslistptv',resultslistptv);
catch
end
put('filename',filename);
put('st',st);
put('H',H);
put('Him_out',Him_out);
put('Hroi',Hroi);
put('HX',HX);
put('HY',HY);
put('Imask',Imask);
put('Img_roi',Img_roi);
put('list_cs',list_cs);
put('list_pt',list_pt);

% set(handles.slider_rec, 'Value',id_result);
set(handles.slider_rec, 'value',1, ...
    'enable','on',...
    'min', 1,...
    'max',size(resultslist,2),...
    'sliderstep', [1/(size(resultslist,2)-1) 1/(size(resultslist,2)-1)*10]);

set(handles.popup_results,'Enable','on');
set(handles.slider_rec,'Enable','on','Visible','on');

set(handles.m_val,'String',num2str(m));%number of elments on x
set(handles.n_val,'String',num2str(n));%number of elments on x;%number of elments on y
set(handles.popup_results, 'value',deriv);
set(handles.size_val,'String',num2str(scale));

get_axes_left
try
    imshow([PathName_CP FileName_CP]);
catch
    try
        imshow([pathname FileName_CP]);
        PathName_CP=pathname;
        put('PathName_CP',PathName_CP);
    catch
        waitfor(msgbox('The Control Points image cannot be found. Please select an image.'));
        [FileName_CP,PathName_CP] = uigetfile([PathName '*.jpg'],'Select Image with Control Points (CPs)on');
        put('FileName_CP',FileName_CP);
        put('PathName_CP',PathName_CP);
        imshow([PathName_CP FileName_CP]);
    end
end
set(gca,'Tag','axes_left')
plotroi


sliderdisp

function project_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function Untitled_2_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function calc_meanimg_Callback(hObject, eventdata, handles)
[filename pathname]=uigetfile('*.jpg','Multiselect','on');
if pathname~=0
    I=double(imread([pathname filename{1}]))*0;
    I=I(:,:,1);
     h = waitbar(0,'Please wait...','Name','Calculating mean Image');
    for i=1:size(filename,2)
        A=imread([pathname filename{i}]);
        if size(A,3)>1
            I=I+double(rgb2gray(imread([pathname filename{i}])));
        else
            I=I+double(imread([pathname filename{i}]));
        end
        waitbar(i/ size(filename,2))
    end
    close(h) 
    I=I./size(filename,2);
    
    J=uint8(I); imwrite(J,[pathname 'mean_image.jpg']);
    
        
%     for i=1:size(filename,2) %substract mean
%         A=imread([pathname filename{i}]);
%         if size(A,3)>1
%             K=double(rgb2gray(imread([pathname filename{i}])))-I;
%         else
%             K=double(imread([pathname filename{i}]))-I;
%         end
%         
%         imwrite(uint8(K),[pathname name '_filt.jpg']);
%     end
    
    
end







% --- Executes during object creation, after setting all properties.
function id_traj_CreateFcn(hObject, eventdata, handles)
% hObject    handle to id_traj (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function Untitled_5_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function exp_cur_vel_Callback(hObject, eventdata, handles)
handles=gethand;
warning off
resultslist=retr('resultslist');
st=retr('st');
H=retr('H');
Him_out=retr('Him_out');
Hroi=retr('Hroi');
HX=retr('HX');
HY=retr('HY');
PathName=retr('PathName');
id_result=get(handles.slider_rec, 'value');
m=str2double(get(handles.m_val,'String'));%number of elments on x
n=str2double(get(handles.n_val,'String'));%number of elments on y
res_rec=[m n]; %results resolution on x and y respectively
[X_rec Y_rec U_rec V_rec]=rvr_rec_res(resultslist(:,id_result),H,Hroi,st,res_rec);

fecha='01-04-2017'; %dd-mm-yyyy
x=securitydate(fecha);
if x==0
log_text = {'Exporting Summary.xls...'};
statusLogging(handles.LogWindow, log_text)

bckupcd=pwd;
cd(PathName);
mkdir(['RIVeR_' num2str(id_result)]);

%save an Excel file with velocity field and Cross sections
%save matrices
cd([PathName '\RIVeR_' num2str(id_result)])
xlswrite('Summary.xls', X_rec, 'X' , 'A1');
xlswrite('Summary.xls', Y_rec, 'Y' , 'A1');
xlswrite('Summary.xls',U_rec, 'U' , 'A1');
xlswrite('Summary.xls',V_rec, 'V' , 'A1');

cd(bckupcd)

log_text = {'done !'};
statusLogging(handles.LogWindow, log_text)
end


% --------------------------------------------------------------------
function exp_cur_traj_Callback(hObject, eventdata, handles)
handles=gethand;
H_traj=retr('H_traj');
id_traj=retr('id_traj'); 
id_result=get(handles.slider_rec, 'value');
log_text = {'Exporting Trajectories...'};
statusLogging(handles.LogWindow, log_text)
PathName=retr('PathName');
bckupcd=pwd;
cd(PathName);
mkdir(['RIVeR_trajectories(1 to ' num2str(id_result) ')']);
cd([PathName 'RIVeR_trajectories(1 to ' num2str(id_result) ')'])

for i=1:size(H_traj,1)
    eval(['trajectories.id_' num2str(id_traj(i)) '.x=H_traj{i,1}(:,1);']);
    eval(['trajectories.id_' num2str(id_traj(i)) '.y=H_traj{i,1}(:,2);']);
    eval(['trajectories.id_' num2str(id_traj(i)) '.velocity=H_traj{i,1}(:,3);']);
    
    
end
fecha='01-04-2017'; %dd-mm-yyyy
x=securitydate(fecha);
if x==0
save trajectories trajectories
end
cd(bckupcd);
log_text = {'done !'};
statusLogging(handles.LogWindow, log_text)

% --------------------------------------------------------------------
function exp_im_left_Callback(hObject, eventdata, handles)
PathName=retr('PathName');
[FileName,PathName] = uiputfile([PathName 'left.png']);
handles=gethand;
get_axes_left
set(gca,'Tag','axes_left')
ax=gca;
H=figure('Visible','off','Position',[160   368   732   465]);
s = copyobj(ax,H) 
colormap('gray')
axis off
fecha='01-04-2017'; %dd-mm-yyyy
x=securitydate(fecha);
if x==0
export_fig(H,[PathName FileName],'-transparent','-r350'); %export resolution @350dpi 
end
close(H)
axis off


function exp_im_right_Callback(hObject, eventdata, handles)
PathName=retr('PathName');
[FileName,PathName] = uiputfile([PathName 'right.png']);
handles=gethand;
get_axes_right
set(gca,'Tag','axes_right')
ax=gca;
H=figure('Visible','off','Position',[160   368   732   465]);
s = copyobj(ax,H) 
colormap('gray')
axis off
% fecha='01-04-2017'; %dd-mm-yyyy
% x=securitydate(fecha);
% if x==0
export_fig(H,[PathName FileName],'-transparent','-r350'); %export resolution @350dpi 
close(H)
axis off
% end


function exp_imgs_res_Callback(hObject, eventdata, handles)
PathName=retr('PathName');
resultslist=retr('resultslist');
handles=gethand;
PathName = uigetdir(PathName);

prompt = {'Results:','Extension name:'};
dlg_title = 'Input';
num_lines = 1;
defaultans = {['1:' num2str(size(resultslist,2))],'results'};
answer = inputdlg(prompt,dlg_title,num_lines,defaultans);

list=eval(answer{1,1});%list id of results to export
for i=list
    set(handles.slider_rec,'value',i);
    sliderdisp
    get_axes_right
    set(gca,'Tag','axes_right')
    ax=gca;
    H=figure('Visible','off','Position',[160   368   732   465]);
    s = copyobj(ax,H)
    colormap('gray')
    axis off
    index=num2str(i,['%0',num2str(length(num2str(size(resultslist,2)))),'i']);
    
    export_fig(H,[PathName '\' answer{2} '_' index],'-transparent','-r350');
    close(H);
    axis off
end


% --------------------------------------------------------------------
function load_analysis_Callback(hObject, eventdata, handles)
% hObject    handle to load_analysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------


% --------------------------------------------------------------------
function cpsplane_Callback(hObject, eventdata, handles)
% hObject    handle to cpsplane (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function spsspace_Callback(hObject, eventdata, handles)
% hObject    handle to spsspace (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function define_3d_cps_Callback(hObject, eventdata, handles)
% hObject    handle to define_3d_cps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function timeseries_Callback(hObject, eventdata, handles)
% hObject    handle to timeseries (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function selectpoint_Callback(hObject, eventdata, handles)
% hObject    handle to selectpoint (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function extracttsptoriginal_Callback(hObject, eventdata, handles)
list_pt=retr('list_pt');
H=retr('H');
HX=retr('HX');
HY=retr('HY');
Him_out=retr('Him_out');
Hroi=retr('Hroi');
st=retr('st');
resultslist=retr('resultslist');

%plot the section on the right
get_axes_left
plotroi
set(gca,'Tag','axes_left')
hold on
h=impoint(gca);
new_pt = wait(h);
delete(h);
% plot(Hnew_pt(:,1),Hnew_pt(:,2),'Color',[0.93 0.69 0.13],'x');
plot(new_pt(:,1),new_pt(:,2),'x','Color',[0.8 0 0]);
plot(new_pt(:,1),new_pt(:,2),'o','Color',[0.8 0 0]);
%rectify the new cross-section
Hnew_pt=rvr_trans2rw([new_pt'; 1],H)';

%plot the section on the right
get_axes_right
get_axes_right

set(gca,'Tag','axes_right')
Him_out=shade_out_Hroi(HX,HY,Him_out,Hroi);
plot_rec_bck(HX,HY,Him_out,Hroi)
set(gca,'Tag','axes_right')
hold on


plot(Hnew_pt(:,1),Hnew_pt(:,2),'x','Color',[0.8 0 0]);
plot(Hnew_pt(:,1),Hnew_pt(:,2),'o','Color',[0.8 0 0]);

%get u and v in time at this point
[u v]=rvr_rec_time_series(resultslist,new_pt,st,H)


%ask for a name
promptPT = {'Name'};
dlg_title_PT = 'Name of Point';
def_Coor = {['PT_' num2str(size(list_pt,1))]};
options.Resize='on';
options.WindowStyle='normal';
answer_name = inputdlg(promptPT,dlg_title_PT,1,def_Coor,options);

if isempty(answer_name)==0
    
    %put the section in the section  list
    list_pt{end+1,1}=new_pt;
    list_pt{end,2}=Hnew_pt;
    list_pt{end,3}=answer_name;
    list_pt{end,4}=u;
    list_pt{end,5}=v;
    
    put('list_pt',list_pt);
    
    %call edit point
    edit_pt_Callback
else
end


% --------------------------------------------------------------------
function extracttsptrectified_Callback(hObject, eventdata, handles)
list_pt=retr('list_pt');
H=retr('H');
HX=retr('HX');
HY=retr('HY');
Him_out=retr('Him_out');
Hroi=retr('Hroi');
st=retr('st');
resultslist=retr('resultslist');

%plot the section on the right
get_axes_right

set(gca,'Tag','axes_right')
Him_out=shade_out_Hroi(HX,HY,Him_out,Hroi);
plot_rec_bck(HX,HY,Him_out,Hroi)
set(gca,'Tag','axes_right')
hold on

h=impoint(gca);
Hnew_pt = wait(h);
delete(h);
% plot(Hnew_pt(:,1),Hnew_pt(:,2),'Color',[0.93 0.69 0.13],'x');
plot(Hnew_pt(:,1),Hnew_pt(:,2),'x','Color',[0.8 0 0]);
plot(Hnew_pt(:,1),Hnew_pt(:,2),'o','Color',[0.8 0 0]);
%un-rectify the new cross-section
new_pt=rvr_trans2pix([Hnew_pt'; 1],H)';

%plot the section on the left
get_axes_left
plotroi
set(gca,'Tag','axes_left')
hold on

plot(new_pt(:,1),new_pt(:,2),'x','Color',[0.8 0 0]);
plot(new_pt(:,1),new_pt(:,2),'o','Color',[0.8 0 0]);

%get u and v in time at this point
[u v]=rvr_rec_time_series(resultslist,new_pt,st,H)


%ask for a name
promptPT = {'Name'};
dlg_title_PT = 'Name of Point';
def_Coor = {['PT_' num2str(size(list_pt,1))]};
options.Resize='on';
options.WindowStyle='normal';
answer_name = inputdlg(promptPT,dlg_title_PT,1,def_Coor,options);

if isempty(answer_name)==0
    
    %put the section in the section  list
    list_pt{end+1,1}=new_pt;
    list_pt{end,2}=Hnew_pt;
    list_pt{end,3}=answer_name;
    list_pt{end,4}=u;
    list_pt{end,5}=v;
    
    put('list_pt',list_pt);
    
    %call edit point
    edit_pt_Callback
else
end


function edit_pt_Callback(hObject, eventdata, handles)
handles=gethand;
PathName=retr('PathName');
list_pt=retr('list_pt');
H=retr('H');
Hroi=retr('Hroi');
HX=retr('HX');
HY=retr('HY');
Him_out=retr('Him_out');
st=retr('st');
resultslist=retr('resultslist');
id_result=get(handles.slider_rec, 'value');
units=check_unit;
m=str2double(get(handles.m_val,'String'));%number of elments on x
n=str2double(get(handles.n_val,'String'));%number of elments on y
res_rec=[m n];

% 
% %calculate the current rectified velocity field
% [X_rec Y_rec U_rec V_rec]=rvr_rec_tseries(resultslist,H,Hroi,st,res_rec);


gray = get(0,'DefaultUIControlBackgroundColor');
wfig=800;
hfig=660;
fig = figure;
rvr_edit_pt_gui(PathName,list_pt,units,HX,HY,Him_out,Hroi,st)
waitfor(fig)    
data = guidata(gcf);
try
    list_pt=data.list_pt;
    put('list_pt',list_pt);
catch
end


% --------------------------------------------------------------------
function areacomp_disc_Callback(hObject, eventdata, handles)
msgbox({'Disclaimer: This software has been approved for release by the U.S. Geological Survey (USGS). Although the software has been subjected to rigorous review, the USGS reserves the right to update the software as needed pursuant to further analysis and review. No warranty, expressed or implied, is made by the USGS or the U.S. Government as to the functionality of the software and related material nor shall the fact of release constitute any such warranty. Furthermore, the software is released on condition that neither the USGS nor the U.S. Government shall be held liable for any damages resulting from its authorized or unauthorized use' ...
' '...    
'Copyright / License - CC0 1.0: The person who associated a work with this deed has dedicated the work to the public domain by waiving all of his or her rights to the work worldwide under copyright law, including all related and neighboring rights, to the extent allowed by law. You can copy, modify, distribute and perform the work, even for commercial purposes, all without asking permission.' ...
    '- In no way are the patent or trademark rights of any person affected by CC0, nor are the rights that other persons may have in the work or in how the work is used, such as publicity or privacy rights.' ...
    '- Unless expressly stated otherwise, the person who associated a work with this deed makes no warranties about the work, and disclaims liability for all uses of the work, to the fullest extent permitted by applicable law.'...
    '- When using or citing the work, you should not imply endorsement by the author or the affirmer. Publicity or privacy: The use of a work free of known copyright restrictions may be otherwise regulated or limited. The work or its use may be subject to personal data protection laws, publicity, image, or privacy rights that allow a person to control how their voice, image or likeness is used, or other restrictions or limitations under applicable law.' ...
    ' '...
    'Endorsement: In some jurisdictions, wrongfully implying that an author, publisher or anyone else endorses your use of a work may be unlawful.?'},'Areacomp v2')
