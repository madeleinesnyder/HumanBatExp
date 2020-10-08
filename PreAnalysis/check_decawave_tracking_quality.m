% This function examines the quality of the Decawave data.
% On a mac:
 
root_save = '/Users/madeleinesnyder/Documents/Berkeley/Bats/data/Decawave_DBG';
% session = 2; day = '200923';
% filetype = strcat('decawave_',day,'*',num2str(session),'.mat');
% dirlist = dir(fullfile(root_save,filetype)); 
% deca = [root_save filesep dirlist(end).name];

% Better example
session = 1; day = '200925'; % 117.04s time. 
%filetype = ('*poortracking2*');
filetype = strcat('decawave_',day,'*',num2str(session),'.mat');
dirlist = dir(fullfile(root_save,filetype)); 
deca = [root_save filesep dirlist(end).name];

    load(deca);
    
    % Plot Data Quality (Precision) Blog: "If quality factor is below 50 then the data error can be up to 50cm."
    figure(); hold on; plot(UD.Prec); refline(0,50); title('Automatic Precision Metric'); xlabel('Time'); ylabel('Precision');
    
    Tag1Prec = UD.Prec(:,1); Tag2Prec = UD.Prec(:,2); 
    tag_1_below_threshold = size(Tag1Prec(Tag1Prec<50),1)/size(Tag1Prec,1); tag_2_below_threshold = size(Tag2Prec(Tag2Prec<50),1)/size(Tag2Prec,1)
    
    disp(strcat(num2str(tag_1_below_threshold*100),' % of Tag1 data has large (>50) error'));
    disp(strcat(num2str(tag_2_below_threshold*100),' % of Tag2 data has large (>50) error'));
    
    % Plot the xy movement with the error to see if there is a specific
    % spot in the room
    c = linspace(1,10,size(UD.Pos,3));
    
    % Plot precision/birds eye view over time
    figure(); title('Tag1 XY Positions'); colormap(hot); subplot(2,2,[1 3]); hold on; xlabel('NorthEast Wall (m)'); ylabel('Door Wall (m)'); 
    scatter(squeeze(UD.Pos(1,1,:)),squeeze(UD.Pos(2,1,:)),[],c); 
    scatter(squeeze(UD.Pos(1,2,:)),squeeze(UD.Pos(2,2,:)),[],c);
    subplot(2,2,2); hold on; xlabel('Time'); ylabel('Precision Tag 1');
    col = (1:size(Tag1Prec,1));  % This is the color, vary with x in this case.
    surface([col;col;],[Tag1Prec';Tag1Prec'],[col;col],...
        'facecol','no',...
        'edgecol','interp',...
        'linew',2);
    refline(0,50);
    subplot(2,2,4); hold on; xlabel('Time'); ylabel('Precision Tag 2');
    col = (1:size(Tag2Prec,1));  % This is the color, vary with x in this case.
    surface([col;col;],[Tag2Prec';Tag2Prec'],[col;col],...
        'facecol','no',...
        'edgecol','interp',...
        'linew',2);
    refline(0,50);
    
    %Scatter xy, Scatter xz, Scatter yz.
    colormap(cool);
    x = squeeze(UD.Pos(1,1,:)); x2 = squeeze(UD.Pos(1,2,:));
    y = squeeze(UD.Pos(2,1,:)); y2 = squeeze(UD.Pos(2,2,:));
    z = squeeze(UD.Pos(3,1,:)); z2 = squeeze(UD.Pos(3,2,:));
    figure();  hold on; title("Red Tag1; Blue Tag2; Birds-Eye-View");
    scatter(x,y,'r.');
    scatter(x2,y2,'b.');
    figure(); hold on; title("Red Tag1; Blue Tag2; Side-View#1");
    scatter(x,z,'r.');
    scatter(x2,z2,'b.');
    figure(); hold on; title("Red Tag1; Blue Tag2; Side-View#2");
    scatter(y,z,'r.');
    scatter(y2,z2,'b.');
    [n_hist,c_hist] = hist3([y,x]);
     
    % Plot the distance bewteen the two tags. Dont super care about this,
    % just care about vector.
    tag_diff = abs(UD.Pos(:,1,:)-UD.Pos(:,2,:));
    TD = squeeze(tag_diff);
    figure(); hold on; title('Distance between tags (m)'); plot(TD(1,:)); plot(TD(2,:)); %plot(TD(3,:));
    
    % Median filter the data?
    Medfilt_tag1x = medfilt1(squeeze(UD.Pos(1,1,:))); Medfilt_tag2x = medfilt1(squeeze(UD.Pos(1,2,:)));
    Medfilt_tag1y = medfilt1(squeeze(UD.Pos(2,1,:))); Medfilt_tag2y = medfilt1(squeeze(UD.Pos(2,2,:)));
    Medfilt_tag1z = medfilt1(squeeze(UD.Pos(3,1,:))); Medfilt_tag2z = medfilt1(squeeze(UD.Pos(3,2,:)));
    figure(); hold on; plot(Medfilt_tag1x); plot(squeeze(UD.Pos(1,1,:))); 

    figure(); hold on;
    scatter(Medfilt_tag1x,Medfilt_tag1y); scatter(squeeze(UD.Pos(1,1,:)),squeeze(UD.Pos(2,1,:)));
    % Plus gaussian
    w = gausswin(30);
    w=w/sum(w);
    medfilt_gauss_tag1x = filter(w,1,Medfilt_tag1x); medfilt_gauss_tag2x = filter(w,1,Medfilt_tag2x);
    medfilt_gauss_tag1y = filter(w,1,Medfilt_tag1y); medfilt_gauss_tag2y = filter(w,1,Medfilt_tag2y);
    medfilt_gauss_tag1z = filter(w,1,Medfilt_tag1z); medfilt_gauss_tag2z = filter(w,1,Medfilt_tag2z);
    figure(); hold on;
    plot(medfilt_gauss_tag1x); plot(squeeze(UD.Pos(1,1,:))); 
    figure(); hold on;
    scatter(medfilt_gauss_tag1x,medfilt_gauss_tag1y); scatter(squeeze(UD.Pos(1,1,:)),squeeze(UD.Pos(2,1,:)));
    
    % JustGaussian filter the data?
    gauss_tag1x = filter(w,1,squeeze(UD.Pos(1,1,:))); gauss_tag2x = filter(w,1,squeeze(UD.Pos(1,2,:)));
    gauss_tag1y = filter(w,1,squeeze(UD.Pos(2,1,:))); gauss_tag2y = filter(w,1,squeeze(UD.Pos(2,2,:)));
    gauss_tag1z = filter(w,1,squeeze(UD.Pos(3,1,:))); gauss_tag2z = filter(w,1,squeeze(UD.Pos(3,2,:)));
    figure(); hold on;
    plot(gauss_tag1x); plot(squeeze(UD.Pos(1,1,:))); 
    figure(); hold on;
    scatter(gauss_tag1x,gauss_tag1y); scatter(squeeze(UD.Pos(1,1,:)),squeeze(UD.Pos(2,1,:)));
    
    % Plot the distance bewteen the two tags
    tag_diffx = abs(gauss_tag1x-gauss_tag2x);  tag_diffy = abs(gauss_tag1y-gauss_tag2y);  tag_diffz = abs(gauss_tag1z-gauss_tag2z);
    figure(); hold on; title('Distance between tags (m)'); 
    subplot(3,1,1); plot(tag_diffx); 
    subplot(3,1,2); plot(tag_diffy);
    subplot(3,1,3); plot(tag_diffz);
    
    figure(); title('Tag1 XY Positions with difference between tags'); colormap(cool); subplot(2,3,[1 4]); hold on; xlabel('NorthEast Wall (m)'); ylabel('Door Wall (m)'); 
    scatter(squeeze(UD.Pos(1,1,:)),squeeze(UD.Pos(2,1,:)),[],c); 
    scatter(squeeze(UD.Pos(1,2,:)),squeeze(UD.Pos(2,2,:)),[],c);
    subplot(2,3,2); hold on; xlabel('Time'); ylabel('Precision Tag 1');
    col = (1:size(Tag1Prec,1));  % This is the color, vary with x in this case.
    surface([col;col;],[Tag1Prec';Tag1Prec'],[col;col],...
        'facecol','no',...
        'edgecol','interp',...
        'linew',2);
    refline(0,50);
    subplot(2,3,5); hold on; xlabel('Time'); ylabel('Precision Tag 2');
    col = (1:size(Tag2Prec,1));  % This is the color, vary with x in this case.
    surface([col;col;],[Tag2Prec';Tag2Prec'],[col;col],...
        'facecol','no',...
        'edgecol','interp',...
        'linew',2);
    refline(0,50);
    subplot(2,3,[3 6]); hold on; 
    col = (1:size(tag_diffx,1));  % This is the color, vary with x in this case.
    surface([col;col;],[tag_diffx';tag_diffx'],[col;col],...
        'facecol','no',...
        'edgecol','interp',...
        'linew',2);
    xlabel('Time'); ylabel('Distance between Tags (m)');
    refline(0,0.3);
    %plot(tag_diffx); plot(tag_diffy);
    