function [X Y answer]=rvr_solver(PathName_CP,units)

choice_CPs_WS = questdlg('Do you want to load lengths between CPs ?' , ...
    'load lengths','Yes','No','No');
%Calcular H
switch choice_CPs_WS %si los PCs se ubican sobre la superficie
    case 'Yes'
        [FileName_length,PathName_length] = uigetfile([PathName_CP '*.xls'],'Select File with lengts between CPs');
        CPs= xlsread([PathName_length FileName_length]);
        
        def_Coor = {num2str(CPs(1)),num2str(CPs(2)),num2str(CPs(3)),num2str(CPs(4)),num2str(CPs(5)),num2str(CPs(6))};
    case 'No'
        
        def_Coor = {'1','1','1','1','1','1'};
end


% promptCoor = {['blue length: (in ' units ')'],...
%     ['orange length: (in ' units ')'],...
%     ['yellow: (in ' units ')'],...
%     ['magenta length: (in ' units ')'],...
%     ['green length: (in ' units ')'],...
%     ['cyan length: (in ' units ')']};
promptCoor = {['blue length: (in ' units ')'],...
    ['red length: (in ' units ')'],...
    ['green length: (in ' units ')'],...
    ['back length: (in ' units ')'],...
    ['magenta length: (in ' units ')'],...
    ['cyan length: (in ' units ')']};
dlg_title_Coor = ['lengths in ' units];
num_lines = 1;
% def_Coor = {'4.23','4.58','3.6','2.36','4.31','5.8'};
% def_Coor = {'0','0','0','0','0','0'};
options.Resize='on';
options.WindowStyle='normal';

answer = inputdlg(promptCoor,dlg_title_Coor,num_lines,def_Coor,options);
%
% fake_scale=check_dimensions(answer);
%
% l12=str2num(answer{1})*fake_scale;
% l23=str2num(answer{2})*fake_scale;
% l34=str2num(answer{3})*fake_scale;
% l41=str2num(answer{4})*fake_scale;
% l13=str2num(answer{5})*fake_scale;
% l24=str2num(answer{6})*fake_scale;


l12=str2num(answer{1});
l23=str2num(answer{2});
l34=str2num(answer{3});
l41=str2num(answer{4});
l13=str2num(answer{5});
l24=str2num(answer{6});

X1=0;
Y1=0;
X2=l12;
Y2=0;

w0 = [1;1;1;1];
options=optimset('Display','iter','MaxFunEvals' , 5000,'MaxIter' , 5000);
warning('off')
[w,fval] = fsolve(@myfun,w0,options);
warning('on')
X3=w(1);
Y3=w(2);
X4=w(3);
Y4=w(4);

X=[X1 X2 X3 X4];
Y=[Y1 Y2 Y3 Y4];


    function F = myfun(x)
        
        l12=str2num(answer{1});
        l23=str2num(answer{2});
        l34=str2num(answer{3});
        l41=str2num(answer{4});
        l13=str2num(answer{5});
        l24=str2num(answer{6});
        
        F = [x(1)^2 + x(2)^2 - l13^2;
            x(3)^2 + x(4)^2 - l41^2;
            (x(1)-l12)^2+x(2)^2-l23^2;
            (x(1)-x(3))^2+(x(2)-x(4))^2-l34^2;
            (l12-x(3))^2+x(4)^2-l24^2];
    end
end