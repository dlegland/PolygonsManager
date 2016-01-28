function polygonsAlign(obj)
%POLYGONSALIGN  Rotate all slab contours such that they are aligned with
%one of the axis
%
%   Inputs :
%       - obj : handle of the MainFrame
%   Outputs : none

% select which axis the contours will be aligned with
axis = contoursAlignPrompt;
tic;
if ~strcmp(axis, '?')
    % preallocating memory
    polygonArray = cell(1,length(obj.model.nameList));
    
    save = 0;
    if any(obj.model.PolygonArray.alignAngles, 2) == 0
        save = 1;
    end
    disp(save);
    % create waitbar
    h = waitbar(0,'Please wait...', 'name', 'Alignement des contours');
    for i = 1:length(obj.model.nameList)
        % get the name of the polygon that will be rotated
        name = obj.model.nameList{i};
        
        % update the waitbar and the contours selection (purely cosmetic)
        obj.model.selectedPolygons = name;
        updateSelectedPolygonsDisplay(obj.handles.Panels{obj.handles.tabs.Selection});
        set(obj.handles.list, 'value', find(strcmp(name, obj.model.nameList)));

        waitbar(i / (length(obj.model.nameList)+1), h, ['process : ' name]);
        
        % get the polygon from its name
        poly = getPolygonFromName(obj.model, name);

        if strcmp(axis, 'x-axis')
            % compute symmetric wrt the horizontal axis
            polySym = [poly(:,1) -poly(:,2)];
        else
            % compute symmetric wrt the vertical axis
            polySym = [-poly(:,1) poly(:,2)];
        end
        
        if save == 1
            % determines the rotation angle that best matches the polygon with the
            % rotated polygon
            obj.model.PolygonArray.alignAngles(i) = fminbnd(...
                                                    @(theta) sum(distancePointPolygon(transformPoint(polySym, createRotation(theta)), poly).^2), ...
                                                    -pi/4, pi/4);
        end

        % divide angle by 2 for aligning polygon with axis
        rot     = createRotation(-obj.model.PolygonArray.alignAngles(i)/2);
        polyRot = transformPoint(poly, rot);

        polygonArray{i} = polyRot;
    end
    waitbar(length(obj.model.nameList), h);
        
    % close waitbar
    close(h) 
    
    % create a new figure and display the results of the rotation on this
    % new figure  
    model = PolygonsManagerData('PolygonArray', BasicPolygonArray(polygonArray), 'nameList', obj.model.nameList, 'factorTable', obj.model.factorTable, 'pca', obj.model.pca);
    
    fen = PolygonsManagerMainFrame;  
    setupNewFrame(fen, model);
end
toc;
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
            'position', [145 82 90 20], ...
               'style', 'radiobutton', ...
              'string', 'y-axis');

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
        % get the value of the selected radio button and close the
        % dialog box
        axe = group.SelectedObject.String;
        delete(gcf);
    end
end

end