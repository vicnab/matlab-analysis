function varargout = gui_analysis(varargin)
% GUI_ANALYSIS M-file for gui_analysis.fig
%      GUI_ANALYSIS, by itself, creates a new GUI_ANALYSIS or raises the existing
%      singleton*.
%
%      H = GUI_ANALYSIS returns the handle to a new GUI_ANALYSIS or the handle to
%      the existing singleton*.
%
%      GUI_ANALYSIS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_ANALYSIS.M with the given input arguments.
%
%      GUI_ANALYSIS('Property','Value',...) creates a new GUI_ANALYSIS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_analysis_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_analysis_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_analysis

% Last Modified by GUIDE v2.5 20-Nov-2010 18:02:27

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_analysis_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_analysis_OutputFcn, ...
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


% --- Executes just before gui_analysis is made visible.
function gui_analysis_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_analysis (see VARARGIN)

% Choose default command line output for gui_analysis
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui_analysis wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_analysis_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function TestNumSlider_Callback(hObject, eventdata, handles)
% hObject    handle to TestNumSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
TestNum = get(handles.TestNumSlider,'Value');
%puts the slider value into the edit text component
set(handles.TestSliderText,'String', num2str(TestNum));
% Update handles structure
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function TestNumSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TestNumSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function TestSliderText_Callback(hObject, eventdata, handles)
% hObject    handle to TestSliderText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of TestSliderText as text
%        str2double(get(hObject,'String')) returns contents of TestSliderText as a double
TestNum = round(str2num(get(handles.TestSliderText, 'String')));
%if user inputs something is not a number, or if the input is less than 0
%or greater than 100, then the slider value defaults to 0
if (isempty(TestNum) || TestNum < 1)
    set(handles.TestNumSlider,'Value',1);
    set(handles.TestSliderText,'String','1');
    TestNum = 1;
elseif(TestNum > 5)
    set(handles.TestNumSlider,'Value',5);
    set(handles.TestSliderText,'String','5');
    TestNum = 5;

    
else
    set(handles.TestSliderText,'String',TestNum); %this is in case someone inserts a noninteger
    set(handles.TestNumSlider,'Value',TestNum);
end

% --- Executes during object creation, after setting all properties.
function TestSliderText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TestSliderText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


