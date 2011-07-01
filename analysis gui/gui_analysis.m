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

% Last Modified by GUIDE v2.5 28-Jan-2011 14:42:18

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

global TestNum;

set(handles.Single, 'Enable', 'Off');
set(handles.Multiple, 'Enable', 'Off');
set(handles.Dose, 'Enable', 'Off');
axes(handles.axes3);
TitleScreen = imread('titlepage.png');
imshow(TitleScreen);
curdir = pwd;
cd ..;
homepath = pwd;
cd(curdir);
if(ispc)
    circlepath = [homepath '\circle detect'];
    AnalysisPath = [homepath '\Analysis_Methods\Line_Profile\'];
    GuiPath = [homepath '\analysis gui'];
    LogPath = [homepath '\logistic'];
end
if(ismac)
    circlepath = [homepath '/circle detect'];
    AnalysisPath = [homepath '/Analysis_Methods/Line_Profile'];
    GuiPath = [homepath '/analysis gui'];
    LogPath = [homepath '/logistic'];
end

if(isempty(regexp(path,circlepath)))
    path(path, circlepath);
end
if(isempty(regexp(path,AnalysisPath)))
    path(path, AnalysisPath)
end
if(isempty(regexp(path,GuiPath)))
    path(path, GuiPath)
end
if(isempty(regexp(path,LogPath)))
    path(path, LogPath)
end
set(handles.chip_group,'SelectionChangeFcn',@chip_group_SelectionChangeFcn);
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

function chip_group_SelectionChangeFcn(hObject, eventdata)
 global small
 global large
%retrieve GUI data, i.e. the handles structure
handles = guidata(hObject); 
 
switch get(eventdata.NewValue,'Tag')   % Get Tag of selected object
    case 'small'
      small = 1;
      large = 0;
 
    case 'large'
        large = 1;
        small = 0;
    otherwise
       % Code for when there is no match.
end
%updates the handles structure
guidata(hObject, handles);

% --- Executes on slider movement.
function TestNumSlider_Callback(hObject, eventdata, handles)
% hObject    handle to TestNumSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global TestNum;
TestNum = get(handles.TestNumSlider,'Value');
%puts the slider value into the edit text component
set(handles.TestSliderText,'String', num2str(TestNum));
set(handles.Single, 'Enable', 'On');
% Update handles structure
if(get(handles.epi, 'Value') == 1 || get(handles.color, 'Value') == 1)
    set(handles.Setup, 'String', '');
    set(handles.Single, 'Enable', 'On');
    set(handles.Multiple,'Enable', 'On');
    set(handles.Dose,'Enable', 'On');
else
    set(handles.Setup, 'String', 'Please set imaging modality');
    set(handles.Single, 'Enable', 'Off');
    set(handles.Multiple,'Enable', 'Off');
    set(handles.Dose,'Enable', 'Off');
end
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
global TestNum;
TestNum = round(str2num(get(handles.TestSliderText, 'String')));
%if user inputs something is not a number, or if the input is less than 0
%or greater than 100, then the slider value defaults to 0
if (isempty(TestNum) || TestNum < 1)
    set(handles.TestNumSlider,'Value',1);
    set(handles.TestSliderText,'String','1');
    TestNum = 1;
    if(get(handles.epi, 'Value') == 1 || get(handles.color, 'Value') == 1)
        set(handles.Single, 'Enable', 'On');
        set(handles.Multiple,'Enable', 'On');
        set(handles.Dose,'Enable', 'On');
        set(handles.Setup, 'String', '');
    else
        set(handles.Single, 'Enable', 'Off');
        set(handles.Multiple,'Enable', 'Off');
        set(handles.Dose,'Enable', 'Off');
        set(handles.Setup, 'String', 'Please set imaging modality');
    end

elseif(TestNum > 5)
    set(handles.TestNumSlider,'Value',5);
    set(handles.TestSliderText,'String','5');
    TestNum = 5;
    if(get(handles.epi, 'Value') == 1 || get(handles.color, 'Value') == 1)
        set(handles.Single, 'Enable', 'On');
        set(handles.Multiple,'Enable', 'On');
        set(handles.Dose,'Enable', 'On');
        set(handles.Setup, 'String', '');
    else
        set(handles.Single, 'Enable', 'Off');
        set(handles.Multiple,'Enable', 'Off');
        set(handles.Dose,'Enable', 'Off');
        set(handles.Setup, 'String', 'Please set imaging modality');
    end


else
    set(handles.TestSliderText,'String',TestNum); %this is in case someone inserts a noninteger
    set(handles.TestNumSlider,'Value',TestNum);
    if(get(handles.epi, 'Value') == 1 || get(handles.color, 'Value') == 1)
        set(handles.Single, 'Enable', 'On');
        set(handles.Multiple,'Enable', 'On');
        set(handles.Dose,'Enable', 'On');
        set(handles.Setup, 'String', '');
    else
        set(handles.Single, 'Enable', 'Off');
        set(handles.Multiple,'Enable', 'Off');
        set(handles.Dose,'Enable', 'Off');
        set(handles.Setup, 'String', 'Please set imaging modality');
    end
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




% --- Executes on button press in epi.
function epi_Callback(hObject, eventdata, handles)
% hObject    handle to epi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
curval = str2num(get(handles.TestSliderText, 'String'));
if(get(handles.epi, 'Value') == 1)
    set(handles.color, 'Value', 0)
    
    if(curval<=5 &curval >= 1)
        set(handles.Single, 'Enable', 'On');
        set(handles.Multiple,'Enable', 'On');
        set(handles.Dose,'Enable', 'On');
        set(handles.Setup, 'String', '');
    else
        set(handles.Single, 'Enable', 'Off');
        set(handles.Multiple,'Enable', 'Off');
        set(handles.Dose,'Enable', 'Off');
        set(handles.Setup, 'String', 'Please set number of tests');
    end
else
    set(handles.Single, 'Enable', 'Off');
    set(handles.Multiple,'Enable', 'Off');
    set(handles.Dose,'Enable', 'Off');
    if(curval<=5 &curval >= 1)
        set(handles.Setup, 'String', 'Please set imaging modality');
    else
        set(handles.Setup, 'String', 'Please set imaging modality and number of test conditions');
    end


end

% Hint: get(hObject,'Value') returns toggle state of epi


% --- Executes on button press in color.
function color_Callback(hObject, eventdata, handles)
    curval = str2num(get(handles.TestSliderText, 'String'));
if(get(handles.color, 'Value') == 1)
    set(handles.epi, 'Value', 0)

    if(curval<=5 &curval >= 1)
        set(handles.Single, 'Enable', 'On');
        set(handles.Multiple,'Enable', 'On');
        set(handles.Dose,'Enable', 'On');
        set(handles.Setup, 'String', '');
    else
        set(handles.Single, 'Enable', 'Off');
        set(handles.Multiple,'Enable', 'Off');
        set(handles.Dose,'Enable', 'Off');
        set(handles.Setup, 'String', 'Please set number of test conditions');
    end
else
    set(handles.Single, 'Enable', 'Off');
    set(handles.Multiple,'Enable', 'Off');
    set(handles.Dose,'Enable', 'Off');
    if(curval<=5 &curval >= 1)
        set(handles.Setup, 'String', 'Please set imaging modality');
    else
        set(handles.Setup, 'String', 'Please set imaging modality and number of test conditions');
    end

end
% hObject    handle to color (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of color


% --- Executes on button press in Dose.
function Dose_Callback(hObject, eventdata, handles)
global TestNum tests conts
[tests conts]  = BeadData(TestNum);
if(get(handles.color, 'Value'))
%    [runname direct] = Single_Color(handles.axes3, tests, conts);
 %   Single_Run_Analysis_Color(handles, runname,direct)  ; 
  %  pause();
   % Success(hObject, eventdata, handles) fill this in
elseif(get(handles.epi, 'Value'))
     Dose_Fluor(hObject, tests,conts)
     Success(hObject, eventdata, handles);
end


% hObject    handle to Dose (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in Multiple.
function Multiple_Callback(hObject, eventdata, handles)
% hObject    handle to Multiple (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global TestNum tests conts
[tests conts]  = BeadData(TestNum);


% --- Executes on button press in Single.
function Single_Callback(hObject, eventdata, handles)
% hObject    handle to Single (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TestNum tests conts
[tests conts]  = BeadData(TestNum);
if(get(handles.color, 'Value'))
    [runname direct] = Single_Color(handles.axes3, tests, conts);
    Single_Run_Analysis_Color(handles, runname,direct)  ; 
    pause();
    Success(hObject, eventdata, handles)
elseif(get(handles.epi, 'Value'))
   cal_exp = str2num(get(handles.calexp, 'String'));
    [runname direct] = Single_Epi(hObject,tests, conts);
    Single_Run_Analysis_Color(handles, runname, direct);
    pause();
     Success(hObject, eventdata, handles);
end

function [tests conts] = BeadData(TestNum)
tests = [];
conts = [];
myprompt = 'Enter beads for ';
prompttest = {};
promptcont = {};
for i = 1:TestNum
    testname = sprintf('test%1.0f', i);
    contname = sprintf('Control%1.0f', i);
    curtestprompt = sprintf('%s %s', myprompt, testname);
    curcontprompt = sprintf('%s %s', myprompt, contname);
    prompttest = {prompttest{:}, curtestprompt};
    promptcont = {promptcont{:}, curcontprompt};

end
correcttest = 0;
while(~correcttest)
    testinfo = inputdlg(prompttest);

    isnumerror = 0;
    isbigerror = 0;
    for a = 1:TestNum
        testsamp = str2num(testinfo{a});
        if (isempty(testsamp))
            isnumerror = isnumerror + 1;
        elseif (max(testsamp) > 20)
            isbigerror = isbigerror +1
        end
    end
    if(isnumerror > 0)
        uiwait(warndlg('Bead input is in wrong format, contains nonumeric data', '**Nonnumeric Input**'));
    end
    if(isbigerror>0)
        uiwait(warndlg('Bead input contains numbers exceeding array size', '**Bead Index Eceeds Array Size**'))
    end
    if(isbigerror == 0 & isnumerror == 0)
        correcttest =1;
    end
end
correcttest = 0;
while(~correcttest)
    continfo = inputdlg(promptcont);

    isnumerror = 0;
    isbigerror = 0;
    for a = 1:TestNum
        contsamp = str2num(continfo{a});
        if (isempty(contsamp))
            isnumerror = isnumerror + 1;
        elseif (max(contsamp) > 20)
            isbigerror = isbigerror +1
        end
    end
    if(isnumerror > 0)
        uiwait(warndlg('Bead input is in wrong format, contains nonumeric data', '**Nonnumeric Input**'));
    end
    if(isbigerror>0)
        uiwait(warndlg('Bead input contains numbers exceeding array size', '**Bead Index Eceeds Array Size**'))
    end
    if(isbigerror == 0 & isnumerror == 0)
        correcttest =1;
    end
end


for a = 1:TestNum
    tests(a,:) = str2num(testinfo{a});
    conts(a,:) = str2num(continfo{a});
end

function Success(hObject, eventdata, handles)
set(handles.pan, 'Visible', 'Off');
%set(handles.axes4, 'Visible', 'Off');
set(handles.axes3, 'Visible', 'On');
axes(handles.axes3);
AnalysisComplete = imread('analysiscomplete.png');
imshow(AnalysisComplete);


% --- Executes when figure1 is resized.
function figure1_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





function calexp_Callback(hObject, eventdata, handles)
% hObject    handle to calexp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of calexp as text
%        str2double(get(hObject,'String')) returns contents of calexp as a double


% --- Executes during object creation, after setting all properties.
function calexp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to calexp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
