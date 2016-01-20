function contoursConvertPxMm(~,~, obj)
%CONTOURSCONVERTPXMM  Converts contours units to user untis (millimeters)
%
%   Inputs :
%       - ~ (not used) : inputs automatically send by matlab during a callback
%       - obj : handle of the MainFrame
%   Outputs : none


polygonList = cell(1, length(obj.model.nameList));
resol = contoursConvertPxMmPrompt;

if ~strcmp(resol, '?')
    h = waitbar(0,'Conversion starting ...', 'name', 'Conversion');
    for i = 1:length(polygonList)

        name = obj.model.nameList{i};

        poly = getPolygonFromName(obj.model, name);

        polyMm = poly * resol;

        updatePolygon(obj.model.PolygonArray, getPolygonIndexFromName(obj.model, name), polyMm);
        waitbar(i / length(polygonList), h, ['process : ' name]);
    end
    close(h) 
    ud = obj.model.selectedFactor;
    if iscell(ud)
        polygonList = getPolygonsFromFactor(obj.model, ud{1});
        displayPolygonsFactor(obj, polygonList);
    else
        displayPolygons(obj, getAllPolygons(obj.model.PolygonArray));
        if isa(obj.model.PolygonArray, 'PolarSignatureArray')
            displayPolarSignature(obj, obj.model.PolygonArray);
        end
    end
end

    function resol = contoursConvertPxMmPrompt
        
        resol = '?';
        
        pos = getMiddle(gcf, 250, 130);

        d = dialog('position', pos, ...
                       'name', 'Enter image resolution');

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

        uicontrol('parent', d,...
                'position', [30 30 85 25], ...
                  'string', 'Cancel',...
                'callback', 'delete(gcf)');

        uicontrol('parent', d,...
                'position', [135 30 85 25], ...
                  'string', 'Validate',...
                'callback', @callback);

        % Wait for d to close before running to completion
        uiwait(d);

        function callback(~,~)
            try
                if ~isnan(str2double(get(edit,'String')))
                    resol = str2double(get(edit,'String'));
                    delete(gcf);
                else
                    if find(ismember(get(edit,'String'), ['\', '¨', '/', '*', '+', '-'])) ~= 0
                        resol = eval(get(edit,'String'));
                        delete(gcf);
                    else
                        set(error, 'visible', 'on');
                    end
                end
            catch
                set(error, 'visible', 'on');
            end
        end
    end

end