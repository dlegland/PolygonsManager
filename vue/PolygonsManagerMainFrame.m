classdef PolygonsManagerMainFrame < handle
%POLYGONSMANAGERMAINFRAME Class that creates the main frame of the application
%
%   Creation : 
%   figure = PolygonsManagerMainFrame;
%
    
    properties
        % struct containing the handles of all the objects used in the
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
            
            left_box = uix.VBox('parent', main_box, ...
                               'spacing', 5);
            
            list_box = uicontrol('parent', left_box, ...
                                  'style', 'listbox', ...
                                    'max', 100, ...
                                    'min', 0);
            
            info_box =  uipanel('parent', left_box, ...
                            'background', 'w');
            
            tab_box = uix.TabPanel('parent', main_box, ...
                                 'tabwidth', 75);
            
            set(main_box, 'widths', [150 -1]);
            set(left_box, 'Heights', [-1 85]);
            
            % add created handles to the list of handles
            this.handles.main = main_box;
            this.handles.left = left_box;
            this.handles.tabs = tab_box;
            this.handles.list = list_box;
            this.handles.info = info_box;
            this.handles.infoFields = setupInfoPanel;
            
            % create spaces that will be used by other elements later
            this.handles.Panels = {};
            
            % create the menu
            setupMenu;
            
            function fields = setupInfoPanel
                
                fields = {};
                
                % create the inputs of the dialog box
                uicontrol('parent', info_box,...
                        'position', [10 60 100 14], ...
                           'style', 'text',...
                          'string', 'Area :', ... 
                        'fontsize', 10, ...
             'horizontalalignment', 'left', ...
                      'background', 'w');
         
                uicontrol('parent', info_box,...
                        'position', [10 35 100 14], ...
                           'style', 'text',...
                          'string', 'Perimeter :', ... 
                        'fontsize', 10, ...
             'horizontalalignment', 'left', ...
                      'background', 'w');
         
                uicontrol('parent', info_box,...
                        'position', [10 10 100 14], ...
                           'style', 'text',...
                          'string', 'Orientation :', ... 
                        'fontsize', 10, ...
             'horizontalalignment', 'left', ...
                      'background', 'w');
         
                fields{1} = uicontrol('parent', info_box,...
                                   'position', [86 60 100 14], ...
                                      'style', 'text',...
                                   'fontsize', 10, ...
                        'horizontalalignment', 'left', ...
                                 'background', 'w');
         
                fields{2} = uicontrol('parent', info_box,...
                                   'position', [86 35 100 14], ...
                                      'style', 'text',...
                                   'fontsize', 10, ...
                        'horizontalalignment', 'left', ...
                                 'background', 'w');
         
                fields{3} = uicontrol('parent', info_box,...
                                   'position', [86 10 100 14], ...
                                      'style', 'text',...
                                   'fontsize', 10, ...
                        'horizontalalignment', 'left', ...
                                 'background', 'w');

            end
            
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
                              'callback', @(~,~) importBasicPolygon(this));
                f2 = uimenu(fileMenu, 'label', '&Import polygons (file)', ...
                              'callback', @(~,~) importCoordsPolygon(this));
                f3 = uimenu(fileMenu, 'label', '&Import signatures', ...
                              'callback', @(~,~) importPolarSignature(this));
                
                f4 = uimenu(fileMenu, 'label', '&Divide polygons', ...
                                   'callback', @(~,~) dividePolygonArray(this), ...
                                     'enable', 'off', ...
                                  'separator', 'on');
                
                f5 = uimenu(fileMenu, 'label', '&Save polygons', ...
                                   'callback', @(~,~) saveContours(this), ...
                                     'enable', 'off', ...
                                  'separator', 'on');
                f6 = uimenu(fileMenu, 'label', '&Save signatures', ...
                                   'callback', @(~,~) savePolarSignature(this), ...
                                     'enable', 'off');
                                 
                f7 = uimenu(fileMenu, 'label', '&Save Macro', ...
                                   'callback', @(~,~) saveMacro(this), ...
                                     'enable', 'off', ...
                                  'separator', 'on');
                f8 = uimenu(fileMenu, 'label', '&Load Macro', ...
                                   'callback', @(~,~) loadMacro(this), ...
                                     'enable', 'off');
                
                f9 = uimenu(fileMenu, 'label', '&Close', ...
                              'callback', @(~,~) closef(gcf), ...
                             'separator', 'on');
                
                this.handles.submenus{1} = {f1, f2, f3, f4, f5, f6, f7, f8, f9};
                
