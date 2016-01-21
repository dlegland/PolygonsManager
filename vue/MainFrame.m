classdef MainFrame < handle
    
    properties
        
        handles;
        
        model;
        
    end
    
    methods
        function obj = MainFrame
            fen = figure('units', 'normalized', ...
                 'outerposition', [0.25 0.25 0.5 0.5], ...
                       'menubar', 'none', ...
                   'numbertitle', 'off', ...
                   'name', 'Polygons Manager');
            set(fen, 'units', 'pixel');
            
            obj.handles.figure = fen;            
            
            main_box = uix.HBox('parent', fen, ...
                               'padding', 5);
            
            list_box = uicontrol('parent', main_box, ...
                                  'style', 'listbox', ...
                                    'max', 100, ...
                                    'min', 0);
                           
            tab_pan = uix.TabPanel('parent', main_box);
            
            set(main_box, 'widths', [-1 -8]);
            
            obj.handles.main = main_box;
            obj.handles.tabs = tab_pan;
            obj.handles.list = list_box;
            obj.handles.panels = {};
            obj.handles.axes = {};
            obj.handles.lines = {};
            obj.handles.legends = {};
            
            setupMenu(fen);
            
            function setupMenu(fen)
                fileMenu = uimenu(fen, 'label', '&File');
                editMenu = uimenu(fen, 'label', '&Edit', 'enable', 'off');
                foncMenu = uimenu(fen, 'label', '&Process', 'enable', 'off');
                viewMenu = uimenu(fen, 'label', '&View', 'enable', 'off');
                
                obj.handles.menus = {fileMenu, editMenu, foncMenu, viewMenu};
                obj.handles.submenus = {};
                
                f1 = uimenu(fileMenu, 'label', '&Import polygons', ...
                              'callback', {@importPolygonArray, obj});
                          
                f2 = uimenu(fileMenu, 'label', '&Import signatures', ...
                              'callback', {@importPolarSignature, obj});
                          
                f3 = uimenu(fileMenu, 'label', '&Save polygons', ...
                                   'callback', {@saveContours, obj}, ...
                                     'enable', 'off', ...
                             'separator', 'on');
                f4 = uimenu(fileMenu, 'label', '&Save signatures', ...
                                   'callback', {@savePolarSignature, obj}, ...
                                     'enable', 'off');
                                 
                f5 = uimenu(fileMenu, 'label', '&Close', ...
                              'callback', {@closef, gcf}, ...
                             'separator', 'on');
                         
                obj.handles.submenus{1} = {f1, f2, f3, f4, f5};
                          
%               ----------------------------------------------------------- 

                e1 = uimenu(editMenu, 'label', '&Import factors', ...
                              'callback', {@importFactors, obj});
                          
                e2 = uimenu(editMenu, 'label', '&Display factors', ...
                                   'callback', @showFactors, ...
                                     'enable', 'off');
                
                obj.handles.submenus{2} = {e1, e2};
                          
%               -----------------------------------------------------------  
                          
                fc1 = uimenu(foncMenu, 'label', '&Rotate all');
                uimenu(fc1, 'label', '&90° droite', ...
                         'callback', {@contoursRotate, obj, 1, 1});
                uimenu(fc1, 'label', '&90° gauche', ...
                         'callback', {@contoursRotate, obj, 2, 1});
                uimenu(fc1, 'label', '&180°', ...
                         'callback', {@contoursRotate, obj, 3, 1});
                     
                fc2 = uimenu(foncMenu, 'label', '&Rotate selected');
                uimenu(fc2, 'label', '&90° droite', ...
                         'callback', {@contoursRotate, obj, 1, 2});
                uimenu(fc2, 'label', '&90° gauche', ...
                         'callback', {@contoursRotate, obj, 2, 2});
                uimenu(fc2, 'label', '&180°', ...
                         'callback', {@contoursRotate, obj, 3, 2});
                     
                fc3 = uimenu(foncMenu, 'label', '&Recenter polygons', ...
                              'callback', {@contoursRecenter, obj}, ...
                             'separator', 'on');
                fc4 = uimenu(foncMenu, 'label', '&Convert to Mm', ...
                              'callback', {@contoursConvertPxMm, obj});
                          
                fc5 = uimenu(foncMenu, 'label', '&Align axis', ...
                              'callback', {@contoursAlign, obj}, ...
                             'separator', 'on');
                fc6 = uimenu(foncMenu, 'label', '&Signature', ...
                              'callback', {@contoursToSignature, obj});
                          
                obj.handles.submenus{3} = {fc1, fc2, fc3, fc4, fc5, fc6};
                          
