function contoursRotate(~,~,obj)
%ROTATECONTOURS  Rotate all slab contours such that they point upwards
%
%   Inputs are in slabs/tables/contoursMm
%   Outputs are in slabs/tables/contoursMmCR
%   (CR stands for centered and rotated)
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2009-06-18,    using Matlab 7.7.0.471 (R2008b)
% Copyright 2009 INRA - Cepia Software Platform.

polygonArray = cell(1,length(obj.model.nameList));

axis = contoursRotatePrompt;
if ~strcmp(axis, '?')
    h = waitbar(0,'Please wait...', 'name', 'Alignement des contours');
    for i = 1:length(obj.model.nameList)
        name = obj.model.nameList{i};

        obj.model.selectedPolygons = name;
        selection(obj);
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
    setPolygonArray(fen, obj.model.nameList, polygons);
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