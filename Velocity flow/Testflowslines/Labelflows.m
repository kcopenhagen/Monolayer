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

% Last Modified by GUIDE v2.5 04-Apr-2019 12:01:01

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
function Labelflows_OpeningFcn(hObject, ~, handles, varargin)
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
handles.ids = [];

handles.p0 = drawpolyline(handles.imax,'Position',[0 0],'Visible','off',...
    'LineWidth',1,'Color','r');
handles.p1 = drawpolyline(handles.imax,'Position',[0 0],'Visible','off',...
    'LineWidth',1,'Color','r');
handles.p2 = drawpolyline(handles.imax,'Position',[0 0],'Visible','off',...
    'LineWidth',1,'Color','r');

handles.waittxt.Visible = 'Off';
handles.savetxt.Visible = 'Off';
set(hObject,'KeyPressFcn',@KeyPressed);
set(hObject,'KeyReleaseFcn',@KeyReleased);
handles.ct = 0;
handles.cellsvis = 0;
handles.clrerr = 1;
handles.drawready = 0;
handles.ptdr = 6;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Labelflows wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Labelflows_OutputFcn(~, ~, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function KeyPressed(hObject, eventdata)
%Functionality for when various keys are pressed.
handles = guidata(hObject);
if handles.drawready == 1
    draw = 1;
else
    draw = 0;
end
handles.drawready = 0;
%Select frame by number.
if eventdata.Key == '1'
    plotim(handles,0)
    handles.ct = 0;
    guidata(hObject,handles);
    try
        updatecells(hObject,eventdata,handles);
    end
    handles.n0.FontWeight = 'bold';
    handles.n1.FontWeight = 'normal';
    handles.n2.FontWeight = 'normal';
elseif eventdata.Key == '2'
    plotim(handles,1)
    handles.ct = 1;
    guidata(hObject,handles);
    try
        updatecells(hObject,eventdata,handles);
    end
    handles.n0.FontWeight = 'normal';
    handles.n1.FontWeight = 'bold';
    handles.n2.FontWeight = 'normal';
elseif eventdata.Key == '3'
    plotim(handles,2)
    handles.ct = 2;
    guidata(hObject,handles);
    try
        updatecells(hObject,eventdata,handles);
    end
    handles.n0.FontWeight = 'normal';
    handles.n1.FontWeight = 'normal';
    handles.n2.FontWeight = 'bold';

end

%Go to next frame.
if eventdata.Key == 'x'
    if handles.ct == 2
        plotim(handles,0)
        handles.ct = 0;
        guidata(hObject,handles);
        try
            updatecells(hObject,eventdata,handles);
        end
        handles.n0.FontWeight = 'bold';
        handles.n1.FontWeight = 'normal';
        handles.n2.FontWeight = 'normal';
    elseif handles.ct == 0
        plotim(handles,1)
        handles.ct = 1;
        guidata(hObject,handles);
        try
            updatecells(hObject,eventdata,handles);
        end
        handles.n0.FontWeight = 'normal';
        handles.n1.FontWeight = 'bold';
        handles.n2.FontWeight = 'normal';
    elseif handles.ct == 1
        plotim(handles,2)
        handles.ct = 2;
        guidata(hObject,handles);
        try
            updatecells(hObject,eventdata,handles);
        end
        handles.n0.FontWeight = 'normal';
        handles.n1.FontWeight = 'normal';
        handles.n2.FontWeight = 'bold';
    end
end

%Add a spline point to current frame.
if eventdata.Key == 'c'

    if handles.ct == 0
        handles.p1.Visible = 'off';
        handles.p2.Visible = 'off';
        C = get(handles.imax,'CurrentPoint');
        if handles.p0.Position(1,1) == 0
            handles.p0.Position = [C(1,1) C(1,2)];
        else
            dx = C(1,1) - handles.p0.Position(end,1);
            dy = C(1,2) - handles.p0.Position(end,2);
            dr = sqrt(dx^2+dy^2);
            np = round(dr/6);
            pts = (1:np)'/np;
            if numel(pts>1)
                handles.p0.Position = [handles.p0.Position;...
                    pts*dx+handles.p0.Position(end,1)...
                    pts*dy+handles.p0.Position(end,2)];
            else
                handles.errortxt.String = "Points too close together";
                handles.clrerr = 0;
            end
        end
        handles.p0.Visible = 'on';
        for i = 1:numel(handles.p0.NodeChildren)-4
            handles.p0.NodeChildren(i).Size = 3;
        end
        handles.n0.String = num2str(numel(handles.p0.Position(:,1)));
        handles.n0.FontWeight = 'bold';
        handles.n1.FontWeight = 'normal';
        handles.n2.FontWeight = 'normal';
    elseif handles.ct == 1
        handles.p0.Visible = 'off';
        handles.p2.Visible = 'off';
        C = get(handles.imax,'CurrentPoint');
        if handles.p1.Position(1,1) == 0
            handles.p1.Position = [C(1,1) C(1,2)];
        else
            dx = C(1,1) - handles.p1.Position(end,1);
            dy = C(1,2) - handles.p1.Position(end,2);
            dr = sqrt(dx^2+dy^2);
            np = round(dr/6);
            pts = (1:np)'/np;
            if numel(pts>1)
                handles.p1.Position = [handles.p1.Position;...
                    pts*dx+handles.p1.Position(end,1)...
                    pts*dy+handles.p1.Position(end,2)];
            else
                handles.errortxt.String = "Points too close together";
                handles.clrerr = 0;
            end
        end        
        handles.p1.Visible = 'on';
        for i = 1:numel(handles.p1.NodeChildren)-4
            handles.p1.NodeChildren(i).Size = 3;
        end
        handles.n1.String = num2str(numel(handles.p1.Position(:,1)));
        handles.n0.FontWeight = 'normal';
        handles.n1.FontWeight = 'bold';
        handles.n2.FontWeight = 'normal';
    elseif handles.ct == 2
        handles.p0.Visible = 'off';
        handles.p1.Visible = 'off';
        C = get(handles.imax,'CurrentPoint');
        if handles.p2.Position(1,1) == 0
            handles.p2.Position = [C(1,1) C(1,2)];
        else
            dx = C(1,1) - handles.p2.Position(end,1);
            dy = C(1,2) - handles.p2.Position(end,2);
            dr = sqrt(dx^2+dy^2);
            np = round(dr/6);
            pts = (1:np)'/np;
            if numel(pts>1)
                handles.p2.Position = [handles.p2.Position;...
                    pts*dx+handles.p2.Position(end,1)...
                    pts*dy+handles.p2.Position(end,2)];
            else
                handles.errortxt.String = "Points too close together";
                handles.clrerr = 0;
            end
        end
        handles.p2.Visible = 'on';
        for i = 1:numel(handles.p2.NodeChildren)-4
            handles.p2.NodeChildren(i).Size = 3;
        end
        handles.n2.String = num2str(numel(handles.p2.Position(:,1)));
        handles.n0.FontWeight = 'normal';
        handles.n1.FontWeight = 'normal';
        handles.n2.FontWeight = 'bold';
    end
end

%Mark start of current cell for drawing.
if eventdata.Key == 's'
    if handles.ct == 0
        handles.p1.Visible = 'off';
        handles.p2.Visible = 'off';
        C = get(handles.imax,'CurrentPoint');
        if handles.p0.Position(1,1) == 0
            handles.p0.Position = [C(1,1) C(1,2)];
        else
            handles.errortxt.String = 'Clear current cells first';
            handles.clrerr = 0;
        end
        
        handles.p0.Visible = 'on';
        for i = 1:numel(handles.p0.NodeChildren)-4
            handles.p0.NodeChildren(i).Size = 3;
        end
        handles.n0.String = num2str(numel(handles.p0.Position(:,1)));
        handles.n0.FontWeight = 'bold';
        handles.n1.FontWeight = 'normal';
        handles.n2.FontWeight = 'normal';
    elseif handles.ct == 1
        if numel(handles.p0.Position)<3
            handles.errortxt.String = 'Mark cell in frame 1 first';
            handles.clrerr = 0;
        else
            handles.p0.Visible = 'off';
            handles.p2.Visible = 'off';
            C = get(handles.imax,'CurrentPoint');
            if handles.p1.Position(1,1) == 0
                handles.p1.Position = [C(1,1) C(1,2)];
            else
                handles.errortxt.String = 'Clear current cells first';
                handles.clrerr = 0;            
            end
            handles.p1.Visible = 'on';
            for i = 1:numel(handles.p1.NodeChildren)-4
                handles.p1.NodeChildren(i).Size = 3;
            end
            handles.n1.String = num2str(numel(handles.p1.Position(:,1)));
            handles.n0.FontWeight = 'normal';
            handles.n1.FontWeight = 'bold';
            handles.n2.FontWeight = 'normal';
        end
    elseif handles.ct == 2
        if numel(handles.p0.Position)<3
            handles.errortxt.String = 'Mark cell in frame 1 first';
            handles.clrerr = 0;
        else
            handles.p0.Visible = 'off';
            handles.p1.Visible = 'off';
            C = get(handles.imax,'CurrentPoint');
            if handles.p2.Position(1,1) == 0
                handles.p2.Position = [C(1,1) C(1,2)];
            else
                handles.errortxt.String = 'Clear current cells first';
                handles.clrerr = 0;
            end
            handles.p2.Visible = 'on';
            for i = 1:numel(handles.p2.NodeChildren)-4
                handles.p2.NodeChildren(i).Size = 3;
            end
            handles.n2.String = num2str(numel(handles.p2.Position(:,1)));
            handles.n0.FontWeight = 'normal';
            handles.n1.FontWeight = 'normal';
            handles.n2.FontWeight = 'bold';
        end
    end
    guidata(hObject,handles);
end

%Mark current cell end point for calculating point separation for drawing
%cells.
if eventdata.Key == 'f'
    
    if handles.ct == 0
        if numel(handles.p0.Position)==2 && handles.p0.Position(1) ~=0
            C = get(handles.imax,'CurrentPoint');
            l = sqrt((C(1,1)-handles.p0.Position(1))^2 ...
                +(C(1,2)-handles.p0.Position(2))^2);
            l = l*1.0147;
            handles.ptdr = l/round(l/6);
            handles.errortxt.String = ['Approximate number of points: '...
                num2str(round(l/6)+1)];
            handles.clrerr = 0;
        else
            handles.errortxt.String = "Use 's' to set cell start point.";
            handles.clrerr = 0;
        end
    elseif handles.ct == 1
        if numel(handles.p1.Position)==2 && handles.p1.Position(1) ~=0
            if numel(handles.p0.Position)<3
                handles.errortxt.String = 'Mark cell in frame 1 first';
                handles.clrerr = 0;
            else
                C = get(handles.imax,'CurrentPoint');
                l = sqrt((C(1,1)-handles.p1.Position(1))^2 ...
                    +(C(1,2)-handles.p1.Position(2))^2);
                l = l*1.0147;
                handles.ptdr = l/(numel(handles.p0.Position(:,1))-1);
                handles.errortxt.String = ['Approximate point separation: '...
                    num2str(handles.ptdr) 'pixels'];
                handles.clrerr = 0;
            end
        else
            handles.errortxt.String = "Use 's' to set cell start point.";
            handles.clrerr = 0;
        end
    elseif handles.ct == 2
        if numel(handles.p2.Position)==2 && handles.p2.Position(1) ~=0
            if numel(handles.p0.Position)<3
                handles.errortxt.String = 'Mark cell in frame 1 first';
                handles.clrerr = 0;
            else
                C = get(handles.imax,'CurrentPoint');
                l = sqrt((C(1,1)-handles.p2.Position(1))^2 ...
                    +(C(1,2)-handles.p2.Position(2))^2);
                l = l*1.0147;
                handles.ptdr = l/(numel(handles.p0.Position(:,1))-1);
                handles.errortxt.String = ['Approximate point separation: '...
                    num2str(handles.ptdr) 'pixels'];
                handles.clrerr = 0;
            end
        else
            handles.errortxt.String = "Use 's' to set cell start point.";
            handles.clrerr = 0;
        end
    end
    
    handles.drawready = 1;
end

if eventdata.Key == 'd'
    if draw == 0
        handles.errortxt.String = "Use 's' and 'f' to set start and finish of cell";
        handles.clrerr = 0;
    else
        handles.DrawCell.Value = 1;
    end
end
    
% Save current cell to ongoing list.
if eventdata.Key == "space"
    
    if all([numel(handles.p0.Position)==numel(handles.p1.Position),...
            numel(handles.p0.Position)==numel(handles.p2.Position),...
            handles.p0.Position(1,1)~=0])
        %Check cell orientations.
        dp0p1 = handles.p0.Position - handles.p1.Position;
        dxp0p1 = sqrt(dp0p1(:,1).^2 + dp0p1(:,2).^2);
        
        drp0p1 = handles.p0.Position - flipud(handles.p1.Position);
        dxrp0p1 = sqrt(drp0p1(:,1).^2 + drp0p1(:,2).^2);

        if max(dxp0p1)>max(dxrp0p1)
            handles.p1.Position = flipud(handles.p1.Position);
        end
        
        dp1p2 = handles.p1.Position - handles.p2.Position;
        dxp1p2 = sqrt(dp1p2(:,1).^2 + dp1p2(:,2).^2);
        
        drp1p2 = handles.p1.Position - flipud(handles.p2.Position);
        dxrp1p2 = sqrt(drp1p2(:,1).^2 + drp1p2(:,2).^2);

        if max(dxp1p2)>max(dxrp1p2)
            handles.p2.Position = flipud(handles.p2.Position);
        end
        
        
        %Save cell positions into ongoing array.
        handles.p0s = [handles.p0s; [handles.p0.Position]];
        handles.p1s = [handles.p1s; [handles.p1.Position]];
        handles.p2s = [handles.p2s; [handles.p2.Position]];
        if isempty(handles.ids)
            cid = 1;
        else
            cid = max(handles.ids)+1;
        end
        handles.ids = [handles.ids;...
                cid*ones(size(handles.p0.Position(:,1)))];
        
        handles.ids(handles.p0s(:,1)==0) = [];
        handles.p0s(handles.p0s(:,1)==0) = [];
        handles.p1s(handles.p1s(:,1)==0) = [];
        handles.p2s(handles.p2s(:,1)==0) = [];
        
        
        %Hide the cell to be revealed again when more point are added.
        handles.p0.Visible = 'off';
        handles.p1.Visible = 'off';
        handles.p2.Visible = 'off';
        handles.p0.Position = [0 0];
        handles.p1.Position = [0 0];
        handles.p2.Position = [0 0];
        
        handles.cellsvis = 1;
        guidata(hObject,handles);
        plotcells(hObject,eventdata,handles);
        handles = guidata(hObject);
        handles.n0.String = 0;
        handles.n1.String = 0;
        handles.n2.String = 0;
    else
        handles.errortxt.String = "Inequal number of points per frame.";
        handles.clrerr = 0;
    end

end

if eventdata.Key == "backspace"
    if handles.ct == 0
        handles.p0.Position(end,:) = [];
        for i = 1:numel(handles.p0.NodeChildren)-4
            handles.p0.NodeChildren(i).Size = 3;
        end
        handles.n0.String = num2str(str2num(handles.n0.String)-1);

    elseif handles.ct == 1
        handles.p1.Position(end,:) = [];
        for i = 1:numel(handles.p1.NodeChildren)-4
            handles.p1.NodeChildren(i).Size = 3;
        end
        handles.n1.String = num2str(str2num(handles.n1.String)-1);

    elseif handles.ct == 2
        handles.p2.Position(end,:) = [];
        for i = 1:numel(handles.p2.NodeChildren)-4
            handles.p2.NodeChildren(i).Size = 3;
        end
        handles.n2.String = num2str(str2num(handles.n2.String)-1);
    end
end

if eventdata.Key == 'm'
    handles.movescreenbut.Value = 1;
    handles.CP = get(handles.imax,'CurrentPoint');
end

if eventdata.Key == 'y'
    if handles.ct == 0
        pts = handles.p0s;
    elseif handles.ct == 1
        pts = handles.p1s;
    elseif handles.ct == 2
        pts = handles.p2s;
    end
    C = get(handles.imax,'CurrentPoint');
    drs = sqrt((pts(:,1)-C(1,1)).^2+(pts(:,2)-C(1,2)).^2);
    delid = handles.ids(drs == min(drs));
    dels = handles.ids == delid;
    handles.p0s(dels,:) = [];
    handles.p1s(dels,:) = [];
    handles.p2s(dels,:) = [];
    handles.ids(dels) = [];
    handles.ids(handles.ids>delid) = handles.ids(handles.ids>delid)-1;
    guidata(hObject,handles);
    plotcells(hObject,eventdata,handles);
end

uistack(handles.cellsax,'top');
if handles.clrerr == 1
    handles.errortxt.String = " ";
end
handles.clrerr = 1;


guidata(hObject,handles);

function KeyReleased(hObject, eventdata)
handles = guidata(hObject);

if eventdata.Key == 'm'
    handles.movescreenbut.Value = 0;
end
if eventdata.Key == 'd'
    handles.DrawCell.Value = 0;
end
guidata(hObject,handles);

function MouseMove(hObject, eventdata)
handles = guidata(hObject);
% Defined so that the mouse position is constantly updated (otherwise it 
%  will only save the last clicked location.
if handles.movescreenbut.Value == 1
    C = get(handles.imax,'CurrentPoint');
    dx = C(1,1)-handles.CP(1,1);
    dy = C(1,2)-handles.CP(1,2);
    movesimage(hObject,eventdata,handles,-dx,-dy);
    handles.CP = get(handles.imax,'CurrentPoint');

end

if handles.DrawCell.Value == 1
    if handles.ct == 0
        C = get(handles.imax,'CurrentPoint');
        dx = C(1,1)-handles.p0.Position(end,1);
        dy = C(1,2)-handles.p0.Position(end,2);
        dr = sqrt(dx^2+dy^2);
        if dr > handles.ptdr
            handles.p0.Position = [handles.p0.Position; C(1,1) C(1,2)];
        end
        handles.n0.String = num2str(numel(handles.p0.Position(:,1)));
        for i = 1:numel(handles.p0.NodeChildren)-4
            handles.p0.NodeChildren(i).Size = 3;
        end
    elseif handles.ct == 1
        C = get(handles.imax,'CurrentPoint');
        dx = C(1,1)-handles.p1.Position(end,1);
        dy = C(1,2)-handles.p1.Position(end,2);
        dr = sqrt(dx^2+dy^2);
        if dr > handles.ptdr
            handles.p1.Position = [handles.p1.Position; C(1,1) C(1,2)];
        end
        handles.n1.String = num2str(numel(handles.p1.Position(:,1)));
        for i = 1:numel(handles.p1.NodeChildren)-4
            handles.p1.NodeChildren(i).Size = 3;
        end
    elseif handles.ct == 2
        C = get(handles.imax,'CurrentPoint');
        dx = C(1,1)-handles.p2.Position(end,1);
        dy = C(1,2)-handles.p2.Position(end,2);
        dr = sqrt(dx^2+dy^2);
        if dr > handles.ptdr
            handles.p2.Position = [handles.p2.Position; C(1,1) C(1,2)];
        end
        handles.n2.String = num2str(numel(handles.p2.Position(:,1)));
        for i = 1:numel(handles.p2.NodeChildren)-4
            handles.p2.NodeChildren(i).Size = 3;
        end
    end
end
guidata(hObject,handles);

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
ids = handles.ids;

name = strsplit(handles.fpath,'/');
fold = handles.folderpath.String;
name = name{end-1};
t = handles.t;
[~,~,~] = mkdir([fold '/Labeledflows/']);
save([fold '/Labeledflows/flows' name 't' num2str(t)],'p0s','p1s','p2s','ids');
handles.savetxt.Visible = 'off';
handles.errortxt.String = ['Data saved to ' fold '/Labeledflows/flows' name 't' num2str(t)]; 

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

pts = ones(size(x0s));
xlims = handles.imax.XLim;
ylims = handles.imax.YLim;

pts(x0s<xlims(1)) = 0;
pts(x0s>xlims(2)) = 0;
pts(x1s<xlims(1)) = 0;
pts(x1s>xlims(2)) = 0;
pts(x2s<xlims(1)) = 0;
pts(x2s>xlims(2)) = 0;
pts(y0s<ylims(1)) = 0;
pts(y0s>ylims(2)) = 0;
pts(y1s<ylims(1)) = 0;
pts(y1s>ylims(2)) = 0;
pts(y2s<ylims(1)) = 0;
pts(y2s>ylims(2)) = 0;
x0s = x0s(pts==1);
x1s = x1s(pts==1);
x2s = x2s(pts==1);
y0s = y0s(pts==1);
y1s = y1s(pts==1);
y2s = y2s(pts==1);

x0s = normalize_units(hObject,handles,x0s,'x');
x1s = normalize_units(hObject,handles,x1s,'x');
x2s = normalize_units(hObject,handles,x2s,'x');
y0s = normalize_units(hObject,handles,y0s,'y');
y1s = normalize_units(hObject,handles,y1s,'y');
y2s = normalize_units(hObject,handles,y2s,'y');

for i = 1:numel(x0s)
    annotation('line',[x0s(i) x1s(i)],[y0s(i) y1s(i)],'Color','r',...
        'LineWidth',1);
    annotation('arrow',[x1s(i) x2s(i)],[y1s(i) y2s(i)],...
        'headStyle','cback1','HeadLength',6,'HeadWidth',6,'Color','r',...
        'LineWidth',1);
end

% --- Executes on button press in Oshow.
function Oshow_Callback(hObject, eventdata, handles)
% hObject    handle to Oshow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isempty(handles.testflow)
    handles.waittxt.Visible = 'on';
    drawnow
    handles.testflow = calctestflow(handles.fpath,handles.t,...
        str2double(handles.nf.String),str2double(handles.gf.String),...
        str2double(handles.imf.String));
    handles.waittxt.Visible = 'off';
end
guidata(hObject,handles);

flow = handles.testflow;

x1s = handles.p1s(:,1);
y1s = handles.p1s(:,2);
sz = size(flow.Vx);
inds = sub2ind(sz,round(y1s),round(x1s));
s = str2double(handles.scale.String);

R = str2double(handles.OflowR.String);
G = str2double(handles.OflowG.String);
B = str2double(handles.OflowB.String);

col = [R,G,B];
x0s = x1s - s*flow.Vx(inds);
y0s = y1s - s*flow.Vy(inds);
x2s = x1s + s*flow.Vx(inds);
y2s = y1s + s*flow.Vy(inds);

pts = ones(size(x0s));
xlims = handles.imax.XLim;
ylims = handles.imax.YLim;

pts(x0s<xlims(1)) = 0;
pts(x0s>xlims(2)) = 0;
pts(x1s<xlims(1)) = 0;
pts(x1s>xlims(2)) = 0;
pts(x2s<xlims(1)) = 0;
pts(x2s>xlims(2)) = 0;
pts(y0s<ylims(1)) = 0;
pts(y0s>ylims(2)) = 0;
pts(y1s<ylims(1)) = 0;
pts(y1s>ylims(2)) = 0;
pts(y2s<ylims(1)) = 0;
pts(y2s>ylims(2)) = 0;
x0s = x0s(pts==1);
x1s = x1s(pts==1);
x2s = x2s(pts==1);
y0s = y0s(pts==1);
y1s = y1s(pts==1);
y2s = y2s(pts==1);


x0s = normalize_units(hObject,handles,x0s,'x');
x1s = normalize_units(hObject,handles,x1s,'x');
x2s = normalize_units(hObject,handles,x2s,'x');
y0s = normalize_units(hObject,handles,y0s,'y');
y1s = normalize_units(hObject,handles,y1s,'y');
y2s = normalize_units(hObject,handles,y2s,'y');

for i = 1:numel(x0s)
    %annotation('line',[x0s(i) x1s(i)],[y0s(i) y1s(i)],'Color',col);
    annotation('arrow',[x0s(i) x2s(i)],[y0s(i) y2s(i)],...
        'headStyle','cback1','HeadLength',6,'HeadWidth',6,'Color',col,...
        'LineWidth',1);
end

guidata(hObject,handles);

% --- Executes on button press in Ocalc.
function Ocalc_Callback(hObject, eventdata, handles)
% hObject    handle to Ocalc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.waittxt.Visible = 'On';
drawnow
handles.testflow = calctestflow(handles.fpath,handles.t,...
    str2double(handles.nf.String),str2double(handles.gf.String),...
    str2double(handles.imf.String));
handles.waittxt.Visible = 'off';

guidata(hObject,handles);

% --- Executes on button press in clearflow.
function clearflow_Callback(hObject, eventdata, handles)
% hObject    handle to clearflow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
delete(findall(gcf,'type','annotation'));

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

handles.cellsax.XLim = [X-49 X+50];
handles.cellsax.YLim = [Y-49 Y+50];
handles.cellsax.XLimMode = 'manual';
handles.cellsax.YLimMode = 'manual';
handles.cellsax.Visible = 'off';
handles.cellsax.YDir = 'reverse';
hold(handles.cellsax,'on');

folders = dir([handles.folderpath.String '/Data/']);
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

% l0 = imsharpen(l0./imgaussfilt(l0,64),'Amount',3,'Radius',3);
% l1 = imsharpen(l1./imgaussfilt(l1,64),'Amount',3,'Radius',3);
% l2 = imsharpen(l2./imgaussfilt(l2,64),'Amount',3,'Radius',3);

l0 = l0./imgaussfilt(l0,64);
l1 = l1./imgaussfilt(l1,64);
l2 = l2./imgaussfilt(l2,64);


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
handles.ids = [];
handles.ct = 0;
guidata(hObject,handles);

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
if ispc && isequal(get(hObject,'BackgroundColor'),...
        get(0,'defaultUicontrolBackgroundColor'))
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
if ispc && isequal(get(hObject,'BackgroundColor'),...
        get(0,'defaultUicontrolBackgroundColor'))
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
if ispc && isequal(get(hObject,'BackgroundColor'),...
        get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

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
if ispc && isequal(get(hObject,'BackgroundColor'),...
        get(0,'defaultUicontrolBackgroundColor'))
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
handles.n0.String = '0';
handles.n1.String = '0';
handles.n2.String = '0';


function folderpath_Callback(hObject, eventdata, handles)
% hObject    handle to folderpath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of folderpath as text
%        str2double(get(hObject,'String')) returns contents of folderpath as a double


% --- Executes during object creation, after setting all properties.
function folderpath_CreateFcn(hObject, eventdata, handles)
% hObject    handle to folderpath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'),...
        get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in selectfolder.
function selectfolder_Callback(hObject, eventdata, handles)
% hObject    handle to selectfolder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder = uigetdir(handles.folderpath.String);
handles.folderpath.String = [folder '/'];

% --- Executes on button press in showcellsbut.
function showcellsbut_Callback(hObject, eventdata, handles)
% hObject    handle to showcellsbut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.cellsvis = 1;
guidata(hObject,handles);
plotcells(hObject,eventdata,handles);

% --- Executes on button press in hidecellsbut.
function hidecellsbut_Callback(hObject, eventdata, handles)
% hObject    handle to hidecellsbut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.cellsvis = 0;
guidata(hObject,handles);
cla(handles.cellsax);

function plotcells(hObject, eventdata, handles)
cla(handles.cellsax);
t = handles.ct;
x = [handles.p0s(:,1); handles.p1s(:,1); handles.p2s(:,1)];
y = [handles.p0s(:,2); handles.p1s(:,2); handles.p2s(:,2)];
z = zeros(size(x));
ids = [handles.ids; handles.ids; handles.ids];

%Use ids to find the ends of cells where it changes numbers.
%Set alphas to one everywhere except the ends of cells.
idst = [ids(2:end); ids(1)];
dids = idst-ids;

alphas = ones(size(ids));
alphas(dids~=0) = 0;
alphas(1) = 0;

N = numel(unique(ids));
cellcols = rand(N,3);
colt = cellcols(ids,:);

col = [colt(:,1)'; colt(:,1)'];
col = cat(3,col,[colt(:,2)'; colt(:,2)']);
col = cat(3,col,[colt(:,3)'; colt(:,3)']);

%Set alphas of cells at not the current time to zero.
Np = numel(ids)/3;
idx = find(ids);
alphas((floor((idx-1)/Np)-t)~=0)=0;

handles.s = surface([x';x'],[y';y'],[z';z'],col,...
        'alphadata',[alphas';alphas'],...
        'facecol','no',...
        'edgecol','flat',...
        'edgealpha','flat',...
        'linew',2,...
        'Parent',handles.cellsax);
guidata(hObject,handles);

function updatecells(hObject,eventdata,handles)

t = handles.ct;

%Use ids to find the ends of cells where it changes numbers.
%Set alphas to one everywhere except the ends of cells.
ids = [handles.ids; handles.ids; handles.ids];
idst = [ids(2:end); ids(1)];
dids = idst-ids;

alphas = ones(size(ids));
alphas(dids~=0) = 0;

%Set alphas of cells at not the current time to zero.
Np = numel(ids)/3;
idx = find(ids);
alphas((floor((idx-1)/Np)-t)~=0)=0;
if handles.cellsvis == 0
    alphas = zeros(size(ids));
end
handles.s.AlphaData = [alphas';alphas'];

function xn = normalize_units(hObject,handles,x,axisdir)
    figpos = get(gcf,'Position');
    axpost = handles.cellsax.Position;
    if axisdir == 'x'
        lims = handles.cellsax.XLim;
        w = figpos(3);
        axpos = axpost(1);
        wax = axpost(3);
        fax = (x - lims(1))/(lims(2)-lims(1));

    elseif axisdir == 'y'
        lims = handles.cellsax.YLim;
        w = figpos(4);
        axpos = axpost(2);
        wax = axpost(4);
        fax = 1-(x - lims(1))/(lims(2)-lims(1));
    end

    xn = wax/w*fax + axpos/w;

function movesimage(hObject,eventdata,handles,dx,dy)

xlims = get(handles.imax,'XLim');
ylims = get(handles.imax,'YLim');

sz = size(handles.l0);

if xlims(1)+dx>70 && xlims(2)+dx<sz(2)-70
    xlims = xlims+dx;
end
if ylims(1)+dy>70 && ylims(2)+dy<sz(1)-70
    ylims = ylims+dy;
end

handles.imax.XLim = xlims;
handles.imax.YLim = ylims;
handles.imax.XLimMode = 'manual';
handles.imax.YLimMode = 'manual';
hold(handles.imax,'on');

handles.cellsax.XLim = xlims;
handles.cellsax.YLim = ylims;
handles.cellsax.XLimMode = 'manual';
handles.cellsax.YLimMode = 'manual';
handles.cellsax.Visible = 'off';
handles.cellsax.YDir = 'reverse';
hold(handles.cellsax,'on');
guidata(hObject,handles);


% --- Executes on button press in movescreenbut.
function movescreenbut_Callback(hObject, eventdata, handles)
% hObject    handle to movescreenbut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of movescreenbut


% --- Executes on button press in DrawCell.
function DrawCell_Callback(hObject, eventdata, handles)
% hObject    handle to DrawCell (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of DrawCell



function OflowR_Callback(hObject, eventdata, handles)
% hObject    handle to OflowR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of OflowR as text
%        str2double(get(hObject,'String')) returns contents of OflowR as a double


% --- Executes during object creation, after setting all properties.
function OflowR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to OflowR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function OflowG_Callback(hObject, eventdata, handles)
% hObject    handle to OflowG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of OflowG as text
%        str2double(get(hObject,'String')) returns contents of OflowG as a double


% --- Executes during object creation, after setting all properties.
function OflowG_CreateFcn(hObject, eventdata, handles)
% hObject    handle to OflowG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function OflowB_Callback(hObject, eventdata, handles)
% hObject    handle to OflowB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of OflowB as text
%        str2double(get(hObject,'String')) returns contents of OflowB as a double


% --- Executes during object creation, after setting all properties.
function OflowB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to OflowB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
