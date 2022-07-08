function test_Script()

% Create Time Vector
tVec=0:0.025:5;
% Loop through time
for i=1:length(tVec) 


% Coefficients for Polynomial Phase-Interpolation
a = 2.739726027397260;  % y1(t) = at^2
b = 2.739726027397260;  % y3(t) = -b(t-1)^2+1
c = -2.029426686960933; % y2(t) = ct^3 + dt^2 + gt + h
d = 3.044140030441400;
g = -0.015220700152207;
h = 0.000253678335870;

% Period Info
tP1 = 0.125;                        % Down-stroke
tP2 = 0.125;                        % Up-stroke
period = tP1+tP2;                   % Period
t = rem(tVec(i),period);       % Current time in simulation ( 'modular arithmetic to get time in period')

% Read In y_Pts for two Phases!
[xl,yP1,yP2] = read_File_In('swimmer.phases'); 

if(tVec(i)==0)
    xLag=xl;
else
    id=fopen('xLagnew.txt','r');
    format='%f';
    size=[1 Inf];
    xLag=fscanf(id,format,size);
    xLag=xLag';
    fclose(id);
end
%PHASE 1 --> PHASE 2
    if (t <= tP1) 

        %tprev = 0.0;
        t1 = 0.1*tP1;   
        t2 = 0.9*tP1;
        if (t<t1) 							%For Polynomial Phase Interp.
            g1 = a*power((t/tP1),2);
        elseif ((t>=t1)&&(t<t2)) 
            g1 = c*power((t/tP1),3) + d*power((t/tP1),2) + g*(t/tP1) + h;
        elseif (t>=t2)
            g1 = -b*power(((t/tP1) - 1),2) + 1;
        end
    
    
   if(t<(tP1/2))
       k=0;
       for j=1:length(xLag)
           xLag(j)=xLag(j)+k;
           k=k+0.0001;
       end
   elseif(t>(tP1/2) && t<tP1)
       k=0;
       for j=1:length(xLag)
           xLag(j)=xLag(j)-k;
           k=k+0.0001;
       end
   end
   
   xPts = xLag;
   yPts = yP1 + g1*( yP2 - yP1 );
   %PHASE 2 --> PHASE 1
    elseif ((t>tP1)&&(t<=(tP1+tP2)))
			
        tprev = tP1;
        t1 = 0.1*tP2 + tP1;
        t2 = 0.9*tP2 + tP1;
        if (t<t1) 							%//For Polynomial Phase Interp.
            g2 = a*power( ( (t-tprev)/tP2) ,2);
        elseif ((t>=t1)&&(t<t2)) 
            g2 = c*power( ( (t-tprev)/tP2) ,3) + d*power( ((t-tprev)/tP2) ,2) + g*( (t-tprev)/tP2) + h;
        elseif (t>=t2) 
            g2 = -b*power( (( (t-tprev)/tP2) - 1) ,2) + 1;
        end			
        
        if(t>tP1 && t<(tP1+(tP2/2)))
       k=0;
       for j=1:length(xLag)
           xLag(j)=xLag(j)+k;
           k=k+0.0001;
       end
   elseif(t>(tP1+(tP2/2)) && t<=(tP1+tP2))
       k=0;
       for j=1:length(xLag)
           xLag(j)=xLag(j)-k;
           k=k+0.0001;
       end
       end
        xPts = xLag;
        yPts = yP2 + g2*( yP1 - yP2 );
    end
ida=fopen('xLagnew.txt','w');
    for za=1:length(xLag)
        fprintf(ida,'%f \n',xLag(za));
    end
fclose(ida);


plot(xPts,yPts,'.'); hold on;
    axis([0 5 0 5]);
    pause(0.1); 
    clf;
end


function [xLag,y1,y2] = read_File_In(file_name)

filename = file_name;  %Name of file to read in

fileID = fopen(filename);

    % Read in the file, use 'CollectOutput' to gather all similar data together
    % and 'CommentStyle' to to end and be able to skip lines in file.
    C = textscan(fileID,'%f %f %f','CollectOutput',1);

fclose(fileID);        %Close the data file.

mat_info = C{1};   %Stores all read in data

%Store all elements in matrix
mat = mat_info(1:end,1:end);

y1 =  mat(:,2); %store yVals 1 
y2 =  mat(:,3); %store yVals 2


id=fopen('xLag.txt','r');
format='%f';
size=[1 Inf];
xLag=fscanf(id,format,size);
xLag=xLag';
fclose(id);