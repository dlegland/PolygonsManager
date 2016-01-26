function contoursResize(obj)
%CONTOURSRESIZE  Converts contours units to user untis (millimeters)
%
%   Inputs :
%       - obj : handle of the MainFrame
%   Outputs : none

% enter the resolution of the image to make the conversion
resol = contoursResizePrompt;

if ~strcmp(resol, '?')
    
    % memory allocation
    polygonList = cell(1, length(obj.model.nameList));

    % create waitbar
%     h = waitbar(0,'Conversion starting ...', 'name', 'Conversion');
    
    for i = 1:length(polygonList)
        % get the name of the polygon that will be converted
        name = obj.model.nameList{i};

        % get the polygon from its name
        poly = getPolygonFromName(obj.model, name);
        
        % convert the polygon
        polyMm = poly * resol;

        %update the polygon and the waitbar
        updatePolygon(obj.model.PolygonArray, getPolygonIndexFromName(obj.model, name), polyMm);
%         waitbar(i / length(polygonList), h, ['process : ' name]);
    end
    % close waitbar
%     close(h)
    
    % get the selected factor
    ud = obj.model.selectedFactor;
    
    % if a factor was selected prior to the conversion
    if iscell(ud)
        % display the contours colored depending on the selected factor
        polygonList = getPolygonsFromFactor(obj.model, ud{1});
        displayPolygonsFactor(obj, polygonList, obj.handles.axes{1});
    else
        % display the contours without special coloration
        displayPolygons(obj, getAllPolygons(obj.model.PolygonArray), obj.handles.axes{1});
    end
end

function resol = contoursResizePrompt
%CONTOURSRESIZEPROMPT  A dialog figure on which the user can select type
%the resolution of the image
%
%   Inputs : none
%   Outputs : resolution of the image

    % default value of the ouput to prevent errors
    resol = '?';

    % get the position where the prompt will at the center of the
    % current figure
    pos = getMiddle(gcf, 250, 130);

    % create the dialog
    d = dialog('position', pos, ...
                   'name', 'Enter image resolution');

    % create the inputs of the dialog box
    uicontrol('parent', d,...
            'position', [30 80 90 20], ...
               'style', 'text',...
              'string', 'Resolution :', ...
            'fontsize', 10, ...
 'horizontalalignment', 'right');

    edit = uicontrol('parent', d,...
                   'position', [130 81 90 20], ...
                      'style', 'edit');

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
            'callback', @callback);

    uicontrol('parent', d, ...
            'position', [135 30 85 25], ...
              'string', 'Cancel', ...
            'callback', 'delete(gcf)');

    % Wait for d to close before running to completion
    uiwait(d);

    function callback(~,~)
        try
            % if the input numeric then get its value and close the dialog box
            if ~isnan(str2double(get(edit,'String')))
                resol = str2double(get(edit,'String'));
                delete(gcf);
            % if the input contains an operation get the result and close the dialog box
            elseif find(ismember(get(edit,'String'), ['\', '¨', '/', '*', '+', '-'])) ~= 0
                resol = eval(get(edit,'String'));
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