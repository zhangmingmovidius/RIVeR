function rvr_add_cps(actual_M)
f = figure('Name','RIVeR - Add CPs',...
    'ToolBar','none',...
    'MenuBar','none',...
    'IntegerHandle','off',...
    'Resize','off',...
    'Tag','fig_cps');
f.Position(3)=365;f.Position(4)=146;
str=uicontrol('Position',[15 115 200 21],...
    'Style','text',...
    'String','Control Points coordinates. UTM zone:',...
    'Tag','str');
utmzone=uicontrol('Position',[210 120 30 18],...
    'Style','edit',...
    'String','20 H',...
    'Tag','utmzone');
% create the data
cnames = {'East-Data','North-Data'};

if isempty(actual_M)==1
    d = [0 0; 0 0; 0 0;0 0];
    rnames = {'CP_1','CP_2','CP_3','CP_4'};
else
    d=actual_M(1:2,:)';
    for i=1:size(d,1)
        rnames{i} =['CP_' num2str(i)];
    end
    
end

% Create the uitable
t = uitable(f,'Data',d,...
    'ColumnName',cnames,...
    'RowName',rnames,...
    'Enable','on',...
    'ColumnEditable',[true, true],...
    'CellSelectionCallback',@(src,evnt)set(src,'UserData',evnt.Indices),...
    'Tag','table');

t.Position(3) = 206.1;
t.Position(4) = 18.62*(size(rnames,2)+1);
f.Position(4)=t.Position(4)+46;
str.Position(2)=f.Position(4)-24.1;

%Create a button to add point
bt_add=uicontrol('Position',[0.5 0.5 100 21],...
    'Style','pushbutton',...
    'String','Add New',...
    'Tag','bt_ass',...
    'Callback',@add_cp);
bt_add.Position(1) = 250;
bt_add.Position(2) = f.Position(4)-46;

%Create a button to delete point
bt_del=uicontrol('Position',[0.5 0.5 100 21],...
    'Style','pushbutton',...
    'String','Delete',...
    'Tag','bt_del',...
    'Callback',@del_cp);
bt_del.Position(1) = 250;
bt_del.Position(2) = f.Position(4)-46-21-3;

%Create a button to import from excel
bt_xls=uicontrol('Position',[0.5 0.5 100 21],...
    'Style','pushbutton',...
    'String','Import from Excel',...
    'Callback',@imp_cp);
bt_xls.Position(1) = 250;
bt_xls.Position(2) = f.Position(4)-46-2*(21+ 3);

%Create a button to apply
bt_apply=uicontrol('Position',[0.5 0.5 100 21],...
    'Style','pushbutton',...
    'String','Apply',...
    'Callback',@apply);
bt_apply.Position(1) = 250;
bt_apply.Position(2) = f.Position(4)-46-3*(21+ 3);

function add_cp(hObject,eventdata)
table=findobj('Tag','table');
str=findobj('Tag','str');
Data=get(table,'Data');
delete(table);
f=gcf;
cnames = {'East-Data','North-Data'};
for i=1:size(Data,1)+1
        rnames{i} =['CP_' num2str(i)];
end
    
Data(i,:)=[0 0];
t = uitable(f,'Data',Data,...
    'ColumnName',cnames,...
    'RowName',rnames,...
    'Enable','on',...
    'ColumnEditable',[true, true],...
    'CellSelectionCallback',@(src,evnt)set(src,'UserData',evnt.Indices),...
    'Tag','table');

t.Position(3) = 206.1;
t.Position(4) = 18.62*(size(rnames,2)+1);
f.Position(4)=t.Position(4)+46;
str.Position(2)=f.Position(4)-24.1;

function del_cp(hObject,eventdata)
table=findobj('Tag','table');
selected=get(table,'UserData');
if isempty(selected)==0
str=findobj('Tag','str');
Data=get(table,'Data');
delete(table);
f=gcf;
cnames = {'East-Data','North-Data'};
  
%remove the selected row
Data=removerows(Data,selected(1));

for i=1:size(Data,1)
        rnames{i} =['CP_' num2str(i)];
end
t = uitable(f,'Data',Data,...
    'ColumnName',cnames,...
    'RowName',rnames,...
    'Enable','on',...
    'ColumnEditable',[true, true],...
    'CellSelectionCallback',@(src,evnt)set(src,'UserData',evnt.Indices),...
    'Tag','table');

t.Position(3) = 206.1;
t.Position(4) = 18.62*(size(rnames,2)+1);
f.Position(4)=t.Position(4)+46;
str.Position(2)=f.Position(4)-24.1;
else
end

function imp_cp(hObject,eventdata)
[FileName PathName]=uigetfile({'*.xls;*.xlsx';'*.*'},'Select a file');
if FileName~=0
Data=xlsread([PathName FileName]);
table=findobj('Tag','table');
str=findobj('Tag','str');
delete(table);
f=gcf;
cnames = {'East-Data','North-Data'};

for i=1:size(Data,1)
        rnames{i} =['CP_' num2str(i)];
end
t = uitable(f,'Data',Data,...
    'ColumnName',cnames,...
    'RowName',rnames,...
    'Enable','on',...
    'ColumnEditable',[true, true],...
    'CellSelectionCallback',@(src,evnt)set(src,'UserData',evnt.Indices),...
    'Tag','table');

t.Position(3) = 206.1;
t.Position(4) = 18.62*(size(rnames,2)+1);
f.Position(4)=t.Position(4)+46;
str.Position(2)=f.Position(4)-24.1;

end

function apply(hObject,eventdata)
f=gcf;
table=findobj('Tag','table');
utmzone=findobj('Tag','utmzone');
Data=get(table,'Data');
utmzone=get(utmzone,'String');
M=[Data'; ones(1,size(Data,1))];
dummy=figure('Tag','dummy','Visible','off');
guidata(dummy,struct('M',M,'utmzone',utmzone));

close(f);
  


