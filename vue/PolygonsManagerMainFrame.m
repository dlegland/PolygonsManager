classdef PolygonsManagerMainFrame < handle
%POLYGONSMANAGERMAINFRAME Class that creates the main frame of the application
%
%   Creation : 
%   figure = PolygonsManagerMainFrame;
%
    
    properties
        % cell array containing the handles of all the objects used in the
        % application
        handles;
        
        % PolygonsManagerData that contains all the datas of the
        % application
        model;
        
    end
    
    methods
        function this = PolygonsManagerMainFrame
        %Constructor for PolygonsManagerMainFrame class
        %
        %   figure = PolygonsManagerMainFrame
            
            % creation of the main figure
            fen = figure('units', 'normalized', ...
                 'outerposition', [0.25 0.25 0.5 0.5], ...
                       'menubar', 'none', ...
                   'numbertitle', 'off', ...
                          'name', 'Polygons Manager');
            % the units properties of the figure is set to pixel so that it
            % can be used to position other elements later
            set(fen, 'units', 'pixel');
            
            % add the handle of the figure to the list of handles
            this.handles.figure = fen;            
            
            % creation of the boxes that will contain different elements
            % later
            main_box = uix.HBox('parent', fen, ...
                               'padding', 5);
            
            list_box = uicontrol('parent', main_box, ...
                                  'style', 'listbox', ...
                                    'max', 100, ...
                                    'min', 0);
            
            tab_box = uix.TabPanel('parent', main_box, ...
                                 'tabwidth', 75);
            
            set(main_box, 'widths', [-1 -8]);
            
            % add created handles to the list of handles
            this.handles.main = main_box;
            this.handles.tabs = tab_box;
            this.handles.list = list_box;
            
            % create spaces that will be used by other elements later
            this.handles.Panels = {};
            
            % create the menu
            setupMenu;
            
            function setupMenu
                % create all the menus
                fileMenu = uimenu(fen, 'label', '&File');
                editMenu = uimenu(fen, 'label', '&Factors', 'enable', 'off');
                foncMenu = uimenu(fen, 'label', '&Process', 'enable', 'off');
                pcaMenu = uimenu(fen, 'label', '&Pca', 'visible', 'off');
                viewMenu = uimenu(fen, 'label', '&View', 'enable', 'off');
                contPmenu = uicontextmenu; 
                contLmenu = uicontextmenu; 
                
                %add the menus' handles to the list of handles
                this.handles.menus = {fileMenu, editMenu, foncMenu, viewMenu, pcaMenu, contPmenu, contLmenu};
                
                % create the space that will contain all the submenus
                this.handles.submenus = {};
                
%               ----------------------------------------------------------- 
                
                % create all the submenus of the 'file' menu
                f1 = uimenu(fileMenu, 'label', '&Import polygons (folder)', ...
                              'callback', @(src, event) importBasicPolygon(this));
                f2 = uimenu(fileMenu, 'label', '&Import polygons (file)', ...
                              'callback', @(src, event) importCoordsPolygon(this));
                f3 = uimenu(fileMenu, 'label', '&Import signatures', ...
                              'callback', @(src, event) importPolarSignature(this));
                
                f4 = uimenu(fileMenu, 'label', '&Divide polygons', ...
                                   'callback', @(src, event) dividePolygonArray(this), ...
                                     'enable', 'off', ...
                                  'separator', 'on');
                
                f5 = uimenu(fileMenu, 'label', '&Save polygons', ...
                                   'callback', @(src, event) saveContours(this), ...
                                     'enable', 'off', ...
                             'separator', 'on');
                f6 = uimenu(fileMenu, 'label', '&Save signatures', ...
                                   'callback', @(src, event) savePolarSignature(this), ...
                                     'enable', 'off');
                
                f7 = uimenu(fileMenu, 'label', '&Close', ...
                              'callback', @(src, event) closef(gcf), ...
                             'separator', 'on');
                
                this.handles.submenus{1} = {f1, f2, f3, f4, f5, f6, f7};
                
