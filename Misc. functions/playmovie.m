function varargout = playmovie(varargin)
% PLAYMOVIE MATLAB code for playmovie.fig
%      PLAYMOVIE, by itself, creates a new PLAYMOVIE or raises the existing
%      singleton*.
%
%      H = PLAYMOVIE returns the handle to a new PLAYMOVIE or the handle to
%      the existing singleton*.
%
%      PLAYMOVIE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PLAYMOVIE.M with the given input arguments.
%
%      PLAYMOVIE('Property','Value',...) creates a new PLAYMOVIE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before playmovie_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to playmovie_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help playmovie

% Last Modified by GUIDE v2.5 09-Aug-2019 13:57:56

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @playmovie_OpeningFcn, ...
                   'gui_OutputFcn',  @playmovie_OutputFcn, ...
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


% --- Executes just before playmovie is made visible.
function playmovie_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to playmovie (see VARARGIN)
handles.F = varargin{1};
handles.slider1.Max = numel(handles.F);
handles.slider1.SliderStep = [1/numel(handles.F) 10/numel(handles.F)];
set(hObject,'KeyPressFcn',@KeyPressed);
% addlistener(handles.slider1,'Value','PostSet',@bardragged);

handles.ct = 1;
imshow(handles.F(1).cdata);

% Choose default command line output for playmovie
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes playmovie wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = playmovie_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
t = round(get(hObject,'Value'));
F = handles.F;
imshow(F(t).cdata,'Parent',handles.axes1);
drawnow
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
F = handles.F;
frt = 1/str2double(handles.edit1.String);
handles.ct = 1;
for t = 1:numel(F)
    imshow(F(t).cdata)
    pause(frt)
    handles.slider1.Value = t;
end
guidata(hObject, handles);

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


function KeyPressed(hObject, eventdata)
%Functionality for when various keys are pressed.
handles = guidata(hObject);

if eventdata.Key == "rightarrow"
    handles.ct = handles.ct+1;
elseif eventdata.Key == "leftarrow"
    handles.ct = handles.ct-1;
end
if handles.ct < 1
    handles.ct = 1;
elseif handles.ct > numel(handles.F)
    handles.ct = numel(handles.F);
end

imshow(handles.F(handles.ct).cdata);
handles.slider1.Value = handles.ct;
guidata(hObject,handles);

% function bardragged(hObject, eventdata)

