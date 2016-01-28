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
        function obj = PolygonsManagerMainFrame
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
            obj.handles.figure = fen;            
            
            % creation of the boxes that will contain different elements
            % later
            main_box = uix.HBox('parent', fen, ...
                               'padding', 5);
            
            list_box = uicontrol('parent', main_box, ...
                                  'style', 'listbox', ...
                                    'max', 100, ...
                                    'min', 0);
            
            tab_pan = uix.TabPanel('parent', main_box, ...
                                 'tabwidth', 75);
            
            set(main_box, 'widths', [-1 -8]);
            
            % add created handles to the list of handles
            obj.handles.main = main_box;
            obj.handles.tabs = tab_pan;
            obj.handles.list = list_box;
            
            % create spaces that will be used by other elements later
            obj.handles.panels = {};
            obj.handles.axes = {};
            obj.handles.lines = {};
            obj.handles.legends = {};
            
            % create the menu
            setupMenu;
            
            function setupMenu
                % create all the menus
                fileMenu = uimenu(fen, 'label', '&File');
                editMenu = uimenu(fen, 'label', '&Factors', 'enable', 'off');
                foncMenu = uimenu(fen, 'label', '&Process', 'enable', 'off');
                pcaMenu = uimenu(fen, 'label', '&Pca', 'visible', 'off');
                viewMenu = uimenu(fen, 'label', '&View', 'enable', 'off');
                contmenu = uicontextmenu; 
                
                %add the menus' handles to the list of handles
                obj.handles.menus = {fileMenu, editMenu, foncMenu, viewMenu, pcaMenu, contmenu};
                
                % create the space that will contain all the submenus
                obj.handles.submenus = {};
                
%               ----------------------------------------------------------- 
                
                % create all the submenus of the 'file' menu
                f1 = uimenu(fileMenu, 'label', '&Import polygons (folder)', ...
                              'callback', @(src, event) importBasicPolygon(obj));
                f2 = uimenu(fileMenu, 'label', '&Import polygons (file)', ...
                              'callback', @(src, event) importCoordsPolygon(obj));
                f3 = uimenu(fileMenu, 'label', '&Import signatures', ...
                              'callback', @(src, event) importPolarSignature(obj));
                
                f4 = uimenu(fileMenu, 'label', '&Save polygons', ...
                                   'callback', @(src, event) saveContours(obj), ...
                                     'enable', 'off', ...
                             'separator', 'on');
                f5 = uimenu(fileMenu, 'label', '&Save signatures', ...
                                   'callback', @(src, event) savePolarSignature(obj), ...
                                     'enable', 'off');
                
                f6 = uimenu(fileMenu, 'label', '&Close', ...
                              'callback', @(src, event) closef(gcf), ...
                             'separator', 'on');
                
                obj.handles.submenus{1} = {f1, f2, f3, f4, f5, f6};
                
%               ----------------------------------------------------------- 
                
                % create all the submenus of the 'factors' menu
                e1 = uimenu(editMenu, 'label', '&Import factors', ...
                              'callback', @(src, event) importFactors(obj));
                e2 = uimenu(editMenu, 'label', '&Create factors', ...
                              'callback', @(src, event) createFactors(obj));
                
                e3 = uimenu(editMenu, 'label', '&Save factors', ...
                                   'callback', @(src, event) saveFactors(obj), ...
                                     'enable', 'off', ...
                                  'separator', 'on');
                
                e4 = uimenu(editMenu, 'label', '&Display factors', ...
                                   'callback', @(src, event) showFactors, ...
                                     'enable', 'off', ...
                                  'separator', 'on');
                
                obj.handles.submenus{2} = {e1, e2, e3, e4};
                
%               -----------------------------------------------------------  
                
                % create all the submenus of the 'process' menu
                fc1 = uimenu(foncMenu, 'label', '&Rotate all');
                uimenu(fc1, 'label', '&90° right', ...
                         'callback', @(src, event) contoursRotate(obj, 1, 'all'));
                uimenu(fc1, 'label', '&90° left', ...
                         'callback', @(src, event) contoursRotate(obj, 2, 'all'));
                uimenu(fc1, 'label', '&180°', ...
                         'callback', @(src, event) contoursRotate(obj, 3, 'all'));
                
                fc2 = uimenu(foncMenu, 'label', '&Rotate selected');
                uimenu(fc2, 'label', '&90° right', ...
                         'callback', @(src, event) contoursRotate(obj, 1, 'selected'));
                uimenu(fc2, 'label', '&90° left', ...
                         'callback', @(src, event) contoursRotate(obj, 2, 'selected'));
                uimenu(fc2, 'label', '&180°', ...
                         'callback', @(src, event) contoursRotate(obj, 3, 'selected'));
                
                fc3 = uimenu(foncMenu, 'label', '&Recenter polygons', ...
                              'callback', @(src, event) contoursRecenter(obj), ...
                             'separator', 'on');
                fc4 = uimenu(foncMenu, 'label', '&Resize polygons', ...
                              'callback', @(src, event) contoursResize(obj));
                
                fc5 = uimenu(foncMenu, 'label', '&Align axis', ...
                              'callback', @(src, event) contoursAlign(obj), ...
                             'separator', 'on');
                fc6 = uimenu(foncMenu, 'label', '&Signature', ...
                              'callback', @(src, event) contoursToSignature(obj));
                fc7 = uimenu(foncMenu, 'label', '&Concatenate', ...
                              'callback', @(src, event) contoursConcatenate(obj));
                          
                obj.handles.submenus{3} = {fc1, fc2, fc3, fc4, fc5, fc6, fc7};
                
