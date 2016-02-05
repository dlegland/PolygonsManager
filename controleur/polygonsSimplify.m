function varargout = polygonsSimplify(obj, display,  varargin)
%POLYGONSSIMPLIFY  Simplify the current polygons
%
%   Inputs :
%       - obj : handle of the MainFrame
%   Outputs : none

% enter the resolution of the image to make the conversion
if nargin == 2
    tolerence = polygonsSimplifyPrompt;
else
    if ~strcmp(class(varargin{1}), 'double')
        tolerence = str2double(varargin{1});
    else
        tolerence = varargin{1};
    end
end

if ~strcmp(tolerence, '?')
    
    if strcmp(display, 'off')
        obj.model.usedProcess{end+1} = ['polygonsSimplify : display = ' display ' ; tolerence = ' num2str(tolerence)];
    end
    % memory allocation
    polygonArray = cell(1,length(obj.model.nameList));

    for i = 1:length(polygonArray)
        % get the name of the polygon that will be converted
        name = obj.model.nameList{i};

        % get the polygon from its name
        poly = getPolygonFromName(obj.model, name);
        
        % convert the polygon
        polyS = simplifyPolygon(poly, tolerence);

        polygonArray{i} = polyS;
    end
    
    if strcmp(display, 'off')
        varargout{1} = PolygonsManagerData('PolygonArray', BasicPolygonArray(polygonArray), 'nameList', obj.model.nameList, 'factorTable', obj.model.factorTable, 'pca', obj.model.pca, 'usedProcess', obj.model.usedProcess);
        if nargout == 2
            varargout{2} = tolerence;
        end
    else
        if nargin == 2
            % create a new figure and display the results of the rotation on this
            % new figure  
            model = PolygonsManagerData('PolygonArray', BasicPolygonArray(polygonArray), 'nameList', obj.model.nameList, 'factorTable', obj.model.factorTable, 'pca', obj.model.pca, 'usedProcess', obj.model.usedProcess);

            fen = PolygonsManagerMainFrame;  
            setupNewFrame(fen, model);
        else
            polygons = BasicPolygonArray(polygonArray);
            obj.model.PolygonArray = polygons;
            updatePolygonInfos(obj.model, name)
        end
    end
end

function tol = polygonsSimplifyPrompt
%POLYGONSSIMPLIFYPROMPT  A dialog figure on which the user can select type
%the simplification's tolerence
%
%   Inputs : none
%   Outputs : resolution of the image

    % default value of the ouput to prevent errors
    tol = '?';

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
              'string', 'Tolerence :', ...
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
            'callback', @(~,~) callback);

    uicontrol('parent', d, ...
            'position', [135 30 85 25], ...
              'string', 'Cancel', ...
            'callback', 'delete(gcf)');

    % Wait for d to close before running to completion
    uiwait(d);

    function callback
        try
            if ~isnan(str2double(get(edit,'String')))
            % if the input numeric then get its value and close the dialog box
                tol = str2double(get(edit,'String'));
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