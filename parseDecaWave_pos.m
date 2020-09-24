function [r,t,p] = parseDecaWave_pos(data)
        
        data_Lns = splitlines(data);                            %Split lines
        numTags = str2double(erase(data_Lns(1), "data: "));     %Extract number of tags
        dataTime = split(data_Lns(3+numTags)," ");              %Extract time info
        t = str2double(erase(dataTime(1), "["));
        
        r = NaN(3,numTags);
        p = NaN(1,numTags);
        for i = 1:numTags
            pos_data = split(extractBetween(data_Lns(1+i),"[","]"),",");
            r(1,i) = str2double(pos_data(1));       %x position
            r(2,i) = str2double(pos_data(2));       %y position
            r(3,i) = str2double(pos_data(3));       %z position
            p(i) = str2double(pos_data(4));         %precision  
        end

%         scatter3(x,y,z,'filled');
%         xlim([-1 4]); ylim([-1 2]); zlim([-1 2]);
%         drawnow();
end