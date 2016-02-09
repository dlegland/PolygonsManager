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
        %Constructor for the PolygonsManagerMainFrame class
        %
        %   inputs : none
        %   ouputs : 
        %       - this : PolygonsManagerMainFrame instance
            
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
            
            % box containing the polygon list and their informations
            left_box = uix.VBox('parent', main_box, ...
                               'spacing', 5);
            
            list_box = uicontrol('parent', left_box, ...
                                  'style', 'listbox', ...
                                    'max', 100, ...
                                    'min', 0);
            
            info_box =  uipanel('parent', left_box, ...
                            'background', 'w');
            
            % box containing the panels on which the polygons are drawn
            tab_box = uix.TabPanel('parent', main_box, ...
                                 'tabwidth', 100);
                             
            set(main_box, 'widths', [180 -1]);
            set(left_box, 'Heights', [-1 109]);
            
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
            %SETUPINFOPANEL  creates the fields where the polygons' informations are displayed
                                % fields with fixed text 
                uicontrol('parent', info_box,...
                        'position', [10 85 100 14], ...
                           'style', 'text',...
                          'string', 'Area :');
         
                uicontrol('parent', info_box,...
                        'position', [10 60 100 14], ...
                           'style', 'text',...
                          'string', 'Perimeter :');
         
                uicontrol('parent', info_box,...
                        'position', [10 35 100 14], ...
                           'style', 'text',...
                          'string', 'Vertices :');
         
                uicontrol('parent', info_box,...
                        'position', [10 10 100 14], ...
                           'style', 'text',...
                          'string', 'Orientation :');
         
                % fields with dynamic text 
                fields{1} = uicontrol('parent', info_box,...
                                   'position', [86 85 100 14], ...
                                      'style', 'text');
         
                fields{2} = uicontrol('parent', info_box,...
                                   'position', [86 60 100 14], ...
                                      'style', 'text');
         
                fields{3} = uicontrol('parent', info_box,...
                                   'position', [86 35 100 14], ...
                                      'style', 'text');
         
                fields{4} = uicontrol('parent', info_box,...
                                   'position', [86 10 100 14], ...
                                      'style', 'text');
                             
                 set(info_box.Children(:), 'fontsize', 10, ...
                                'horizontalalignment', 'left', ...
                                         'background', 'w');
            end
            
            function setupMenu
            %SETUPMENU  Creates all the menus of the MainFrame
            
                % create all the main menus
                fileMenu = uimenu(fen, 'label', 'F&ile');
                editMenu = uimenu(fen, 'label', 'F&actors', 'enable', 'off');
                foncMenu = uimenu(fen, 'label', '&Process', 'enable', 'off');
                pcaMenu = uimenu(fen, 'label', 'P&ca', 'visible', 'off');
                viewMenu = uimenu(fen, 'label', '&View', 'enable', 'off');
                contPmenu = uicontextmenu; 
                contLmenu = uicontextmenu; 
                
                % add the menus' handles to the list of handles
                this.handles.menus = {fileMenu, editMenu, foncMenu, viewMenu, pcaMenu, contPmenu, contLmenu};
                
                % create the space that will contain all the submenus
                this.handles.submenus = {};
                
