
function uimakeframes_v2(PathName,FileName)

% Version: 2.1, 19 January 2016
% Author:  Antoine Patalano
%uipickfiles: GUI program to select file(s) and/or directories.
%
% Syntax:
%   files = uimakeframes('PathName','FileName')

curent_dir=pwd;
% Pathffmpeg=[pwd '\ffmpeg-20150319-git-b61cb61-win64-static\bin\'];
Pathffmpeg=[pwd];

try
    % for i =1:length(info_videos)
    [status,resolutions]=dos(['cd ' Pathffmpeg ' & ffprobe -v error -of flat=s=_ -select_streams v:0 -show_entries stream=height,width,avg_frame_rate,duration ' PathName,FileName  ] );
    resol_str=strsplit(resolutions,{'=','streams_stream_0_','"'});
    Height=str2double(resol_str{5});
    Width=str2double(resol_str{3});
    fps=eval(resol_str{7});
    SS=str2double(resol_str{10});
    
    
    % Create figure.
    gray = get(0,'DefaultUIControlBackgroundColor');
    fig = figure('Position',[0 0 265 230],...
        'Color',gray,...
        'Name','RIVeR - Images Extraction',...
        'CreateFcn',{@movegui,'center'},...
        'ToolBar','none',...
        'MenuBar','none',...
        'IntegerHandle','off'); %#ok<NOPRT>
    
    % This is a ... s movie at .. fps
    uicontrol('Position',[10 198 200 21],...
        'Style','text',...
        'String',['This is a ' num2str(round(SS*100)/100) ' s movie at ' num2str(fps) ' fps'], ...
        'HorizontalAlignment','left')
    
    uicontrol('Position',[10 160 53 15],...
        'Style','text',...
        'String','fps:', ...
        'HorizontalAlignment','left')
    
    % Step
    fps_value=uicontrol('Position',[40 160 32 20],...
        'Style','edit',...
        'String',num2str(fps), ...
        'HorizontalAlignment','center',...
        'Callback', @StepCallback);
    
    uicontrol('Position',[80 160 55 15],...
        'Style','text',...
        'String','(resample)', ...
        'HorizontalAlignment','left')
    
    %Range
    uicontrol('Position',[10 122 60 15],...
        'Style','text',...
        'String','Range: from', ...
        'HorizontalAlignment','left')
    
    Time_min=uicontrol('Position',[72 122 27 20],...
        'Style','edit',...
        'String','0', ...
        'HorizontalAlignment','center',...
        'Callback', @TimeMinCallback);
    
    uicontrol('Position',[100 122 20 15],...
        'Style','text',...
        'String','s to', ...
        'HorizontalAlignment','left')
    Time_max=uicontrol('Position',[125 122 37 20],...
        'Style','edit',...
        'String',num2str(SS), ...
        'HorizontalAlignment','center',...
        'Callback', @TimeMaxCallback);
    
    uicontrol('Position',[163 122 20 15],...
        'Style','text',...
        'String','s', ...
        'HorizontalAlignment','left')
    
    %Select the resolution
    uicontrol('Position',[10 84 103 24],...
        'Style','text',...
        'String','Image Resolution:', ...
        'HorizontalAlignment','left')
    
    List = {[num2str(Width) ':' num2str(Height)], ...
        [num2str(round(Width*2/3)) ':' num2str(round(Height*2/3))],...
        [num2str(round(Width/2)) ':' num2str(round(Height/2))]};
    
    % PopupMenu=uicontrol('Position',[100 87 80 24],...
    %     'Style','popupmenu',...
    %     'String',List,...
    %     'CallBack', @PopupMenuCallBack);
    %         jCombo = findjobj(PopupMenu)
    %         jCombo.setEditable(true);
    %         set(hCombo, 'string', [])
    
    position = [100 91 80 20];  % pixels
    hContainer = gcf;  % can be any uipanel or figure handle
    options = List;
    model = javax.swing.DefaultComboBoxModel(options);
    PopupMenu = javacomponent('javax.swing.JComboBox', position, hContainer);
    PopupMenu.setModel(model);
    PopupMenu.setEditable(true);
    
    
    
    %check box Invert
    grayscale_value=uicontrol('Position',[10 60 103 24],...
        'Style','checkbox',...
        'String','Grayscale', ...
        'HorizontalAlignment','left', ...
        'Value', 0.0);
    %check lens correction
    lens_value=uicontrol('Position',[10 35 153 24],...
        'Style','checkbox',...
        'String','Correct lens distortions', ...
        'HorizontalAlignment','left', ...
        'Value', 0.0);
    
    %Make Frame
    BottonMkf=uicontrol('Position',[77 5 115 28],...
        'Style','pushbutton',...
        'String','Extract Frames', ...
        'HorizontalAlignment','left',...
        'Callback',@Mkf);
catch
    msgbox('Path should not includes spaces','Error','error','modal');
end
% catch
%     disp('Please download and install the necessary video CODECS: <a href="http://download.cnet.com/AVI-Codec-Pack-Pro/3000-2140_4-10509745.html">AVI-Codec-Pack-Pro</a> and <a href="http://www.4shared.com/file/8io3dYaG/m3jpegv3.html">m3jpegv3</a> ')
% end
    function StepCallback(varargin)
        %         exnum=get(Slider,'Value');
        %         num = str2num(get(fps_value,'String'));
        %         if length(num) == 1 & num <=fps & num >=1 %#ok<AND2>
        %             %             set(Slider,'Value',num);
        %         else
        %             msgbox(['The value should be a number in the range [0,' num2str(round(fps)) ']'],'Error','error','modal');
        %             set(fps_value,'String',num2str(fps));
        %         end
    end

    function TimeMinCallback(varargin)
        num = str2num(get(Time_min,'String'));
        if length(num) == 1 & num <str2num(get(Time_max,'String')) & num >=0 %#ok<AND2>
            %             set(Slider,'Value',num);
        else
            %             msgbox('The Time range selected is wrong','Error','error','modal');
            %             set(Time_min,'String',num2str(num));
        end
    end
    function TimeMaxCallback(varargin)
        num = str2num(get(Time_max,'String'));
        if length(num) == 1 & num >str2num(get(Time_min,'String')) & num >=0 & num <=num2str(round(SS*100)/100)%#ok<AND2>
            %             set(Slider,'Value',num);
        else
            %             msgbox('The Time range selected is wrong','Error','error','modal');
            %             set(Time_max,'String',num2str(num));
        end
    end

%     function PopupMenuCallBack(varargin)
%
%         List = get(PopupMenu,'String');
%         Val = get(PopupMenu,'Value');
%         %     msgbox(List{Val},'Selecting:','modal')
%
%
%     end

    function Mkf(varargin)
        FpsValue=str2double(get(fps_value,'String'));
        resolution_ffmpeg=char(PopupMenu.getSelectedItem);
        
        
        Tmin=str2num(get(Time_min,'String'));
        Tmax=str2num(get(Time_max,'String'));
        %         TminVec=round((Tmin*info.FramesPerSecond))+1;
        %         TmaxVec=round((Tmax*info.FramesPerSecond))+1;
        duration=Tmax-Tmin;
        Tmin_str=datestr(Tmin/(3600*24),'HH:MM:SS');
        duration_str=datestr(duration/(3600*24),'HH:MM:SS');
        
        %% EXRACT AND SAVE IMAGES
        
        frate=num2str(FpsValue);% u otra coasa eligir
        %get the duration
        
        [pathstr,filename,ext] = fileparts([PathName FileName]);
        
        %grayscale colors
        if get(grayscale_value,'Value')==1
            command_ffmpeg=['ffmpeg -ss ' Tmin_str ' -t ' duration_str ' -i ' PathName FileName ' -q:v 1  -vf "format=gray, scale=' resolution_ffmpeg '" -r ' frate ' ' PathName filename '_%5d.jpg'];
            color_depth='Yes';
        else
            command_ffmpeg=['ffmpeg -ss ' Tmin_str ' -t ' duration_str ' -i ' PathName FileName ' -q:v 1 -vf scale=' resolution_ffmpeg ' -r ' frate ' ' PathName filename '_%5d.jpg'];
            color_depth='No';
        end
        
        set(BottonMkf, 'string' , ['Image Extraction ...'],...
            'ForegroundColor', [0.502 0.502 0.502])
        drawnow
        
        %makes the frames
        [status,results]=dos(['cd ' Pathffmpeg ' & ' command_ffmpeg] )
        
        
        %lens correction
        if get(lens_value,'Value')==1
            lens_correction='Yes';
            if exist('intParam')==0
                intParam=rvr_select_camera;
                
            end
            %find files with filname_ in the name
            id_images=[];
            listing = dir(PathName);
            stringToBeFound=[filename '_'];
            numOfFiles = length(listing);
            for i=1:numOfFiles
                filename=listing(i).name;
                if ~isempty(findstr(filename,stringToBeFound))
                    id_images=[id_images i];
                end
            end
            
            for i=1:length(id_images)
                frame=imread([PathName listing(id_images(i)).name]);
                frame=rvr_correctlens(frame, intParam);
                imwrite(frame,[PathName 'C_' listing(id_images(i)).name ]);
                set(BottonMkf, 'string' , ['Lens Correction: ' int2str(i/length(id_images)*100) '%'],...
                    'ForegroundColor', [0.502 0.502 0.502])
                drawnow
            end
            
        else
            lens_correction='No';
        end
        
        %Write summary in notepad
        summary{1}=['Filename: ' FileName];
        summary{2}=['Extracted from: ' num2str(Tmin) ' s to ', ...
            num2str(Tmax) ' s; Total: '  num2str(Tmax-Tmin) ' s'];
        summary{3}=['Resolution: ' resolution_ffmpeg];
        summary{4}=['@ ' frate ' fps; time step: '  num2str(1000/FpsValue) ' ms'];
        summary{5}=['Grayscale: ' color_depth];
        summary{6}=['Lens Correction: ' lens_correction];
        
        
        close
        
        %write summary
        TheFile = fullfile(PathName, 'Images_Extraction_2.txt');
        fid = fopen(TheFile, 'a');
        for i=1:6
            fprintf(fid, [ summary{i}, '\r\n']);
        end
        fclose(fid);
        
    end

end

