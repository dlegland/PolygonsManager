function setupMenuPolygonsManager(obj)
%SETUPMENUPOLYGONSMANAGER  Creates all the menus of the MainFrame

% create all the main menus
fileMenu = uimenu(obj.handles.figure, 'label', '&File');
editMenu = uimenu(obj.handles.figure, 'label', '&Edit');
factMenu = uimenu(obj.handles.figure, 'label', 'F&actors', 'enable', 'off');
foncMenu = uimenu(obj.handles.figure, 'label', '&Process', 'enable', 'off');
pcaMenu = uimenu(obj.handles.figure, 'label', 'P&ca', 'visible', 'off');
viewMenu = uimenu(obj.handles.figure, 'label', '&View', 'enable', 'off');
contPmenu = uicontextmenu; 
contLmenu = uicontextmenu; 

% build menubar data structure
menubar.file.handle = fileMenu;
menubar.edit.handle = editMenu;
menubar.factors.handle = factMenu;
menubar.process.handle = foncMenu;
menubar.view.handle = viewMenu;
menubar.pca.handle = pcaMenu;


%               ----------------------------------------------------------- FILE

% create all the submenus of the 'file' menu
menubar.file.openFolder.handle = uimenu(fileMenu, ...
    'label', '&Import polygons (folder)', ...
    'callback', @(~,~) importBasicPolygon(obj), ...
    'accelerator', 'N');

menubar.file.openFile.handle = uimenu(fileMenu, ...
    'label', 'Import &concatenated polygons file', ...
    'callback', @(~,~) importCoordsPolygon(obj));
               
menubar.file.openPolarSignatures.handle = uimenu(fileMenu, ...
    'label', '&Import polar signatures file', ...
    'callback', @(~,~) importPolarSignature(obj));

menubar.file.openDemoPolygonList.handle = uimenu(fileMenu, ...
    'label', '&Import demo polygon list', ...
    'callback', @(~,~) importDemoPolygonList(obj), ...
    'separator', 'on');
               
menubar.file.openDemoPolygonArray.handle = uimenu(fileMenu, ...
    'label', '&Import demo polygon Array', ...
    'callback', @(~,~) importDemoPolygonArray(obj));
               
menubar.file.savePolygons.handle = uimenu(fileMenu, ...
    'label', 'Save polygons', ...
    'callback', @(~,~) savePolygons(obj.model), ...
    'enable', 'off', ...
    'accelerator', 'S', ...
    'separator', 'on');

menubar.file.saveMacro.handle = uimenu(fileMenu, 'label', 'Save &macro', ...
                   'callback', @(~,~) saveMacro(obj.model), ...
                     'enable', 'off', ...
                  'separator', 'on', ...
                'accelerator', 'Q');
menubar.file.loadMacro.handle = uimenu(fileMenu, 'label', '&Load macro', ...
                   'callback', @(~,~) loadMacro(obj), ...
                     'enable', 'off');

menubar.file.exportToWorkspace.handle = uimenu(fileMenu, 'label', '&Export datas to workspace', ...
                   'callback', @(~,~) exportToWS, ...
                     'enable', 'off', ...
                  'separator', 'on');

menubar.file.exportDisplay.handle = uimenu(fileMenu, 'label', '&Export display', ...
                   'callback', @(~,~) saveView(obj), ...
                     'enable', 'off');

menubar.file.close.handle = uimenu(fileMenu, 'label', '&Close', ...
                   'callback', @(~,~) close(gcf), ...
                  'separator', 'on', ...
                'accelerator', 'p');

%               ----------------------------------------------------------- EDIT

menubar.edit.extractSelection.handle = uimenu(editMenu, 'label', 'E&xtract Selection', ...
                   'callback', @(~,~) extractSelectedPolygons(obj), ...
                     'enable', 'off', ...
                'accelerator', 'D');
              
menubar.edit.showInfo.handle = uimenu(editMenu, 'label', 'Display &Infos', ...
                   'callback', @(~,~) showTable(obj.model.infoTable), ...
                     'enable', 'on', ...
                  'separator', 'on');


% menubar.edit.
%               ----------------------------------------------------------- FACTORS

% create all the submenus of the 'factors' menu
menubar.factors.import.handle = uimenu(factMenu, 'label', 'Import &factors', ...
                   'callback', @(~,~) importFactors(obj), ...
                'accelerator', 'f');
