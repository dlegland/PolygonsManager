function polygonsRotate(frame, angle, type)
%POLYGONSROTATE  Rotate the contour 
%
%   Inputs :
%       - obj : handle of the MainFrame
%       - angle : variable that defines the rotation angle (clockwise) -> Values : 
%                   - 1 : 90°
%                   - 2 : 270°
%                   - 3 : 180°
%       - type : determines which polygons must be rotated
%   Outputs : none

% F = getframe(obj.handles.Panels{1}.uiAxis);
% Image = frame2im(F);
% imwrite(Image, 'Image.jpg')

if strcmp(angle, 'customCCW')
    angle = polygonsRotatePrompt(1);
elseif strcmp(angle, 'customCW')
    angle = polygonsRotatePrompt(-1);
end
if ~isa(angle, 'double')
    angle = str2double(angle);
end

% determine which polygons will be rotated
switch type
    case 'all'
        % all the polygons
        polygonArray = frame.model.nameList;
        
        % save the name of the function and the parameters used during
        % its call in the log variable
        frame.model.usedProcess{end+1} = ['polygonsRotate : angle = ' num2str(angle) ' ; type = ' type];
    case 'selected'
        % only the polygons selected by the user
        polygonArray = frame.model.selectedPolygons;
end 

if isempty(polygonArray)
   return;
end

for i = 1:length(polygonArray)
    % get the name of the contours that will be rotated
    name = polygonArray{i};

    % get the polygon from its name
    poly = getPolygonFromName(frame.model, name);

    % rotate the polygon
    switch angle
        case 90
            % 90°
            polyRot = [poly(:,2) -poly(:,1)];
        case 270
            % 270 °
            polyRot = [-poly(:,2) poly(:,1)];
        case 180
            % 180°
            polyRot = [-poly(:,1) -poly(:,2)];
        otherwise
            polyRot = transformPoint(poly, createRotation(angle));
    end

    %update the polygon
    setPolygon(frame.model.PolygonArray, i, polyRot);
    updatePolygonInfos(frame.model, name)
end

refreshDisplay(getActivePanel(frame));
updateMenus(frame);


function angle = polygonsRotatePrompt(direction)
%CONTOURSROTATEPROMPT  A dialog figure on which the user can enter the
%angles of rotation he wants
%
%   Inputs : none
%   Outputs : angle in radians

    % default value of the ouput to prevent errors
    angle = '?';

    % get the position where the prompt will at the center of the
    % current figure
    pos = getMiddle(frame, 250, 130);

    % create the dialog
    d = dialog('position', pos, ...
                   'name', 'Enter image resolution');

    % create the inputs of the dialog box
    uicontrol('parent', d,...
            'position', [30 80 90 20], ...
               'style', 'text',...
              'string', 'Coefficient :', ... 
            'fontsize', 10, ...
 'horizontalalignment', 'right');

    edit = uicontrol('parent', d,...
                   'position', [130 81 90 20], ...
                      'style', 'edit', ...
                   'callback', @(~,~) callback);

    error = uicontrol('parent', d,...
                    'position', [135 46 85 25], ...
                       'style', 'text',...
                      'string', 'Invalid value', ...
             'foregroundcolor', 'r', ...
                     'visible', 'off', ...
                    'fontsize', 8);

    % create the two button to cancel or validate the inputs
    uicontrol('parent', d, ...
            'position', [30 30 85 25], ...
              'string', 'Validate', ...
            'callback', @(~,~) callback);

    uicontrol('parent', d, ...
            'position', [135 30 85 25], ...
              'string', 'Cancel', ...
            'callback', 'delete(gcf)');

    % Wait for d to close before running to completion
    uiwait(d);

    function callback
        try
            % if the input numeric then get its value and close the dialog box
            if ~isnan(str2double(get(edit,'String')))
                angle = str2double(get(edit,'String'))*pi/180*direction;
                delete(gcf);
            % if the input contains an operation get the result and close the dialog box
            elseif find(ismember(get(edit,'String'), ['\', '¨', '/', '*', '+', '-'])) ~= 0
                angle = eval(get(edit,'String'));
                angle = angle*pi/180*direction;
                delete(gcf);
            else
                set(error, 'visible', 'on');
            end
        catch
            set(error, 'visible', 'on');
        end
    end
end
end