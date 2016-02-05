function dividePolygonArray(obj)
%DIVIDEPOLYGONARRAY  Isolate some of the current polygons and display them
%in a new frame
%
%   Inputs :
%       - obj : handle of the MainFrame
%   Outputs : none

    % select which polygons must be isolated
    [method, factor, level] = dividePolygonArrayPrompt;
    
    if ~strcmp(method, '?')
        % get the list of names of the polygons that'll be isolated
        if strcmp(method, 'Selection')
            if strcmp(factor, 'Display selected')
                nameArray = obj.model.selectedPolygons;
            else
                nameArray = setdiff(obj.model.nameList, obj.model.selectedPolygons);
            end
        else
            nameArray = getPolygonsNameFromFactor(obj.model, factor, level);
        end
       
        if strcmp(class(obj.model.factorTable), 'Table')
            % if there was already a factor Table loaded, update it to
            % match the new polygons
            
            % memory allocation
            factorTbl = zeros(length(nameArray), columnNumber(obj.model.factorTable));

            %for each row of the imported factor Table
            for i = 1:rowNumber(obj.model.factorTable)
                % find the polygon that contains the current row's name
                index = not(cellfun('isempty', ...
                        strfind(nameArray, obj.model.factorTable.rowNames{i})));

                % if one of the polygons contains the name of the current row
                if any(index, 2) ~= 0
                    % save this row in the futur factor Table at the right
                    % index
                    factorTbl(index, :) = getRow(obj.model.factorTable, i);
                end
            end
            factorTbl = Table.create(factorTbl, 'rowNames', nameArray, 'colNames', obj.model.factorTable.colNames);
            
            % set the levels of the new factor Table
            for i = 1:length(obj.model.factorTable.levels)
                if isFactor(obj.model.factorTable, i)
                    setFactorLevels(factorTbl, i, obj.model.factorTable.levels{i});
                else
                    setAsFactor(factorTbl, i);
                end
            end
            factorTbl.name = obj.model.factorTable.name;
        else
            factorTbl = [];
        end
        
        % create a new mainframe
        fen = PolygonsManagerMainFrame;
        
        if strcmp(class(obj.model.PolygonArray), 'BasicPolygonArray')
            % if the current polygons are Basic polygons
            polygons = cell(length(nameArray), 1);
            
            % get all the polygons
            for i = 1:length(nameArray)
                polygons{i} = getPolygonFromName(obj.model, nameArray{i});
            end
            
            % create the data model of the new frame
            model = PolygonsManagerData('PolygonArray', BasicPolygonArray(polygons), 'nameList', nameArray, 'factorTable', factorTbl);

        elseif strcmp(class(obj.model.PolygonArray), 'CoordsPolygonArray')
            % if the current polygons are already simplified polygons
            polygons = zeros(length(nameArray), getPolygonSize(obj.model.PolygonArray));
            
            % get all the polygons
            for i = 1:length(nameArray)
                polygons(i, :) = getPolygonRowFromName(obj.model, nameArray{i});
            end
            
            % create the data model of the new frame
            model = PolygonsManagerData('PolygonArray', CoordsPolygonArray(polygons), 'nameList', nameArray, 'factorTable', factorTbl);

        elseif strcmp(class(obj.model.PolygonArray), 'PolarSignatureArray')
            % if the current polygons are saved as polar signatures
            polygons = zeros(length(nameArray), getPolygonSize(obj.model.PolygonArray));
            
            angles = obj.model.PolygonArray.angleList;
            
            % get all the polygons
            for i = 1:length(nameArray)
                polygons(i, :) = getSignatureFromName(obj.model, nameArray{i});
            end
            
            % create the data model of the new frame
            model = PolygonsManagerData('PolygonArray', PolarSignatureArray(polygons, angles), 'nameList', nameArray, 'factorTable', factorTbl);
        end
        
        %setup the frame
        setupNewFrame(fen, model);
    end
    
    function [method, factor, level] = dividePolygonArrayPrompt  