menubar.factors.create.handle = uimenu(factMenu, 'label', '&Create factors', ...
                   'callback', @(~,~) createFactors(obj));

menubar.factors.save.handle = uimenu(factMenu, 'label', '&Save factors', ...
                   'callback', @(~,~) saveFactors(obj.model), ...
                     'enable', 'off', ...
                  'separator', 'on');

menubar.factors.display.handle = uimenu(factMenu, 'label', '&Display factors', ...
                   'callback', @(~,~) showTable(obj.model.factorTable), ...
                     'enable', 'off', ...
                  'separator', 'on');

% menubar.factors.import.handle = e1;
% menubar.factors.create.handle = e2;
% menubar.factors.save.handle = e3;
% menubar.factors.display.handle = e4;

%               ----------------------------------------------------------- PROCESS

% create all the submenus of the 'process' menu
menubar.process.recenter.handle = uimenu(foncMenu, 'label', 'Re&center polygons', ...
              'callback', @(~,~) polygonsRecenter(obj));

fc1 = uimenu(foncMenu, 'label', 'Rotate &all');
           uimenu(fc1, 'label', '90� &right', ...
                    'callback', @(~,~) polygonsRotate(obj, 90, 'all'));
           uimenu(fc1, 'label', '90� &left', ...
                    'callback', @(~,~) polygonsRotate(obj, 270, 'all'));
           uimenu(fc1, 'label', '&180�', ...
                    'callback', @(~,~) polygonsRotate(obj, 180, 'all'));
menubar.process.rotateAll.handle = fc1;

fc2 = uimenu(foncMenu, 'label', 'Rotate &selected');
           uimenu(fc2, 'label', '90� &right', ...
                    'callback', @(~,~) polygonsRotate(obj, 90, 'selected'));
           uimenu(fc2, 'label', '90� &left', ...
                    'callback', @(~,~) polygonsRotate(obj, 270, 'selected'));
           uimenu(fc2, 'label', '&180�', ...
                    'callback', @(~,~) polygonsRotate(obj, 180, 'selected'));
           uimenu(fc2, 'label', 'Custom angle C&W', ...
                    'callback', @(~,~) polygonsRotate(obj, 'customCW', 'selected'), ...
                   'separator', 'on');
           uimenu(fc2, 'label', 'Custom angle &CCW', ...
                    'callback', @(~,~) polygonsRotate(obj, 'customCCW', 'selected'));
menubar.process.rotateSelected.handle = fc2;

menubar.process.resizePolygons.handle = uimenu(foncMenu, 'label', '&Resize polygons', ...
              'callback', @(~,~) polygonsResize(obj));

menubar.process.simplifyPolygons.handle = uimenu(foncMenu, ...
    'label', 'Sim&plify polygons', ...
    'callback', @(~,~) polygonsSimplify(obj, 'on'), ...
    'separator', 'on');
menubar.process.resamplePolygonsByLength.handle = uimenu(foncMenu, ...
    'label', 'Resample by length', ...
    'callback', @(~,~) polygonsResampleByLength(obj));

menubar.process.alignAroundAxis.handle = uimenu(foncMenu, ...
    'label', 'A&lign around symmetry axis');
uimenu(menubar.process.alignAroundAxis.handle, 'label', '&Precise', ...
    'callback', @(~,~) polygonsAlign(obj, 'precise'));
uimenu(menubar.process.alignAroundAxis.handle, 'label', '&Fast', ...
    'callback', @(~,~) polygonsAlign(obj, 'fast'));


menubar.process.concatenatePolygons.handle = uimenu(foncMenu, ...
    'label', 'C&oncatenate Polygons', ...
    'callback', @(~,~) polygonsConcatenate(obj), ...
    'separator', 'on');

menubar.process.computeSignatures.handle = uimenu(foncMenu, ...
    'label', 'Compute Polar S&ignatures', ...
    'callback', @(~,~) polygonsToSignature(obj));
         
%               ----------------------------------------------------------- PCA

% create all the submenus of the 'pca' menu
menubar.pca.computePCA.handle = uimenu(pcaMenu, 'label', '&Compute PCA', ...
                    'callback', @(~,~) computePCA(obj));

