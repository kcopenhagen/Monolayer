function varargout = markcells(varargin)
% MARKCELLS MATLAB code for markcells.fig
%      MARKCELLS, by itself, creates a new MARKCELLS or raises the existing
%      singleton*.
%
%      H = MARKCELLS returns the handle to a new MARKCELLS or the handle to
%      the existing singleton*.
%
%      MARKCELLS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MARKCELLS.M with the given input arguments.
%
%      MARKCELLS('Property','Value',...) creates a new MARKCELLS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before markcells_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to markcells_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help markcells

% Last Modified by GUIDE v2.5 23-Oct-2019 11:00:16

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @markcells_OpeningFcn, ...
                   'gui_OutputFcn',  @markcells_OutputFcn, ...
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


% --- Executes just before markcells is made visible.
function markcells_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to markcells (see VARARGIN)

% Choose default command line output for markcells
handles.output = hObject;
hold(handles.ax1,'on');
set(hObject,'KeyPressFcn',@KeyPressed);
set(hObject,'WindowButtonMotionFcn',@MouseMove);

load([handles.fpath.String 'adefs.mat'],'adefs');
handles.adefs = adefs;
i = 1;
t = adefs(i).ts;
l = laserdata(handles.fpath.String,t);
l = l./imgaussfilt(l,64);
xlim([adefs(i).x-200 adefs(i).x+200]);
ylim([adefs(i).y-200 adefs(i).y+200]);
imagesc(handles.ax1,l);
name = sprintf('%06d.mat',t);
fname = [handles.fpath.String 'analysis/cells/' name];
if exist(fname,'file')
    load(fname,'x','y');
    handles.x = x;
    handles.y = y;
else
    handles.x = [];
    handles.y = [];
end

handles.s = scatter(handles.x,handles.y,'r.');

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes markcells wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = markcells_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function fpath_Callback(hObject, eventdata, handles)
% hObject    handle to fpath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fpath as text
%        str2double(get(hObject,'String')) returns contents of fpath as a double


% --- Executes during object creation, after setting all properties.
function fpath_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fpath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in but_select.
function but_select_Callback(hObject, eventdata, handles)
% hObject    handle to but_select (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder = uigetdir([handles.fpath.String '../']);
handles.fpath.String = [folder '/'];
[~,~,~] = mkdir([handles.fpath.String '/analysis/cellxys/']);
load([fpath 'adefs.mat'],'adefs');
handles.adefs = adefs;

guidata(hObject,handles);


% --- Executes on button press in but_next.
function but_next_Callback(hObject, eventdata, handles)
% hObject    handle to but_next (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

i = str2double(handles.edit_i.String);
t = handles.adefs(i).ts;
name = sprintf('%06d.mat',t);
fname = [handles.fpath.String 'analysis/cells/' name];
x = handles.x;
y = handles.y;
save(fname,'x','y');

i = i+1;
if i <= numel(handles.adefs)
    handles.edit_i.String = num2str(i);
end

t = handles.adefs(i).ts;
l = laserdata(handles.fpath.String,t);
l = l./imgaussfilt(l,64);
cla(handles.ax1);
imagesc(handles.ax1,l);
xlim([handles.adefs(i).x-200 handles.adefs(i).x+200]);
ylim([handles.adefs(i).y-200 handles.adefs(i).y+200]);
handles.s = scatter(handles.x,handles.y,'r.');

colormap gray
handles.text_t.String = sprintf('t = %d',t);
name = sprintf('%06d.mat',t);
fname = [handles.fpath.String 'analysis/cells/' name];
if exist(fname,'file')==2
    load(fname,'x','y');
    handles.x = x;
    handles.y = y;
else
    handles.x = [];
    handles.y = [];
end
handles.s.XData = handles.x;
handles.s.YData = handles.y;

guidata(hObject,handles);



function edit_i_Callback(hObject, eventdata, handles)
% hObject    handle to edit_i (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_i as text
%        str2double(get(hObject,'String')) returns contents of edit_i as a double


% --- Executes during object creation, after setting all properties.
function edit_i_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_i (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function KeyPressed(hObject, eventdata)
handles = guidata(hObject);
if eventdata.Key == 'n'
    C = get(handles.ax1,'CurrentPoint');
    X = round(C(1,1));
    Y = round(C(1,2));
    handles.x = [handles.x; X];
    handles.y = [handles.y; Y];
    
    handles.s.XData = handles.x;
    handles.s.YData = handles.y;
    
    x = handles.x;
    y = handles.y;
    i = str2double(handles.edit_i.String);
    t = handles.adefs(i).ts;
    name = sprintf('%06d.mat',t);
    fname = [handles.fpath.String 'analysis/cells/' name];
    save(fname,'x','y');
    
end
if eventdata.Key == 'd'
    C = get(handles.ax1,'CurrentPoint');
    X = round(C(1,1));
    Y = round(C(1,2));
    
    x = handles.x;
    y = handles.y;
    dxs = x-X;
    dys = y-Y;
    drs = sqrt(dxs.^2+dys.^2);
    [~,j] = min(drs);
    x(j) = [];
    y(j) =[];
    handles.x = x;
    handles.y = y;
    handles.s.XData = handles.x;
    handles.s.YData = handles.y;
    
    i = str2double(handles.edit_i.String);
    t = handles.adefs(i).ts;
    name = sprintf('%06d.mat',t);
    fname = [handles.fpath.String 'analysis/cells/' name];
    save(fname,'x','y');
    
end

guidata(hObject,handles);

function MouseMove(hObject,eventdata)