%               -----------------------------------------------------------  
                
                % create all the submenus of the 'process' menu
                pca1 = uimenu(pcaMenu, 'label', '&Compute PCA', ...
                              'callback', @(src, event) testPCA(obj));
                          
                pca2 = uimenu(pcaMenu, 'label', '&Display eigen', ...
                              'callback', @(src, event) pcaEigen(obj), ...
                                'enable', 'off', ...
                             'separator', 'on');
                pca3 = uimenu(pcaMenu, 'label', '&Display scores', ...
                              'callback', @(src, event) pcaScores(obj), ...
                                'enable', 'off');
                pca4 = uimenu(pcaMenu, 'label', '&Display loadings', ...
                              'callback', @(src, event) pcaLoadings(obj), ...
                                'enable', 'off');
                pca5 = uimenu(pcaMenu, 'label', '&Display influence', ...
                              'callback', @(src, event) pcaInfluence(obj), ...
                                'enable', 'off');
                obj.handles.submenus{5} = {pca1, pca2, pca3, pca4, pca5};
                
%               ----------------------------------------------------------- 
                
                % create all the submenus of the 'view' menu
                v1 = uimenu(viewMenu, 'label', '&No Coloration', ...
                              'callback', @(src, event) dispAxes);
                v2 = uimenu(viewMenu, 'label', '&Coloration factor', ...
                              'callback', @(src, event) selectFactor(obj), ...
                                'enable', 'off');
                v3 = uimenu(viewMenu, 'label', '&Grid', ...
                              'callback', @(src, event) showGrid);
                
                obj.handles.submenus{4} = {v1, v2, v3};
                