menubar.pca.displayEigenValues.handle = uimenu(pcaMenu, 'label', 'Display &Eigen Values', ...
                    'callback', @(~,~) pcaEigen(obj), ...
                      'enable', 'off', ...
                   'separator', 'on');
menubar.pca.displayScores.handle = uimenu(pcaMenu, 'label', 'Display &Scores', ...
                    'callback', @(~,~) pcaScores(obj), ...
                      'enable', 'off');
menubar.pca.displayLoadings.handle = uimenu(pcaMenu, 'label', 'Display &Loadings', ...
                    'callback', @(~,~) pcaLoadings(obj), ...
                      'enable', 'off');
menubar.pca.displayProfiles.handle = uimenu(pcaMenu, 'label', '&Influence Plot', ...
                    'callback', @(~,~) pcaInfluence(obj), ...
                      'enable', 'off');
menubar.pca.displayProfiles.handle = uimenu(pcaMenu, 'label', 'Display &profiles', ...
                    'callback', @(~,~) pcaVector(obj), ...
                      'enable', 'off');

menubar.pca.displayScoresAndProfiles.handle = uimenu(pcaMenu, 'label', '&Display scores + profiles', ...
                    'callback', @(~,~) pcaScoresProfiles(obj), ...
                      'enable', 'off', ...
                   'separator', 'on');
% PCA sub-menu
pca8 = uimenu(pcaMenu, 'label', 'Save pca', ...
                     'enable', 'off');
           uimenu(pca8, 'label', '&Means', ...
                    'callback', @(~,~) savePca(obj.model, 'means'));
           uimenu(pca8, 'label', '&Scores', ...
                    'callback', @(~,~) savePca(obj.model, 'scores'));
           uimenu(pca8, 'label', '&Loadings', ...
                    'callback', @(~,~) savePca(obj.model, 'loadings'));
           uimenu(pca8, 'label', '&Eigen values', ...
                    'callback', @(~,~) savePca(obj.model, 'eigenValues'));
menubar.pca.savePca.handle = pca8;


%               ----------------------------------------------------------- VIEW

% create all the submenus of the 'view' menu
menubar.view.grid.handle = uimenu(viewMenu, 'label', '&Grid', ...
                   'callback', @(~,~) toggleGridDisplay(obj), ...
                'accelerator', 'G');
menubar.view.markers.handle = uimenu(viewMenu, 'label', '&Markers', ...
                   'callback', @(~,~) toggleMarkerDisplay(obj), ...
                'accelerator', 'M');

menubar.view.zoom.handle = uimenu(viewMenu, 'label', '&Zoom', ...
                   'callback', @(~,~) toggleZoomMode(obj), ...
                  'separator', 'on', ...
                'accelerator', 'Z');
menubar.view.resetZoom.handle = uimenu(viewMenu, 'label', '&Reset zoom', ...
                   'callback', @(~,~) zoom('out'));


%               ----------------------------------------------------------- 

% create all the submenus of the context menu of the futur
menubar.contextPanel.handle = contPmenu;
menubar.contextPanel.grid.handle = uimenu(contPmenu, 'label', '&Grid', ...
                     'callback', @(~,~) toggleGridDisplay(obj));
menubar.contextPanel.markers.handle  = uimenu(contPmenu, 'label', '&Markers', ...
                     'callback', @(~,~) toggleMarkerDisplay(obj));

menubar.contextPanel.zoom.handle = uimenu(contPmenu, 'label', '&Zoom', ...
                     'callback', @(~,~) toggleZoomMode(obj), ...
                    'separator', 'on');
menubar.contextPanel.resetZoom.handle = uimenu(contPmenu, 'label', '&Reset zoom', ...
                     'callback', @(~,~) zoom('out'));

%               ----------------------------------------------------------- 

% create the submenu of the selection list
menubar.contextList.handle = contLmenu;
menubar.contextList.swapSelection.handle = uimenu(contLmenu, 'label', '&Swap selection', ...
                     'callback', @(~,~) swapSelection);

obj.menuBar = menubar;


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

function swapSelection
%SWAPSELECTION  unselects all the selected polygons and selects all the unselected

    % get the complete list of polygons' name
    liste = obj.model.nameList;

    % memory allocation
    nonSelVal = zeros(length(liste), 1);

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
    
    updateSelectedPolygonsDisplay(getActivePanel(obj));
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