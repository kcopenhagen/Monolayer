function varargout = LayerVerification(varargin)
% LAYERVERIFICATION MATLAB code for LayerVerification.fig
%      LAYERVERIFICATION, by itself, creates a new LAYERVERIFICATION or raises the existing
%      singleton*.
%
%      H = LAYERVERIFICATION returns the handle to a new LAYERVERIFICATION or the handle to
%      the existing singleton*.
%
%      LAYERVERIFICATION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LAYERVERIFICATION.M with the given input arguments.
%
%      LAYERVERIFICATION('Property','Value',...) creates a new LAYERVERIFICATION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before LayerVerification_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to LayerVerification_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help LayerVerification

% Last Modified by GUIDE v2.5 11-Apr-2019 17:43:00

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @LayerVerification_OpeningFcn, ...
                   'gui_OutputFcn',  @LayerVerification_OutputFcn, ...
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
% End initialization code - DO NOT EDIT


% --- Executes just before LayerVerification is made visible.
function LayerVerification_OpeningFcn(hObject, ~, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to LayerVerification (see VARARGIN)

set(hObject,'WindowButtonMotionFcn',@MouseMove);
set(hObject,'KeyPressFcn',@KeyPressed);
set(hObject,'KeyReleaseFcn',@KeyReleased);
handles.ll = NaN;
handles.copylay = [];
handles.moving = 0;
handles.lims = [0 512; 0 384];
handles.lays = round(imgaussfilt(loaddata(handles.fpath.String,1,'covid_layers','int8'),3));
handles.laychs = [];
handles.undol = 0;
handles.idx = [];
% Choose default command line output for LayerVerification
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes LayerVerification wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = LayerVerification_OutputFcn(~, ~, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function fpath_Callback(~, ~, ~)
% hObject    handle to fpath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fpath as text
%        str2double(get(hObject,'String')) returns contents of fpath as a double


% --- Executes during object creation, after setting all properties.
function fpath_CreateFcn(hObject, ~, ~)
% hObject    handle to fpath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in selectbut.
function selectbut_Callback(hObject, ~, handles)
% hObject    handle to selectbut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder = uigetdir([handles.fpath.String '../']);
handles.fpath.String = [folder '/'];
[~,~,~] = mkdir([handles.fpath.String '/analysis/manuallayers2/']);
guidata(hObject,handles);

function ct_Callback(hObject, eventdata, handles)
% hObject    handle to ct (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ct as text
%        str2double(get(hObject,'String')) returns contents of ct as a double
ct = str2double(handles.ct.String);

try
    handles.lays = loaddata(handles.fpath.String,ct,'manuallayers2','int8');
    
catch
    handles.lays = round(imgaussfilt(loaddata(handles.fpath.String,ct,'covid_layers','int8'),3));
end

handles.lays(handles.lays<0) = 0;
guidata(hObject,handles);
update_plots(hObject,eventdata,handles);

% --- Executes during object creation, after setting all properties.
function ct_CreateFcn(hObject, ~, ~)
% hObject    handle to ct (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in nextlayer.
function nextlayer_Callback(hObject, eventdata, handles)
[~,~,~] = mkdir([handles.fpath.String '/analysis/manuallayers2/']);
% hObject    handle to nextlayer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
savebut_Callback(hObject,eventdata,handles);
if isempty(handles.laychs)
    ct = str2double(handles.ct.String);
    if ct == 1
        try
            handles.lays = loaddata(handles.fpath.String,ct,'manuallayers2','int8');
        catch
            handles.lays = round(imgaussfilt(loaddata(handles.fpath.String,ct,'covid_layers','int8'),3));
        end
        handles.lays(handles.lays<0) = 0;
        name = sprintf('%06d.bin', ct-1);
        
        if exist([handles.fpath.String '/analysis/manuallayers2/' name],'file')~=2
            fID = fopen([handles.fpath.String '/analysis/manuallayers2/' name],'w');
            fwrite(fID,handles.lays,'int8');
            fclose(fID);
        end
    end
    
    ct = ct+1;
    handles.ct.String = num2str(ct);
    laych = LayerChanges(handles.fpath.String,ct);
    
    while isempty(laych)
        
        try 
            handles.lays = loaddata(handles.fpath.String,ct,'manuallayers2','int8');
        catch
            handles.lays = round(imgaussfilt(loaddata(handles.fpath.String,ct,'covid_layers','int8'),3));
        end
        handles.lays(handles.lays<0) = 0;

        name = sprintf('%06d.bin', ct-1);
        if exist([handles.fpath.String '/analysis/manuallayers2/' name],'file')~=2
            fID = fopen([handles.fpath.String '/analysis/manuallayers2/' name],'w');
            fwrite(fID,handles.lays,'int8');
            fclose(fID);
        end
        
        ct = ct+1;
        handles.ct.String = num2str(ct);

        laych = LayerChanges(handles.fpath.String,ct);
        
    end
    
    handles.laychs = laych;
    handles.lims(1,1) = laych(1).x-256;
    handles.lims(1,2) = laych(1).x+256;
    handles.lims(2,1) = laych(1).y-192;
    handles.lims(2,2) = laych(1).y+192;

    handles.msgtxt.String = [num2str(laych(1).o) ' to ' num2str(laych(1).n)];
    handles.undol = laych(1).o;
    handles.idx = laych(1).idx;
    handles.laychs(1) = [];
    
else
    ct = handles.laychs(1).t;
    try 
        handles.lays = loaddata(handles.fpath.String,ct,'manuallayers2','int8');
    catch
        handles.lays = round(imgaussfilt(loaddata(handles.fpath.String,ct,'covid_layers','int8'),3));
    end
    handles.lays(handles.lays<0) = 0;
    handles.ct.String = num2str(ct);
    handles.lims(1,1) = handles.laychs(1).x - 256;
    handles.lims(1,2) = handles.laychs(1).x + 256;
    handles.lims(2,1) = handles.laychs(1).y - 192;
    handles.lims(2,2) = handles.laychs(1).y + 192;
    handles.msgtxt.String = [num2str(handles.laychs(1).o) ' to '...
        num2str(handles.laychs(1).n)] ;
    handles.undol = handles.laychs(1).o;
    handles.idx = handles.laychs(1).idx;
    
    handles.laychs(1) = [];
end

guidata(hObject,handles);
try
    handles.lays = loaddata(handles.fpath.String,ct,'manuallayers2','int8');
catch
    handles.lays = round(imgaussfilt(loaddata(handles.fpath.String,ct,'covid_layers','int8'),3));
end
handles.lays(handles.lays<0) = 0;
guidata(hObject,handles);
update_plots(hObject,eventdata,handles);

function KeyPressed(hObject, eventdata)
handles = guidata(hObject);
if eventdata.Key == "leftarrow"
    nt = str2double(handles.ct.String)-1;
    if nt>0
        handles.ct.String = num2str(nt);
        try
            handles.lays = loaddata(handles.fpath.String,...
                nt,'manuallayers2','int8');
        catch
            handles.lays = round(imgaussfilt(loaddata(handles.fpath.String...
                ,nt,'covid_layers','int8'),3));
        end
        handles.lays(handles.lays<0) = 0;
        guidata(hObject,handles);

    end
elseif eventdata.Key == "rightarrow"
    nt = str2double(handles.ct.String)+1;
    handles.ct.String = num2str(nt);
    try
        handles.lays = loaddata(handles.fpath.String,...
            nt,...
            'manuallayers2','int8');
    catch
        handles.lays = round(imgaussfilt(loaddata(handles.fpath.String,...
            nt,...
            'covid_layers','int8'),3));
    end
    handles.lays(handles.lays<0) = 0;
    guidata(hObject,handles);
elseif eventdata.Key == 'm'
    handles.CP = get(handles.laserim,'CurrentPoint');
    handles.moving = 1;
end

handles.ll = str2double(eventdata.Key);
update_plots(hObject,eventdata,handles);
guidata(hObject,handles);

function KeyReleased(hObject, eventdata)
handles = guidata(hObject);
if eventdata.Key == 'm'
    handles.moving = 0;
end
handles.ll = NaN;
guidata(hObject,handles);
update_plots(hObject,eventdata,handles);

function MouseMove(hObject,eventdata)
handles = guidata(hObject);
C = get(handles.laserim,'CurrentPoint');
if ~isnan(handles.ll)
    X = round(C(1,1));
    Y = round(C(1,2));
    Xs = X-5:X+5;
    Ys = Y-5:Y+5;
    Xs(Xs<1) = 1;
    Xs(Xs>1024) = 1024;
    Ys(Ys<1) = 1;
    Ys(Ys>768) = 768;
    handles.lays(Ys,Xs) = handles.ll*ones(11,11);
end

if handles.moving == 1
    C = get(handles.laserim,'CurrentPoint');
    dx = C(1,1)-handles.CP(1,1);
    dy = C(1,2)-handles.CP(1,2);
    
    handles.lims(1,:) = handles.lims(1,:)-dx;
    handles.lims(2,:) = handles.lims(2,:)-dy;

    handles.laserim.XLim = handles.lims(1,:);
    handles.laserim.YLim = handles.lims(2,:);

    handles.heightim.XLim = handles.lims(1,:);
    handles.heightim.YLim = handles.lims(2,:);
    handles.CP = get(handles.laserim,'CurrentPoint');

end

guidata(hObject,handles);


function update_plots(hObject,~,handles)
%Reads in the current time and file path and displays a laser image
%overlayed with the layer count and the height map next to it.
cla(handles.heightim);
cla(handles.laserim);
cla(handles.tm1im);

ct = str2double(handles.ct.String);

l = laserdata(handles.fpath.String,ct);

l = l./imgaussfilt(l,64);
l = normalise(l);


im = real2rgb(handles.lays,colorcet('R2'),[0 3]);
im = im.*l*1.8;
im(im>1) = 1;
try
    lm1 = laserdata(handles.fpath.String,ct-1);
    lm1 = lm1./imgaussfilt(lm1,64);
    lm1 = normalise(lm1);

    laysm1 = loaddata(handles.fpath.String,ct-1,'manuallayers2','int8');
    imm1 = real2rgb(laysm1,colorcet('R2'),[0 3]);
    imm1 = imm1.*lm1*1.8;
    imm1(imm1>1) = 1;

    imshow(imm1,'Parent',handles.tm1im);
end
imshow(im,'Parent',handles.laserim);

h = heightdata(handles.fpath.String,ct);
hs = imgaussfilt(h,256);
h = h-hs;
h = h-min(h(:));

im = real2rgb(h,colorcet('R2'),[0 1]);
imshow(im,'Parent',handles.heightim);
set(handles.laserim,'XLim',handles.lims(1,:),'YLim',handles.lims(2,:));
set(handles.heightim,'XLim',handles.lims(1,:),'YLim',handles.lims(2,:));
set(handles.tm1im,'XLim',handles.lims(1,:),'YLim',handles.lims(2,:));

guidata(hObject,handles);

% --- Executes on button press in savebut.
function savebut_Callback(hObject, eventdata, handles)
% hObject    handle to savebut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data = handles.lays;

name = sprintf('%06d.bin', str2double(handles.ct.String)-1);
fID = fopen([handles.fpath.String '/analysis/manuallayers2/' name],'w');
fwrite(fID,data,'int8');
fclose(fID);
handles.msgtxt.String = "Saved...";

% --- Executes on button press in arrowtoggle.
function arrowtoggle_Callback(hObject, eventdata, handles)
% hObject    handle to arrowtoggle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of arrowtoggle

if get(hObject,'Value') == 1
    xn = normalize_units(hObject,handles,'x');
    yn = normalize_units(hObject,handles,'y');
    annotation('arrow',[xn-0.02 xn],[yn-0.02 yn],...
        'headStyle','cback1','HeadLength',8,'HeadWidth',8,'Color','w',...
        'LineWidth',2);
else
    delete(findall(gcf,'type','annotation'));
end

function xn = normalize_units(hObject,handles,axisdir)
    figpos = get(gcf,'Position');
    axpost = handles.laserim.Position;
    if axisdir == 'x'
        w = figpos(3);
        axpos = axpost(1);
        wax = axpost(3);

    elseif axisdir == 'y'
        w = figpos(4);
        axpos = axpost(2);
        wax = axpost(4);
    end
    fax = 0.5;
    xn = wax/w*fax + axpos/w;


% --- Executes on button press in ROItoggle.
function ROItoggle_Callback(hObject, eventdata, handles)
% hObject    handle to ROItoggle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ROItoggle
axes(handles.laserim);
if handles.ROItoggle.Value == 1
    [handles.ROI,xi,yi] = roipoly;
end
hold on
plot(xi,yi,'w--','LineWidth',2);
guidata(hObject,handles);



function ROIval_Callback(hObject, eventdata, handles)
% hObject    handle to ROIval (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ROIval as text
%        str2double(get(hObject,'String')) returns contents of ROIval as a double


% --- Executes during object creation, after setting all properties.
function ROIval_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ROIval (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ApplyROI.
function ApplyROI_Callback(hObject, eventdata, handles)
% hObject    handle to ApplyROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.lays(handles.ROI==1) = str2double(handles.ROIval.String);
guidata(hObject,handles);
update_plots(hObject,eventdata,handles);


% --- Executes on button press in copyroi.
function copyroi_Callback(hObject, eventdata, handles)
% hObject    handle to copyroi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.copylay = handles.lays(handles.ROI);
guidata(hObject,handles);


% --- Executes on button press in pasteroi.
function pasteroi_Callback(hObject, eventdata, handles)
% hObject    handle to pasteroi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.lays(handles.ROI) = handles.copylay;
guidata(hObject,handles);
update_plots(hObject,eventdata,handles);


% --- Executes on button press in clearbut.
function clearbut_Callback(hObject, eventdata, handles)
% hObject    handle to clearbut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.laychs =[];
guidata(hObject,handles);


% --- Executes on button press in undo.
function undo_Callback(hObject, eventdata, handles)
% hObject    handle to undo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.lays(handles.idx) = handles.undol;
guidata(hObject,handles);
update_plots(hObject,eventdata,handles);