%               ----------------------------------------------------------- 
                
                % create all the submenus of the context menu of the futur
                % panels and axes
                c1 = uimenu(contmenu, 'label', '&No Coloration', ...
                              'callback', @(src, event) dispAxes);
                c2 = uimenu(contmenu, 'label', '&Coloration factor', ...
                              'callback', @(src, event) selectFactor(obj), ...
                                'enable', 'off');
                c3 = uimenu(contmenu, 'label', '&Grid', ...
                              'callback', @(src, event) showGrid);
                
                obj.handles.submenus{6} = {c1, c2, c3};
                
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
                    show(obj.model.factorTable);
                end
                
                function showGrid
                    %SHOWGRID  display the grids on an axis and updates
                    %the menus
                    if strcmp(v3.Checked, 'off');
                        set(v3, 'checked', 'on');
                        set(c3, 'checked', 'on');
                        set(obj.handles.axes{obj.handles.tabs.Selection}, 'xgrid', 'on');
                        set(obj.handles.axes{obj.handles.tabs.Selection}, 'ygrid', 'on');
                    else
                        set(v3, 'checked', 'off');
                        set(c3, 'checked', 'off');
                        set(obj.handles.axes{obj.handles.tabs.Selection}, 'xgrid', 'off');
                        set(obj.handles.axes{obj.handles.tabs.Selection}, 'ygrid', 'off');
                    end
                end
                
                function dispAxes
                    %DISPAXES  display the datas of the current polygons
                    displayPolygons(obj, getAllPolygons(obj.model.PolygonArray), obj.handles.axes{1});
                    if isa(obj.model.PolygonArray, 'PolarSignatureArray')
                        displayPolarSignature(obj, obj.model.PolygonArray, obj.handles.axes{2});
                    end
                end
            end
        end
        
        function pos = getMiddle(obj, height, width)
            %GETMIDDLE  get the position where a figure must be to be at
            %the exact center of the main frame
            pos = get(obj, 'outerposition');

            pos(1) = pos(1) + (pos(3)/2) - (height/2);
            pos(2) = pos(2) + (pos(4)/2) - (width/2);
            pos(3) = height;
            pos(4) = width;
        end
        
        function setupNewFrame(obj, nameArray, polygonArray, varargin)
            %SETUPNEWFRAME  fill a PolygonsManagerMainFrame with the parameters given
            %
            %   inputs :
            %       - obj : handle of the PolygonsManagerMainFrame that
            %       must be setup
            %       - nameArray : list of the names of the polygons that
            %       the futur PolygonsManagerMainFrame will display
            %       - polygonArray : list of polygons that the futur
            %       PolygonsManagerMainFrame will display
            
            % creation of the model of the new PolygonsManagerMainFrame
            obj.model = PolygonsManagerData(polygonArray, nameArray);
            
            if  find(strcmp('factorTable', varargin))
                ind = find(strcmp('factorTable', varargin));
                obj.model.factorTable = varargin{ind+1};
                varargin(ind+1) = [];
                varargin(ind) = [];
            end
            if find(strcmp('pca', varargin))
                ind = find(strcmp('pca', varargin));
                obj.model.pca = varargin{ind+1};
                varargin(ind+1) = [];
                varargin(ind) = [];
            end
            
            % fill the selection list of the new PolygonsManagerMainFrame
            set(obj.handles.list, 'string', nameArray, 'callback', @(src, event) select);
            
            % update the menus of the new PolygonsManagerMainFrame
            updateMenus(obj);
            
            
            if isempty(varargin)
                % creation of a panel on which the polygons will be drawn
                createPanel(obj,length(obj.handles.tabs.Children) + 1, 'on');
                
                % draw the polygons of the new PolygonsManagerMainFrame
                displayPolygons(obj, getAllPolygons(obj.model.PolygonArray), obj.handles.axes{1});
                if isa(obj.model.PolygonArray, 'PolarSignatureArray')
                    createPanel(obj,obj.handles.tabs.Selection + 1, 'off');
                    displayPolarSignature(obj, obj.model.PolygonArray, obj.handles.axes{2});
                end
            else
                % creation of a panel on which the polygons will be drawn
                createPanel(obj,length(obj.handles.tabs.Children) + 1, varargin{3});
                
                displayPca(obj, obj.handles.axes{1}, varargin{1}, varargin{2});
            end
        
            function select
                list = cellstr(get(obj.handles.list, 'String'));
                sel_val = get(obj.handles.list, 'value');
                obj.model.selectedPolygons = list(sel_val);
                updateSelectedPolygonsDisplay(obj);
            end
        end
        
        function updateSelectedPolygonsDisplay(obj)
            %UPDATESELECTEDPOLYGONSDISPLAY  display the lines of the
            %current axis differently if they're selected or not
            selected = obj.model.selectedPolygons;
            allHandleList = get(obj.handles.axes{obj.handles.tabs.Selection}, 'Children'); 
            allTagList = get(allHandleList, 'tag');
            if ~isempty(allTagList)
                neededHandle = allHandleList(ismember(allTagList, selected));
                if strcmp(allHandleList(1).LineStyle, '-')
                    set(allHandleList, 'LineWidth', .5);
                    set(neededHandle, 'LineWidth', 3.5);
                    uistack(neededHandle, 'top');
                else    
                    set(allHandleList, 'color', 'k');
                    set(allHandleList, 'Marker', '.');
                    set(neededHandle, 'color', 'r');
                    set(neededHandle, 'Marker', '*');
                    uistack(neededHandle, 'top');
                end
            end
        end
        
        function updateMenus(obj)
            %UPDATEMENUS  update the menus depending on the current datas
            %of the model
            if isa(obj.model, 'PolygonsManagerData')
                set(obj.handles.menus{2}, 'enable', 'on');
                set(obj.handles.menus{4}, 'enable', 'on');
                set(obj.handles.menus{3}, 'enable', 'on');
                if isa(obj.model.PolygonArray, 'BasicPolygonArray')
                    set(obj.handles.submenus{1}{4}, 'enable', 'on');
                elseif isa(obj.model.PolygonArray, 'CoordsPolygonArray')
                    set(obj.handles.menus{3}, 'visible', 'off');
                    set(obj.handles.menus{5}, 'visible', 'on');
                    set(obj.handles.submenus{1}{4}, 'enable', 'on');
                elseif isa(obj.model.PolygonArray, 'PolarSignatureArray')
                    set(obj.handles.menus{3}, 'visible', 'off');
                    set(obj.handles.menus{5}, 'visible', 'on');
                    set(obj.handles.submenus{1}{5}, 'enable', 'on');
                end
                if isa(obj.model.factorTable, 'Table')
                    set(obj.handles.submenus{2}{1}, 'checked', 'on');
                    set([obj.handles.submenus{2}{:}], 'enable', 'on');
                    set(obj.handles.submenus{4}{2}, 'enable', 'on');
                    set(obj.handles.submenus{6}{2}, 'enable', 'on');
                    set(obj.handles.figure, 'name', ['Polygons Manager | factors : ' obj.model.factorTable.name]);
                end
                if isa(obj.model.pca, 'Pca')
                    set([obj.handles.submenus{5}{:}], 'enable', 'on');
                    if isa(obj.model.factorTable, 'Table')
                        set(obj.handles.figure, 'name', ['Polygons Manager | factors : ' obj.model.factorTable.name ' | PCA']);
                    else
                        set(obj.handles.figure, 'name', 'Polygons Manager | PCA');
                    end
                end
            end
        end
    end
end