%               ----------------------------------------------------------- 
                
                % create all the submenus of the 'factors' menu
                e1 = uimenu(editMenu, 'label', '&Import factors', ...
                              'callback', @(src, event) importFactors(this));
                e2 = uimenu(editMenu, 'label', '&Create factors', ...
                              'callback', @(src, event) createFactors(this));
                
                e3 = uimenu(editMenu, 'label', '&Save factors', ...
                                   'callback', @(src, event) saveFactors(this), ...
                                     'enable', 'off', ...
                                  'separator', 'on');
                
                e4 = uimenu(editMenu, 'label', '&Display factors', ...
                                   'callback', @(src, event) showFactors, ...
                                     'enable', 'off', ...
                                  'separator', 'on');
                
                this.handles.submenus{2} = {e1, e2, e3, e4};
                
%               -----------------------------------------------------------  
                
                % create all the submenus of the 'process' menu
                fc1 = uimenu(foncMenu, 'label', '&Rotate all');
                uimenu(fc1, 'label', '&90° right', ...
                         'callback', @(src, event) polygonsRotate(this, 1, 'all'));
                uimenu(fc1, 'label', '&90° left', ...
                         'callback', @(src, event) polygonsRotate(this, 2, 'all'));
                uimenu(fc1, 'label', '&180°', ...
                         'callback', @(src, event) polygonsRotate(this, 3, 'all'));
                
                fc2 = uimenu(foncMenu, 'label', '&Rotate selected');
                uimenu(fc2, 'label', '&90° right', ...
                         'callback', @(src, event) polygonsRotate(this, 1, 'selected'));
                uimenu(fc2, 'label', '&90° left', ...
                         'callback', @(src, event) polygonsRotate(this, 2, 'selected'));
                uimenu(fc2, 'label', '&180°', ...
                         'callback', @(src, event) polygonsRotate(this, 3, 'selected'));
                
                fc3 = uimenu(foncMenu, 'label', '&Recenter polygons', ...
                              'callback', @(src, event) polygonsRecenter(this), ...
                             'separator', 'on');
                fc4 = uimenu(foncMenu, 'label', '&Resize polygons', ...
                              'callback', @(src, event) polygonsResize(this));
                
                fc5 = uimenu(foncMenu, 'label', '&Simplify polygons', ...
                              'callback', @(src, event) polygonsSimplify(this), ...
                             'separator', 'on');
                fc6 = uimenu(foncMenu, 'label', '&Align polygons', ...
                              'callback', @(src, event) polygonsAlign(this));
                          
                fc7 = uimenu(foncMenu, 'label', '&Signature', ...
                              'callback', @(src, event) polygonsToSignature(this), ...
                             'separator', 'on');
                fc8 = uimenu(foncMenu, 'label', '&Concatenate', ...
                              'callback', @(src, event) polygonsConcatenate(this));
                          
                this.handles.submenus{3} = {fc1, fc2, fc3, fc4, fc5, fc6, fc7, fc8};
                
%               -----------------------------------------------------------  
                
                % create all the submenus of the 'process' menu
                pca1 = uimenu(pcaMenu, 'label', '&Compute PCA', ...
                              'callback', @(src, event) computePCA(this));
                          
                pca2 = uimenu(pcaMenu, 'label', '&Display eigen', ...
                              'callback', @(src, event) pcaEigen(this), ...
                                'enable', 'off', ...
                             'separator', 'on');
                pca3 = uimenu(pcaMenu, 'label', '&Display scores', ...
                              'callback', @(src, event) pcaScores(this), ...
                                'enable', 'off');
                pca4 = uimenu(pcaMenu, 'label', '&Display loadings', ...
                              'callback', @(src, event) pcaLoadings(this), ...
                                'enable', 'off');
                pca5 = uimenu(pcaMenu, 'label', '&Display influence', ...
                              'callback', @(src, event) pcaInfluence(this), ...
                                'enable', 'off');
                this.handles.submenus{5} = {pca1, pca2, pca3, pca4, pca5};
                
