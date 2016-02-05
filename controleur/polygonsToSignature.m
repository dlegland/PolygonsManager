function polygonsToSignature(obj, varargin)
%POLYGONSTOSIGNATURE  Converts contour in polar signatures
%
%   Inputs :
%       - obj : handle of the MainFrame
%   Outputs : none

% enter the starting angle and the number of angle that will be used during
% the transformation
if nargin == 1
    [startAngle, angleNumber] = contoursToSignaturePrompt;
else
    if ~strcmp(class(varargin{1}), 'double')
        startAngle = str2double(varargin{1});
    else
        startAngle = varargin{1};
    end
    if ~strcmp(class(varargin{1}), 'double')
        angleNumber = str2double(varargin{2});
    else
        angleNumber = varargin{1};
    end
end

if ~strcmp(startAngle, '?')
    
    obj.model.usedProcess{end+1} = ['polygonsToSignature : startAngle = ' num2str(startAngle) ' ; angleNumber = ' num2str(angleNumber)];
    % determine the angles that will be used for the transformation
    pas = 360/angleNumber;
    angles = startAngle:pas:360+startAngle-pas;
    
    % preallocating memory
    dat = zeros(length(obj.model.nameList), angleNumber);
    
    %create waitbar
    h = waitbar(0,'Conversion starting ...', 'name', 'Conversion');
    
    for i = 1:length(obj.model.nameList)

        % get the name of the polygon that will be transformed
        name = obj.model.nameList{i};

        % update the waitbar and the contours selection (purely cosmetic)
        obj.model.selectedPolygons = name;
        updateSelectedPolygonsDisplay(obj.handles.Panels{obj.handles.tabs.Selection});
        set(obj.handles.list, 'value', find(strcmp(name, obj.model.nameList)));

        waitbar(i / (length(obj.model.nameList)+1), h, ['process : ' name]);

        % get the polygon from its name
        poly = getPolygonFromName(obj.model, name);

        % calculate the polar signature of the polygon
        sign = polygonSignature(poly, angles);

        % save all the polar signatures in a numeric array 
        dat(i, 1:length(sign)) = sign(:);
    end
    waitbar(length(obj.model.nameList), h);
    % close waitbar
    close(h) 
    
    % create a new figure and display the results of the rotation on this
    % new figure
    model = PolygonsManagerData('PolygonArray', PolarSignatureArray(dat, angles), 'nameList', obj.model.nameList, 'factorTable', obj.model.factorTable, 'pca', obj.model.pca, 'usedProcess', obj.model.usedProcess);
    fen = PolygonsManagerMainFrame;  
    
    setupNewFrame(fen, model);
end

function [start, number] = contoursToSignaturePrompt
%CONTOURSTOSIGNATUREPROMPT  A dialog figure on which the user can select
%which axis will be aligned with the contours
%
%   Inputs : none
%   Outputs : 
%       - start : the starting angle
%       - number : the number of angles

    % default value of the ouput to prevent errors
    start = '?';
    number = '?';

    % get the position where the prompt will at the center of the
    % current figure
    pos = getMiddle(gcf, 250, 165);

    % create the dialog box
    d = dialog('position', pos, ...
                   'name', 'Enter image resolution');

    % create the inputs of the dialog box
    uicontrol('parent', d,...
            'position', [30 115 90 20], ...
               'style', 'text',...
              'string', 'Starting angle :', ...
            'fontsize', 10, ...
 'horizontalalignment', 'right');

    edit = uicontrol('parent', d,...
                   'position', [130 116 90 20], ...
                      'style', 'edit', ...
                     'string', 0);

    uicontrol('parent', d,...
            'position', [30 80 90 20], ...
               'style', 'text',...
              'string', 'Nb of angles :', ...
            'fontsize', 10, ...
 'horizontalalignment', 'right');

    edit2 = uicontrol('parent', d,...
                   'position', [130 81 90 20], ...
                      'style', 'edit', ...
                     'string', 360);


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
            % if both inputs are numeric, get them and close the dialog box
            if ~isnan(str2double(get(edit,'String'))) && ~isnan(str2double(get(edit2,'String')))
                start = str2double(get(edit,'String'));
                number = str2double(get(edit2,'String'));
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