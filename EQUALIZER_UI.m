function varargout = EQUALIZER_UI(varargin)
% EQUALIZER_UI MATLAB code for EQUALIZER_UI.fig
%      EQUALIZER_UI, by itself, creates a new EQUALIZER_UI or raises the existing
%      singleton*.
%
%      H = EQUALIZER_UI returns the handle to a new EQUALIZER_UI or the handle to
%      the existing singleton*.
%
%      EQUALIZER_UI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EQUALIZER_UI.M with the given input arguments.
%
%      EQUALIZER_UI('Property','Value',...) creates a new EQUALIZER_UI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before EQUALIZER_UI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to EQUALIZER_UI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help EQUALIZER_UI

% Last Modified by GUIDE v2.5 09-May-2018 11:39:34

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @EQUALIZER_UI_OpeningFcn, ...
                   'gui_OutputFcn',  @EQUALIZER_UI_OutputFcn, ...
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


% --- Executes just before EQUALIZER_UI is made visible.
function EQUALIZER_UI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to EQUALIZER_UI (see VARARGIN)

% Choose default command line output for EQUALIZER_UI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes EQUALIZER_UI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = EQUALIZER_UI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function Low_Slider_Callback(hObject, eventdata, handles)
%Low Pass Cut-Off Frequency
global FC;
FC1 = get(hObject, 'Value');
set(handles.Low_Label, 'String', strcat(num2str(FC1),' Hz'));
FC = FC1*1000;
% hObject    handle to Low_Slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function Low_Slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Low_Slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function Low_Gain_Callback(hObject, eventdata, handles)
%Low Pass Gain
global LowGain;
%Get low pass gain from slider
LowGain = get(hObject,'Value');
%Set text label
set(handles.Low_Gain_Label,'String', strcat(num2str(LowGain), ' dB'));
% hObject    handle to Low_Gain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function Low_Gain_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Low_Gain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on button press in Load_Button.
function Load_Button_Callback(hObject, eventdata, handles)
% hObject    handle to Load_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global file;
[file, path] = uigetfile('*.wav');
if (file == 0)
    set(handles.file_name, 'String', 'No Selection')
else
    set(handles.file_name, 'String', file)
    global y, global fs;
    [y, fs] = audioread(fullfile(path,file));

end


% --- Executes on button press in play_button.
function play_button_Callback(hObject, eventdata, handles)
% hObject    handle to play_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Generate Filters based on parameters from sliders;
%Initialize Low Pass cut-off, F1, F2, F3, High Pass cut-off (in that order)
FC = get(handles.Low_Slider, 'Value');
F1 = get(handles.BP_Slider1, 'Value');
F2 = get(handles.BP_Slider2, 'Value')*1000;
F3 = get(handles.BP_Slider3, 'Value')*1000;
FCH = get(handles.High_Slider, 'Value')*1000;

%If FC not set, make 60Hz by default
if (FC < 1)
    FC = 60;
end

%Initialize bandwidths of bell curves
BW1 = get(handles.BW_BP1, 'value');
BW2 = get(handles.BW_BP2, 'value')*1000;
BW3 = get(handles.BW_BP3, 'value')*1000;


%if BW was not set, set to default values
if (BW1 < 1)
    BW1 = 60;
    set(handles.BW_BP1, 'value', 2.0);
end
    
if (BW2 < 1)
    BW2 = 1400;
    set(handles.BW_BP2, 'value', 1.1);
end

if (BW3 < 1)
    BW3 = 3.750;
    set(handles.BW_BP3, 'value', 1.25);
end

%Initialize gains 
LowGain = get(handles.Low_Gain, 'Value');
BP1Gain = get(handles.BP1_Gain, 'Value');
BP2Gain = get(handles.BP2_Gain, 'Value');
BP3Gain = get(handles.BP3_Gain, 'Value');
HighGain = get(handles.High_Gain, 'Value');

%Create Filters
LowShelf = LPF(FC, 10^(LowGain/20));
Bell1 = BPF(F1,BW1,10^(BP1Gain/20));
Bell2 = BPF(F2, BW2, 10^(BP2Gain/20));
Bell3 = BPF(F3, BW3, 10^(BP3Gain/20));
HighShelf = HPF(FCH, 10^(HighGain/20));
%Load signal and fs
global y, global fs;

%Clip the song because otherwise it takes too long
start = length(y)/4;
ending = 5*length(y)/16;

%Filter signal 
global signal;
signal = (y(start:ending, :));
yLow = filter(LowShelf, signal*10^(LowGain/20));
yBP1 = filter(Bell1, signal*10^(BP1Gain/20));
yBP2 = filter(Bell2, signal*10^(BP2Gain/20));
yBP3 = filter(Bell3, signal*10^(BP3Gain/20));
yHigh = filter(HighShelf, signal*10^(HighGain/20));
global y_out;
y_out = yLow + yBP1 + yBP2 + yBP3 + yHigh;

figure
subplot(2,1,1)
plot(fftshift(abs(fft(signal))));
title('Unaltered')
%xlim([3.2e5 3.8e5])
subplot(2,1,2)
plot(fftshift(abs(fft(y_out))));
title('Equalized')
%xlim([3.2e5 3.8e5])

global out;
out = audioplayer(y_out, fs);
set(handles.CommandLine, 'String', 'Playing');
play(out);


% --- Executes on button press in pause_button.
function pause_button_Callback(hObject, eventdata, handles)
% hObject    handle to pause_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global out;
pause(out)

% --- Executes on button press in stop_button.
function stop_button_Callback(hObject, eventdata, handles)
% hObject    handle to stop_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global out;
set(handles.CommandLine, 'String', 'Stopping');
stop(out)

% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on slider movement.
function BP1_Gain_Callback(hObject, eventdata, handles)
%BP1 Gain
global BP1Gain;
%Get BP1 gain from slider
BP1Gain = get(hObject,'Value');
%Set text label
set(handles.BP1_Gain_Label,'String', strcat(num2str(BP1Gain), ' dB'));
% hObject    handle to BP1_Gain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function BP1_Gain_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BP1_Gain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function BP2_Gain_Callback(hObject, eventdata, handles)
%BP2 Gain
global BP2Gain;
%Get low pass gain from slider
BP2Gain = get(hObject,'Value');
%Set text label
set(handles.BP2_Gain_Label,'String', strcat(num2str(BP2Gain), ' dB'));
% hObject    handle to BP2_Gain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function BP2_Gain_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BP2_Gain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all Createfns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function BP3_Gain_Callback(hObject, eventdata, handles)
%BP3 Gain
global BP3Gain;
%Get BP3 gain from slider
BP3Gain = get(hObject,'Value');
%Set text label
set(handles.BP3_Gain_Label,'String', strcat(num2str(BP3Gain), ' dB'));
% hObject    handle to BP3_Gain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function BP3_Gain_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BP3_Gain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function High_Gain_Callback(hObject, eventdata, handles)
%High Pass Gain
global HighGain;
%Get high pass gain from slider
HighGain = get(hObject,'Value');
%Set text label
set(handles.High_Gain_Label,'String', strcat(num2str(HighGain), ' dB'));
% hObject    handle to High_Gain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function High_Gain_CreateFcn(hObject, eventdata, handles)
% hObject    handle to High_Gain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider31_Callback(hObject, eventdata, handles)
% hObject    handle to slider31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider31_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider32_Callback(hObject, eventdata, handles)
% hObject    handle to slider32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider32_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider33_Callback(hObject, eventdata, handles)
% hObject    handle to slider33 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider33_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider33 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider34_Callback(hObject, eventdata, handles)
% hObject    handle to slider34 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider34_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider34 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function BP_Slider1_Callback(hObject, eventdata, handles)
global F1;
F11 = get(hObject, 'Value');
set(handles.BP1_Label, 'String', strcat(num2str(F11),' Hz'));
F1 = F11*1000;
% hObject    handle to BP_Slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function BP_Slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BP_Slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function BP_Slider2_Callback(hObject, eventdata, handles)
global F2;
F2 = get(hObject, 'Value');
set(handles.BP2_Label, 'String', strcat(num2str(F2),' kHz'));
% hObject    handle to BP_Slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function BP_Slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BP_Slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function BP_Slider3_Callback(hObject, eventdata, handles)
global F3;
F3 = get(hObject, 'Value');
set(handles.BP3_Label, 'String', strcat(num2str(F3),' kHz'));
% hObject    handle to BP_Slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function BP_Slider3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BP_Slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function High_Slider_Callback(hObject, eventdata, handles)
global FCH;
FCH = get(hObject, 'Value');
set(handles.High_Label, 'String', strcat(num2str(FCH),' kHz'));
% hObject    handle to High_Slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function High_Slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to High_Slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function BW_BP1_Callback(hObject, eventdata, handles)
global BW1;
BW1 = get(hObject, 'Value');
set(handles.BW_BP1_Label, 'String', strcat(num2str(BW1),' kHz'));
% hObject    handle to BW_BP1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function BW_BP1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BW_BP1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function BW_BP2_Callback(hObject, eventdata, handles)
global BW2;
BW2 = get(hObject, 'Value');
set(handles.BW_BP2_Label, 'String', strcat(num2str(BW2),' kHz'));
% hObject    handle to BW_BP2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function BW_BP2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BW_BP2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function BW_BP3_Callback(hObject, eventdata, handles)
global BW3;
BW3 = get(hObject, 'Value');
set(handles.BW_BP3_Label, 'String', strcat(num2str(BW3),' kHz'));
% hObject    handle to BW_BP3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function BW_BP3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BW_BP3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in ResetButton.
function ResetButton_Callback(hObject, eventdata, handles)
%Reset all parameters to default values
set(handles.Low_Slider, 'Value', 60);
set(handles.BP_Slider1, 'Value', 180);
set(handles.BP_Slider2, 'Value', 1.4);
set(handles.BP_Slider3, 'Value', 3.75);
set(handles.High_Slider, 'Value', 5);
set(handles.BW_BP1, 'value', 60);
set(handles.BW_BP2, 'value', 1.1);
set(handles.BW_BP3, 'value', 1.25);
set(handles.Low_Gain, 'Value', 0);
set(handles.BP1_Gain, 'Value', 0);
set(handles.BP2_Gain, 'Value', 0);
set(handles.BP3_Gain, 'Value', 0);
set(handles.High_Gain, 'Value', 0);
set(handles.Low_Gain_Label,'String', '0 dB');
set(handles.BP1_Gain_Label,'String', '0 dB');
set(handles.BP2_Gain_Label,'String', '0 dB');
set(handles.BP3_Gain_Label,'String', '0 dB');
set(handles.High_Gain_Label,'String', '0 dB');
set(handles.Low_Label,'String', '60 Hz');
set(handles.BP1_Label,'String', '180 Hz');
set(handles.BP2_Label,'String', '1.4 kHz');
set(handles.BP3_Label,'String', '3.75 kHz');
set(handles.High_Label,'String', '5 kHz');
set(handles.BW_BP1_Label, 'String', '60 Hz');
set(handles.BW_BP2_Label, 'String', '1.1 kHz');
set(handles.BW_BP3_Label, 'String', '1.25 kHz');


% hObject    handle to ResetButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
