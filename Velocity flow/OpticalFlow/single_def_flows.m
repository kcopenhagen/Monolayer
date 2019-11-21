function varargout = single_def_flows(varargin)
% SINGLE_DEF_FLOWS MATLAB code for single_def_flows.fig
%      SINGLE_DEF_FLOWS, by itself, creates a new SINGLE_DEF_FLOWS or raises the existing
%      singleton*.
%
%      H = SINGLE_DEF_FLOWS returns the handle to a new SINGLE_DEF_FLOWS or the handle to
%      the existing singleton*.
%
%      SINGLE_DEF_FLOWS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SINGLE_DEF_FLOWS.M with the given input arguments.
%
%      SINGLE_DEF_FLOWS('Property','Value',...) creates a new SINGLE_DEF_FLOWS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before single_def_flows_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to single_def_flows_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help single_def_flows

% Last Modified by GUIDE v2.5 19-Sep-2019 09:52:53

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @single_def_flows_OpeningFcn, ...
                   'gui_OutputFcn',  @single_def_flows_OutputFcn, ...
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

% --- Executes just before single_def_flows is made visible.
function single_def_flows_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to single_def_flows (see VARARGIN)

% Choose default command line output for single_def_flows
handles.output = hObject;

handles.datapath = handles.edit_datapath.String;
handles.fpaths = getfold(handles.datapath);
fpaths = handles.fpaths;
handles.Ns = zeros(numel(fpaths),1);
for f = 1:numel(fpaths)
    load([fpaths{f} 'adefs.mat'],'adefs');

    handles.Ns(f) = numel(unique([adefs.id]));
    handles.avgvx{f}{handles.Ns(f)} = [];
    handles.avgvy{f}{handles.Ns(f)} = [];
    handles.stdvx{f}{handles.Ns(f)} = [];
    handles.stdvy{f}{handles.Ns(f)} = [];
    handles.doneqs{f}{handles.Ns(f)} = [];
    str = fpaths{f};
    newstr = split(str,'/');
    fpaths{f} = ['<HTML><FONT COLOR="red">' newstr{end-1} '/</FONT></HTML>'];
end


f = 3;
handles.popup_fpath.String = fpaths;
handles.popup_fpath.Value = f;

load([handles.fpaths{f} 'adefs.mat'],'adefs');
handles.adefs = adefs;
handles.text_idrange.String = sprintf("(%d to %d)",...
   1,numel(unique([handles.adefs.id])));

handles.vx = [];
handles.vy = [];
handles.vxr = [];
handles.vyr = [];
handles.vxlo = [];
handles.vylo = [];
handles.l = [];
handles.lr = [];
handles.llo = [];

handles.pmvx = [];
handles.pmvy = [];
handles.psvx = zeros(401,401);
handles.psvy = zeros(401,401);
handles.nmvx = [];
handles.nmvy = [];
handles.nsvx = zeros(401,401);
handles.nsvy = zeros(401,401);
handles.pk = zeros(401,401);
handles.nk = zeros(401,401);
handles.cdx = [];
handles.cdy = [];

addlistener(handles.edit_t,'String','PostSet',@new_t);
addlistener(handles.edit_id,'String','PostSet',@new_id);
addlistener(handles.popup_fpath,'Value','PostSet',@new_f);

addlistener(handles.slider_t,'Value','PostSet',@move_slider);
addlistener(handles.toggle_calc,'Value','PostSet',@calc);
addlistener(handles.toggle_play,'Value','PostSet',@play);
set(hObject,'WindowKeyPressFcn',@key_pressed);
set(hObject,'windowscrollWheelFcn',@scroll_t);

for ax = [handles.ax_l, handles.ax_t, handles.ax_p, handles.ax_n, handles.ax_d,...
        handles.ax_ap, handles.ax_an]
    set(ax,'xlim',[0 401]);
    set(ax,'ylim',[0 401]);
    hold(ax,'on')
    set(ax,'ydir','reverse');