%               ----------------------------------------------------------- 
                
                % create all the submenus of the 'view' menu
                v1 = uimenu(viewMenu, 'label', '&No Coloration', ...
                              'callback', @(src, event) dispAxes);
                v2 = uimenu(viewMenu, 'label', '&Coloration factor', ...
                              'callback', @(src, event) selectFactor(this), ...
                                'enable', 'off');
                v3 = uimenu(viewMenu, 'label', '&Grid', ...
                              'callback', @(src, event) showGrid);
                v4 = uimenu(viewMenu, 'label', '&Markers', ...
                              'callback', @(src, event) showMarker);
                
                this.handles.submenus{4} = {v1, v2, v3, v4};
                
%               ----------------------------------------------------------- 
                
                % create all the submenus of the context menu of the futur
                % panels and axes
                cp1 = uimenu(contPmenu, 'label', '&No Coloration', ...
                              'callback', @(src, event) dispAxes);
                cp2 = uimenu(contPmenu, 'label', '&Coloration factor', ...
                              'callback', @(src, event) selectFactor(this), ...
                                'enable', 'off');
                cp3 = uimenu(contPmenu, 'label', '&Grid', ...
                              'callback', @(src, event) showGrid);
                cp4 = uimenu(contPmenu, 'label', '&Markers', ...
                              'callback', @(src, event) showMarker);
                
                this.handles.submenus{6} = {cp1, cp2, cp3, cp4};
                