%               ----------------------------------------------------------- FILE
                
                % create all the submenus of the 'file' menu
                f1 = uimenu(fileMenu, 'label', 'Import polygons (folder)', ...
                                   'callback', @(~,~) importBasicPolygon(this), ...
                                'accelerator', 'N');
                f2 = uimenu(fileMenu, 'label', 'Import polygons (file)', ...
                                   'callback', @(~,~) importCoordsPolygon(this));
                f3 = uimenu(fileMenu, 'label', 'Import signatures', ...
                                   'callback', @(~,~) importPolarSignature(this));
                
                f4 = uimenu(fileMenu, 'label', '&Divide polygons', ...
                                   'callback', @(~,~) dividePolygonArray(this), ...
                                     'enable', 'off', ...
                                'accelerator', 'D', ...
                                  'separator', 'on');
                
                f5 = uimenu(fileMenu, 'label', 'Save polygons', ...
                                   'callback', @(~,~) saveContours(this), ...
                                     'enable', 'off', ...
                                'accelerator', 'S', ...
                                  'separator', 'on');
                f6 = uimenu(fileMenu, 'label', 'Save signatures', ...
                                   'callback', @(~,~) savePolarSignature(this), ...
                                     'enable', 'off', ...
                                'accelerator', 'S');
                                 
                f7 = uimenu(fileMenu, 'label', 'Save &Macro', ...
                                   'callback', @(~,~) saveMacro(this.model), ...
                                     'enable', 'off', ...
                                  'separator', 'on', ...
                                'accelerator', 'Q');
                f8 = uimenu(fileMenu, 'label', '&Load Macro', ...
                                   'callback', @(~,~) loadMacro(this), ...
                                     'enable', 'off');
                
                f9 = uimenu(fileMenu, 'label', '&Export to WS', ...
                                   'callback', @(~,~) exportToWS, ...
                                     'enable', 'off', ...
                                  'separator', 'on');
                            
                f10 = uimenu(fileMenu, 'label', '&Close', ...
                                   'callback', @(~,~) close(gcf), ...
                                  'separator', 'on', ...
                                'accelerator', 'p');
                            
                this.handles.submenus{1} = {f1, f2, f3, f4, f5, f6, f7, f8, f9, f10};
                
%               ----------------------------------------------------------- FACTORS
                
                % create all the submenus of the 'factors' menu
                e1 = uimenu(editMenu, 'label', 'Import &factors', ...
                                   'callback', @(~,~) importFactors(this), ...
                                'accelerator', 'f');
                e2 = uimenu(editMenu, 'label', '&Create factors', ...
                                   'callback', @(~,~) createFactors(this));
                
                e3 = uimenu(editMenu, 'label', '&Save factors', ...
                                   'callback', @(~,~) saveFactors(this), ...
                                     'enable', 'off', ...
                                  'separator', 'on');
                
                e4 = uimenu(editMenu, 'label', '&Display factors', ...
                                   'callback', @(~,~) showTable(this.model.factorTable), ...
                                     'enable', 'off', ...
                                  'separator', 'on');
                
                e5 = uimenu(editMenu, 'label', 'Display &Infos', ...
                                   'callback', @(~,~) showTable(this.model.infoTable), ...
                                     'enable', 'on', ...
                                  'separator', 'on');
                
                this.handles.submenus{2} = {e1, e2, e3, e4, e5};
                
