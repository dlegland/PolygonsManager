function setupMenuPolygonsManager(obj)
%SETUPMENUPOLYGONSMANAGER  Creates all the menus of the MainFrame

% create all the main menus
fileMenu = uimenu(obj.handles.figure, 'label', 'F&ile');
editMenu = uimenu(obj.handles.figure, 'label', 'F&actors', 'enable', 'off');
foncMenu = uimenu(obj.handles.figure, 'label', '&Process', 'enable', 'off');
pcaMenu = uimenu(obj.handles.figure, 'label', 'P&ca', 'visible', 'off');
viewMenu = uimenu(obj.handles.figure, 'label', '&View', 'enable', 'off');
contPmenu = uicontextmenu; 
contLmenu = uicontextmenu; 

% add the menus' handles to the list of handles
obj.handles.menus = {fileMenu, editMenu, foncMenu, viewMenu, pcaMenu, contPmenu, contLmenu};

% create the space that will contain all the submenus
obj.handles.submenus = {};

%               ----------------------------------------------------------- FILE

% create all the submenus of the 'file' menu
f1 = uimenu(fileMenu, 'label', '&Import polygons (folder)', ...
                   'callback', @(~,~) importBasicPolygon(obj), ...
                'accelerator', 'N');
f2 = uimenu(fileMenu, 'label', 'Import &concatenated polygons file', ...
                   'callback', @(~,~) importCoordsPolygon(obj));
f3 = uimenu(fileMenu, 'label', '&Import polar signatures file', ...
                   'callback', @(~,~) importPolarSignature(obj));

f4 = uimenu(fileMenu, 'label', 'E&xtract Selection', ...
                   'callback', @(~,~) extractSelectedPolygons(obj), ...
                     'enable', 'off', ...
                'accelerator', 'D', ...
                  'separator', 'on');

f5 = uimenu(fileMenu, 'label', 'Save polygons', ...
                   'callback', @(~,~) savePolygons(obj.model), ...
                     'enable', 'off', ...
                'accelerator', 'S', ...
                  'separator', 'on');
              
% PCA sub-menu
f12 = uimenu(fileMenu, 'label', 'Save pca', ...
                     'enable', 'off');
           uimenu(f12, 'label', '&Means', ...
                    'callback', @(~,~) savePca(obj.model, 'means'));
           uimenu(f12, 'label', '&Scores', ...
                    'callback', @(~,~) savePca(obj.model, 'scores'));
           uimenu(f12, 'label', '&Loadings', ...
                    'callback', @(~,~) savePca(obj.model, 'loadings'));
           uimenu(f12, 'label', '&Eigen values', ...
                    'callback', @(~,~) savePca(obj.model, 'eigenValues'));

f7 = uimenu(fileMenu, 'label', 'Save &macro', ...
                   'callback', @(~,~) saveMacro(obj.model), ...
                     'enable', 'off', ...
                  'separator', 'on', ...
                'accelerator', 'Q');
f8 = uimenu(fileMenu, 'label', '&Load macro', ...
                   'callback', @(~,~) loadMacro(obj), ...
                     'enable', 'off');

f9 = uimenu(fileMenu, 'label', '&Export datas to workspace', ...
                   'callback', @(~,~) exportToWS, ...
                     'enable', 'off', ...
                  'separator', 'on');

f10 = uimenu(fileMenu, 'label', '&Export display', ...
                   'callback', @(~,~) saveView(obj), ...
                     'enable', 'off');

f11 = uimenu(fileMenu, 'label', '&Close', ...
                   'callback', @(~,~) close(gcf), ...
                  'separator', 'on', ...
                'accelerator', 'p');

obj.handles.submenus{1} = {f1, f2, f3, f4, f5, f7, f8, f9, f10, f11, f12};

%               ----------------------------------------------------------- FACTORS

% create all the submenus of the 'factors' menu
e1 = uimenu(editMenu, 'label', 'Import &factors', ...
                   'callback', @(~,~) importFactors(obj), ...
                'accelerator', 'f');
