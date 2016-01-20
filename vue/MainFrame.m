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
                   'numbertitle', 'off');
            set(fen, 'units', 'pixel');
            
            obj.handles.figure = fen;            
            
            main_box = uix.HBox('parent', fen, ...
                               'padding', 5);
            
            list_box = uicontrol('parent', main_box, ...
                                  'style', 'listbox', ...
                                    'max', 100, ...
                                    'min', 0, ...
                               'callback', @select);
                           
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
                
                uimenu(fileMenu, 'label', '&Import polygons', ...
                              'callback', {@importPolygonArray, obj});
                          
                uimenu(fileMenu, 'label', '&Import signatures', ...
                              'callback', {@importPolarSignature, obj});
                          
                f1 = uimenu(fileMenu, 'label', '&Save polygons', ...
                                   'callback', {@saveContours, obj}, ...
                                     'enable', 'off', ...
                             'separator', 'on');
                f2 = uimenu(fileMenu, 'label', '&Save signatures', ...
                                   'callback', {@savePolarSignature, obj}, ...
                                     'enable', 'off');
                                 
                uimenu(fileMenu, 'label', '&Close', ...
                              'callback', {@closef, gcf}, ...
                             'separator', 'on');
                          
%               ----------------------------------------------------------- 

                uimenu(editMenu, 'label', '&Import factors', ...
                              'callback', {@importFactors, obj});
                          
                e1 = uimenu(editMenu, 'label', '&Display factors', ...
                                   'callback', @showFactors, ...
                                     'enable', 'off');
                
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
                     
                uimenu(foncMenu, 'label', '&Recenter polygons', ...
                              'callback', {@contoursRecenter, obj}, ...
                             'separator', 'on');
                uimenu(foncMenu, 'label', '&Convert to Mm', ...
                              'callback', {@contoursConvertPxMm, obj});
                          
                uimenu(foncMenu, 'label', '&Align axis', ...
                              'callback', {@contoursAlign, obj}, ...
                             'separator', 'on');
                uimenu(foncMenu, 'label', '&Signature', ...
                              'callback', {@contoursToSignature, obj});
                          
%               -----------------------------------------------------------   

                uimenu(viewMenu, 'label', '&No Coloration', ...
                              'callback', @dispAxes);
                v1 = uimenu(viewMenu, 'label', '&Coloration factor', ...
                              'callback', {@selectFactor, obj}, ...
                                'enable', 'off');
                v2 = uimenu(viewMenu, 'label', '&Grid', ...
                              'callback', @showGrid);
                            
                obj.handles.submenus = {f1, v1, e1, v2, f2};
                          
                function closef(~,~,h)
                    close(h);
                end
            
                function showFactors(~,~)
                    show(obj.model.factorTable);
                end
                
                function showGrid(~,~)
                    if strcmp(v2.Checked, 'off');
                        set(v2, 'checked', 'on');
                        set(obj.handles.axes{obj.handles.tabs.Selection}, 'xgrid', 'on');
                        set(obj.handles.axes{obj.handles.tabs.Selection}, 'ygrid', 'on');
                    else
                        set(v2, 'checked', 'off');
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
                
            function select(~,~)
                list = cellstr(get(obj.handles.list, 'String'));
                sel_val = get(obj.handles.list, 'value');
                obj.model.selectedPolygons = list(sel_val);
                updateSelectedPolygonsDisplay(obj);
            end
        end
        
        function pos = getMiddle(obj, height, width)
            pos = get(obj, 'outerposition');

            pos(1) = pos(1) + (pos(3)/2) - (height/2);
            pos(2) = pos(2) + (pos(4)/2) - (width/2);
            pos(3) = height;
            pos(4) = width;

        end
        
        function setPolygonArray(obj, nameArray, polygonArray)
            obj.model = Model(polygonArray, nameArray);
            if isempty(obj.handles.panels);
                createPanel(obj,length(obj.handles.tabs.Children) + 1, 1);
            end
            set(obj.handles.list, 'string', nameArray);
            set([obj.handles.menus{:}], 'enable', 'on');
            set(obj.handles.submenus{1}, 'enable', 'on');
            displayPolygons(obj, getAllPolygons(obj.model.PolygonArray));
            if isa(obj.model.PolygonArray, 'PolarSignatureArray')
                createPanel(obj,obj.handles.tabs.Selection + 1, 0);
                displayPolarSignature(obj, obj.model.PolygonArray);
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
    end
end