%               ----------------------------------------------------------- 
                
                % create all the submenus of the 'factors' menu
                e1 = uimenu(editMenu, 'label', '&Import factors', ...
                              'callback', @(~,~) importFactors(this));
                e2 = uimenu(editMenu, 'label', '&Create factors', ...
                              'callback', @(~,~) createFactors(this));
                
                e3 = uimenu(editMenu, 'label', '&Save factors', ...
                                   'callback', @(~,~) saveFactors(this), ...
                                     'enable', 'off', ...
                                  'separator', 'on');
                
                e4 = uimenu(editMenu, 'label', '&Display factors', ...
                                   'callback', @(~,~) showFactors, ...
                                     'enable', 'off', ...
                                  'separator', 'on');
                
                e5 = uimenu(editMenu, 'label', '&Display Infos', ...
                                   'callback', @(~,~) showInfos, ...
                                     'enable', 'on', ...
                                  'separator', 'on');
                
                this.handles.submenus{2} = {e1, e2, e3, e4, e5};
                
%               -----------------------------------------------------------  
                
                % create all the submenus of the 'process' menu
                fc1 = uimenu(foncMenu, 'label', '&Rotate all');
                uimenu(fc1, 'label', '&90° right', ...
                         'callback', @(~,~) polygonsRotate(this, 90, 'all'));
                uimenu(fc1, 'label', '&90° left', ...
                         'callback', @(~,~) polygonsRotate(this, 270, 'all'));
                uimenu(fc1, 'label', '&180°', ...
                         'callback', @(~,~) polygonsRotate(this, 180, 'all'));
                
                fc2 = uimenu(foncMenu, 'label', '&Rotate selected');
                uimenu(fc2, 'label', '&90° right', ...
                         'callback', @(~,~) polygonsRotate(this, 90, 'selected'));
                uimenu(fc2, 'label', '&90° left', ...
                         'callback', @(~,~) polygonsRotate(this, 270, 'selected'));
                uimenu(fc2, 'label', '&180°', ...
                         'callback', @(~,~) polygonsRotate(this, 180, 'selected'));
                
                fc3 = uimenu(foncMenu, 'label', '&Recenter polygons', ...
                              'callback', @(~,~) polygonsRecenter(this), ...
                             'separator', 'on');
                fc4 = uimenu(foncMenu, 'label', '&Resize polygons', ...
                              'callback', @(~,~) polygonsResize(this));
                
                fc5 = uimenu(foncMenu, 'label', '&Simplify polygons', ...
                              'callback', @(~,~) polygonsSimplify(this), ...
                             'separator', 'on');
                fc6 = uimenu(foncMenu, 'label', '&Align polygons');
                uimenu(fc6, 'label', '&slow', ...
                         'callback', @(~,~) polygonsAlign(this, 'slow'));
                uimenu(fc6, 'label', '&fast', ...
                         'callback', @(~,~) polygonsAlign(this, 'fast'));
                     
                          
                fc7 = uimenu(foncMenu, 'label', '&Signature', ...
                              'callback', @(~,~) polygonsToSignature(this), ...
                             'separator', 'on');
                fc8 = uimenu(foncMenu, 'label', '&Concatenate', ...
                              'callback', @(~,~) polygonsConcatenate(this));
                          
                this.handles.submenus{3} = {fc1, fc2, fc3, fc4, fc5, fc6, fc7, fc8};
                
%               -----------------------------------------------------------  
                
                % create all the submenus of the 'process' menu
                pca1 = uimenu(pcaMenu, 'label', '&Compute PCA', ...
                              'callback', @(~,~) computePCA(this));
                          
                pca2 = uimenu(pcaMenu, 'label', '&Display eigen values', ...
                              'callback', @(~,~) pcaEigen(this), ...
                                'enable', 'off', ...
                             'separator', 'on');
                pca3 = uimenu(pcaMenu, 'label', '&Display scores', ...
                              'callback', @(~,~) pcaScores(this), ...
                                'enable', 'off');
                pca5 = uimenu(pcaMenu, 'label', '&Display influence', ...
                              'callback', @(~,~) pcaInfluence(this), ...
                                'enable', 'off');
                pca4 = uimenu(pcaMenu, 'label', '&Display loadings', ...
                              'callback', @(~,~) pcaLoadings(this), ...
                                'enable', 'off');
                pca6 = uimenu(pcaMenu, 'label', '&Display vectors', ...
                              'callback', @(~,~) pcaVector(this), ...
                                'enable', 'off');
                this.handles.submenus{5} = {pca1, pca2, pca3, pca4, pca5, pca6};
                
%               ----------------------------------------------------------- 
                
                % create all the submenus of the 'view' menu
                v1 = uimenu(viewMenu, 'label', '&No Coloration', ...
                              'callback', @(~,~) dispAxes);
                v2 = uimenu(viewMenu, 'label', '&Coloration factor', ...
                              'callback', @(~,~) selectFactor(this), ...
                                'enable', 'off');
                v3 = uimenu(viewMenu, 'label', '&Grid', ...
                              'callback', @(~,~) showGrid);
                v4 = uimenu(viewMenu, 'label', '&Markers', ...
                              'callback', @(~,~) showMarker);
                
                this.handles.submenus{4} = {v1, v2, v3, v4};
                