e2 = uimenu(editMenu, 'label', '&Create factors', ...
                   'callback', @(~,~) createFactors(obj));

e3 = uimenu(editMenu, 'label', '&Save factors', ...
                   'callback', @(~,~) saveFactors(obj.model), ...
                     'enable', 'off', ...
                  'separator', 'on');

e4 = uimenu(editMenu, 'label', '&Display factors', ...
                   'callback', @(~,~) showTable(obj.model.factorTable), ...
                     'enable', 'off', ...
                  'separator', 'on');

e5 = uimenu(editMenu, 'label', 'Display &Infos', ...
                   'callback', @(~,~) showTable(obj.model.infoTable), ...
                     'enable', 'on', ...
                  'separator', 'on');

obj.handles.submenus{2} = {e1, e2, e3, e4, e5};

%               ----------------------------------------------------------- PROCESS

% create all the submenus of the 'process' menu
fc1 = uimenu(foncMenu, 'label', 'Rotate &all');
           uimenu(fc1, 'label', '90° &right', ...
                    'callback', @(~,~) polygonsRotate(obj, 90, 'all'));
           uimenu(fc1, 'label', '90° &left', ...
                    'callback', @(~,~) polygonsRotate(obj, 270, 'all'));
           uimenu(fc1, 'label', '&180°', ...
                    'callback', @(~,~) polygonsRotate(obj, 180, 'all'));

fc2 = uimenu(foncMenu, 'label', 'Rotate &selected');
           uimenu(fc2, 'label', '90° &right', ...
                    'callback', @(~,~) polygonsRotate(obj, 90, 'selected'));
           uimenu(fc2, 'label', '90° &left', ...
                    'callback', @(~,~) polygonsRotate(obj, 270, 'selected'));
           uimenu(fc2, 'label', '&180°', ...
                    'callback', @(~,~) polygonsRotate(obj, 180, 'selected'));
           uimenu(fc2, 'label', 'Custom angle C&W', ...
                    'callback', @(~,~) polygonsRotate(obj, 'customCW', 'selected'), ...
                   'separator', 'on');
           uimenu(fc2, 'label', 'Custom angle &CCW', ...
                    'callback', @(~,~) polygonsRotate(obj, 'customCCW', 'selected'));

fc3 = uimenu(foncMenu, 'label', 'Re&center polygons', ...
              'callback', @(~,~) polygonsRecenter(obj), ...
             'separator', 'on');
fc4 = uimenu(foncMenu, 'label', '&Resize polygons', ...
              'callback', @(~,~) polygonsResize(obj));

fc5 = uimenu(foncMenu, 'label', 'Sim&plify polygons', ...
              'callback', @(~,~) polygonsSimplify(obj, 'on'), ...
             'separator', 'on');
fc6 = uimenu(foncMenu, 'label', 'A&lign around symmetry axis');
           uimenu(fc6, 'label', '&Precise', ...
                    'callback', @(~,~) polygonsAlign(obj, 'precise'));
           uimenu(fc6, 'label', '&Fast', ...
                    'callback', @(~,~) polygonsAlign(obj, 'fast'));


fc7 = uimenu(foncMenu, 'label', 'Polar S&ignature Array', ...
              'callback', @(~,~) polygonsToSignature(obj), ...
             'separator', 'on');
fc8 = uimenu(foncMenu, 'label', 'C&oncatenate Polygons', ...
              'callback', @(~,~) polygonsConcatenate(obj));

obj.handles.submenus{3} = {fc1, fc2, fc3, fc4, fc5, fc6, fc7, fc8};

%               ----------------------------------------------------------- PCA

% create all the submenus of the 'pca' menu
pca1 = uimenu(pcaMenu, 'label', '&Compute PCA', ...
                    'callback', @(~,~) computePCA(obj));

pca2 = uimenu(pcaMenu, 'label', 'Display &eigen values', ...
                    'callback', @(~,~) pcaEigen(obj), ...
                      'enable', 'off', ...
                   'separator', 'on');
