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

% build menubar data structure
menubar.file.handle = fileMenu;
menubar.factors.handle = editMenu;
menubar.process.handle = foncMenu;
menubar.view.handle = viewMenu;
menubar.pca.handle = pcaMenu;


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

menubar.file.openFolder.handle = f1;
menubar.file.openFile.handle = f2;
menubar.file.openPolarSignatures.handle = f3;
menubar.file.extractSelection.handle = f4;
menubar.file.savePolygons.handle = f5;
% menubar.file.x.handle = f6;
menubar.file.saveMacro.handle = f7;
menubar.file.loadMacro.handle = f8;
menubar.file.exportToWorkspace.handle = f9;
menubar.file.exportDisplay.handle = f10;
menubar.file.close.handle = f11;

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

menubar.factors.import.handle = e1;
menubar.factors.create.handle = e2;
menubar.factors.save.handle = e3;
menubar.factors.display.handle = e4;

menubar.edit.showInfo.handle = e5;

%               ----------------------------------------------------------- PROCESS

% create all the submenus of the 'process' menu
fc3 = uimenu(foncMenu, 'label', 'Re&center polygons', ...
              'callback', @(~,~) polygonsRecenter(obj));

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


fc8 = uimenu(foncMenu, 'label', 'C&oncatenate Polygons', ...
              'callback', @(~,~) polygonsConcatenate(obj), ...
              'separator', 'on');

fc7 = uimenu(foncMenu, 'label', 'Compute Polar S&ignatures', ...
              'callback', @(~,~) polygonsToSignature(obj));
         
menubar.process.recenter.handle = fc3;
menubar.process.rotateAll.handle = fc1;
menubar.process.rotateSelected.handle = fc2;
menubar.process.resizePolygons.handle = fc4;
menubar.process.simplifyPolygons.handle = fc5;
menubar.process.alignAroundAxis.handle = fc6;
menubar.process.concatenatePolygons.handle = fc8;
menubar.process.computeSignatures.handle = fc7;

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
pca4 = uimenu(pcaMenu, 'label', 'Display &loadings', ...
                    'callback', @(~,~) pcaLoadings(obj), ...
                      'enable', 'off');
pca5 = uimenu(pcaMenu, 'label', '&Influence Plot', ...
                    'callback', @(~,~) pcaInfluence(obj), ...
                      'enable', 'off');
pca6 = uimenu(pcaMenu, 'label', 'Display &profiles', ...
                    'callback', @(~,~) pcaVector(obj), ...
                      'enable', 'off');

pca7 = uimenu(pcaMenu, 'label', '&Display scores + profiles', ...
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

menubar.pca.computePCA.handle = pca1;
menubar.pca.displayEigenValues.handle = pca2;
menubar.pca.displayScores.handle = pca3;
menubar.pca.displayLoadings.handle = pca4;
menubar.pca.influencePlot.handle = pca5;
menubar.pca.displayProfiles.handle = pca6;
menubar.pca.displayScoresAndProfiles.handle = pca7;

menubar.pca.savePca.handle = pca8;

%               ----------------------------------------------------------- VIEW

% create all the submenus of the 'view' menu
v1 = uimenu(viewMenu, 'label', '&Grid', ...
                   'callback', @(~,~) toggleGridDisplay(obj), ...
                'accelerator', 'G');
v2 = uimenu(viewMenu, 'label', '&Markers', ...
                   'callback', @(~,~) toggleMarkerDisplay(obj), ...
                'accelerator', 'M');

v3 = uimenu(viewMenu, 'label', '&Zoom', ...
                   'callback', @(~,~) toggleZoomMode(obj), ...
                  'separator', 'on', ...
                'accelerator', 'Z');
v4 = uimenu(viewMenu, 'label', '&Reset zoom', ...
                   'callback', @(~,~) zoom('out'));

% obj.handles.submenus{4} = {v1, v2, v3, v4};
menubar.view.grid.handle = v1;
menubar.view.markers.handle = v2;
menubar.view.zoom.handle = v3;
menubar.view.resetZoom.handle = v4;

%               ----------------------------------------------------------- 

% create all the submenus of the context menu of the futur
cp1 = uimenu(contPmenu, 'label', '&Grid', ...
                     'callback', @(~,~) toggleGridDisplay(obj));
cp2 = uimenu(contPmenu, 'label', '&Markers', ...
                     'callback', @(~,~) toggleMarkerDisplay(obj));

cp3 = uimenu(contPmenu, 'label', '&Zoom', ...
                     'callback', @(~,~) toggleZoomMode(obj), ...
                    'separator', 'on');
cp4 = uimenu(contPmenu, 'label', '&Reset zoom', ...
                     'callback', @(~,~) zoom('out'));

% obj.handles.submenus{6} = {cp1, cp2, cp3, cp4};
menubar.contextPanel.handle = contPmenu;
menubar.contextPanel.grid.handle = cp1;
menubar.contextPanel.markers.handle = cp2;
menubar.contextPanel.zoom.handle = cp3;
menubar.contextPanel.resetZoom.handle = cp4;

%               ----------------------------------------------------------- 

% create the submenu of the selection list
cl1 = uimenu(contLmenu, 'label', '&Swap selection', ...
                     'callback', @(~,~) swapSelection);

% obj.handles.submenus{7} = {cl1};
menubar.contextList.handle = contLmenu;
menubar.contextList.swapSelection.handle = cl1;

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