%               ----------------------------------------------------------- PROCESS
                
                % create all the submenus of the 'process' menu
                fc1 = uimenu(foncMenu, 'label', 'Rotate &all');
                           uimenu(fc1, 'label', '90° &right', ...
                                    'callback', @(~,~) polygonsRotate(this, 90, 'all'));
                           uimenu(fc1, 'label', '90° &left', ...
                                    'callback', @(~,~) polygonsRotate(this, 270, 'all'));
                           uimenu(fc1, 'label', '&180°', ...
                                    'callback', @(~,~) polygonsRotate(this, 180, 'all'));
                
                fc2 = uimenu(foncMenu, 'label', 'Rotate &selected');
                           uimenu(fc2, 'label', '90° &right', ...
                                    'callback', @(~,~) polygonsRotate(this, 90, 'selected'));
                           uimenu(fc2, 'label', '90° &left', ...
                                    'callback', @(~,~) polygonsRotate(this, 270, 'selected'));
                           uimenu(fc2, 'label', '&180°', ...
                                    'callback', @(~,~) polygonsRotate(this, 180, 'selected'));
                           uimenu(fc2, 'label', 'Custom angle C&W', ...
                                    'callback', @(~,~) polygonsRotate(this, 'customCW', 'selected'), ...
                                   'separator', 'on');
                           uimenu(fc2, 'label', 'Custom angle &CCW', ...
                                    'callback', @(~,~) polygonsRotate(this, 'customCCW', 'selected'));
                
                fc3 = uimenu(foncMenu, 'label', 'Re&center polygons', ...
                              'callback', @(~,~) polygonsRecenter(this), ...
                             'separator', 'on');
                fc4 = uimenu(foncMenu, 'label', '&Resize polygons', ...
                              'callback', @(~,~) polygonsResize(this));
                
                fc5 = uimenu(foncMenu, 'label', 'Sim&plify polygons', ...
                              'callback', @(~,~) polygonsSimplify(this, 'on'), ...
                             'separator', 'on');
                fc6 = uimenu(foncMenu, 'label', 'A&lign polygons');
                           uimenu(fc6, 'label', '&Precise', ...
                                    'callback', @(~,~) polygonsAlign(this, 'precise'));
                           uimenu(fc6, 'label', '&fast', ...
                                    'callback', @(~,~) polygonsAlign(this, 'fast'));
                    
                          
                fc7 = uimenu(foncMenu, 'label', 'S&ignature', ...
                              'callback', @(~,~) polygonsToSignature(this), ...
                             'separator', 'on');
                fc8 = uimenu(foncMenu, 'label', 'C&oncatenate', ...
                              'callback', @(~,~) polygonsConcatenate(this));
                          
                this.handles.submenus{3} = {fc1, fc2, fc3, fc4, fc5, fc6, fc7, fc8};
                
%               ----------------------------------------------------------- PCA
                
                % create all the submenus of the 'pca' menu
                pca1 = uimenu(pcaMenu, 'label', '&Compute PCA', ...
                                    'callback', @(~,~) computePCA(this));
                          
                pca2 = uimenu(pcaMenu, 'label', 'Display &eigen values', ...
                                    'callback', @(~,~) pcaEigen(this), ...
                                      'enable', 'off', ...
                                   'separator', 'on');
                pca3 = uimenu(pcaMenu, 'label', 'Display &scores', ...
                                    'callback', @(~,~) pcaScores(this), ...
                                      'enable', 'off');
                pca5 = uimenu(pcaMenu, 'label', 'Display &influence', ...
                                    'callback', @(~,~) pcaInfluence(this), ...
                                      'enable', 'off');
                pca4 = uimenu(pcaMenu, 'label', 'Display &loadings', ...
                                    'callback', @(~,~) pcaLoadings(this), ...
                                      'enable', 'off');
                pca6 = uimenu(pcaMenu, 'label', 'Display &profiles', ...
                                    'callback', @(~,~) pcaVector(this), ...
                                      'enable', 'off');
                            
                pca7 = uimenu(pcaMenu, 'label', '&Display scores + profiles', ...
                                    'callback', @(~,~) pcaScoresProfiles(this), ...
                                      'enable', 'off', ...
                                   'separator', 'on');
                               
                this.handles.submenus{5} = {pca1, pca2, pca3, pca4, pca5, pca6, pca7};
                
%               ----------------------------------------------------------- VIEW
                
                % create all the submenus of the 'view' menu
                v1 = uimenu(viewMenu, 'label', '&No Coloration', ...
                                   'callback', @(~,~) deleteColors);
                v2 = uimenu(viewMenu, 'label', '&Coloration factor', ...
                                   'callback', @(~,~) selectFactor(this), ...
                                     'enable', 'off', ...
                                'accelerator', 'W');
                                 
                v3 = uimenu(viewMenu, 'label', '&Grid', ...
                                   'callback', @(~,~) showGrid, ...
                                  'separator', 'on', ...
                                'accelerator', 'V');
                v4 = uimenu(viewMenu, 'label', '&Markers', ...
                                   'callback', @(~,~) showMarker, ...
                                'accelerator', 'B');
                v5 = uimenu(viewMenu, 'label', '&Zoom', ...
                                   'callback', @(~,~) zoomMode, ...
                                  'separator', 'on', ...
                                'accelerator', 'Z');
                v6 = uimenu(viewMenu, 'label', '&Reset zoom', ...
                                   'callback', @(~,~) zoom('out'));
                
                this.handles.submenus{4} = {v1, v2, v3, v4, v5, v6};
                
