function varargout = yeni_arayuz(varargin)
% YENI_ARAYUZ MATLAB code for yeni_arayuz.fig
%      YENI_ARAYUZ, by itself, creates a new YENI_ARAYUZ or raises the existing
%      singleton*.
%
%      H = YENI_ARAYUZ returns the handle to a new YENI_ARAYUZ or the handle to
%      the existing singleton*.
%
%      YENI_ARAYUZ('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in YENI_ARAYUZ.M with the given input arguments.
%
%      YENI_ARAYUZ('Property','Value',...) creates a new YENI_ARAYUZ or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before yeni_arayuz_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to yeni_arayuz_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help yeni_arayuz

% Last Modified by GUIDE v2.5 06-Apr-2020 22:45:19

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @yeni_arayuz_OpeningFcn, ...
                   'gui_OutputFcn',  @yeni_arayuz_OutputFcn, ...
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


% --- Executes just before yeni_arayuz is made visible.
function yeni_arayuz_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to yeni_arayuz (see VARARGIN)

% Choose default command line output for yeni_arayuz
% Center the GUI
movegui(hObject,'center');
%Disconnect and delete all image acquisition objects
imaqreset
% Empty string to save the path of the object.
  handles.route =' ';
  handles.route2=' ';
  handles.route3=' ';
 

% Disable buttons "Trace path" and "Save" 
set(handles.plot_route,'Enable','off');
set(handles.save_route,'Enable','off');
%
set(handles.axes1,'XTickLabel',[],'YTickLabel',[])
% ___________________________________________________
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes yeni_arayuz wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = yeni_arayuz_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in start.
function start_Callback(hObject, eventdata, handles)
% hObject    handle to start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Enable buttons "Trace path" and "Save" 
set(handles.plot_route,'Enable','off');
set(handles.save_route,'Enable','off');
% Set the user data to 0 in "STOP" button. This button stops the "search" of the color
set(handles.stop,'UserData',0);



topsecretinfo1=[ ];
topsecretinfo2=[ ];
topsecretinfo3=[ ];


global topsecretinfo
topsecretinfo=[ ];


 global x1
 global x2
 global x3
 global y1
 global y2
 global y3
 global bw1
 global bw2
 global bw3


x1=0;
x2=0;
x3=0;
y1=0;
y2=0;
y3=0;
obj= videoinput('winvideo',1);
  guidata(hObject, handles);
src = getselectedsource(obj); 
 obj.ReturnedColorspace = 'rgb';
obj.FrameGrabInterval = 5;
        set(obj,'FramesPerTrigger',Inf);
        obj.FramesPerTrigger=Inf;
      



     
        start(obj);

 

framesAcquired =50;
while (framesAcquired<=1000) 
    
     if get(handles.stop,'UserData')==1
                    break % Break while loop to stop
                end

 % Get image
 data = getdata(obj,1);
 framesAcquired = framesAcquired + 5; 
 % transform image to double format
 data=double(data); 
 %show image
   data=uint8(data);                
                 image(data)
                 axis image off
   
      
     
      diff_red = imsubtract(data(:,:,1), rgb2gray(data)); 
      diff_red = medfilt2(diff_red, [3 3]);             
      diff_red = im2bw(diff_red,0.18); 
      diff_red = bwareaopen(diff_red,1200);
      bw1 = bwlabel(diff_red, 8);
      
      stats1 = regionprops(bw1, 'BoundingBox', 'Centroid');
      
       diff_green = imsubtract(data(:,:,2), rgb2gray(data)); 
       diff_green = medfilt2(diff_green, [3 3]);             
       diff_green = im2bw(diff_green,0.134); 
        diff_green = bwareaopen(diff_green,1200);
       bw2 = bwlabel(diff_green, 8);
       
       stats2 = regionprops(bw2, 'BoundingBox', 'Centroid');
        
        diff_blue = imsubtract(data(:,:,3), rgb2gray(data)); 
       diff_blue = medfilt2(diff_blue, [3 3]);             
       diff_blue = im2bw(diff_blue,0.18); 
      diff_blue = bwareaopen(diff_blue,1200);
       bw3 = bwlabel(diff_blue, 8);
       
       stats3 = regionprops(bw3, 'BoundingBox', 'Centroid');
       
    imshow(data)
   hold on
   for object = 1:length(stats1)
        bb = stats1(object).BoundingBox;
        bc = stats1(object).Centroid;
        rectangle('Position',bb,'EdgeColor','r','LineWidth',2)
        plot(bc(1),bc(2), '-m+')
        x1=round(bc(1));
        y1=round(bc(2)); 
        topsecretinfo1=[topsecretinfo1; x1  y1];
        
        
   end
   
      for object = 1:length(stats2)
        bb1 = stats2(object).BoundingBox;
        bc1 = stats2(object).Centroid;
        rectangle('Position',bb1,'EdgeColor','g','LineWidth',2)
        plot(bc1(1),bc1(2), '-m+')
        x2=bc1(1);
        y2=bc1(2);
        topsecretinfo2=[topsecretinfo2; x2  y2];
      end
 
      
        for object = 1:length(stats3)
        bb2 = stats3(object).BoundingBox;
        bc2 = stats3(object).Centroid;
        rectangle('Position',bb2,'EdgeColor','b','LineWidth',2)
        plot(bc2(1),bc2(2), '-m+')
        x3=bc2(1);
        y3=bc2(2);
        topsecretinfo3=[topsecretinfo3; x3  y3];
       end
        hold off 
       
     
drawnow
end
            stop(obj);
            imaqreset
      


            
 handles.route=topsecretinfo1;
 guidata(hObject, handles)

 handles.route2=topsecretinfo2;
 guidata(hObject, handles)

 handles.route3=topsecretinfo3;
 guidata(hObject, handles)

% Enable buttons "Trace path" y "Save"
 set(handles.plot_route,'Enable','on');
 set(handles.save_route,'Enable','on');





% --- Executes on button press in red.
function red_Callback(hObject, eventdata, handles)
% hObject    handle to red (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%%for RED
 
 global topsecretinfo
 global bw1
 global x1
 global y1


          imshow(bw1);
       
        hold on
         topsecretinfo=[x1 ; y1];
         handles.filename=xlswrite('deneme.xlsx',topsecretinfo,'A1:A2');
         guidata(hObject,handles);
         yatay=x1;
         dikey=y1;
         set(handles.x_konum,'String',yatay);
         set(handles.y_konum,'String',dikey);
        hold off
        
          
   axes(handles.axes1);    


% --- Executes on button press in green.
 function green_Callback(hObject, eventdata, handles)
% % hObject    handle to green (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% %For Green
% 
global topsecretinfo
global bw2
global x2
global y2

       imshow(bw2);
      
       hold on 
       topsecretinfo=[x2 ; y2];
       handles.filename=xlswrite('deneme.xlsx',topsecretinfo,'B1:B2');
       guidata(hObject,handles);
       yatay=x2;
       dikey=y2;
       set(handles.x_konum,'String',yatay);
       set(handles.y_konum,'String',dikey);
       hold off
 axes(handles.axes1);

% % % --- Executes on button press in blue.
 function blue_Callback(hObject, eventdata, handles)
% % hObject    handle to blue (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% % for blue

global topsecretinfo
global bw3
global x3
global y3

           imshow(bw3);
           
            hold on
           
          topsecretinfo=[x3 ; y3];
           handles.filename=xlswrite('deneme.xlsx',topsecretinfo,'C1:C2');
           guidata(hObject,handles);
            yatay=x3;
             dikey=y3;
            set(handles.x_konum,'String',yatay);
             set(handles.y_konum,'String',dikey);

        hold off
        axes(handles.axes1);


% --- Executes on button press in stop.
function stop_Callback(hObject, eventdata, handles)
% hObject    handle to stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.stop,'UserData',1);
guidata(hObject, handles);

% --- Executes on button press in x_konum.
function x_konum_Callback(hObject, eventdata, handles)
% hObject    handle to x_konum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in y_konum.
function y_konum_Callback(hObject, eventdata, handles)
% hObject    handle to y_konum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in excel_data.
function excel_data_Callback(hObject, eventdata, handles)
% hObject    handle to excel_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 winopen('deneme.xlsx');
 guidata(hObject,handles);
 
 % --- Executes on button press in plot_route.
function plot_route_Callback(hObject, eventdata, handles)
% hObject    handle to plot_route (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

hold on
val = str2num(get(handles.input1,'String'));
hold off
if val==1
figure(1)
% Call data path
ruta=handles.route;
% Plot path
plot(ruta(1:5:end,1),ruta(1:5:end,2))
title('OBJECT PATH RED')
axis ij
elseif val==2
     figure(2)
 ruta=handles.route2;
 plot(ruta(1:5:end,1),ruta(1:5:end,2))
 title('OBJECT PATH GREEN')
 axis ij
elseif val==3
figure(3)
ruta=handles.route3;
plot(ruta(1:5:end,1),ruta(1:5:end,2))
title('OBJECT PATH BLUE')
axis ij
else
    msgbox('1-For Red 2-For Green 3-For Blue')
end

% --- Executes on button press in save_route.
function save_route_Callback(hObject, eventdata, handles)
% hObject    handle to save_route (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hold on
val = str2num(get(handles.input1,'String'));
hold off
[nombre ruta]=uiputfile('*.mat','SAVE PATH');
%Returns if you press cancel
if nombre==0, return, end
if val==1
% Save parh
ruta=handles.route;
save(nombre,'ruta')
elseif val==2
    ruta=handles.route2;
    save(nombre,'ruta')
elseif val==3
    ruta=handles.route3;
    save(nombre,'ruta')

end
    



% --- Executes during object creation, after setting all properties.
function x_konum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x_konum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function y_konum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to y_konum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function input1_Callback(hObject, eventdata, handles)
% hObject    handle to input1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of input1 as text
%        str2double(get(hObject,'String')) returns contents of input1 as a double



% --- Executes during object creation, after setting all properties.
function input1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to input1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
