classdef MainFrame < handle
    
    properties
        
        handles;
        
        model;
        
    end
    
    methods
        function obj = MainFrame
            fen = figure('units', 'normalized', ...
                 'outerposition', [0 0 1 1], ...
                       'menubar', 'none', ...
                   'numbertitle', 'off');
            set(fen, 'units', 'pixel');
               
            obj.handles.figure = fen;            
            
            main_box = uix.HBox('parent', fen, ...
                               'padding', 5);
            
            function_box = uix.VBox('parent', main_box, ...
                                   'padding', 5);
            
            list_box = uicontrol('parent', function_box, ...
                                  'style', 'listbox', ...
                                    'max', 100, ...
                                    'min', 0, ...
                               'callback', @select);
                           
             
%             uicontrol('parent', function_box, ...
%                       'string', 'Clear selection', ...
%                     'callback', @reset);
            
%             set(function_box, 'heights', [-30 -1]);
            
            tab_pan = uix.TabPanel('parent', main_box);
            
            set(main_box, 'widths', [-1 -8]);
            
            obj.handles.main = main_box;
            obj.handles.tabs = tab_pan;
            obj.handles.functions = function_box;
            obj.handles.list = list_box;
            obj.handles.panels = {};
            obj.handles.axes = {};
            obj.handles.lines = {};
            
            setupMenu(fen);
            
            function setupMenu(fen)
                fileMenu = uimenu(fen, 'label', '&File');
                editMenu = uimenu(fen, 'label', '&Edit', 'enable', 'off');
                foncMenu = uimenu(fen, 'label', '&Process', 'enable', 'off');
                viewMenu = uimenu(fen, 'label', '&View', 'enable', 'off');
                
                obj.handles.menus = {fileMenu, editMenu, foncMenu, viewMenu};
                
                uimenu(fileMenu, 'label', '&Import polygons', ...
                              'callback', {@importPolygonArray, obj});
                          
                f1 = uimenu(fileMenu, 'label', '&Save polygons', ...
                                   'callback', {@saveContours, obj}, ...
                                     'enable', 'off');
                uimenu(fileMenu, 'label', '&Close', ...
                              'callback', {@closef, gcf}, ...
                             'separator', 'on');
                          
%               -----------------------------------------------------------            
                          
                uimenu(editMenu, 'label', '&Import factors', ...
                              'callback', {@importFactors, obj});
                          
                e1 = uimenu(editMenu, 'label', '&Display foctors', ...
                                   'callback', @showFactors, ...
                                     'enable', 'off');
                
%               -----------------------------------------------------------            
                          
                uimenu(foncMenu, 'label', '&Recenter polygons', ...
                              'callback', {@contoursRecenter, obj});
                uimenu(foncMenu, 'label', '&Convert to Mm', ...
                              'callback', {@contoursConvertPxMm, obj});
                uimenu(foncMenu, 'label', '&Align axis', ...
                              'callback', {@contoursRotate, obj});
                          
                fc1 = uimenu(foncMenu, 'label', '&Rotate');
                uimenu(fc1, 'label', '&90° droite', ...
                         'callback', {@rotate, obj, 1});
                uimenu(fc1, 'label', '&90° gauche', ...
                         'callback', {@rotate, obj, 2});
                uimenu(fc1, 'label', '&180°', ...
                         'callback', {@rotate, obj, 3});
                          
                          
%               -----------------------------------------------------------   

                uimenu(viewMenu, 'label', '&No Coloration', ...
                              'callback', @dispContours);
                v1 = uimenu(viewMenu, 'label', '&Coloration factor', ...
                              'callback', {@loadContoursFactor, obj}, ...
                                'enable', 'off');
                            
                obj.handles.submenus = {f1, v1, e1};
                          
                function closef(~,~,h)
                    close(h);
                end
            
                function showFactors(~,~)
                    show(obj.model.factorTable);
                end
                
                function dispContours(~,~)
                    showContours(obj);
                end
            end
            
%             function reset(~,~)
%                 obj.model.selectedPolygons = {};
%                 selection(obj);
%             end
            
            function select(~,~)
                list = cellstr(get(obj.handles.list, 'String'));
                sel_val = get(obj.handles.list, 'value');
                obj.model.selectedPolygons = list(sel_val);
                selection(obj);
            end
        end
    end
end