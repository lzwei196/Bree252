function varargout = bree252ui(varargin)
% BREE252UI MATLAB code for bree252ui.fig
%      BREE252UI, by itself, creates a new BREE252UI or raises the existing
%      singleton*.
%
%      H = BREE252UI returns the handle to a new BREE252UI or the handle to
%      the existing singleton*.
%
%      BREE252UI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BREE252UI.M with the given input arguments.
%
%      BREE252UI('Property','Value',...) creates a new BREE252UI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before bree252ui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to bree252ui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help bree252ui

% Last Modified by GUIDE v2.5 29-Nov-2018 10:20:53

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @bree252ui_OpeningFcn, ...
                   'gui_OutputFcn',  @bree252ui_OutputFcn, ...
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


% --- Executes just before bree252ui is made visible.
function bree252ui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to bree252ui (see VARARGIN)


% Choose default command line output for bree252ui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes bree252ui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = bree252ui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes during object creation, after setting all properties.
function location_CreateFcn(hObject, eventdata, handles)
% hObject    handle to location (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in location.
function location_Callback(hObject, eventdata, handles)
locationcontents = cellstr(get(hObject,'String'));
locationchoice = locationcontents(get(hObject,'Value'));

%%store the users choice and store them to the variable locationvalue
if (strcmp(locationchoice,'Laval'))
    locationvalue = 'laval-rive-nord';
elseif(strcmp(locationchoice,'Montreal'))
    locationvalue = 'ville-de-montreal';
elseif(strcmp(locationchoice,'South Shore'))
    locationvalue = 'longueuil-rive-sud';
elseif(strcmp(locationchoice,'West Island'))
    locationvalue = 'ouest-de-lile-qc';
end

%%give the data to the appdata thus can be used in other functions.
 setappdata(0,'district',locationvalue);
 
 
% --- Executes during object creation, after setting all properties.
function pages_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pages (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in pages.
function pages_Callback(hObject, eventdata, handles)

%store the choice of page numbers, store it as a cellstr
pagecontents = cellstr(get(hObject,'String'));
pagechoice = (pagecontents(get(hObject,'Value')));

%set the data to appdata so other functions can access.
setappdata(0,'numpage1',pagechoice);

% --- Executes on button press in FIND.
function FIND_Callback(hObject, eventdata, handles)
% hObject    handle to FIND (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%msg box to tell the user that the scraping process starts. The scraping
%process takes time, therefore we leave the msgbox untill the scraping
%process is done
msgbox('The scraping processs starts now, please wait patiently. The openning of this window indicates the scraping process is still running.','Attention')

%get the user input from previous two pop button and set them to new
%variables so we can use the data in this function.
numpage1=getappdata(0,'numpage1');
numPage = str2num(numpage1{1});
district = getappdata(0,'district');
html = readHTML(district, numPage);

%After we have the input, we now can begin the scraping process
posthtml = readPost(html);
attributes = readInfo(posthtml);

%the attribute is the table we want, set it to appdata so other function
%can use it
setappdata(0,'attributes',attributes);

%msg the user that the scraping process has finished, the user can now
%begin the next step.
msgbox('The Housing information is ready. Please choose the refine option to generate the table.','Success')


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%request the user input from the two radio buttons, price and bedrooms
price = get(handles.Price, 'SelectedObject');
Price = get(price,'String');
numberofbeds = get(handles.Bedrooms, 'SelectedObject');
Numberofbeds = str2num(get(numberofbeds,'String'));

%get the output table from the appdata  and assign it to a new variable
finaltable = getappdata(0,'attributes');

%%sort the table under different price options
if strcmp(Price,'Low to High')
    sortedtable = sortrows(finaltable,2);
else
    sortedtable = sortrows(finaltable,2,'descend');
end


%%get rid of the rows that dont have the certain number of bedrooms
%transer the bedroom number column in the table to array for easier
%manipulation
a = table2array(sortedtable(:,'num_bedroom'));

%create two index one for array, one for table.
c = 0;
d= 0;

%create a switch section to follow user's choice, remove the rows thats not
%the desired bedroom number
switch Numberofbeds
    %case 1 if the desired bedroom is 1
    case 1
    for n =1:size(sortedtable,1)
      c=c+1;
      d=d+1;
    if a(d,1) ~= 1
       sortedtable([c],:)=[];
       c=c-1;
    end
    end
    
    %case 2 if the desired bedroom is 2
    case 2
    for n =1:size(sortedtable,1)
      c=c+1;
      d=d+1;
    if a(d,1) ~= 2
       sortedtable([c],:)=[];
       c=c-1;
    end
    end
    
    %case 3 if the desired bedroom is 3
    case 3
    for n =1:size(sortedtable,1)
      c=c+1;
      d=d+1;
    if a(d,1) ~= 3
       sortedtable([c],:)=[];
       c=c-1;
    end
    end
end
setappdata(0,'sortedtable',sortedtable);

%write the table to csv file
writetable(sortedtable,'Housinginfo_refined.csv');
msgbox('The file has been succesfully refined and saved to same file pass','Complete');

%%open the table
open('Housinginfo_refined.csv');


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tablenorefine = getappdata(0,'attributes');
writetable(tablenorefine,'Housinginfo.csv');
open('Housinginfo.csv');


