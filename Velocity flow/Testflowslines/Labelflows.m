function varargout = Labelflows(varargin)
% LABELFLOWS MATLAB code for Labelflows.fig
%      LABELFLOWS, by itself, creates a new LABELFLOWS or raises the existing
%      singleton*.
%
%      H = LABELFLOWS returns the handle to a new LABELFLOWS or the handle to
%      the existing singleton*.
%
%      LABELFLOWS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LABELFLOWS.M with the given input arguments.
%
%      LABELFLOWS('Property','Value',...) creates a new LABELFLOWS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Labelflows_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Labelflows_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Labelflows

% Last Modified by GUIDE v2.5 20-Mar-2019 20:40:59

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Labelflows_OpeningFcn, ...
                   'gui_OutputFcn',  @Labelflows_OutputFcn, ...
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


% --- Executes just before Labelflows is made visible.
function Labelflows_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Labelflows (see VARARGIN)

% Choose default command line output for Labelflows
handles.output = hObject;

set(hObject,'WindowButtonMotionFcn',@MouseMove);

handles.p0s = [];
handles.p1s = [];
handles.p2s = [];

handles.p0 = drawpolyline(handles.imax,'Position',[0 0],'Visible','off','LineWidth',1,'Color','r');
handles.p1 = drawpolyline(handles.imax,'Position',[0 0],'Visible','off','LineWidth',1,'Color','r');
handles.p2 = drawpolyline(handles.imax,'Position',[0 0],'Visible','off','LineWidth',1,'Color','r');

handles.waittxt.Visible = 'Off';
handles.savetxt.Visible = 'Off';
set(hObject,'KeyPressFcn',@KeyPressed);
handles.colors = ['b','r','y','c','m'];
handles.ccol = 1;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Labelflows wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Labelflows_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function KeyPressed(hObject, eventdata)
%Functionality for when various keys are pressed.
handles = guidata(hObject);

if eventdata.Key == '1'
    plotim(handles,0)
elseif eventdata.Key == '2'
    plotim(handles,1)
elseif eventdata.Key == '3'
    plotim(handles,2)
end

%Asign point positions and advance frame.
if eventdata.Key == 'q'
    handles.p1.Visible = 'off';
    handles.p2.Visible = 'off';
    C = get(handles.imax,'CurrentPoint');
    handles.p0.Position = [handles.p0.Position; [C(1,1) C(1,2)]];
    handles.p0.Position(handles.p0.Position(:,1)==0,:) = [];
    handles.p0.Visible = 'on';
    for i = 1:numel(handles.p0.NodeChildren)-4
        handles.p0.NodeChildren(i).Size = 3;
    end
end

if eventdata.Key == 'w'
    handles.p0.Visible = 'off';
    handles.p2.Visible = 'off';
    C = get(handles.imax,'CurrentPoint');
    handles.p1.Position = [handles.p1.Position; [C(1,1) C(1,2)]];
    handles.p1.Position(handles.p1.Position(:,1)==0,:) = [];
    handles.p1.Visible = 'on';
    for i = 1:numel(handles.p1.NodeChildren)-4
        handles.p1.NodeChildren(i).Size = 3;
    end
end
if eventdata.Key == 'e'
    handles.p0.Visible = 'off';
    handles.p1.Visible = 'off';
    C = get(handles.imax,'CurrentPoint');
    handles.p2.Position = [handles.p2.Position; [C(1,1) C(1,2)]];
    handles.p2.Position(handles.p2.Position(:,1)==0,:) = [];
    handles.p2.Visible = 'on';
    for i = 1:numel(handles.p2.NodeChildren)-4
        handles.p2.NodeChildren(i).Size = 3;
    end
end

if eventdata.Key == "space"
    if all(numel(handles.p0.Position)==numel(handles.p1.Position),...
            numel(handles.p0.Position)==numel(handles.p2.Position))
        handles.p0s = [handles.p0s; [handles.p0.Position]];
        handles.p1s = [handles.p1s; [handles.p1.Position]];
        handles.p2s = [handles.p2s; [handles.p2.Position]];
        handles.p0.Visible = 'off';
        handles.p1.Visible = 'off';
        handles.p2.Visible = 'off';
        handles.p0.Position = [0 0];
        handles.p1.Position = [0 0];
        handles.p2.Position = [0 0];
        plotim(handles,0);
    end
