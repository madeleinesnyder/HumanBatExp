%Based on https://www.mathworks.com/matlabcentral/answers/421759-how-to-read-com-port-data-continuously-and-plot-the-data-live-in-matlab
%Please be sure to be in UART Shell mode
%The UART baud rate on the DWM1001 module is 115200 bps and the configuration is 8N1
%Generic mode to Shell mode:open TeraTerm, setup Serial connection with DecaWave, press “Enter” twice, wait for response, close TeraTerm or interrupt Serial)
%% Initiaize communication anche check for errors
clear all; close all; clc;

sess=2;

%Create Serial Port Object, wait 1 second and check pin status
s = serialport('COM6',115200,'Timeout',3);
pause(3); % Set longer time because was a delay with only 1s/
getpinstatus(s)

%Add the UserData Field to the serial port object
s.UserData = struct("Pos",[],"Prec",[],"Time",[],"Count",1,"Stop",0,"Date",[]);
formatout = 30;
DATE = datestr(now,formatout);
s.UserData.real_date = strcat(DATE(3:4),DATE(5:6),DATE(7:8),'_',DATE(10:13));

%%% CHANGE THIS TO MATCH BASLER %%
s.UserData.Session = sess;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Clear the output pin (LOW) and flush buffer 
writeline(s,"gc 14");   readline(s);
readline(s)
flush(s);

%Check that there are no incoming data
if ~isempty(readline(s))
    fprintf('Error: ongoing streaming of serial data \nTry again!! \n');
    writeline(s,"les");
    return
else
    disp('Connection OK');
end

%% Data aquisition from serial port
flush(s);
writeline(s,"gt 14");   readline(s);    readline(s);    %Toggle Output Pin
configureTerminator(s,95,"LF");                         %Change terminator to "_"
writeline(s,"les");     readline(s);                    %Start quering position and skip first line
tic;                                                    %Start timer
configureCallback(s,"terminator",@readSerialData);      %Start acquisition
%% Callback function for reading serial data

function readSerialData(src,~)
mins = 1;
sec = 60*mins;      %Length of acquisition in s
Fs = 10;
data = readline(src);
[r,t,p] = parseDecaWave_pos(data);

src.UserData.Pos = cat(3,src.UserData.Pos,r);
src.UserData.Time(end+1) = t;
src.UserData.Prec(end+1,:) = p;

src.UserData.Count = src.UserData.Count + 1;
disp('Acquiring Decawave Data...');

scatter3(r(1,:),r(2,:),r(3,:),'filled');
xlim([0 5]); ylim([-2.5 2.5]); zlim([-1 3]);
%view(2);
drawnow();

% When samples are aquired, switch off the callback
% MANUAL STOP ACQUISITION: type: s.UserData.Stop = 1 
%if mod(src.UserData.Count,Fs*sec) == 0 | src.UserData.Stop == 1
if src.UserData.Stop == 1
    configureCallback(src, "off");
    writeline(src,"gt 14");   %Toggle Output Pin
    writeline(src,"les");     %Stop quering position
    toc;
    UD = src.UserData;
    save(strcat('C:\Users\Batman\Desktop\BatHumanExp\box_3',filesep,src.UserData.real_date(1:6),filesep,'decawave_',src.UserData.real_date,'_',num2str(src.UserData.Session),'.mat'),'UD');
end
end