%               ----------------------------------------------------------- 
                
                % create all the submenus of the context menu of the futur
                % panels and axes
                cp1 = uimenu(contPmenu, 'label', '&No Coloration', ...
                              'callback', @(~,~) dispAxes);
                cp2 = uimenu(contPmenu, 'label', '&Coloration factor', ...
                              'callback', @(~,~) selectFactor(this), ...
                                'enable', 'off');
                cp3 = uimenu(contPmenu, 'label', '&Grid', ...
                              'callback', @(~,~) showGrid);
                cp4 = uimenu(contPmenu, 'label', '&Markers', ...
                              'callback', @(~,~) showMarker);
                
                this.handles.submenus{6} = {cp1, cp2, cp3, cp4};
                
%               ----------------------------------------------------------- 
                
                % create all the submenus of the context menu of the futur
                % panels and axes
                cl1 = uimenu(contLmenu, 'label', '&Swap selection', ...
                              'callback', @(~,~) swapSelection);
                
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
                
                function showInfos
                    %SHOWINFOS  open a new figure that displays the
                    %current info Table
                    [hf, ht] = show(this.model.infoTable);
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
                                 'callback', @(~,~) select, ...
                            'uicontextmenu', this.handles.menus{7});
            
            if isempty(varargin)
                % creation of a panel on which the polygons will be drawn
                Panel(this, length(this.handles.tabs.Children) + 1, 'on');
                this.handles.tabs.TabTitles{1} = 'Polygons';
                
                % draw the polygons of the new PolygonsManagerMainFrame
                displayPolygons(this.handles.Panels{1}, getAllPolygons(this.model.PolygonArray));
                if strcmp(class(this.model.PolygonArray), 'PolarSignatureArray')
                    Panel(this, length(this.handles.tabs.Children) + 1, 'off');
                    this.handles.tabs.TabTitles{2} = 'Signatures';
                    displayPolarSignature(this.handles.Panels{2}, this.model.PolygonArray.signatures, this.model.PolygonArray.angleList);
                end
            else
                % creation of a panel on which the polygons will be drawn
                Panel(this,length(this.handles.tabs.Children) + 1, varargin{2});
                this.handles.Panels{1}.type = varargin{1};
                if strcmp(varargin{1}, 'pcaLoadings')
                    set(this.handles.list, 'callback', '');
                    displayPca(this.handles.Panels{1}, varargin{3}, varargin{4});
                elseif strcmp(varargin{1}, 'pcaVector')
                    set(this.handles.list, 'callback', @(~,~) draw);
                    this.handles.tabs.TabTitles{length(this.handles.tabs.Children)} = 'Polygon';
                    displayPolygons(this.handles.Panels{length(this.handles.tabs.Children)}, varargin{3}, 1);
                    if strcmp(class(this.model.PolygonArray), 'PolarSignatureArray')
                        Panel(this, length(this.handles.tabs.Children) + 1, 'off');
                        this.handles.tabs.TabTitles{length(this.handles.tabs.Children)} = 'Signature';
                        displayPolarSignature(this.handles.Panels{length(this.handles.tabs.Children)}, varargin{4}, this.model.PolygonArray.angleList, 1);
                    end
                else
                    displayPca(this.handles.Panels{1}, varargin{3}, varargin{4});
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
                
                displayPolygons(this.handles.Panels{1}, polygons);
                if strcmp(class(this.model.PolygonArray), 'PolarSignatureArray')
                    displayPolarSignature(this.handles.Panels{2}, signatures, this.model.PolygonArray.angleList);
                end
                this.model.selectedPolygons = {};
            end
        end
        
        function updateMenus(this)
            %UPDATEMENUS  update the menus depending on the current datas
            %of the model
            if strcmp(class(this.model), 'PolygonsManagerData')
                set(this.handles.submenus{1}{4}, 'enable', 'on');
                set(this.handles.submenus{1}{7}, 'enable', 'on');
                set(this.handles.submenus{1}{8}, 'enable', 'on');
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
        
        function names = setupDisplay(this, i1, i2, varargin)
            
            % update the checked values in the menu
            set(this.handles.submenus{4}{i1}, 'checked', 'on');
            set(this.handles.submenus{4}{i2}, 'checked', 'off');
            set(this.handles.submenus{6}{i1}, 'checked', 'on');
            set(this.handles.submenus{6}{i2}, 'checked', 'off');
            
            if nargin > 3
                % set the name of the tab
                this.handles.tabs.TabTitles{varargin{1}} = varargin{2};
            end
            names = this.model.nameList;
        end
        
        function updateInfoBox(this, varargin)
            if nargin > 1
                this.handles.infoFields{1}.String = varargin{1}(1);
                this.handles.infoFields{2}.String = varargin{1}(2);
                this.handles.infoFields{3}.String = this.model.infoTable.levels{3}{varargin{1}(3)};
            else
                this.handles.infoFields{1}.String = '';
                this.handles.infoFields{2}.String = '';
                this.handles.infoFields{3}.String = '';
            end
        end
    end
end