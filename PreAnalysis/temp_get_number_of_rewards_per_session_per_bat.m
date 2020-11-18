% Get rewards for each bat.
% MCS 10/8/20

% Note: change this into a function

%%%%%%%% Pick date, os, session %%%%%%%%%%
day = '201008';
%day = datestr(now,30); today = today(3:8);

% Pick OS
os_var = 'mac';

% Pick session
session = '6';

%%%%%%%%%%%% Do not change below %%%%%%%%%

% Set up roots and paths
if strcmp(os_var,'mac')
    root_root = [filesep 'Volumes' filesep 'server1_home'];
elseif strcmp(os,'pc')
    root_root = ['Y:'];
end
root = [root_root filesep 'users' filesep 'Madeleine' filesep '2021_BatHumanExp' filesep day];
cam_root = [root filesep 'cam' filesep 'session',session]; 
rew_root = [root filesep 'reward' filesep 'session',session];
dca_root = [root filesep 'reward' filesep];

%load parameter file
paramfiletype = strcat('*','param','*','.txt');
paramfiles = dir(fullfile(rew_root,paramfiletype)); 
param_file = [rew_root filesep paramfiles(end).name];
pfid = fopen(param_file);
tline = fgetl(pfid);
while ischar(tline)
    disp(tline)
    tline = fgetl(pfid);
end
fclose(pfid);

%load event file
eventfiletype = strcat('*','event','*','.txt');
eventfiles = dir(fullfile(rew_root,eventfiletype)); 
event_file = [rew_root filesep eventfiles(end).name];
efid = fopen(event_file);
tline = fgetl(efid);
stored_event_lines = {};
while ischar(tline)
    disp(tline)
    tline = fgetl(efid);
    stored_event_lines{end+1} = tline;
end
fclose(efid);

% parse event file (May have to eliminate last cell)
to_rm = [];
for i=1:size(stored_event_lines,2)
    if size(stored_event_lines{i}) < 3
        to_rm = [to_rm,i];
    end
end
stored_event_lines(to_rm) = [];
stored_event_array = cellfun(@parse_e_cells,stored_event_lines,'un',0);

% bfm is the Bat Failure Matrix. Stores # of uneaten LED offerings. 
% brm is the Bat Reward Matrix. Stores # of successfully eaten LED offerings. 
brm = [0, 0, 0, 0]; bfm = [0, 0, 0, 0];
for i=1:size(stored_event_array,2)
    for j=4:7
        temp_cell = str2num(cell2mat(stored_event_array{i}(j)));
        if ~isnan(temp_cell) && temp_cell < 20.0 && ~strcmp(stored_event_array{i}{3},'ChangeFile')
            brm(j-3) = brm(j-3) + 1;
        elseif ~isnan(temp_cell) && temp_cell > 20.0 && ~strcmp(stored_event_array{i}{3},'ChangeFile')
            bfm(j-3) = bfm(j-3) + 1;
        end
    end
end

disp("    Bat1  Bat2  Bat3  Bat4"); disp(brm); disp(bfm);