pca3 = uimenu(pcaMenu, 'label', 'Display &scores', ...
                    'callback', @(~,~) pcaScores(obj), ...
                      'enable', 'off');
pca5 = uimenu(pcaMenu, 'label', 'Display &influence', ...
                    'callback', @(~,~) pcaInfluence(obj), ...
                      'enable', 'off');
pca4 = uimenu(pcaMenu, 'label', 'Display &loadings', ...
                    'callback', @(~,~) pcaLoadings(obj), ...
                      'enable', 'off');
pca6 = uimenu(pcaMenu, 'label', 'Display &profiles', ...
                    'callback', @(~,~) pcaVector(obj), ...
                      'enable', 'off');

pca7 = uimenu(pcaMenu, 'label', '&Display scores + profiles', ...
                    'callback', @(~,~) pcaScoresProfiles(obj), ...
                      'enable', 'off', ...
                   'separator', 'on');

obj.handles.submenus{5} = {pca1, pca2, pca3, pca4, pca5, pca6, pca7};

%               ----------------------------------------------------------- VIEW

% create all the submenus of the 'view' menu
v1 = uimenu(viewMenu, 'label', '&Grid', ...
                   'callback', @(~,~) showGrid, ...
                'accelerator', 'V');
v2 = uimenu(viewMenu, 'label', '&Markers', ...
                   'callback', @(~,~) showMarker, ...
                'accelerator', 'B');

v3 = uimenu(viewMenu, 'label', '&Zoom', ...
                   'callback', @(~,~) zoomMode, ...
                  'separator', 'on', ...
                'accelerator', 'Z');
v4 = uimenu(viewMenu, 'label', '&Reset zoom', ...
                   'callback', @(~,~) zoom('out'));

obj.handles.submenus{4} = {v1, v2, v3, v4};

%               ----------------------------------------------------------- 

% create all the submenus of the context menu of the futur
cp1 = uimenu(contPmenu, 'label', '&Grid', ...
                     'callback', @(~,~) showGrid);
cp2 = uimenu(contPmenu, 'label', '&Markers', ...
                     'callback', @(~,~) showMarker);

cp3 = uimenu(contPmenu, 'label', '&Zoom', ...
                     'callback', @(~,~) zoomMode, ...
                    'separator', 'on');
cp4 = uimenu(contPmenu, 'label', '&Reset zoom', ...
                     'callback', @(~,~) zoom('out'));

obj.handles.submenus{6} = {cp1, cp2, cp3, cp4};

%               ----------------------------------------------------------- 

% create the submenu of the selection list
cl1 = uimenu(contLmenu, 'label', '&Swap selection', ...
                     'callback', @(~,~) swapSelection);

obj.handles.submenus{7} = {cl1};

% -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
% ---------------------------------------------------------------------------- MENU CALLBACKS -----------------------------------------------------------------------------------------------------
% -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function showTable(table)
%SHOWFACTORS  open a new figure that displays the current factor Table
%
%   inputs :
%       - table : table that must be displayed
%   ouputs : none

    % create a figure and display the Table in it
    [hf, ht] = show(table);
    ht.Units = 'pixel';

    if ht.Extent(4) < obj.handles.figure.Position(4)
        % if the Height property of the uitable in which
        % the Table is displayed is lower than the total
        % Height of the MainFrame

        % match the size of the new figure to the size of the
        % uiTable and get the position where the figure
        % will be at the center of the MainFrame
        ht.Position = ht.Extent;
%         pos = getMiddle(obj.handles.figure, ht.Position(3), ht.Position(4));
        pos = getMiddle(obj, ht.Position(3), ht.Position(4));
        
    else
        % get the position where the new figure will be at
        % the center of the MainFrame with the same Height
        % as the MainFrame and make the uiTable take all
        % the place it can
                                            % +16 = scrollbar
        pos = getMiddle(obj.handles.figure, ht.Extent(3)+16, obj.handles.figure.Position(4));
        ht.Units = 'normalized';
        ht.Position = [0 0 1 1];
    end
    % set the position of the new figure
    hf.Position = pos;
end