end


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes single_def_flows wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = single_def_flows_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in but_next.
function but_next_Callback(hObject, eventdata, handles)
% hObject    handle to but_next (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h = guidata(hObject);

f = h.popup_fpath.Value;
i = str2double(h.edit_id.String);

if i < numel(h.doneqs{f})
    h.edit_id.String = num2str(i+1);
else
    h.edit_id.String = '1';
end
%flows(hObject,eventdata,handles)



function edit_datapath_Callback(hObject, eventdata, handles)
% hObject    handle to edit_datapath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_datapath as text
%        str2double(get(hObject,'String')) returns contents of edit_datapath as a double





% --- Executes during object creation, after setting all properties.
function edit_datapath_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_datapath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function popup_fpath_Callback(hObject, eventdata, handles)
% hObject    handle to popup_fpath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of popup_fpath as text
%        str2double(get(hObject,'String')) returns contents of popup_fpath as a double


% --- Executes during object creation, after setting all properties.
function popup_fpath_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_fpath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in but_selectpath.
function but_selectpath_Callback(hObject, eventdata, handles)
% hObject    handle to but_selectpath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h = guidata(hObject);
dpath = uigetdir(h.edit_datapath.String);
h.datapath = dpath;
h.edit_datapath.String = h.datapath;

fpaths = getfold(h.datapath);
for f = 1:numel(fpaths)
    str = fpaths{f};
    newstr = split(str,'/');
    fpaths{f} = [newstr{end-1} '/'];
end
h.popup_fpath.String = fpaths;

guidata(hObject, h);


function edit_t_Callback(hObject, eventdata, handles)
% hObject    handle to edit_t (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_t as text
%        str2double(get(hObject,'String')) returns contents of edit_t as a double


% --- Executes during object creation, after setting all properties.
function edit_t_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_t (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_id_Callback(hObject, eventdata, handles)
% hObject    handle to edit_id (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_id as text
%        str2double(get(hObject,'String')) returns contents of edit_id as a double


% --- Executes during object creation, after setting all properties.
function edit_id_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_id (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in check_lockon.
function check_lockon_Callback(hObject, eventdata, handles)
% hObject    handle to check_lockon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of check_lockon


% --- Executes on slider movement.
function slider_t_Callback(hObject, eventdata, handles)
% hObject    handle to slider_t (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider_t_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_t (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function flows(hObject, eventdata, handles)

h = guidata(hObject);

mpvx = importdata([h.edit_datapath.String '/../Analysis/Flowavgs copy/avgpvx.txt']);
mpvy = importdata([h.edit_datapath.String '/../Analysis/Flowavgs copy/avgpvy.txt']);
mnvx = importdata([h.edit_datapath.String '/../Analysis/Flowavgs copy/avgnvx.txt']);
mnvy = importdata([h.edit_datapath.String '/../Analysis/Flowavgs copy/avgnvy.txt']);

ids = unique([h.adefs.id]);
cdefs = h.adefs([h.adefs.id]==ids(str2double(h.edit_id.String)));

cent = [mean([cdefs.x]) mean([cdefs.y])];

h.vx = [];
h.vy = [];
h.vxr = [];
h.vyr = [];
h.vxlo = [];
h.vylo = [];

h.l = [];
h.lr = [];
h.llo = [];
h.cdx = [];
h.cdy = [];

fpath = h.fpaths{h.popup_fpath.Value};

for t = min([cdefs.ts]):max([cdefs.ts])
    
    dt = t-min([cdefs.ts])+1;
    % Load in flow fields, pad with nans and crop to center around defect.
    lays = loaddata(fpath,t,'manuallayers','int8');
    vx = loaddata(fpath,t,'flows/Vx','float');
    vy = loaddata(fpath,t,'flows/Vy','float');
    vx(lays==0) = NaN;
    vy(lays==0) = NaN;
    
    l = laserdata(fpath,t);
    l = l./imgaussfilt(l,64);
    vx = padarray(vx,[401,401],NaN,'both');
    vy = padarray(vy,[401,401],NaN,'both');
    l = padarray(l,[401,401],NaN,'both');
    
    vx(vx+vy==0) = NaN;
    vy(vx+vy==0) = NaN;
    
    cvx = vx(round(cdefs(dt).y):round(cdefs(dt).y+(2*401)),...
        round(cdefs(dt).x):round(cdefs(dt).x+2*401));
    cvy = vy(round(cdefs(dt).y):round(cdefs(dt).y+(2*401)),...
        round(cdefs(dt).x):round(cdefs(dt).x+2*401));
    cl = l(round(cdefs(dt).y):round(cdefs(dt).y+(2*401)),...
        round(cdefs(dt).x):round(cdefs(dt).x+2*401));
    
    tcvx = vx(round(cent(2)):round(cent(2)+(2*401)),...
        round(cent(1)):round(cent(1)+2*401));
    tcvy = vy(round(cent(2)):round(cent(2)+(2*401)),...
        round(cent(1)):round(cent(1)+2*401));
    tl = l(round(cent(2)):round(cent(2)+(2*401)),...
        round(cent(1)):round(cent(1)+2*401));
    
    
    h.vx = cat(3,h.vx,tcvx((401+1)/2+1:end-(401+1)/2,...
        (401+1)/2+1:end-(401+1)/2));
    h.vy = cat(3,h.vy,tcvy((401+1)/2+1:end-(401+1)/2,...
        (401+1)/2+1:end-(401+1)/2));
    h.l = cat(3,h.l,tl((401+1)/2+1:end-(401+1)/2,...
        (401+1)/2+1:end-(401+1)/2));
    h.cdx = [h.cdx cent(1)-cdefs(dt).x];
    h.cdy = [h.cdy cent(2)-cdefs(dt).y];
    
    % Rotate around center to align with x-axis.
    
    angle = -atan2d(cdefs(dt).d(2),cdefs(dt).d(1));
    cvx = imrotate(cvx,-angle,'nearest','crop');
    cvx = cvx((401+1)/2+1:end-(401+1)/2,...
        (401+1)/2+1:end-(401+1)/2);
    cvy = imrotate(cvy,-angle,'nearest','crop');
    cvy = cvy((401+1)/2+1:end-(401+1)/2,...
        (401+1)/2+1:end-(401+1)/2);
    cl = imrotate(cl,-angle,'nearest','crop');
    cl = cl((401+1)/2+1:end-(401+1)/2,...
        (401+1)/2+1:end-(401+1)/2);
    
    cvxt = cvx*cosd(angle)-cvy*sind(angle);
    cvy = cvx*sind(angle)+cvy*cosd(angle);
    cvx = cvxt;
    
    h.vxr = cat(3,h.vxr,cvx);
    h.vyr = cat(3,h.vyr,cvy);
    
    %**************%
    if cdefs(1).q>0
        h.pk=h.pk+~isnan(cvx);
        h.psvx(~isnan(cvx)) = h.psvx(~isnan(cvx))...
            +(cvx(~isnan(cvx))-mpvx(~isnan(cvx))).^2;
        h.psvy(~isnan(cvy)) = h.psvy(~isnan(cvy))...
            +(cvy(~isnan(cvy))-mpvy(~isnan(cvy))).^2;
    else
        h.nk = h.nk+~isnan(cvx);
        h.nsvx(~isnan(cvx)) = h.nsvx(~isnan(cvx))...
            +(cvx(~isnan(cvx))-mnvx(~isnan(cvx))).^2;
        h.nsvy(~isnan(cvy)) = h.nsvy(~isnan(cvy))...
            +(cvy(~isnan(cvy))-mnvy(~isnan(cvy))).^2;    
    end
    %*****************%
    
    h.vxlo = cat(3,h.vxlo,cvx);
    h.vylo = cat(3,h.vylo,cvy);
    h.llo = cat(3,h.llo,cl);
    
    vxmirror = flipud(cvx);
    vymirror = -flipud(cvy);
    
    h.vxr = cat(3,h.vxr,vxmirror);
    h.vyr = cat(3,h.vyr,vymirror);
    
    %**************%
    if cdefs(1).q>0
        h.pk=h.pk+~isnan(vxmirror);
        h.psvx(~isnan(vxmirror)) = h.psvx(~isnan(vxmirror))...
            +(vxmirror(~isnan(vxmirror))-mpvx(~isnan(vxmirror))).^2;
        h.psvy(~isnan(vymirror)) = h.psvy(~isnan(vymirror))...
            +(vymirror(~isnan(vymirror))-mpvy(~isnan(vymirror))).^2;
    else
        h.nk = h.nk+~isnan(vxmirror);
        h.nsvx(~isnan(vxmirror)) = h.nsvx(~isnan(vxmirror))...
            +(vxmirror(~isnan(vxmirror))-mnvx(~isnan(vxmirror))).^2;
        h.nsvy(~isnan(vymirror)) = h.nsvy(~isnan(vymirror))...
            +(vymirror(~isnan(vymirror))-mnvy(~isnan(vymirror))).^2;    
    end
    %*****************%
        
    %For negative defects rotate it 3 foldily.
    
    if cdefs(1).q<0
        
        angle = -atan2d(cdefs(dt).d(2),cdefs(dt).d(1))+120;
        
        cvx = vx(round(cdefs(dt).y):round(cdefs(dt).y+(2*401)),...
            round(cdefs(dt).x):round(cdefs(dt).x+2*401));
        cvx = imrotate(cvx,-angle,'nearest','crop');
        cvx = cvx((401+1)/2+1:end-(401+1)/2,...
            (401+1)/2+1:end-(401+1)/2);

        cvy = vy(round(cdefs(dt).y):round(cdefs(dt).y+(2*401)),...
            round(cdefs(dt).x):round(cdefs(dt).x+2*401));
        cvy = imrotate(cvy,-angle,'nearest','crop');
        cvy = cvy((401+1)/2+1:end-(401+1)/2,...
            (401+1)/2+1:end-(401+1)/2);

        cvxt = cvx*cosd(angle)-cvy*sind(angle);
        cvy = cvx*sind(angle)+cvy*cosd(angle);
        cvx = cvxt;
        
        h.vxr = cat(3,h.vxr,cvx);
        h.vyr = cat(3,h.vyr,cvy);
        
        %**************%
        if cdefs(1).q>0
            h.pk=h.pk+~isnan(cvx);
            h.psvx(~isnan(cvx)) = h.psvx(~isnan(cvx))...
                +(cvx(~isnan(cvx))-mpvx(~isnan(cvx))).^2;
            h.psvy(~isnan(cvy)) = h.psvy(~isnan(cvy))...
                +(cvy(~isnan(cvy))-mpvy(~isnan(cvy))).^2;
        else
            h.nk = h.nk+~isnan(cvx);
            h.nsvx(~isnan(cvx)) = h.nsvx(~isnan(cvx))...
                +(cvx(~isnan(cvx))-mnvx(~isnan(cvx))).^2;
            h.nsvy(~isnan(cvy)) = h.nsvy(~isnan(cvy))...
                +(cvy(~isnan(cvy))-mnvy(~isnan(cvy))).^2;    
        end
        %*****************%

        vxmirror = flipud(cvx);
        vymirror = -flipud(cvy);

        h.vxr = cat(3,h.vxr,vxmirror);
        h.vyr = cat(3,h.vyr,vymirror);
        h.lr = cat(3,h.lr,cl);
        %**************%
        if cdefs(1).q>0
            h.pk=h.pk+~isnan(vxmirror);
            h.psvx(~isnan(vxmirror)) = h.psvx(~isnan(vxmirror))...
                +(vxmirror(~isnan(vxmirror))-mpvx(~isnan(vxmirror))).^2;
            h.psvy(~isnan(vymirror)) = h.psvy(~isnan(vymirror))...
                +(vymirror(~isnan(vymirror))-mpvy(~isnan(vymirror))).^2;
        else
            h.nk = h.nk+~isnan(vxmirror);
            h.nsvx(~isnan(vxmirror)) = h.nsvx(~isnan(vxmirror))...
                +(vxmirror(~isnan(vxmirror))-mnvx(~isnan(vxmirror))).^2;
            h.nsvy(~isnan(vymirror)) = h.nsvy(~isnan(vymirror))...
                +(vymirror(~isnan(vymirror))-mnvy(~isnan(vymirror))).^2;    
        end
        %*****************%


        angle = -atan2d(cdefs(dt).d(2),cdefs(dt).d(1))+240;
        
        cvx = vx(round(cdefs(dt).y):round(cdefs(dt).y+(2*401)),...
            round(cdefs(dt).x):round(cdefs(dt).x+2*401));
        cvx = imrotate(cvx,-angle,'nearest','crop');
        cvx = cvx((401+1)/2+1:end-(401+1)/2,...
            (401+1)/2+1:end-(401+1)/2);

        cvy = vy(round(cdefs(dt).y):round(cdefs(dt).y+(2*401)),...
            round(cdefs(dt).x):round(cdefs(dt).x+2*401));
        cvy = imrotate(cvy,-angle,'nearest','crop');
        cvy = cvy((401+1)/2+1:end-(401+1)/2,...
            (401+1)/2+1:end-(401+1)/2);


        cvxt = cvx*cosd(angle)-cvy*sind(angle);
        cvy = cvx*sind(angle)+cvy*cosd(angle);
        cvx = cvxt;
        
        h.vxr = cat(3,h.vxr,cvx);
        h.vyr = cat(3,h.vyr,cvy);
        %**************%
        if cdefs(1).q>0
            h.pk=h.pk+~isnan(cvx);
            h.psvx(~isnan(cvx)) = h.psvx(~isnan(cvx))...
                +(cvx(~isnan(cvx))-mpvx(~isnan(cvx))).^2;
            h.psvy(~isnan(cvy)) = h.psvy(~isnan(cvy))...
                +(cvy(~isnan(cvy))-mpvy(~isnan(cvy))).^2;
        else
            h.nk = h.nk+~isnan(cvx);
            h.nsvx(~isnan(cvx)) = h.nsvx(~isnan(cvx))...
                +(cvx(~isnan(cvx))-mnvx(~isnan(cvx))).^2;
            h.nsvy(~isnan(cvy)) = h.nsvy(~isnan(cvy))...
                +(cvy(~isnan(cvy))-mnvy(~isnan(cvy))).^2;    
        end
        %*****************%
        vxmirror = flipud(cvx);
        vymirror = -flipud(cvy);

        h.vxr = cat(3,h.vxr,vxmirror);
        h.vyr = cat(3,h.vyr,vymirror);
        h.lr = cat(3,h.lr,cl);
        
        %**************%
        if cdefs(1).q>0
            h.pk=h.pk+~isnan(vxmirror);
            h.psvx(~isnan(vxmirror)) = h.psvx(~isnan(vxmirror))...
                +(vxmirror(~isnan(vxmirror))-mpvx(~isnan(vxmirror))).^2;
            h.psvy(~isnan(vymirror)) = h.psvy(~isnan(vymirror))...
                +(vymirror(~isnan(vymirror))-mpvy(~isnan(vymirror))).^2;
        else
            h.nk = h.nk+~isnan(vxmirror);
            h.nsvx(~isnan(vxmirror)) = h.nsvx(~isnan(vxmirror))...
                +(vxmirror(~isnan(vxmirror))-mnvx(~isnan(vxmirror))).^2;
            h.nsvy(~isnan(vymirror)) = h.nsvy(~isnan(vymirror))...
                +(vymirror(~isnan(vymirror))-mnvy(~isnan(vymirror))).^2;    
        end
        %*****************%
    end
end

guidata(hObject,h);

function fast_flows(hObject, eventdata, handles)

h = guidata(hObject);
ids = unique([h.adefs.id]);
cdefs = h.adefs([h.adefs.id]==ids(str2double(h.edit_id.String)));

cent = [mean([cdefs.x]) mean([cdefs.y])];

h.vx = [];
h.vy = [];
h.vxlo = [];
h.vylo = [];

h.l = [];
h.llo = [];
h.cdx = [];
h.cdy = [];

fpath = h.fpaths{h.popup_fpath.Value};

for t = min([cdefs.ts]):max([cdefs.ts])
    
    dt = t-min([cdefs.ts])+1;
    % Load in flow fields, pad with nans and crop to center around defect.
    lays = loaddata(fpath,t,'manuallayers','int8');
    vx = loaddata(fpath,t,'flows/Vx','float');
    vy = loaddata(fpath,t,'flows/Vy','float');
    vx(lays==0) = NaN;
    vy(lays==0) = NaN;
    
    l = laserdata(fpath,t);
    l = l./imgaussfilt(l,64);
    vx = padarray(vx,[401,401],NaN,'both');
    vy = padarray(vy,[401,401],NaN,'both');
    l = padarray(l,[401,401],NaN,'both');
    
    vx(vx+vy==0) = NaN;
    vy(vx+vy==0) = NaN;
    
    cvx = vx(round(cdefs(dt).y):round(cdefs(dt).y+(2*401)),...
        round(cdefs(dt).x):round(cdefs(dt).x+2*401));
    cvy = vy(round(cdefs(dt).y):round(cdefs(dt).y+(2*401)),...
        round(cdefs(dt).x):round(cdefs(dt).x+2*401));
    cl = l(round(cdefs(dt).y):round(cdefs(dt).y+(2*401)),...
        round(cdefs(dt).x):round(cdefs(dt).x+2*401));
    
    tcvx = vx(round(cent(2)):round(cent(2)+(2*401)),...
        round(cent(1)):round(cent(1)+2*401));
    tcvy = vy(round(cent(2)):round(cent(2)+(2*401)),...
        round(cent(1)):round(cent(1)+2*401));
    tl = l(round(cent(2)):round(cent(2)+(2*401)),...
        round(cent(1)):round(cent(1)+2*401));
    
    
    h.vx = cat(3,h.vx,tcvx((401+1)/2+1:end-(401+1)/2,...
        (401+1)/2+1:end-(401+1)/2));
    h.vy = cat(3,h.vy,tcvy((401+1)/2+1:end-(401+1)/2,...
        (401+1)/2+1:end-(401+1)/2));
    h.l = cat(3,h.l,tl((401+1)/2+1:end-(401+1)/2,...
        (401+1)/2+1:end-(401+1)/2));
    h.cdx = [h.cdx cent(1)-cdefs(dt).x];
    h.cdy = [h.cdy cent(2)-cdefs(dt).y];
    
    % Rotate around center to align with x-axis.
    
    angle = -atan2d(cdefs(dt).d(2),cdefs(dt).d(1));
    cvx = imrotate(cvx,-angle,'nearest','crop');
    cvx = cvx((401+1)/2+1:end-(401+1)/2,...
        (401+1)/2+1:end-(401+1)/2);
    cvy = imrotate(cvy,-angle,'nearest','crop');
    cvy = cvy((401+1)/2+1:end-(401+1)/2,...
        (401+1)/2+1:end-(401+1)/2);
    cl = imrotate(cl,-angle,'nearest','crop');
    cl = cl((401+1)/2+1:end-(401+1)/2,...
        (401+1)/2+1:end-(401+1)/2);
    
    cvxt = cvx*cosd(angle)-cvy*sind(angle);
    cvy = cvx*sind(angle)+cvy*cosd(angle);
    cvx = cvxt;

    h.vxlo = cat(3,h.vxlo,cvx);
    h.vylo = cat(3,h.vylo,cvy);
    h.llo = cat(3,h.llo,cl);
    
end

guidata(hObject,h);

function fastest_flows(hObject, eventdata, handles)

h = guidata(hObject);
f = h.popup_fpath.Value;
defs = load([h.fpaths{f} 'adefs.mat']);
h.adefs = defs.adefs;

ids = unique([h.adefs.id]);
cdefs = h.adefs([h.adefs.id]==ids(str2double(h.edit_id.String)));

cent = [mean([cdefs.x]) mean([cdefs.y])];

h.vx = [];
h.vy = [];
h.vxlo = [];
h.vylo = [];

h.l = [];
h.llo = [];
h.cdx = [];
h.cdy = [];

fpath = h.fpaths{h.popup_fpath.Value};

for t = min([cdefs.ts]):max([cdefs.ts])
    
    dt = t-min([cdefs.ts])+1;
    % Load in flow fields, pad with nans and crop to center around defect.
    lays = loaddata(fpath,t,'manuallayers','int8');
    vx = loaddata(fpath,t,'flows/Vx','float');
    vy = loaddata(fpath,t,'flows/Vy','float');
    vx(lays==0) = NaN;
    vy(lays==0) = NaN;
    
    l = laserdata(fpath,t);
    l = l./imgaussfilt(l,64);
    vx = padarray(vx,[401,401],NaN,'both');
    vy = padarray(vy,[401,401],NaN,'both');
    l = padarray(l,[401,401],NaN,'both');
    
    vx(vx+vy==0) = NaN;
    vy(vx+vy==0) = NaN;
    
    cvx = vx(round(cdefs(dt).y):round(cdefs(dt).y+(2*401)),...
        round(cdefs(dt).x):round(cdefs(dt).x+2*401));
    cvy = vy(round(cdefs(dt).y):round(cdefs(dt).y+(2*401)),...
        round(cdefs(dt).x):round(cdefs(dt).x+2*401));
    cl = l(round(cdefs(dt).y):round(cdefs(dt).y+(2*401)),...
        round(cdefs(dt).x):round(cdefs(dt).x+2*401));
    
    tcvx = vx(round(cent(2)):round(cent(2)+(2*401)),...
        round(cent(1)):round(cent(1)+2*401));
    tcvy = vy(round(cent(2)):round(cent(2)+(2*401)),...
        round(cent(1)):round(cent(1)+2*401));
    tl = l(round(cent(2)):round(cent(2)+(2*401)),...
        round(cent(1)):round(cent(1)+2*401));
    
    
    h.vx = cat(3,h.vx,tcvx((401+1)/2+1:end-(401+1)/2,...
        (401+1)/2+1:end-(401+1)/2));
    h.vy = cat(3,h.vy,tcvy((401+1)/2+1:end-(401+1)/2,...
        (401+1)/2+1:end-(401+1)/2));
    h.l = cat(3,h.l,tl((401+1)/2+1:end-(401+1)/2,...
        (401+1)/2+1:end-(401+1)/2));
    h.cdx = [h.cdx cent(1)-cdefs(dt).x];
    h.cdy = [h.cdy cent(2)-cdefs(dt).y];

end

guidata(hObject,h);


function new_id(hObject, eventdata)
%Reload the stored average flow data. 
%   Check if it is already stored.
%   Check if it can be read in from file.
%   Run flows on current defect, save into file.
%   Set strings for how many defects are calculated.

h = guidata(eventdata.AffectedObject.Parent);
f = h.popup_fpath.Value;
i = str2double(h.edit_id.String);

load([h.fpaths{f} 'adefs.mat'],'adefs');
h.adefs = adefs;
cla(h.ax_t);
cla(h.ax_l);

ids = unique([h.adefs.id]);
id = ids(i);

cdefs = h.adefs([h.adefs.id] == id);

need_it = isempty(h.doneqs{f}{i});
name = sprintf('%06d.bin',i);

if exist([h.fpaths{f} 'analysis/defects/vx/' name])
    
    need_it = false;
    fID = fopen([h.fpaths{f} 'analysis/defects/vx/' name],'r');
    h.avgvx{f}{i} = fread(fID, [401 401], 'float');
    fclose(fID);
    fID = fopen([h.fpaths{f} 'analysis/defects/vy/' name],'r');
    h.avgvy{f}{i} = fread(fID, [401 401], 'float');
    fclose(fID);
    fID = fopen([h.fpaths{f} 'analysis/defects/stdvx/' name],'r');
    h.stdvx{f}{i} = fread(fID, [401 401], 'float');
    fclose(fID);
    fID = fopen([h.fpaths{f} 'analysis/defects/stdvy/' name],'r');
    h.stdvy{f}{i} = fread(fID, [401 401], 'float');
    fclose(fID);
    h.doneqs{f}{i} = cdefs(1).q;
end

if need_it
    h.text_running.Visible = 'on';
    drawnow
    
    guidata(eventdata.AffectedObject.Parent,h);

    flows(eventdata.AffectedObject.Parent);

    h = guidata(eventdata.AffectedObject.Parent);

    h.avgvx{f}{i} = mean(h.vxr,3,'omitnan');
    h.stdvx{f}{i} = std(h.vxr,0,3,'omitnan');
    h.avgvy{f}{i} = mean(h.vyr,3,'omitnan');
    h.stdvy{f}{i} = std(h.vyr,0,3,'omitnan');
    
    h.doneqs{f}{i} = cdefs(1).q;
    
    fID = fopen([h.fpaths{f} 'analysis/defects/vx/' name],'w');
    fwrite(fID,h.avgvx{f}{i},'float');
    fclose(fID);
    
    fID = fopen([h.fpaths{f} 'analysis/defects/vy/' name],'w');
    fwrite(fID,h.avgvy{f}{i},'float');
    fclose(fID);
    
    fID = fopen([h.fpaths{f} 'analysis/defects/stdvx/' name],'w');
    fwrite(fID,h.stdvx{f}{i},'float');
    fclose(fID);
    
    fID = fopen([h.fpaths{f} 'analysis/defects/stdvy/' name],'w');
    fwrite(fID,h.stdvy{f}{i},'float');
    fclose(fID);
    guidata(eventdata.AffectedObject.Parent,h);
    
end

str = sprintf("(%d to %d)",min([cdefs.ts]),max([cdefs.ts]));
h.text_trange.String = str;

plotfl(h.ax_d,h.avgvx{f}{i},h.avgvy{f}{i},[0 0],'auto',colorcet('L16'));

h.text_running.Visible = 'off';

n1 = numel([h.doneqs{h.popup_fpath.Value}{:}]);
np = sum([h.doneqs{h.popup_fpath.Value}{:}]>0);
nn = sum([h.doneqs{h.popup_fpath.Value}{:}]<0);

str = sprintf("(%d (%d +, %d -) out of %d)",n1,np,nn,sum(h.Ns(h.popup_fpath.Value)));
h.text_expdone.String = str;
n1 = 0;
for f= 1:numel(h.fpaths)
    n1 = n1+numel([h.doneqs{f}{:}]); 
end

str = sprintf("(%d out of %d)",n1,sum(h.Ns));
h.text_alldone.String = str;

guidata(eventdata.AffectedObject.Parent,h);

function new_t(hObject, eventdata)

h = guidata(eventdata.AffectedObject.Parent);

f = h.popup_fpath.Value;
i = str2double(h.edit_id.String);
t = str2double(h.edit_t.String);
ids = unique([h.adefs.id]);

cdefs = h.adefs([h.adefs.id]==ids(i));

h.slider_t.Max = max([cdefs.ts]);
h.slider_t.Min = min([cdefs.ts]);

if t>max([cdefs.ts])
    t = max([cdefs.ts]);
    h.edit_t.String = num2str(t);
    h = guidata(eventdata.AffectedObject.Parent);
elseif t<min([cdefs.ts])
    t = min([cdefs.ts]);
    h.edit_t.String = num2str(t);
    h = guidata(eventdata.AffectedObject.Parent);
end

h.slider_t.Value = t;

deft = t-min([cdefs.ts])+1;

if h.check_lockon.Value == 1
    plotfl(h.ax_t,h.vxlo(:,:,deft),h.vylo(:,:,deft),[0 0],[0 0.14],colorcet('L16'));
    plotl(h.ax_l,h.llo(:,:,deft),...
        cdefs(str2double(h.edit_t.String)-min([cdefs.ts])+1).q,...
        [1 0],...
        [0 0]);
else
    plotfl(h.ax_t,h.vx(:,:,deft),h.vy(:,:,deft),[h.cdx(deft) h.cdy(deft)],...
        [0 0.14],colorcet('L16'));
    plotl(h.ax_l,h.l(:,:,deft),...
        cdefs(str2double(h.edit_t.String)-min([cdefs.ts])+1).q,...
        cdefs(str2double(h.edit_t.String)-min([cdefs.ts])+1).d,...
        [h.cdx(deft) h.cdy(deft)]);
end
guidata(eventdata.AffectedObject.Parent,h);

function plotfl(ax,vx,vy,c,lims,cmap)
cla(ax)
sp = sqrt(vx.^2+vy.^2);

if lims(1) == 'a'
    lims = [min(sp(:)) max(sp(:))];
end

im = real2rgb(sp,cmap,lims);

x = 1:401;
y = 1:401;
[xx,yy] = meshgrid(x,y);
rr = sqrt((xx-201).^2+(yy-201).^2);

alphas = ones(401,401);
alphas(rr>201) = 0;

flimage = imshow(im,'Parent',ax);
flimage.AlphaData = alphas;

xgrid = 1:20:401;
ygrid = 1:20:401;
[xquiv, yquiv] = meshgrid(xgrid,ygrid);

gridinds = sub2ind(size(im),yquiv,xquiv);

uquiv = vx(gridinds(rr(gridinds)<201));
vquiv = vy(gridinds(rr(gridinds)<201));
xquiv = xquiv((rr(gridinds)<201));
yquiv = yquiv((rr(gridinds)<201));
quiver(xquiv,yquiv,uquiv,vquiv,'c','LineWidth',1.5,'Parent',ax);
plot(201-c(1),201-c(2),'m.','MarkerSize',10,'Parent',ax);

function plotflerr(ax,ex,ey)

cla(ax)
toterr = sqrt(ex.^2+ey.^2);
im = real2rgb(toterr,colorcet('L8'));

x = 1:401;
y = 1:401;
[xx,yy] = meshgrid(x,y);
rr = sqrt((xx-201).^2+(yy-201).^2);

alphas = ones(401,401);
alphas(rr>201) = 0;

flimage = imshow(im,'Parent',ax);
flimage.AlphaData = alphas;

xgrid = 1:40:401;
ygrid = 1:40:401;
[xquiv, yquiv] = meshgrid(xgrid,ygrid);

gridinds = sub2ind(size(im),yquiv,xquiv);

uquiv = ex(gridinds(rr(gridinds)<201));
vquiv = ey(gridinds(rr(gridinds)<201));
xquiv = xquiv((rr(gridinds)<201));
yquiv = yquiv((rr(gridinds)<201));
zers = zeros(size(uquiv));
quiver(xquiv,yquiv,uquiv,zers,0.1,'Color','w','LineWidth',1.5,'ShowArrowHead','off','Parent',ax);
quiver(xquiv,yquiv,-uquiv,zers,0.1,'Color','w','LineWidth',1.5,'ShowArrowHead','off','Parent',ax);
quiver(xquiv,yquiv,zers,vquiv,0.1,'Color','w','LineWidth',1.5,'ShowArrowHead','off','Parent',ax);
quiver(xquiv,yquiv,zers,-vquiv,0.1,'Color','w','LineWidth',1.5,'ShowArrowHead','off','Parent',ax);

plot(201,201,'c.','MarkerSize',10,'Parent',ax);

function plotl(ax,l,q,d,corr)

cla(ax);
imagesc(ax,l);

cx = 201-corr(1);
cy = 201-corr(2);
if q>0
    plot(ax,cx,cy,'r.','MarkerSize',20);
    plot(ax,[cx cx+20*d(1)],[cy cy+20*d(2)],'r','LineWidth',3);
end
if q<0
    plot(ax,cx,cy,'b.','MarkerSize',20);
    plot(ax,[cx cx+20*d(1)...
        cx cx+20*(cosd(120)*d(1)-sind(120)*d(2))...
        cx cx+20*(cosd(240)*d(1)-sind(240)*d(2))],...
        [cy cy+20*d(2)...
        cy cy+20*(sind(120)*d(1)+cosd(120)*d(2))...
        cy cy+20*(sind(240)*d(1)+cosd(240)*d(2))],'b','LineWidth',3);
end


% --- Executes on button press in toggle_play.
function toggle_play_Callback(hObject, eventdata, handles)
% hObject    handle to toggle_play (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


function edit_fps_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit_fps_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_fps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function scroll_t(hObject,eventdata)

h = guidata(hObject);
h.edit_t.String = num2str(str2num(h.edit_t.String)+eventdata.VerticalScrollCount);


function move_slider(hObject,eventdata)

h = guidata(eventdata.AffectedObject.Parent);
h.slider_t.Value = round(h.slider_t.Value);
h.edit_t.String = num2str(h.slider_t.Value);

function key_pressed(hObject,eventdata)
h = guidata(hObject);

if eventdata.Key == "rightarrow"
    h.edit_t.String = num2str(str2double(h.edit_t.String)+1);
end
if eventdata.Key == "leftarrow"
    h.edit_t.String = num2str(str2double(h.edit_t.String)-1);
end


% --- Executes on button press in toggle_calc.
function toggle_calc_Callback(hObject, eventdata, handles)
% hObject    handle to toggle_calc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in but_plotall.
function but_plotall_Callback(hObject, eventdata, handles)
% hObject    handle to but_plotall (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h = guidata(hObject);
% 
% totpvx = zeros(401);
% totpvy = zeros(401);
% 
% totnvx = zeros(401);
% totnvy = zeros(401);
% 
% countp = zeros(size(totpvx));
% countn = zeros(size(totnvx));
% for f = 1:numel(h.fpaths)
%     
%     eavgvx = h.avgvx{f};
%     eavgvy = h.avgvy{f};
%     eq = h.doneqs{f};
% 
%     for i = 1:numel(eavgvx)
%         if ~isempty(eavgvx{i})
%             if eq{i}>0
%                 vx = eavgvx{i};
%                 vy = eavgvy{i};
%                 vx(isnan(vx)) = 0;
%                 vy(isnan(vy)) = 0;
%                 totpvx = totpvx+vx;
%                 totpvy = totpvy+vy;
%                 countp = countp + ~isnan(vx);
% 
%             else
%                 vx = eavgvx{i};
%                 vy = eavgvy{i};
%                 vx(isnan(vx)) = 0;
%                 vy(isnan(vy)) = 0;
%                 totnvx = totnvx+vx;
%                 totnvy = totnvy+vy;
%                 countn = countn + ~isnan(vx);
% 
%             end
%         end
%     end
% end
% 
% plotfl(h.ax_ap,totpvx./countp,totpvy./countp,[0 0],[0 0.014],colorcet('L4'));
% plotfl(h.ax_an,totnvx./countn,totnvy./countn,[0 0],[0 0.014],colorcet('L4'));
% 
mpvx = importdata([h.edit_datapath.String '/../Analysis/Flowavgs copy/avgpvx.txt']);
mpvy = importdata([h.edit_datapath.String '/../Analysis/Flowavgs copy/avgpvy.txt']);
mnvx = importdata([h.edit_datapath.String '/../Analysis/Flowavgs copy/avgnvx.txt']);
mnvy = importdata([h.edit_datapath.String '/../Analysis/Flowavgs copy/avgnvy.txt']);

plotfl(h.ax_ap,mpvx,mpvy,[0 0],[0 0.014],colorcet('L4'));
plotfl(h.ax_an,mnvx,mnvy,[0 0],[0 0.014],colorcet('L4'));

% --- Executes on button press in but_plotexp.
function but_plotexp_Callback(hObject, eventdata, handles)
% hObject    handle to but_plotexp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h = guidata(hObject);

eavgvx = h.avgvx{h.popup_fpath.Value};
eavgvy = h.avgvy{h.popup_fpath.Value};
eq = h.doneqs{h.popup_fpath.Value};

totpvx = zeros(size(eavgvx{1}));
totpvy = zeros(size(eavgvy{1}));

totnvx = zeros(size(eavgvx{1}));
totnvy = zeros(size(eavgvy{1}));

countp = zeros(size(totpvx));
countn = zeros(size(totnvx));
for i = 1:numel(eavgvx)
    if ~isempty(eavgvx{i})
        if eq{i}>0
            vx = eavgvx{i};
            vy = eavgvy{i};
            vx(isnan(vx)) = 0;
            vy(isnan(vy)) = 0;
            totpvx = totpvx+vx;
            totpvy = totpvy+vy;
            countp = countp + ~isnan(vx);
            
        else
            vx = eavgvx{i};
            vy = eavgvy{i};
            vx(isnan(vx)) = 0;
            vy(isnan(vy)) = 0;
            totnvx = totnvx+vx;
            totnvy = totnvy+vy;
            countn = countn + ~isnan(vx);
            
        end
    end
end

plotfl(h.ax_p,totpvx./countp,totpvy./countp,[0 0],[0 0.014],colorcet('L4'));
plotfl(h.ax_n,totnvx./countn,totnvy./countn,[0 0],[0 0.014],colorcet('L4'));


% --- Executes on button press in but_calc_flows.
function but_calc_flows_Callback(hObject, eventdata, handles)
% hObject    handle to but_calc_flows (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h = guidata(hObject);
h.text_running.Visible = 'on';
drawnow
fast_flows(hObject);
h.text_running.Visible = 'off';

function calc(hObject,eventdata)

h = guidata(eventdata.AffectedObject.Parent);
while h.toggle_calc.Value == 1
    h.text_running.Visible = 'on';
    f = h.popup_fpath.Value;
    i = find(cellfun(@numel,h.doneqs{f})==0,1);
    if ~isempty(i)
        h = guidata(eventdata.AffectedObject.Parent);
        h.edit_id.String = num2str(i);
        h = guidata(eventdata.AffectedObject.Parent);
    else
        
        h = guidata(eventdata.AffectedObject.Parent);
        oldstr = h.popup_fpath.String{h.popup_fpath.Value};
        inds = find(oldstr=='"');
        str = [oldstr(1:inds(1)) 'green' oldstr(inds(2):end)];
        h.popup_fpath.String{h.popup_fpath.Value} = str;

        nf = -1;
        for f = 1:numel(h.fpaths)
            if ~isempty(find(cellfun(@numel,h.doneqs{f})==0,1))
                nf = f;
            end
        end
        if nf ~=-1
            f = nf;
            h = guidata(eventdata.AffectedObject.Parent);
            h.popup_fpath.Value = f;
            h = guidata(eventdata.AffectedObject.Parent);
        else
            h = guidata(eventdata.AffectedObject.Parent);
            h.toggle_calc.Value = 0;
        end
        guidata(eventdata.AffectedObject.Parent,h);
    end
    h = guidata(eventdata.AffectedObject.Parent);

end
h.text_running.Visible = 'off';


% --- Executes on button press in but_calc_fast.
function but_calc_fast_Callback(hObject, eventdata, handles)
% hObject    handle to but_calc_flows (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h = guidata(hObject);
h.text_running.Visible = 'on';
drawnow
fastest_flows(hObject);
h.text_running.Visible = 'off';

function play(hObject,eventdata,handles)

h = guidata(eventdata.AffectedObject.Parent);

while h.toggle_play.Value == 1
    h = guidata(eventdata.AffectedObject.Parent);
    ids = unique([h.adefs.id]);
    cdefs = h.adefs([h.adefs.id]==ids(str2double(h.edit_id.String)));
    trange = [min([cdefs.ts]) max([cdefs.ts])];
    if str2double(h.edit_t.String)<trange(2)
        h.edit_t.String = num2str(str2double(h.edit_t.String)+1);
        pause(1/str2double(h.edit_fps.String));
        h = guidata(eventdata.AffectedObject.Parent);
    else 
        h.edit_t.String = num2str(trange(1));
        h = guidata(eventdata.AffectedObject.Parent);
    end
end

function new_f(hObject,eventdata,handles)
% Select new experiment.
%   Load new list of defects into stored data.
%   Update string for number of defects available.

h = guidata(eventdata.AffectedObject.Parent);

for f = 1:numel(h.fpaths)
    
    if sum(cellfun(@isempty,h.doneqs{f})) == 0
        oldstr = h.popup_fpath.String{f};
        inds = find(oldstr=='"');
        newstr = [oldstr(1:inds(1)) 'green' oldstr(inds(2):end)];
        h.popup_fpath.String{f} = newstr;
    end
end
    
f = h.popup_fpath.Value;
load([h.fpaths{f} 'adefs.mat'],'adefs');

h.adefs = adefs;
h.text_idrange.String = sprintf("(%d to %d)",...
   1,numel(unique([h.adefs.id])));

guidata(eventdata.AffectedObject.Parent,h);


% --- Executes on button press in save_all.
function save_all_Callback(hObject, eventdata, handles)
% hObject    handle to save_exp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h = guidata(hObject);
% 
% eavgvx = h.avgvx{h.popup_fpath.Value};
% eavgvy = h.avgvy{h.popup_fpath.Value};
% estdvx = h.stdvx{h.popup_fpath.Value};
% estdvy = h.stdvy{h.popup_fpath.Value};
% eq = h.doneqs{h.popup_fpath.Value};
% 
% totpvx = zeros(size(eavgvx{1}));
% totpvy = zeros(size(eavgvy{1}));
% totpvxerr = zeros(size(estdvx{1}));
% totpvyerr = zeros(size(estdvy{1}));
% 
% totnvx = zeros(size(eavgvx{1}));
% totnvy = zeros(size(eavgvy{1}));
% totnvxerr = zeros(size(eavgvx{1}));
% totnvyerr = zeros(size(eavgvy{1}));
% 
% countp = zeros(size(totpvx));
% countn = zeros(size(totnvx));
% for f = 1:numel(h.fpaths)
%     eavgvx = h.avgvx{f};
%     eavgvy = h.avgvy{f};
%     estdvx = h.stdvx{f};
%     estdvy = h.stdvy{f};
%     eq = h.doneqs{f};
%     
%     for i = 1:numel(eavgvx)
%         if ~isempty(eavgvx{i})
%             if eq{i}>0
%                 vx = eavgvx{i};
%                 vy = eavgvy{i};
%                 vxerr = estdvx{i}.^2;
%                 vyerr = estdvy{i}.^2;
%                 vx(isnan(vx)) = 0;
%                 vy(isnan(vy)) = 0;
%                 vxerr(isnan(vxerr)) = 0;
%                 vyerr(isnan(vyerr)) = 0;
%                 totpvx = totpvx+vx;
%                 totpvy = totpvy+vy;
%                 totpvxerr = totpvxerr+vxerr;
%                 totpvyerr = totpvyerr+vyerr;
%                 countp = countp + ~isnan(vx);
% 
%             else
%                 vx = eavgvx{i};
%                 vy = eavgvy{i};
%                 vxerr = estdvx{i}.^2;
%                 vyerr = estdvy{i}.^2;
%                 vx(isnan(vx)) = 0;
%                 vy(isnan(vy)) = 0;
%                 vxerr(isnan(vxerr)) = 0;
%                 vyerr(isnan(vyerr)) = 0;
%                 totnvx = totnvx+vx;
%                 totnvy = totnvy+vy;
%                 totnvxerr = totnvxerr+vxerr;
%                 totnvyerr = totnvyerr+vyerr;
%                 countn = countn + ~isnan(vx);
% 
%             end
%         end
%     end
% end
% pvx = totpvx./countp;
% pvy = totpvy./countp;
% pvxerr = totpvxerr./countp;
% pvyerr = totpvyerr./countp;
% 
% nvx = totnvx./countn;
% nvy = totnvy./countn;
% nvxerr = totnvxerr./countn;
% nvyerr = totnvyerr./countn;

pvx = importdata([h.edit_datapath.String '/../Analysis/Flowavgs copy/avgpvx.txt']);
pvy = importdata([h.edit_datapath.String '/../Analysis/Flowavgs copy/avgpvy.txt']);
nvx = importdata([h.edit_datapath.String '/../Analysis/Flowavgs copy/avgnvx.txt']);
nvy = importdata([h.edit_datapath.String '/../Analysis/Flowavgs copy/avgnvy.txt']);

pvxerr = h.psvx./h.pk;
pvyerr = h.psvy./h.pk;
nvxerr = h.nsvx./h.nk;
nvyerr = h.nsvy./h.nk;

dpath = [h.edit_datapath.String '/../Analysis/Flowavgs/'];
save([dpath 'avgpvx.txt'], 'pvx', '-ascii','-double','-tabs')
save([dpath 'avgpvy.txt'], 'pvy', '-ascii','-double', '-tabs')
save([dpath 'avgpvxerr.txt'], 'pvxerr', '-ascii','-double', '-tabs')
save([dpath 'avgpvyerr.txt'], 'pvyerr', '-ascii','-double', '-tabs')
save([dpath 'avgnvx.txt'], 'nvx', '-ascii','-double', '-tabs')
save([dpath 'avgnvy.txt'], 'nvy', '-ascii','-double', '-tabs')
save([dpath 'avgnvxerr.txt'], 'nvxerr', '-ascii','-double', '-tabs')
save([dpath 'avgnvyerr.txt'], 'nvyerr', '-ascii','-double', '-tabs')

fig = figure('Units','pixels','Position',[100 100 820 400]);
ax1 = axes(fig,'Units','pixels','Position',[0 0 400 400]);
ax2 = axes(fig,'Units','pixels','Position',[420 0 400 400]);
hold(ax1,'on');
hold(ax2,'on');
plotfl(ax1,pvx,pvy,[0 0],[0 0.014],colorcet('L4'));
plotfl(ax2,nvx,nvy,[0 0],[0 0.014],colorcet('L4'));
saveas(fig,[dpath 'avgflows.png']);
close(fig);

% --- Executes on button press in save_exp.
function save_exp_Callback(hObject, eventdata, handles)
% hObject    handle to save_exp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h = guidata(hObject);

eavgvx = h.avgvx{h.popup_fpath.Value};
eavgvy = h.avgvy{h.popup_fpath.Value};
eq = h.doneqs{h.popup_fpath.Value};

totpvx = zeros(size(eavgvx{1}));
totpvy = zeros(size(eavgvy{1}));

totnvx = zeros(size(eavgvx{1}));
totnvy = zeros(size(eavgvy{1}));

countp = zeros(size(totpvx));
countn = zeros(size(totnvx));
for i = 1:numel(eavgvx)
    if ~isempty(eavgvx{i})
        if eq{i}>0
            vx = eavgvx{i};
            vy = eavgvy{i};
            vx(isnan(vx)) = 0;
            vy(isnan(vy)) = 0;
            totpvx = totpvx+vx;
            totpvy = totpvy+vy;
            countp = countp + ~isnan(vx);
            
        else
            vx = eavgvx{i};
            vy = eavgvy{i};
            vx(isnan(vx)) = 0;
            vy(isnan(vy)) = 0;
            totnvx = totnvx+vx;
            totnvy = totnvy+vy;
            countn = countn + ~isnan(vx);
            
        end
    end
end

pvx = totpvx./countp;
pvy = totpvy./countp;

nvx = totnvx./countn;
nvy = totnvy./countn;

f = h.popup_fpath.Value;
fpath = h.fpaths{f};

fig = figure('Units','pixels','Position',[100 100 820 400]);
ax1 = axes(fig,'Units','pixels','Position',[0 0 400 400]);
ax2 = axes(fig,'Units','pixels','Position',[420 0 400 400]);
hold(ax1,'on');
hold(ax2,'on');
set(ax1,'Visible','off');
set(ax2,'Visible','off');

plotfl(ax1,pvx,pvy,[0 0],[0 0.014],colorcet('L4'));
plotfl(ax2,nvx,nvy,[0 0],[0 0.014],colorcet('L4'));
saveas(fig,[fpath 'analysis/defects/avgflows.png']);
close(fig);


% --- Executes on button press in save_def.
function save_def_Callback(hObject, eventdata, handles)
% hObject    handle to save_def (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h = guidata(hObject);
i = str2double(h.edit_id.String);

fig = figure('Units','pixels','Postition',[100 100 400 400]);
ax1 = axes(fig,'Units','pixels','Position',[0 0 400 400]);
hold(ax1,'on');
set(ax1,'Visible','off');
plotfl(ax1,h.avgvx,h.avgvy,[0 0],'auto',colorcet('L16'));
saveas(fig,sprintf([fpath '/analysis/defects/def%06d.png'],i));
close(fig);


% --- Executes on button press in but_load.
function but_load_Callback(hObject, eventdata, handles)
% hObject    handle to but_load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h = guidata(hObject);

for f = 1:numel(h.fpaths)
    load([h.fpaths{f} 'adefs.mat'],'adefs');
    ids = unique([adefs.id]);
    for i = 1:numel(ids)
        id = ids(i);
        cdefs = adefs([adefs.id]==id);
        name = sprintf('%06d.bin',i);

        if exist([h.fpaths{f} 'analysis/defects/vx/' name])

            fID = fopen([h.fpaths{f} 'analysis/defects/vx/' name],'r');
            h.avgvx{f}{i} = fread(fID, [401 401], 'float');
            fclose(fID);
            fID = fopen([h.fpaths{f} 'analysis/defects/vy/' name],'r');
            h.avgvy{f}{i} = fread(fID, [401 401], 'float');
            fclose(fID);
            fID = fopen([h.fpaths{f} 'analysis/defects/stdvx/' name],'r');
            h.stdvx{f}{i} = fread(fID, [401 401], 'float');
            fclose(fID);
            fID = fopen([h.fpaths{f} 'analysis/defects/stdvy/' name],'r');
            h.stdvy{f}{i} = fread(fID, [401 401], 'float');
            fclose(fID);
            
            h.doneqs{f}{i} = cdefs(1).q;
            
        end
    end
end
guidata(hObject,h);


% --- Executes on button press in but_all_errs.
function but_all_errs_Callback(hObject, eventdata, handles)
% hObject    handle to but_all_errs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h = guidata(hObject);
% 
% totpvx = zeros(401);
% totpvy = zeros(401);
% 
% totnvx = zeros(401);
% totnvy = zeros(401);
% 
% countp = zeros(size(totpvx));
% countn = zeros(size(totnvx));
% 
% for f = 1:numel(h.fpaths)
%     
%     estdvx = h.stdvx{f};
%     estdvy = h.stdvy{f};
%     eavgvx = h.avgvx{f};
%     eavgvy = h.avgvy{f};
%     eq = h.doneqs{f};
%     apvx = [];
%     apvy = [];
%     for i = 1:numel(estdvx)
%         if ~isempty(estdvx{i})
%             if eq{i}>0
%                 vx = estdvx{i}.^2;
%                 vy = estdvy{i}.^2;
%                 apvx = cat(3,apvx,eavgvx{i});
%                 apvy = cat(3,apvy,eavgvy{i});
%                 
%                 vx(isnan(vx)) = 0;
%                 vy(isnan(vy)) = 0;
%                 totpvx = totpvx+vx;
%                 totpvy = totpvy+vy;
%                 countp = countp + ~isnan(vx);
% 
%             else
%                 vx = estdvx{i}.^2;
%                 vy = estdvy{i}.^2;
%                 vx(isnan(vx)) = 0;
%                 vy(isnan(vy)) = 0;
%                 totnvx = totnvx+vx;
%                 totnvy = totnvy+vy;
%                 countn = countn + ~isnan(vx);
% 
%             end
%         end
%     end
% end
% 
% plotflerr(h.ax_ap,totpvx./countp,totpvy./countp);
% plotflerr(h.ax_an,totnvx./countn,totnvy./countn);



vxpstd = sqrt(h.psvx./(h.pk-1))./sqrt(h.pk);
vypstd = sqrt(h.psvy./(h.pk-1))./sqrt(h.pk);
vxnstd = sqrt(h.nsvx./(h.nk-1))./sqrt(h.nk);
vynstd = sqrt(h.nsvy./(h.nk-1))./sqrt(h.nk);

keyboard

plotflerr(h.ax_ap,vxpstd,vypstd);
plotflerr(h.ax_an,vxnstd,vynstd);


% --- Executes on button press in but_exp_errs.
function but_exp_errs_Callback(hObject, eventdata, handles)
% hObject    handle to but_exp_errs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h = guidata(hObject);

estdvx = h.stdvx{h.popup_fpath.Value};
estdvy = h.stdvy{h.popup_fpath.Value};
eq = h.doneqs{h.popup_fpath.Value};

totpvx = zeros(size(estdvx{1}));
totpvy = zeros(size(estdvy{1}));

totnvx = zeros(size(estdvx{1}));
totnvy = zeros(size(estdvy{1}));

countp = zeros(size(totpvx));
countn = zeros(size(totnvx));
for i = 1:numel(estdvx)
    if ~isempty(estdvx{i})
        if eq{i}>0
            vx = estdvx{i}.^2;
            vy = estdvy{i}.^2;
            vx(isnan(vx)) = 0;
            vy(isnan(vy)) = 0;
            totpvx = totpvx+vx;
            totpvy = totpvy+vy;
            countp = countp + ~isnan(vx);
            
        else
            vx = estdvx{i}.^2;
            vy = estdvy{i}.^2;
            vx(isnan(vx)) = 0;
            vy(isnan(vy)) = 0;
            totnvx = totnvx+vx;
            totnvy = totnvy+vy;
            countn = countn + ~isnan(vx);
            
        end
    end
end

plotflerr(h.ax_p,totpvx./countp,totpvy./countp);
plotflerr(h.ax_n,totnvx./countn,totnvy./countn);