%COLORFACTORPROMPT  A dialog figure on which the user can select
%which factor he wants to see colored and if he wants to display the
%legend or not
%
%   Inputs : none
%   Outputs : 
%       - factor : selected factor
%       - leg : display option of the legend

    % default value of the ouput to prevent errors
    method = '?';
    factor = '?';
    level = '?';

    % get the position where the prompt will at the center of the
    % current figure
    pos = getMiddle(gcf, 250, 200);

    % create the dialog box
    d = dialog('Position', pos, ...
                   'Name', 'Select one factor');

    % create the inputs of the dialog box
    group1 = uibuttongroup('visible', 'on', ...
               'SelectionChangedFcn',@(~,~) swapMethod);

    uicontrol('parent', group1, ...
            'position', [45 150 90 20], ...
               'style', 'radiobutton', ...
              'string', 'Selection');

    b2 = uicontrol('parent', group1, ...
                 'position', [145 150 90 20], ...
                    'style', 'radiobutton', ...
                   'string', 'Factor', ...
                   'enable', 'off');
               
    % create the inputs of the dialog box
    group2 = uibuttongroup('parent', d, ...
                         'position', [0 0 1 0.7], ...
                       'bordertype', 'none', ...
                          'visible', 'on');

    uicontrol('parent', group2, ...
            'position', [30 115 210 20], ...
               'style', 'radiobutton', ...
              'string', 'Display selected');

    uicontrol('parent', group2, ...
            'position', [30 80 210 20], ...
               'style', 'radiobutton', ...
              'string', 'Display non-selected');
          
    if strcmp(class(obj.model.factorTable), 'Table')
        set(b2, 'enable', 'on');
    
        factorP{1} = uicontrol('parent', d, ...
                            'position', [30 115 90 20], ...
                               'style', 'text', ...
                              'string', 'Factor :', ...
                            'fontsize', 10, ...
                 'horizontalalignment', 'right', ...
                             'visible', 'off');

        factorP{2} = uicontrol('Parent', d, ...
                            'Position', [130 117 90 20], ...
                               'Style', 'popup', ...
                              'string', obj.model.factorTable.colNames, ...
                               'value', 1, ...
                             'visible', 'off', ...
                            'callback', @(~,~) popupCallback);

        factorP{3} = uicontrol('parent', d, ...
                            'position', [30 80 90 20], ...
                               'style', 'text', ...
                              'string', 'Level :', ...
                            'fontsize', 10, ...
                 'horizontalalignment', 'right', ...
                             'visible', 'off');

        factorP{4} = uicontrol('parent', d, ...
                            'position', [130 82 90 20], ...
                               'style', 'popup', ...
                              'string', obj.model.factorTable.levels{1}, ...
                             'visible', 'off');
    end

    % create the two button to cancel or validate the inputs
    uicontrol('parent', d, ...
            'position', [30 30 85 25], ...
              'string', 'Validate',...
            'callback', @(~,~) callback);

    uicontrol('parent', d, ...
            'position', [135 30 85 25], ...
              'string', 'Cancel',...
            'callback', 'delete(gcf)');

    % Wait for d to close before running to completion
    uiwait(d);

    function callback
        method = group1.SelectedObject.String;
        if strcmp(method, 'Selection')
            factor = group2.SelectedObject.String;
        else
            list = factorP{2}.String;
            value = factorP{2}.Value;
            factor = list(value);
            list = factorP{4}.String;
            value = factorP{4}.Value;
            level = list(value);
        end
        delete(gcf);
    end
    
    function popupCallback
        set(factorP{4}, 'string', obj.model.factorTable.levels{factorP{2}.Value});
    end
    
    function swapMethod
        if strcmp(group1.SelectedObject.String, 'Factor')
            set(group2, 'visible', 'off');
            set([factorP{:}], 'visible', 'on');
        else
            set(group2, 'visible', 'on');
            set([factorP{:}], 'visible', 'off');
        end
    end
end
  
end