end

uistack(handles.Oflowax,'top');
uistack(handles.Lflowax,'top');

guidata(hObject,handles);

function MouseMove(hObject, eventdata)
% Defined so that the mouse position is constantly updated (otherwise it 
%  will only save the last clicked location.

function plotim(handles,im)
axes(handles.imax)
delete(findobj(handles.imax, 'type', 'image'))
if im == 0
    imshow(handles.l0,'Parent',handles.imax);
%     [handles.p0s.Color] = deal('r');
%     [handles.p1s.Color] = deal('k');
%     [handles.p2s.Color] = deal('k');
    handles.p0.Visible = 'on';
    handles.p1.Visible = 'off';
    handles.p2.Visible = 'off';
    handles.p0.Color = 'r';
    handles.p1.Color = 'k';
    handles.p2.Color = 'k';
elseif im == 1
    imshow(handles.l1,'Parent',handles.imax)
    handles.p0.Visible = 'off';
    handles.p1.Visible = 'on';
    handles.p2.Visible = 'off';
    handles.p0.Color = 'k';
    handles.p1.Color = 'r';
    handles.p2.Color = 'k';

elseif im == 2
    imshow(handles.l2,'Parent',handles.imax)
    handles.p0.Visible = 'off';
    handles.p1.Visible = 'off';
    handles.p2.Visible = 'on';
    handles.p0.Color = 'k';
    handles.p1.Color = 'k';
    handles.p2.Color = 'r';

end


% --- Executes on button press in Savebut.
%         Appends current flows to a file.
function Savebut_Callback(hObject, eventdata, handles)
% hObject    handle to Savebut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.savetxt.Visible = 'on';
drawnow
p0s = handles.p0s;
p1s = handles.p1s;
p2s = handles.p2s;

name = strsplit(handles.fpath,'/');
fold = name{end-2};
name = name{end-1};
t = handles.t;
save([fold 'Labeledflows/flows' name 't' num2str(t)],'p0s','p1s','p2s');
handles.savetxt.Visible = 'off';

% --- Executes on button press in Lshow.
function Lshow_Callback(hObject, eventdata, handles)
% hObject    handle to Lshow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
x0s = handles.p0s(:,1);
y0s = handles.p0s(:,2);
x1s = handles.p1s(:,1);
y1s = handles.p1s(:,2);
x2s = handles.p2s(:,1);
y2s = handles.p2s(:,2);
uistack(handles.Lflowax,'top');
quiver(x0s,y0s,x1s-x0s,y1s-y0s,'Color','g','ShowArrowHead','off','LineWidth',1,'AutoScale','off','Parent',handles.Lflowax);
quiver(x1s,y1s,x2s-x1s,y2s-y1s,'Color','g','LineWidth',1,'AutoScale','off','Parent',handles.Lflowax);


% --- Executes on button press in Oshow.
function Oshow_Callback(hObject, eventdata, handles)
% hObject    handle to Oshow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isempty(handles.testflow)
    handles.waittxt.Visible = 'on';
    drawnow
    handles.testflow = calctestflow(handles.fpath,handles.t,str2double(handles.nf.String),str2double(handles.gf.String),str2double(handles.imf.String));
    handles.waittxt.Visible = 'off';
end
guidata(hObject,handles);

flow = handles.testflow;

x1s = handles.p1s(:,1);
y1s = handles.p1s(:,2);
sz = size(flow.Vx);
inds = sub2ind(sz,round(y1s),round(x1s));
s = str2double(handles.scale.String);
uistack(handles.Oflowax,'top');
col = handles.colors(mod(handles.ccol-1,numel(handles.colors))+1);
handles.ccol = handles.ccol+1;
quiver(x1s,y1s,-s*flow.Vx(inds),-s*flow.Vy(inds),'Color',col,'ShowArrowHead','off','LineWidth',1,'AutoScale','off','Parent',handles.Oflowax);
quiver(x1s,y1s,s*flow.Vx(inds),s*flow.Vy(inds),'Color',col,'LineWidth',1,'AutoScale','off','Parent',handles.Oflowax);
guidata(hObject,handles);

% --- Executes on button press in Ocalc.
function Ocalc_Callback(hObject, eventdata, handles)
% hObject    handle to Ocalc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.waittxt.Visible = 'On';
drawnow
handles.testflow = calctestflow(handles.fpath,handles.t,str2double(handles.nf.String),str2double(handles.gf.String),str2double(handles.imf.String));
handles.waittxt.Visible = 'off';

guidata(hObject,handles);


% --- Executes on button press in newimbut.
function newimbut_Callback(hObject, eventdata, handles)
% hObject    handle to newimbut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

X = randi([101,924],1);
Y = randi([101,668],1);
handles.imax.XLim = [X-49 X+50];
handles.imax.YLim = [Y-49 Y+50];
handles.imax.XLimMode = 'manual';
handles.imax.YLimMode = 'manual';
hold(handles.imax,'on');

handles.Lflowax.XLim = [X-49 X+50];
handles.Lflowax.YLim = [Y-49 Y+50];
handles.Lflowax.XLimMode = 'manual';
handles.Lflowax.YLimMode = 'manual';
handles.Lflowax.Visible = 'off';
handles.Lflowax.YDir = 'reverse';
hold(handles.Lflowax,'on');

handles.Oflowax.XLim = [X-49 X+50];
handles.Oflowax.YLim = [Y-49 Y+50];
handles.Oflowax.XLimMode = 'manual';
handles.Oflowax.YLimMode = 'manual';
handles.Oflowax.Visible = 'off';
handles.Oflowax.YDir = 'reverse';
hold(handles.Oflowax,'on');

folders = dir('/Users/kcopenhagen/Documents/Data/Monolayer/High frame rate');
dirFlags = [folders.isdir];
folders = folders(dirFlags);
folders(1:2) = [];
f = randi(numel(folders),1);

fpath = [folders(f).folder '/' folders(f).name '/'];
files = dir([fpath 'Laser/']);
dirFlags = [files.isdir];
files = files(~dirFlags);
N = numel(files);
t = randi(N-10,1);
%t = 10;

l0 = laserdata(fpath,t-1);
l1 = laserdata(fpath,t);
l2 = laserdata(fpath,t+1);

% l0 = imsharpen(l0,'Amount',3,'Radius',3);
% l1 = imsharpen(l1,'Amount',3,'Radius',3);
% l2 = imsharpen(l2,'Amount',3,'Radius',3);

l0 = normalise(l0);
l1 = normalise(l1);
l2 = normalise(l2);

imshow(l0,'Parent',handles.imax);
hold on

handles.fpath = fpath;
handles.t = t;

handles.l0 = l0;
handles.l1 = l1;
handles.l2 = l2;
handles.testflow = [];
handles.p0s = [];
handles.p1s = [];
handles.p2s = [];
guidata(hObject,handles);



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function nf_Callback(hObject, eventdata, handles)
% hObject    handle to nf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nf as text
%        str2double(get(hObject,'String')) returns contents of nf as a double


% --- Executes during object creation, after setting all properties.
function nf_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function imf_Callback(hObject, eventdata, handles)
% hObject    handle to imf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of imf as text
%        str2double(get(hObject,'String')) returns contents of imf as a double


% --- Executes during object creation, after setting all properties.
function imf_CreateFcn(hObject, eventdata, handles)
% hObject    handle to imf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function gf_Callback(hObject, eventdata, handles)
% hObject    handle to gf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gf as text
%        str2double(get(hObject,'String')) returns contents of gf as a double


% --- Executes during object creation, after setting all properties.
function gf_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Lclear.
function Lclear_Callback(hObject, eventdata, handles)
% hObject    handle to Lclear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla(handles.Lflowax);

% --- Executes on button press in Oclear.
function Oclear_Callback(hObject, eventdata, handles)
% hObject    handle to Oclear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla(handles.Oflowax);



function scale_Callback(hObject, eventdata, handles)
% hObject    handle to scale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of scale as text
%        str2double(get(hObject,'String')) returns contents of scale as a double


% --- Executes during object creation, after setting all properties.
function scale_CreateFcn(hObject, eventdata, handles)
% hObject    handle to scale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in clearcurrent.
function clearcurrent_Callback(hObject, eventdata, handles)
% hObject    handle to clearcurrent (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.p0.Position = [0 0];
handles.p1.Position = [0 0];
handles.p2.Position = [0 0];