%               ----------------------------------------------------------- 
                
                % create all the submenus of the context menu of the futur
                % panels and axes
                cp1 = uimenu(contPmenu, 'label', '&No Coloration', ...
                                     'callback', @(~,~) deleteColors);
                cp2 = uimenu(contPmenu, 'label', '&Coloration factor', ...
                                     'callback', @(~,~) selectFactor(this), ...
                                       'enable', 'off');
                                   
                cp3 = uimenu(contPmenu, 'label', '&Grid', ...
                                     'callback', @(~,~) showGrid, ...
                                    'separator', 'on');
                cp4 = uimenu(contPmenu, 'label', '&Markers', ...
                                     'callback', @(~,~) showMarker);
                cp5 = uimenu(contPmenu, 'label', '&Zoom', ...
                                     'callback', @(~,~) zoomMode, ...
                                    'separator', 'on');
                cp6 = uimenu(contPmenu, 'label', '&Reset zoom', ...
                                     'callback', @(~,~) zoom('out'));
                
                this.handles.submenus{6} = {cp1, cp2, cp3, cp4, cp5, cp6};
                
%               ----------------------------------------------------------- 
                
                % create the submenu of the selection list
                cl1 = uimenu(contLmenu, 'label', '&Swap selection', ...
                                     'callback', @(~,~) swapSelection);
                
                this.handles.submenus{7} = {cl1};
                
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
                    
                    if ht.Extent(4) < this.handles.figure.Position(4)
                        % if the Height property of the uitable in which
                        % the Table is displayed is lower than the total
                        % Height of the MainFrame
                        
                        % match the size of the new figure to the size of the
                        % uiTable and get the position where the figure
                        % will be at the center of the MainFrame
                        ht.Position = ht.Extent;
                        pos = getMiddle(this.handles.figure, ht.Position(3), ht.Position(4));
                    else
                        % get the position where the new figure will be at
                        % the center of the MainFrame with the same Height
                        % as the MainFrame and make the uiTable take all
                        % the place it can
                                                            % +16 = scrollbar
                        pos = getMiddle(this.handles.figure, ht.Extent(3)+16, this.handles.figure.Position(4));
                        ht.Units = 'normalized';
                        ht.Position = [0 0 1 1];
                    end
                    % set the position of the new figure
                    hf.Position = pos;
                end
                
                function showGrid
                %SHOWGRID  display the grids on an axis and updates the menus
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
                %SHOWMARKER  display the marker on the lines of an axis and updates th menus
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
                function deleteColors
                %DELETECOLORS  display the datas of the current polygons without coloration
                    
                    if isempty(this.handles.Panels{1}.type)
                        % display the polygons without coloration
                        displayPolygons(this.handles.Panels{1}, getAllPolygons(this.model.PolygonArray));
                        if strcmp(class(this.model.PolygonArray), 'PolarSignatureArray')
                            displayPolarSignature(this.handles.Panels{2}, this.model.PolygonArray.signatures, this.model.PolygonArray.angleList);
                        end
                    else
                        % if the current display is the result of a pca
                        % get all the objects drawn onto the panel
                        allHandleList = allchild(this.handles.Panels{1}.uiAxis); 
                        
                        % among these objects, get the lines
                        allTypeList = get(allHandleList, 'marker');
                        lines = allHandleList(~strcmp(allTypeList, '.'));
                        
                        % reset the color of the points, delete the lines
                        % and the legends
                        set(allHandleList(:), 'color', 'k');
                        delete(lines);
                        delete(this.handles.Panels{1}.uiLegend);
                        
                        % update the menus
                        set(this.handles.submenus{4}{1}, 'checked', 'on');
                        set(this.handles.submenus{4}{2}, 'checked', 'off');
                        set(this.handles.submenus{6}{1}, 'checked', 'on');
                        set(this.handles.submenus{6}{2}, 'checked', 'off');
                    end
                end
                
                function swapSelection
                %SWAPSELECTION  unselects all the selected polygons and selects all the unselected
                    
                    % get the complete list of polygons' name
                    liste = this.model.nameList;
                    
                    % memory allocation
                    nonSelVal=zeros(length(liste),1);
                    
                    
                    for i = 1:length(liste)
                        % for each polygons
                        if ~ismember(i, get(this.handles.list, 'value'))
                            % if the polygon is not selected, save it
                            nonSelVal(i) = i;
                        end
                    end
                    
                    % delete all the zeros of the not selected polygons list
                    nonSelVal = nonSelVal(nonSelVal~=0);
                    
                    % set the unselected polygons as the selected polygons
                    set(this.handles.list, 'value', nonSelVal)
                    this.model.selectedPolygons = liste(nonSelVal);
                    
                    %update the view
                    updateSelectedPolygonsDisplay(this.handles.Panels{this.handles.tabs.Selection});
                end
                
                function zoomMode
                %ZOOMMODE activate/deactive the zoom and updates the menu
                    if strcmp(v5.Checked, 'off');
                        set(v5, 'checked', 'on');
                        set(cp5, 'checked', 'on');
                        zoom('on');
                    else
                        set(v5, 'checked', 'off');
                        set(cp5, 'checked', 'off');
                        zoom('off');
                    end
                end
                
                function exportToWS
                %EXPORTTOWS export the gathered datas to matlab's workspace
                
                    if strcmp(class(this.model.PolygonArray), 'BasicPolygonArray')
                        % export the polygons as a cell array of cell arrays 
                        assignin('base', 'polygons', this.model.PolygonArray.polygons);
                    elseif strcmp(class(this.model.PolygonArray), 'CoordsPolygonArray')
                        % export the polygons as a Table
                        colnames = [cellstr(num2str((1:size(obj.model.PolygonArray.polygons, 2)/2)', 'x%d'))' cellstr(num2str((1:size(obj.model.PolygonArray.polygons, 2)/2)', 'y%d'))'];
        
                        assignin('base', 'polygons', Table.create(obj.model.PolygonArray.polygons, ...
                                                                  'rowNames', this.model.nameList, ...
                                                                  'colNames', colnames));
                    else
                        % export the polar signatures as a table
                        colnames = cellstr(num2str(this.model.PolygonArray.angleList'));
                        
                        assignin('base', 'signatures', Table.create(this.model.PolygonArray.signatures, ...
                                                                  'rowNames', this.model.nameList, ...
                                                                  'colNames', colnames'));
                    end
                    if strcmp(class(this.model.factorTable), 'Table')
                        % if there's one, export the factor Table
                        assignin('base', 'factors', this.model.factorTable);
                    end
                    if strcmp(class(this.model.pca), 'Pca')
                        % if that PCA has been computed, export it
                        assignin('base', 'pca', this.model.pca);
                    end
                    % export the informations concerning the polygons
                    assignin('base', 'informations', this.model.infoTable);
                end
            end
        end
    end
% -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
% ----------------------------------------------------------------------------- OTHER METHODS -----------------------------------------------------------------------------------------------------
% -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    methods
        function pos = getMiddle(figure, width, height)
        %GETMIDDLE  get the position where a figure must be to be at the exact center of a figure
        %
        %   inputs :
        %       - figure : handle of a figure 
        %       - width : width of the figure that must be centered
        %       - height : height of the figure that must be centered
        %   ouputs : 
        %       - pos : result of the computation
            
            % get the position of the figure
            pos = get(figure, 'outerposition');
            
            % compute the position
            pos(1) = pos(1) + (pos(3)/2) - (width/2);
            pos(2) = pos(2) + (pos(4)/2) - (height/2);
            pos(3) = width;
            pos(4) = height;
        end
        
        function setupNewFrame(this, model, varargin)
        %SETUPNEWFRAME  fill a PolygonsManagerMainFrame with the parameters given
        %
        %   inputs :
        %       - obj : handle of the PolygonsManagerMainFrame that
        %       must be setup
        %       - model : PolygonsManagerData instance
        %   ouputs : none
            
            % creation of the model of the new PolygonsManagerMainFrame
            this.model = model;
            
            % fill the selection list of the new PolygonsManagerMainFrame
            set(this.handles.list, 'string', model.nameList, ...
                                 'callback', @(~,~) select, ...
                            'uicontextmenu', this.handles.menus{7});
            if ~isempty(varargin)
                set(this.handles.figure, 'name', varargin{1});
                varargin(1) = [];
            end
            
            if isempty(varargin)
                % creation of a panel on which the polygons will be drawn
                Panel(this, length(this.handles.tabs.Children) + 1, 'on');
                this.handles.tabs.TabTitles{1} = 'Polygons';
                
                % draw the polygons on the new PolygonsManagerMainFrame
                displayPolygons(this.handles.Panels{1}, getAllPolygons(this.model.PolygonArray));
                if strcmp(class(this.model.PolygonArray), 'PolarSignatureArray')
                    % if the polygons are saved as polar signature, display
                    % the polar signatures
                    Panel(this, length(this.handles.tabs.Children) + 1, 'off');
                    this.handles.tabs.TabTitles{2} = 'Signatures';
                    displayPolarSignature(this.handles.Panels{2}, this.model.PolygonArray.signatures, this.model.PolygonArray.angleList);
                end
            else
                % if the mainframe must display one of the results of a PCA
                % creation of a panel on which the polygons will be drawn
                Panel(this,length(this.handles.tabs.Children) + 1, varargin{2});
                this.handles.Panels{1}.type = varargin{1};
                if strcmp(varargin{1}, 'pcaLoadings')
                    % if the loadings of a PCA must be displayed
                    % deactivate the callback of the list
                    set(this.handles.list, 'callback', '');
                    
                    displayPca(this.handles.Panels{1}, varargin{3}, varargin{4});
                elseif strcmp(varargin{1}, 'pcaVector')
                    % if profiles must be displayed
                    % change the callback of the list
                    set(this.handles.list, 'callback', @(~,~) draw);
                    
                    this.handles.tabs.TabTitles{length(this.handles.tabs.Children)} = 'Polygon';
                    displayPolygons(this.handles.Panels{length(this.handles.tabs.Children)}, varargin{3}, varargin{5});
                    if strcmp(class(this.model.PolygonArray), 'PolarSignatureArray')
                        Panel(this, length(this.handles.tabs.Children) + 1, 'off');
                        this.handles.tabs.TabTitles{length(this.handles.tabs.Children)} = 'Signature';
                        displayPolarSignature(this.handles.Panels{length(this.handles.tabs.Children)}, varargin{4}, this.model.PolygonArray.angleList, varargin{5});
                    end
                else
                    displayPca(this.handles.Panels{1}, varargin{3}, varargin{4});
                end
            end
            
            % update the menus of the new PolygonsManagerMainFrame
            updateMenus(this);
            
            function select
            %SELECT  change the display depending on the selected polygons
                
                %get the list of selected polygons
                list = cellstr(get(this.handles.list, 'String'));
                selVal = get(this.handles.list, 'value');
                this.model.selectedPolygons = list(selVal);
                
                %update the displayed polygons
                updateSelectedPolygonsDisplay(this.handles.Panels{this.handles.tabs.Selection});
            end
            
            function draw
            %DRAW  draw polygons depending on the current selection
                
                % get the list of selected polygons
                list = cellstr(get(this.handles.list, 'String'));
                selVal = get(this.handles.list, 'value');
                this.model.selectedPolygons = list(selVal);
                
                % memory allocation
                polygons = cell(length(this.model.selectedPolygons), 1);
                if strcmp(class(this.model.PolygonArray), 'PolarSignatureArray')
                    signatures = zeros(length(this.model.selectedPolygons), length(this.model.PolygonArray.angleList));
                end
                
                % get the polygons using the names got earlier
                for i = 1:length(this.model.selectedPolygons)
                    polygons{i} = getPolygonFromName(this.model, this.model.selectedPolygons{i});
                    if strcmp(class(this.model.PolygonArray), 'PolarSignatureArray')
                        signatures(i, :) = getSignatureFromName(this.model, this.model.selectedPolygons{i});
                    end
                end
                
                % display the polygons
                displayPolygons(this.handles.Panels{1}, polygons);
                if strcmp(class(this.model.PolygonArray), 'PolarSignatureArray')
                    displayPolarSignature(this.handles.Panels{2}, signatures, this.model.PolygonArray.angleList);
                end
                
                %update the infos
                if length(this.model.selectedPolygons) == 1
                    updateInfoBox(this, getInfoFromName(this.model, this.model.selectedPolygons));
                else
                    updateInfoBox(this);
                end
                
                %reset the selection
                this.model.selectedPolygons = {};
            end
        end
        
        function updateMenus(this)
        %UPDATEMENUS  update the menus depending on the current datas of the model
        %
        %   inputs :
        %       - this : handle of the PolygonsManagerMainFrame
        %   ouputs : none
            if strcmp(class(this.model), 'PolygonsManagerData')
                set(this.handles.submenus{1}{4}, 'enable', 'on');
                if ~isempty(this.model.usedProcess) 
                    set([this.handles.submenus{1}{7:8}], 'enable', 'on');
                end
                set(this.handles.submenus{1}{9}, 'enable', 'on');
                set(this.handles.menus{2}, 'enable', 'on');
                set(this.handles.menus{4}, 'enable', 'on');
                set(this.handles.menus{3}, 'enable', 'on');
                if strcmp(class(this.model.PolygonArray), 'BasicPolygonArray')
                    set(this.handles.submenus{1}{5}, 'enable', 'on');
                elseif strcmp(class(this.model.PolygonArray), 'CoordsPolygonArray')
                    set(this.handles.menus{3}, 'visible', 'off');
                    set(this.handles.menus{5}, 'visible', 'on');
                    set(this.handles.submenus{1}{5}, 'enable', 'on');
                else
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
                        if ~ismember(this.handles.Panels{1}.type, {'pcaScores', 'pcaInfluence', 'pcaScoresProfiles'})
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
        %SETUPDISPLAY  set the name of the panel and updates the menus
        %
        %   inputs :
        %       - this : handle of the PolygonsManagerMainFrame
        %       - i1 : index of the menus thet must be checked
        %       - i2 : index of the menus thet must be unchecked
        %   ouputs : 
        %       - names : list of all the polygons names
        
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
        %UPDATEINFOBOX  update the informations concerning the selected polygon
        %
        %   inputs :
        %       - this : handle of the PolygonsManagerMainFrame
        %   ouputs : none
        
            if nargin > 1
                %if there's only one polygon selected display its
                %informations
                this.handles.infoFields{1}.String = varargin{1}(1);
                this.handles.infoFields{2}.String = varargin{1}(2);
                this.handles.infoFields{3}.String = varargin{1}(3);
                this.handles.infoFields{4}.String = this.model.infoTable.levels{4}{varargin{1}(4)};
            else
                %if there's multiple/no polygons selected display nothing
                this.handles.infoFields{1}.String = '';
                this.handles.infoFields{2}.String = '';
                this.handles.infoFields{3}.String = '';
                this.handles.infoFields{4}.String = '';
            end
        end
    end
end