function showGrid
%SHOWGRID  display the grids on an axis and updates the menus
    if strcmp(v1.Checked, 'off')
        set(v1, 'checked', 'on');
        set(cp1, 'checked', 'on');
        set(obj.handles.Panels{obj.handles.tabs.Selection}.uiAxis, 'xgrid', 'on');
        set(obj.handles.Panels{obj.handles.tabs.Selection}.uiAxis, 'ygrid', 'on');
    else
        set(v1, 'checked', 'off');
        set(cp1, 'checked', 'off');
        set(obj.handles.Panels{obj.handles.tabs.Selection}.uiAxis, 'xgrid', 'off');
        set(obj.handles.Panels{obj.handles.tabs.Selection}.uiAxis, 'ygrid', 'off');
    end 
end

function showMarker
%SHOWMARKER  display the marker on the lines of an axis and updates th menus
    if strcmp(v2.Checked, 'off')
        set(v2, 'checked', 'on');
        set(cp2, 'checked', 'on');
        set(obj.handles.Panels{obj.handles.tabs.Selection}.uiAxis.Children, 'Marker', '+');
    else
        set(v2, 'checked', 'off');
        set(cp2, 'checked', 'off');
        set(obj.handles.Panels{obj.handles.tabs.Selection}.uiAxis.Children, 'Marker', 'none');
    end
end

function swapSelection
%SWAPSELECTION  unselects all the selected polygons and selects all the unselected

    % get the complete list of polygons' name
    liste = obj.model.nameList;

    % memory allocation
    nonSelVal=zeros(length(liste),1);


    for i = 1:length(liste)
        % for each polygons
        if ~ismember(i, get(obj.handles.list, 'value'))
            % if the polygon is not selected, save it
            nonSelVal(i) = i;
        end
    end

    % delete all the zeros of the not selected polygons list
    nonSelVal = nonSelVal(nonSelVal~=0);

    % set the unselected polygons as the selected polygons
    set(obj.handles.list, 'value', nonSelVal)
    obj.model.selectedPolygons = liste(nonSelVal);

    %update the view
    updateSelectedPolygonsDisplay(obj.handles.Panels{obj.handles.tabs.Selection});
end

function zoomMode
%ZOOMMODE activate/deactive the zoom and updates the menu
    if strcmp(v3.Checked, 'off')
        set(v3, 'checked', 'on');
        set(cp3, 'checked', 'on');
        zoom('on');
    else
        set(v3, 'checked', 'off');
        set(cp3, 'checked', 'off');
        zoom('off');
    end
end

function exportToWS
%EXPORTTOWS export the gathered datas to matlab's workspace

    if isa(obj.model.PolygonArray, 'BasicPolygonArray')
        % export the polygons as a cell array of cell arrays 
        assignin('base', 'polygons', obj.model.PolygonArray.polygons);
        
    elseif isa(obj.model.PolygonArray, 'CoordsPolygonArray')
        % export the polygons as a Table
        nCols = size(obj.model.PolygonArray.polygons, 2)/2;
        colnames = [cellstr(num2str((1:nCols)', 'x%d'))' cellstr(num2str((1:nCols)', 'y%d'))'];

        assignin('base', 'polygons', Table.create(obj.model.PolygonArray.polygons, ...
                                                  'rowNames', obj.model.nameList, ...
                                                  'colNames', colnames));
    else
        % export the polar signatures as a table
        colnames = cellstr(num2str(obj.model.PolygonArray.angleList'));

        assignin('base', 'signatures', Table.create(obj.model.PolygonArray.signatures, ...
                                                  'rowNames', obj.model.nameList, ...
                                                  'colNames', colnames'));
    end
    
    if isa(obj.model.factorTable, 'Table')
        % if there's one, export the factor Table
        assignin('base', 'factors', obj.model.factorTable);
    end
    
    if isa(obj.model.pca, 'Pca')
        % if that PCA has been computed, export it
        assignin('base', 'pca', obj.model.pca);
    end
    
    % export the informations concerning the polygons
    assignin('base', 'informations', obj.model.infoTable);
end

end