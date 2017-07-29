
function intParam=select_camera

xDoc=xml2struct('Cameras.xml');%carga el archivo xml

cell_cam=fieldnames(xDoc.Cameras); %lista las camaras


[s,v] = listdlg('PromptString','Select a camera:',...
                'SelectionMode','single',...
                'ListString',cell_cam);% selecioan la camara
       
fx=str2double(eval(['xDoc.Cameras.' cell_cam{s} '.fx.Text']));
fy=str2double(eval(['xDoc.Cameras.' cell_cam{s} '.fy.Text']));
cx=str2double(eval(['xDoc.Cameras.' cell_cam{s} '.cx.Text']));
cy=str2double(eval(['xDoc.Cameras.' cell_cam{s} '.cy.Text']));
k1=str2double(eval(['xDoc.Cameras.' cell_cam{s} '.k1.Text']));
k2=str2double(eval(['xDoc.Cameras.' cell_cam{s} '.k2.Text']));
k3=str2double(eval(['xDoc.Cameras.' cell_cam{s} '.k3.Text']));
p1=str2double(eval(['xDoc.Cameras.' cell_cam{s} '.p1.Text']));
p2=str2double(eval(['xDoc.Cameras.' cell_cam{s} '.p2.Text']));
alpha0=str2double(eval(['xDoc.Cameras.' cell_cam{s} '.alpha0.Text']));

intParam.K=0*eye(3,3);

intParam.K(1,1)=fx;
intParam.K(1,3)=cx;
intParam.K(2,2)=fy;
intParam.K(2,3)=cy;
intParam.K(3,3)=1;
intParam.K(1,2)=alpha0;

intParam.kc=[k1 k2 k3];
intParam.pc=[p1 p2];


