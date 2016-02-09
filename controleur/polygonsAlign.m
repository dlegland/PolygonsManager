function polygonsAlign(obj, type, varargin)
%POLYGONSALIGN  Rotate all slab contours such that they are aligned with one of the axis
%
%   Inputs :
%       - obj : handle of the MainFrame
%       - type : determines the type of alignement. Values :
%           - slow : classic alignement
%           - fast : the polygons will be simplified to get an
%           approximation of the rotation angles that must be used, and
%           these angles will be used on the initial polygons
%           - contains a cell array : the array containing the list of
%           angles that must be used during the alignement
%       - varargin : contains the parameters if the function is called from
%       a macro
%   Outputs : none

% select which axis the contours will be aligned with
if nargin == 2
    % if the function is called normally
    axis = contoursAlignPrompt;
else
    % if the function is called from a macro
    axis = varargin{1};
    if nargin > 3 
        % if the function is called from a macro and has the 'fast' type
        tolerence = varargin{2};
    end
end

if ~strcmp(axis, '?')
    % preallocating memory
    polygonArray = cell(1,length(obj.model.nameList));
    
    % prepare the array containing the angles
    if iscell(type)
        % if the array has been predetermined, use it
        angleArray = type;
    else
        % if the array has never been computed, allocate memory ro store it
        angleArray = cell(length(obj.model.nameList), 1);
        if strcmp(type, 'fast')
            % if the function has the 'fast' type
            if exist('tolerence', 'var')
                % if the function is called from a macro (tolerence already known)
                % get the list of simplified polygon using the tolerence
                polygons = polygonsSimplify(obj, 'off', tolerence);
                macro = 'on';
            else
                % if the function isn't called from a macro (tolerence unknown)
                % call the polygonsSimplufy function and get both the list
                % of simplified polygons and the tolerence used during the
                % simplification
                [polygons, tolerence] = polygonsSimplify(obj, 'off');
                macro = 'off';
                if strcmp(tolerence, '?')
                    return;
                end
            end
            
            % save the name of the function and the parameters used during
            % its call in the log variable
            obj.model.usedProcess{end+1} = ['polygonsAlign : type = ' type ' ; axis = ' axis ' ; tolerence = ' num2str(tolerence)];
        else 
            obj.model.usedProcess{end+1} = ['polygonsAlign : type = ' type ' ; axis = ' axis];
        end
    end
    
    % create waitbar
    h = waitbar(0,'Please wait...', 'name', 'Polygons aligning');
    for i = 1:length(obj.model.nameList)
        % get the name of the polygon that will be rotated
        name = obj.model.nameList{i};
        
        % update the waitbar and the contours selection (purely cosmetic)
        obj.model.selectedPolygons = name;
        updateSelectedPolygonsDisplay(obj.handles.Panels{obj.handles.tabs.Selection});
        set(obj.handles.list, 'value', find(strcmp(name, obj.model.nameList)));

        waitbar(i / (length(obj.model.nameList)+1), h, ['process : ' name]);
        
        % get the polygon from its name
        if strcmp(type, 'fast')
            poly = getPolygonFromName(polygons, name);
        else
            poly = getPolygonFromName(obj.model, name);
        end

        if strcmp(axis, 'x-axis')
            % compute symmetric wrt the horizontal axis
            polySym = [poly(:,1) -poly(:,2)];
        else
            % compute symmetric wrt the vertical axis
            polySym = [-poly(:,1) poly(:,2)];
        end
        
        if cellfun('isempty', angleArray(i))
            % determines the rotation angle that best matches the polygon with the
            % rotated polygon
            angleArray{i} = fminbnd(...
                    @(theta) sum(distancePointPolygon(transformPoint(polySym, createRotation(theta)), poly).^2), ...
                    -pi/4, pi/4);
        end
        
        % divide angle by 2 for aligning polygon with axis
        rot     = createRotation(-angleArray{i}/2);
        polyRot = transformPoint(poly, rot);

        polygonArray{i} = polyRot;
    end
    waitbar(1, h);
    
    % close waitbar
    close(h) 
    
    if strcmp(type, 'fast')
        % if the function was called with the 'fast' parameter, recall it
        % with the list of angles as the type parameter
        polygonsAlign(obj, angleArray, axis, macro);
    else
        % create the PolygonsManagerData that'll be used as the new
        % PolygonsManagerMainFrame's model
        model = PolygonsManagerData('PolygonArray', BasicPolygonArray(polygonArray), 'nameList', obj.model.nameList, 'factorTable', obj.model.factorTable, 'pca', obj.model.pca, 'usedProcess', obj.model.usedProcess);
        
        if nargin == 2
            % create a new PolygonsManagerMainFrame
            fen = PolygonsManagerMainFrame;  
            
            % prepare the new PolygonsManagerMainFrame and display the graph
            setupNewFrame(fen, model);
        else
            if strcmp(varargin{2}, 'off')
                % create a new PolygonsManagerMainFrame
                fen = PolygonsManagerMainFrame;
                
                % prepare the new PolygonsManagerMainFrame and display the graph
                setupNewFrame(fen, model);
            else
                % update the model of the current PolygonsManagerMainFrame
                obj.model = model;
                
                % display the graph
                displayPolygons(obj.handles.Panels{1}, getAllPolygons(obj.model.PolygonArray));
            end
        end
    end
end

function axe = contoursAlignPrompt
%CONTOURSALIGNPROMPT  A dialog figure on which the user can select
%which axis will be aligned with the contours
%
%   Inputs : none
%   Outputs : selected axis

    % default value of the ouput to prevent errors
    axe = '?';

    % get the position where the prompt will at the center of the
    % current figure
    pos = getMiddle(gcf, 250, 130);

    % create the dialog box
    d = dialog('position', pos, ...
                   'name', 'Select axis of rotation');

    % create the inputs of the dialog box
    group = uibuttongroup('visible', 'on');

    uicontrol('parent', group, ...
            'position', [45 80 90 20], ...
               'style', 'radiobutton', ...
              'string', 'x-axis');

    uicontrol('parent', group, ...
            'position', [145 80 90 20], ...
               'style', 'radiobutton', ...
              'string', 'y-axis');

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
        % get the value of the selected radio button
        axe = group.SelectedObject.String;
        
        % delete the dialog
        delete(gcf);
    end
end
end
