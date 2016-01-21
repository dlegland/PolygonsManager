function contoursAlign(~,~,obj)
%CONTOURSALIGN  Rotate all slab contours such that they arre aligned with
%one of the axis
%
%   Inputs :
%       - ~ (not used) : inputs automatically send by matlab during a callback
%       - obj : handle of the MainFrame
%   Outputs : none

polygonArray = cell(1,length(obj.model.nameList));

axis = contoursRotatePrompt;
if ~strcmp(axis, '?')
    h = waitbar(0,'Please wait...', 'name', 'Alignement des contours');
    for i = 1:length(obj.model.nameList)
        name = obj.model.nameList{i};

        obj.model.selectedPolygons = name;
        updateSelectedPolygonsDisplay(obj);
        set(obj.handles.list, 'value', find(strcmp(name, obj.model.nameList)));

        waitbar(i / length(obj.model.nameList), h, ['process : ' name]);

        poly = getPolygonFromName(obj.model, name);

        if strcmp(axis, 'x-axis')
            % compute symmetric wrt the horizontal axis
            polySym = [poly(:,1) -poly(:,2)];
        else
            % compute symmetric wrt the vertical axis
            polySym = [-poly(:,1) poly(:,2)];
        end

        % determines the rotation angle that best matches the polygon with the
        % rotated polygon

        thetaMin = fminbnd(...
        @(theta) sum(distancePointPolygon(transformPoint(polySym, createRotation(theta)), poly).^2), ...
        -pi/4, pi/4);

        % divide angle by 2 for aligning polygon with vertical axis
        rot     = createRotation(-thetaMin/2);
        polyRot = transformPoint(poly, rot);

        polygonArray{i} = polyRot;
        
    %     updatePolygon(obj.model.PolygonArray, getPolygonIndexFromName(obj.model, name), polyRot);
    end
    close(h) 
    fen = MainFrame;    
    polygons = BasicPolygonArray(polygonArray);
    if isa(obj.model.factorTable, 'Table')
        setPolygonArray(fen, obj.model.nameList, polygons, obj.model.factorTable);
    else
        setPolygonArray(fen, obj.model.nameList, polygons);
    end
end

    function axe = contoursRotatePrompt
        
        axe = '?';
        
        pos = getMiddle(gcf, 250, 130);

        d = dialog('position', pos, ...
                       'name', 'Select axis of rotation');

        group = uibuttongroup('visible', 'on');
        
        uicontrol('parent', group, ...
                'position', [45 80 90 20], ...
                   'style', 'radiobutton', ...
                  'string', 'x-axis');

        uicontrol('parent', group, ...
                'position', [145 82 90 20], ...
                   'style', 'radiobutton', ...
                  'string', 'y-axis');

        uicontrol('parent', d, ...
                'position', [30 30 85 25], ...
                  'string', 'Cancel', ...
                'callback', 'delete(gcf)');

        uicontrol('parent', d, ...
                'position', [135 30 85 25], ...
                  'string', 'Validate', ...
                'callback', @callback);

        % Wait for d to close before running to completion
        uiwait(d);

        function callback(~,~)
            axe = group.SelectedObject.String;
            delete(gcf);
        end
    end

end