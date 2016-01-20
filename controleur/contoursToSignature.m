function contoursToSignature(~,~, obj)
%CONTOURSTOSIGNATURE  Converts polygons in polar signatures
%
%   Inputs :
%       - ~ (not used) : inputs automatically send by matlab during a callback
%       - obj : handle of the MainFrame
%   Outputs : none

[startAngle, angleNumber] = contoursToSignaturePrompt;
if ~strcmp(startAngle, '?')
    pas = 360/angleNumber;
    angles = startAngle:pas:360+startAngle-pas;
    
    dat = zeros(length(obj.model.nameList), angleNumber);

    h = waitbar(0,'Conversion starting ...', 'name', 'Conversion');
    for i = 1:length(obj.model.nameList)

        name = obj.model.nameList{i};

        obj.model.selectedPolygons = name;
        updateSelectedPolygonsDisplay(obj);
        set(obj.handles.list, 'value', find(strcmp(name, obj.model.nameList)));

        waitbar(i / length(obj.model.nameList), h, ['process : ' name]);

        poly = getPolygonFromName(obj.model, name);

        sign = polygonSignature(poly, angles);

        dat(i, 1:length(sign)) = sign(:);
    end
    close(h);

    fen = MainFrame;
    polygons = PolarSignatureArray(dat, angles);
    setPolygonArray(fen, obj.model.nameList, polygons);
end
    function [start, number] = contoursToSignaturePrompt
        
        start = '?';
        number = '?';
        
        pos = getMiddle(gcf, 250, 165);

        d = dialog('position', pos, ...
                       'name', 'Enter image resolution');

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