%               -----------------------------------------------------------   

                v1 = uimenu(viewMenu, 'label', '&No Coloration', ...
                              'callback', @dispAxes);
                v2 = uimenu(viewMenu, 'label', '&Coloration factor', ...
                              'callback', {@selectFactor, obj}, ...
                                'enable', 'off');
                v3 = uimenu(viewMenu, 'label', '&Grid', ...
                              'callback', @showGrid);
                            
                obj.handles.submenus{4} = {v1, v2, v3};
                          
%               -----------------------------------------------------------   

                function closef(~,~,h)
                    close(h);
                end
            
                function showFactors(~,~)
                    show(obj.model.factorTable);
                end
                
                function showGrid(~,~)
                    if strcmp(v3.Checked, 'off');
                        set(v3, 'checked', 'on');
                        set(obj.handles.axes{obj.handles.tabs.Selection}, 'xgrid', 'on');
                        set(obj.handles.axes{obj.handles.tabs.Selection}, 'ygrid', 'on');
                    else
                        set(v3, 'checked', 'off');
                        set(obj.handles.axes{obj.handles.tabs.Selection}, 'xgrid', 'off');
                        set(obj.handles.axes{obj.handles.tabs.Selection}, 'ygrid', 'off');
                    end
                end
                
                function dispAxes(~,~)
                    displayPolygons(obj, getAllPolygons(obj.model.PolygonArray));
                    if isa(obj.model.PolygonArray, 'PolarSignatureArray')
                        displayPolarSignature(obj, obj.model.PolygonArray);
                    end
                end
            end
                
        end
        
        function pos = getMiddle(obj, height, width)
            pos = get(obj, 'outerposition');

            pos(1) = pos(1) + (pos(3)/2) - (height/2);
            pos(2) = pos(2) + (pos(4)/2) - (width/2);
            pos(3) = height;
            pos(4) = width;

        end
        
        function setPolygonArray(obj, nameArray, polygonArray, varargin)
            obj.model = Model(polygonArray, nameArray);
            if isempty(obj.handles.panels);
                createPanel(obj,length(obj.handles.tabs.Children) + 1, 1);
            end
            if ~isempty(varargin)
                obj.model.factorTable = varargin{1};
            end
            set(obj.handles.list, 'string', nameArray, 'callback', @select);
            updateMenus(obj);
            displayPolygons(obj, getAllPolygons(obj.model.PolygonArray));
            if isa(obj.model.PolygonArray, 'PolarSignatureArray')
                createPanel(obj,obj.handles.tabs.Selection + 1, 0);
                displayPolarSignature(obj, obj.model.PolygonArray);
            end
        
            function select(~,~)
                list = cellstr(get(obj.handles.list, 'String'));
                sel_val = get(obj.handles.list, 'value');
                obj.model.selectedPolygons = list(sel_val);
                updateSelectedPolygonsDisplay(obj);
            end
        end
        
        function updateSelectedPolygonsDisplay(obj)
            selected = obj.model.selectedPolygons;
            allHandleList = get(obj.handles.axes{obj.handles.tabs.Selection}, 'Children'); 
            set(allHandleList, 'LineWidth', .5);
            allTagList = get(allHandleList, 'tag');
            if ~isempty(allTagList)
                neededHandle = allHandleList(ismember(allTagList, selected));
                set(neededHandle, 'LineWidth', 3.5);
                uistack(neededHandle, 'top');
            end
        end
        
        function updateMenus(obj)
            if isa(obj.model, 'Model')
                set(obj.handles.menus{2}, 'enable', 'on');
                set(obj.handles.menus{4}, 'enable', 'on');
                if isa(obj.model.PolygonArray, 'BasicPolygonArray')
                    set(obj.handles.menus{3}, 'enable', 'on');
                    set(obj.handles.submenus{1}{3}, 'enable', 'on');
                elseif isa(obj.model.PolygonArray, 'PolarSignatureArray')
                    set(obj.handles.submenus{1}{4}, 'enable', 'on');
                end
                if isa(obj.model.factorTable, 'Table')
                    set(obj.handles.submenus{2}{1}, 'checked', 'on');
                    set(obj.handles.submenus{2}{2}, 'enable', 'on');
                    set(obj.handles.submenus{4}{2}, 'enable', 'on');
                    set(obj.handles.figure, 'name', [get(obj.handles.figure, 'name') ' | factors : ' obj.model.factorTable.name]);
                end
            end
        end
    end
end