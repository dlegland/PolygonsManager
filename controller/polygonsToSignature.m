function polygonsToSignature(frame, varargin)
%POLYGONSTOSIGNATURE  Converts contour in polar signatures
%
%   Inputs :
%       - obj : handle of the MainFrame
%       - varargin : contains the parameters if the function is called from
%       a macro
%   Outputs : none

% select the starting angle and the number of angle that will be used during
% the transformation
if nargin == 1
    [startAngle, angleNumber] = contoursToSignaturePrompt;
else
    if ~isa(varargin{1}, 'double')
        startAngle = str2double(varargin{1});
    else
        startAngle = varargin{1};
    end
    if ~isa(varargin{1}, 'double')
        angleNumber = str2double(varargin{2});
    else
        angleNumber = varargin{1};
    end
end


if strcmp(startAngle, '?')
    return;
end

% save the name of the function and the parameters used during
% its call in the log variable
frame.model.usedProcess{end+1} = ['polygonsToSignature : startAngle = ' num2str(startAngle) ' ; angleNumber = ' num2str(angleNumber)];

% determine the angles that will be used for the transformation
pas = 360/angleNumber;
angles = startAngle:pas:360+startAngle-pas;

% preallocating memory
nPolys = length(frame.model.nameList);
dat = zeros(nPolys, angleNumber);

% create waitbar
h = waitbar(0,'Conversion starting ...', 'name', 'Conversion to signature');

for i = 1:nPolys
    % get the name of the polygon that will be transformed
    name = getPolygonName(frame.model, i);
    
    % update the waitbar and the contours selection (purely cosmetic)
    setSelectedPolygonIndices(frame.model, i);
    updateSelectedPolygonsDisplay(getActivePanel(frame));
    set(frame.handles.list, 'value', i);
    
    waitbar(i / (length(frame.model.nameList)+1), h, ['process : ' name]);
    
    % get the polygon from its name
    poly = getPolygon(frame.model.polygonList, i);
    
    % save all the polar signatures in a numeric array
    dat(i, :) = polygonSignature(poly, angles);
end

% close waitbar
waitbar(1, h);
close(h);

% create the PolygonsManagerData that'll be used as the new
% PolygonsManagerMainFrame's model
newArray = PolarSignatureArray(dat, angles);
model = PolygonsManagerData(newArray, 'parent', frame.model);

% create a new PolygonsManagerMainFrame
PolygonsManagerMainFrame(model);

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
    pos = getMiddle(frame, 250, 165);

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