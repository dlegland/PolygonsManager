function polygonsResize(obj, varargin)
%POLYGONSRESIZE  Converts contours units to user untis (millimeters)
%
%   Inputs :
%       - obj : handle of the MainFrame
%       - varargin : contains the parameters if the function is called from
%       a macro
%   Outputs : none

% select the coefficient of the conversion
if nargin == 1
    coef = contoursResizePrompt;
else
    if ~strcmp(class(varargin{1}), 'double')
        coef = str2double(varargin{1});
    else
        coef = varargin{1};
    end
end

if ~strcmp(coef, '?')
    
    % save the name of the function and the parameters used during
    % its call in the log variable
    obj.model.usedProcess{end+1} = ['polygonsResize : resol = ' num2str(coef)];

    % memory allocation
    polygonList = cell(1, length(obj.model.nameList));

    for i = 1:length(polygonList)
        % get the name of the polygon that will be converted
        name = obj.model.nameList{i};

        % get the polygon from its name
        poly = getPolygonFromName(obj.model, name);
        
        % convert the polygon
        polyMm = poly * coef;

        %update the polygon
        updatePolygon(obj.model.PolygonArray, getPolygonIndexFromName(obj.model, name), polyMm);
        updatePolygonInfos(obj.model, name)
    end
    
    % get the selected factor
    sf = obj.model.selectedFactor;

    % if a factor was selected prior to the conversion
    if iscell(sf)
        % display the contours colored depending on the selected factor
        polygonList = getPolygonsFromFactor(obj.model, sf{1});
        displayPolygonsFactor(obj.handles.Panels{1}, polygonList);
    else
        % display the contours without special coloration
        displayPolygons(obj.handles.Panels{1}, getAllPolygons(obj.model.PolygonArray));
    end
    
    updateMenus(obj);
end

function coef = contoursResizePrompt
%CONTOURSRESIZEPROMPT  A dialog figure on which the user can select type
%the resolution of the image
%
%   Inputs : none
%   Outputs : resolution of the image

    % default value of the ouput to prevent errors
    coef = '?';

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
                coef = str2double(get(edit,'String'));
                delete(gcf);
            % if the input contains an operation get the result and close the dialog box
            elseif find(ismember(get(edit,'String'), ['\', '¨', '/', '*', '+', '-'])) ~= 0
                coef = eval(get(edit,'String'));
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