%               ----------------------------------------------------------- 
                
                % create all the submenus of the context menu of the futur
                % panels and axes
                cl1 = uimenu(contLmenu, 'label', '&Swap selection', ...
                              'callback', @(src, event) swapSelection);
                
                this.handles.submenus{7} = {cl1};
                
                
                function closef(h)
                    %CLOSEF  close a figure
                    %
                    %   inputs : 
                    %       h : handle of a figure
                    close(h);
                end
                
                function showFactors
                    %SHOWFACTORS  open a new figure that displays the
                    %current factor Table
                    [hf, ht] = show(this.model.factorTable);
                    ht.Units = 'pixel';
                    if ht.Extent(4) < this.handles.figure.Position(4)
                        pos = getMiddle(this.handles.figure, ht.Extent(3), ht.Extent(4));
                        ht.Position = ht.Extent;
                    else
                        pos = getMiddle(this.handles.figure, ht.Extent(3)+16, this.handles.figure.Position(4));
                        ht.Units = 'normalized';
                        ht.Position = [0 0 1 1];
                    end
                    hf.Position = pos;
                end
                
                function showGrid
                    %SHOWGRID  display the grids on an axis and updates
                    %the menus
                    if strcmp(v3.Checked, 'off');
                        set(v3, 'checked', 'on');
                        set(cp3, 'checked', 'on');
                        set(this.handles.Panels{this.handles.tabs.Selection}.uiAxis, 'xgrid', 'on');
                        set(this.handles.Panels{this.handles.tabs.Selection}.uiAxis, 'ygrid', 'on');
                    else
                        set(v3, 'checked', 'off');
                        set(cp3, 'checked', 'off');
                        set(this.handles.Panels{this.handles.tabs.Selection}.uiAxis, 'xgrid', 'off');
                        set(this.handles.Panels{this.handles.tabs.Selection}.uiAxis, 'ygrid', 'off');
                    end
                end
                
                function showMarker
                    %SHOWGRID  display the grids on an axis and updates
                    %the menus
                    if strcmp(v4.Checked, 'off');
                        set(v4, 'checked', 'on');
                        set(cp4, 'checked', 'on');
                        set(this.handles.Panels{this.handles.tabs.Selection}.uiAxis.Children, 'Marker', '+');
                    else
                        set(v4, 'checked', 'off');
                        set(cp4, 'checked', 'off');
                        set(this.handles.Panels{this.handles.tabs.Selection}.uiAxis.Children, 'Marker', 'none');
                    end
                end
                function dispAxes
                    %DISPAXES  display the datas of the current polygons
                    if isempty(this.handles.Panels{1}.type)
                        displayPolygons(this.handles.Panels{1}, getAllPolygons(this.model.PolygonArray));
                        if strcmp(class(this.model.PolygonArray), 'PolarSignatureArray')
                            displayPolarSignature(this.handles.Panels{2}, this.model.PolygonArray.signatures, this.model.PolygonArray.angleList);
                        end
                    else
                        fh = str2func(this.handles.Panels{1}.type);
                        fh(this);
                    end
                end
                
                function swapSelection
                    liste = cellstr(get(this.handles.list, 'String'));
                    
                    nonSelVal=zeros(length(liste),1);
                    for i = 1:length(liste)
                        if ~ismember(i, get(this.handles.list, 'value'))
                            nonSelVal(i) = i;
                        end
                    end
                    nonSelVal = nonSelVal(nonSelVal~=0);
                    set(this.handles.list, 'value', nonSelVal)
                
                    this.model.selectedPolygons = liste(nonSelVal);
                    updateSelectedPolygonsDisplay(this.handles.Panels{this.handles.tabs.Selection});
                end
            end
        end
        
        function pos = getMiddle(figure, width, heigth)
            %GETMIDDLE  get the position where a figure must be to be at
            %the exact center of the main frame
            pos = get(figure, 'outerposition');

            pos(1) = pos(1) + (pos(3)/2) - (width/2);
            pos(2) = pos(2) + (pos(4)/2) - (heigth/2);
            pos(3) = width;
            pos(4) = heigth;
        end
        
        function setupNewFrame(this, model, varargin)
            %SETUPNEWFRAME  fill a PolygonsManagerMainFrame with the parameters given
            %
            %   inputs :
            %       - obj : handle of the PolygonsManagerMainFrame that
            %       must be setup
            %       - model : PolygonsManagerData instance
            
            % creation of the model of the new PolygonsManagerMainFrame
            this.model = model;
            
            % fill the selection list of the new PolygonsManagerMainFrame
            set(this.handles.list, 'string', model.nameList, ...
                                 'callback', @(src, event) select, ...
                            'uicontextmenu', this.handles.menus{7});
            
            if isempty(varargin)
                % creation of a panel on which the polygons will be drawn
                Panel(this, length(this.handles.tabs.Children) + 1, 'on');
                
                % draw the polygons of the new PolygonsManagerMainFrame
                displayPolygons(this.handles.Panels{1}, getAllPolygons(this.model.PolygonArray));
                if strcmp(class(this.model.PolygonArray), 'PolarSignatureArray')
                    Panel(this, length(this.handles.tabs.Children) + 1, 'off');
                    displayPolarSignature(this.handles.Panels{2}, this.model.PolygonArray.signatures, this.model.PolygonArray.angleList);
                end
            else
                % creation of a panel on which the polygons will be drawn
                Panel(this,length(this.handles.tabs.Children) + 1, varargin{3});
                this.handles.Panels{1}.type = varargin{4};
                displayPca(this.handles.Panels{1}, varargin{1}, varargin{2});
                if strcmp(varargin{4}, 'pcaLoadings')
                    set(this.handles.list, 'callback', @(src, event) draw);
                    [poly, values] = pcaVector(this);
                    Panel(this, length(this.handles.tabs.Children) + 1, 'on');
                    displayPolygons(this.handles.Panels{length(this.handles.tabs.Children)}, {poly}, 1);
                    this.handles.tabs.TabTitles{length(this.handles.tabs.Children)} = 'Polygon';
                    if strcmp(class(this.model.PolygonArray), 'PolarSignatureArray')
                        Panel(this, length(this.handles.tabs.Children) + 1, 'off');
                        displayPolarSignature(this.handles.Panels{length(this.handles.tabs.Children)}, values, this.model.PolygonArray.angleList, 1);
                    end
                    this.handles.tabs.TabTitles{2} = 'Polygon';
                    this.handles.tabs.TabTitles{3} = 'Signature';
                end
            end
            
            % update the menus of the new PolygonsManagerMainFrame
            updateMenus(this);
            
            function select
                list = cellstr(get(this.handles.list, 'String'));
                selVal = get(this.handles.list, 'value');
                this.model.selectedPolygons = list(selVal);
                
                updateSelectedPolygonsDisplay(this.handles.Panels{this.handles.tabs.Selection});
            end
            
            function draw
                list = cellstr(get(this.handles.list, 'String'));
                selVal = get(this.handles.list, 'value');
                this.model.selectedPolygons = list(selVal);
                
                polygons = cell(length(this.model.selectedPolygons), 1);
                if strcmp(class(this.model.PolygonArray), 'PolarSignatureArray')
                    signatures = zeros(length(this.model.selectedPolygons), length(this.model.PolygonArray.angleList));
                end
                for i = 1:length(this.model.selectedPolygons)
                    polygons{i} = getPolygonFromName(this.model, this.model.selectedPolygons{i});
                    if strcmp(class(this.model.PolygonArray), 'PolarSignatureArray')
                        signatures(i, :) = getSignatureFromName(this.model, this.model.selectedPolygons{i});
                    end
                end
                
                displayPolygons(this.handles.Panels{2}, polygons);
                if strcmp(class(this.model.PolygonArray), 'PolarSignatureArray')
                    displayPolarSignature(this.handles.Panels{3}, signatures, this.model.PolygonArray.angleList);
                end
                this.model.selectedPolygons = {};
            end
        end
        
        function updateMenus(this)
            %UPDATEMENUS  update the menus depending on the current datas
            %of the model
            if strcmp(class(this.model), 'PolygonsManagerData')
                set(this.handles.submenus{1}{4}, 'enable', 'on');
                set(this.handles.menus{2}, 'enable', 'on');
                set(this.handles.menus{4}, 'enable', 'on');
                set(this.handles.menus{3}, 'enable', 'on');
                if strcmp(class(this.model.PolygonArray), 'BasicPolygonArray')
                    set(this.handles.submenus{1}{5}, 'enable', 'on');
                elseif strcmp(class(this.model.PolygonArray), 'CoordsPolygonArray')
                    set(this.handles.menus{3}, 'visible', 'off');
                    set(this.handles.menus{5}, 'visible', 'on');
                    set(this.handles.submenus{1}{5}, 'enable', 'on');
                elseif strcmp(class(this.model.PolygonArray), 'PolarSignatureArray')
                    set(this.handles.menus{3}, 'visible', 'off');
                    set(this.handles.menus{5}, 'visible', 'on');
                    set(this.handles.submenus{1}{6}, 'enable', 'on');
                end
                if strcmp(class(this.model.factorTable), 'Table')
                    set(this.handles.submenus{2}{1}, 'checked', 'on');
                    set([this.handles.submenus{2}{:}], 'enable', 'on');
                    set(this.handles.submenus{4}{2}, 'enable', 'on');
                    set(this.handles.submenus{6}{2}, 'enable', 'on');
                    set(this.handles.figure, 'name', ['Polygons Manager | factors : ' this.model.factorTable.name]);
                end
                if strcmp(class(this.model.pca), 'Pca')
                    set([this.handles.submenus{5}{:}], 'enable', 'on');
                    if ~isempty(this.handles.Panels{1}.type)
                        set([this.handles.submenus{4}{4}], 'enable', 'off');
                        set([this.handles.submenus{6}{4}], 'enable', 'off');
                        if ~ismember(this.handles.Panels{1}.type, {'pcaScores', 'pcaInfluence'})
                            set(this.handles.submenus{4}{2}, 'enable', 'off');
                            set(this.handles.submenus{6}{2}, 'enable', 'off');
                        end
                    end
                    if strcmp(class(this.model.factorTable), 'Table')
                        set(this.handles.figure, 'name', ['Polygons Manager | factors : ' this.model.factorTable.name ' | PCA']);
                    else
                        set(this.handles.figure, 'name', 'Polygons Manager | PCA');
                    end
                end
            end
        end
        
        function names = setupDisplay(this, i1, i2, tabInd, tabName)
            
            % update the checked values in the menu
            set(this.handles.submenus{4}{i1}, 'checked', 'on');
            set(this.handles.submenus{4}{i2}, 'checked', 'off');
            set(this.handles.submenus{6}{i1}, 'checked', 'on');
            set(this.handles.submenus{6}{i2}, 'checked', 'off');

            % set the name of the tab
            this.handles.tabs.TabTitles{tabInd} = tabName;
            
            names = this.model.nameList;
        end
    end
end