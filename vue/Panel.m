classdef Panel < handle
   
    properties
        mainFrame;
        
        colorMap;
        
        uiPanel;
        uiAxis;
        uiLegend = {};
        
        type;
    end
    
    methods
        function this = Panel(mainFrame, index, equal)
            this.mainFrame = mainFrame;
            this.colorMap = [56 , 58 , 255; 60 , 58 , 255; 63 , 59 , 254; 66 , 59 , 254; 69 , 60 , 253; 72 , 61 , 253; 75 , 61 , 252;
                            78 , 62 , 252; 81 , 62 , 251; 85 , 63 , 251; 88 , 63 , 250; 91 , 64 , 250; 94 , 64 , 249; 97 , 65 , 249;
                            100, 65 , 248; 103, 66 , 248; 106, 66 , 247; 110, 67 , 247; 113, 67 , 246; 116, 68 , 246; 119, 68 , 245;
                            122, 69 , 245; 125, 69 , 244; 128, 70 , 244; 131, 70 , 243; 135, 71 , 243; 138, 71 , 242; 141, 72 , 242;
                            144, 72 , 241; 147, 73 , 241; 150, 73 , 240; 153, 74 , 240; 156, 74 , 239; 160, 75 , 239; 163, 75 , 239;
                            166, 76 , 238; 169, 76 , 238; 172, 77 , 237; 175, 77 , 237; 178, 78 , 236; 181, 78 , 236; 185, 79 , 235;
                            188, 79 , 235; 191, 80 , 234; 194, 80 , 234; 197, 81 , 233; 200, 81 , 233; 203, 82 , 232; 207, 82 , 232;
                            210, 83 , 231; 213, 83 , 231; 216, 84 , 230; 219, 84 , 230; 222, 85 , 229; 225, 85 , 229; 228, 86 , 228;
                            232, 86 , 228; 235, 87 , 227; 238, 87 , 227; 241, 88 , 226; 244, 89 , 226; 247, 89 , 225; 250, 90 , 225;
                            253, 90 , 224; 255, 90 , 224; 255, 90 , 221; 255, 90 , 219; 255, 89 , 217; 255, 89 , 214; 255, 89 , 212;
                            255, 88 , 210; 255, 88 , 207; 255, 88 , 205; 255, 87 , 203; 255, 87 , 200; 255, 87 , 198; 255, 87 , 196;
                            255, 86 , 193; 255, 86 , 191; 255, 86 , 189; 255, 85 , 186; 255, 85 , 184; 255, 85 , 182; 255, 84 , 180;
                            255, 84 , 177; 255, 84 , 175; 255, 83 , 173; 255, 83 , 170; 255, 83 , 168; 255, 82 , 166; 255, 82 , 163;
                            255, 82 , 161; 255, 82 , 159; 255, 81 , 156; 255, 81 , 154; 255, 81 , 152; 255, 80 , 149; 255, 80 , 147;
                            255, 80 , 145; 255, 79 , 142; 255, 79 , 140; 255, 79 , 138; 255, 78 , 136; 255, 78 , 133; 255, 78 , 131;
                            255, 77 , 129; 255, 77 , 126; 255, 77 , 124; 255, 76 , 122; 255, 76 , 119; 255, 76 , 117; 255, 76 , 115;
                            255, 75 , 112; 255, 75 , 110; 255, 75 , 108; 255, 74 , 105; 255, 74 , 103; 255, 74 , 101; 255, 73 , 98 ;
                            255, 73 , 96 ; 255, 73 , 94 ; 255, 72 , 92 ; 255, 72 , 89 ; 255, 72 , 87 ; 255, 71 , 85 ; 255, 71 , 82 ;
                            255, 71 , 80 ; 255, 70 , 78 ; 255, 71 , 76 ; 255, 73 , 75 ; 255, 75 , 74 ; 255, 77 , 72 ; 255, 79 , 71 ;
                            255, 80 , 70 ; 255, 82 , 69 ; 255, 84 , 67 ; 255, 86 , 66 ; 255, 88 , 65 ; 255, 90 , 64 ; 255, 91 , 63 ;
                            255, 93 , 61 ; 255, 95 , 60 ; 255, 97 , 59 ; 255, 99 , 58 ; 255, 101, 57 ; 255, 102, 56 ; 255, 104, 54 ;
                            255, 106, 53 ; 255, 108, 52 ; 255, 110, 51 ; 255, 112, 49 ; 255, 113, 48 ; 255, 115, 47 ; 255, 117, 46 ;
                            255, 119, 45 ; 255, 121, 44 ; 255, 122, 42 ; 255, 124, 41 ; 255, 126, 40 ; 255, 128, 39 ; 255, 130, 38 ;
                            255, 132, 36 ; 255, 133, 35 ; 255, 135, 34 ; 255, 137, 33 ; 255, 139, 32 ; 255, 141, 30 ; 255, 143, 29 ;
                            255, 144, 28 ; 255, 146, 27 ; 255, 148, 25 ; 255, 150, 24 ; 255, 152, 23 ; 255, 154, 22 ; 255, 155, 21 ;
                            255, 157, 20 ; 255, 159, 18 ; 255, 161, 17 ; 255, 163, 16 ; 255, 165, 15 ; 255, 166, 13 ; 255, 168, 12 ;
                            255, 170, 11 ; 255, 172, 10 ; 255, 174, 9  ; 255, 176, 8  ; 255, 177, 6  ; 255, 179, 5  ; 255, 181, 4  ;
                            255, 183, 3  ; 255, 185, 1  ; 255, 187, 0  ; 254, 188, 1  ; 252, 189, 3  ; 250, 190, 5  ; 248, 191, 7  ;
                            246, 192, 9  ; 244, 193, 11 ; 242, 194, 13 ; 240, 195, 15 ; 238, 196, 17 ; 236, 198, 19 ; 234, 199, 21 ;
                            232, 200, 23 ; 230, 201, 25 ; 228, 202, 27 ; 226, 203, 29 ; 224, 204, 31 ; 222, 205, 33 ; 220, 206, 35 ;
                            218, 207, 37 ; 216, 208, 39 ; 214, 209, 41 ; 211, 210, 43 ; 209, 212, 45 ; 207, 213, 47 ; 205, 214, 49 ;
                            203, 215, 51 ; 201, 216, 53 ; 199, 217, 54 ; 197, 218, 56 ; 195, 219, 58 ; 193, 220, 60 ; 191, 221, 62 ;
                            189, 222, 64 ; 187, 223, 66 ; 185, 224, 68 ; 183, 226, 70 ; 181, 227, 72 ; 179, 228, 74 ; 177, 229, 76 ;
                            175, 230, 78 ; 173, 231, 80 ; 171, 232, 82 ; 169, 233, 84 ; 167, 234, 86 ; 165, 235, 88 ; 163, 236, 90 ;
                            161, 237, 92 ; 159, 239, 94 ; 157, 240, 96 ; 154, 241, 98 ; 152, 242, 100; 150, 243, 102; 148, 244, 104;
                            146, 245, 106; 144, 246, 108; 142, 247, 109; 140, 248, 111; 138, 249, 113; 136, 250, 115; 134, 251, 117;
                            132, 253, 119; 130, 254, 121; 128, 255, 123; 126, 255, 125]/255;
                        
            % creation of the panel taht'll contain the axis
            this.uiPanel = uipanel('parent', mainFrame.handles.tabs, ...
                              'bordertype', 'none', ...
                           'uicontextmenu', mainFrame.handles.menus{6});

            % creation of the axis on which the lines will be drawn
            this.uiAxis = axes('parent', this.uiPanel, ...
                       'ButtonDownFcn', @(src, event) reset, ...
                          'colororder', this.colorMap, ...
                       'uicontextmenu', mainFrame.handles.menus{6});
            
            if strcmp(equal, 'on')
                % use the same length for the data units along each axis
                axis(this.uiAxis, 'equal');
            end
                          
            mainFrame.handles.Panels{index} = this;
            
            % add a callback to the tabpanel to call when the tab selection change
            set(mainFrame.handles.tabs, 'selection', index, ...
                              'SelectionChangedFcn', @(src, event) select);

            function reset
                %RESET  set the current selection to null

                if ~ismember(mainFrame.handles.figure.SelectionType, {'alt', 'open'})
                    % if the user is not pressing the 'ctrl' key or right-clicking

                    %empty the selection lists and update the view
                    mainFrame.model.selectedPolygons = {};
                    set(mainFrame.handles.list, 'value', []);

                    % update the view
                    updateSelectedPolygonsDisplay(this);
                end
            end
            
            function select
                %SELECT  update the view depending on the selection
                
                updateSelectedPolygonsDisplay(mainFrame.handles.Panels{mainFrame.handles.tabs.Selection});
                set(mainFrame.handles.submenus{4}{3}, 'checked', get(mainFrame.handles.Panels{mainFrame.handles.tabs.Selection}.uiAxis, 'xgrid'));
                set(mainFrame.handles.submenus{6}{3}, 'checked', get(mainFrame.handles.Panels{mainFrame.handles.tabs.Selection}.uiAxis, 'xgrid'));
            end

        end
        
        function updateSelectedPolygonsDisplay(this)
            %UPDATESELECTEDPOLYGONSDISPLAY  display the lines of the
            %current axis differently if they're selected or not
            selected = this.mainFrame.model.selectedPolygons;
            allHandleList = get(this.uiAxis, 'Children'); 
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
        
        function detectLineClick(this, h,~)
            %DETECTLINECLICK  callback used when the user clicks on one of the axis' line
            %
            %   Inputs :
            %       - h : handle of the object that sent the callback 
            %       - ~ (not used) : input automatically send by matlab during a callback
            %       - obj : handle of the MainFrame
            %   Outputs : none

            if ismember(this.mainFrame.handles.figure.SelectionType, {'alt', 'open'})
                % if the user is pressing the 'ctrl' key or using the right
                % mouse-button
                if find(strcmp(get(h,'tag'), this.mainFrame.model.selectedPolygons))
                    % if the clicked line was already selected, deselect it
                    this.mainFrame.model.selectedPolygons(strcmp(get(h,'tag'), this.mainFrame.model.selectedPolygons)) = [];
                else
                    % if the clicked line wasn't selected, add it to the list of
                    % selected lines
                    this.mainFrame.model.selectedPolygons{end+1} = this.mainFrame.model.nameList{strcmp(get(h,'tag'), this.mainFrame.model.nameList)};
                end
            else
                % if the user didn't press 'ctrl' or click the right mouse-button
                if find(strcmp(get(h,'tag'), this.mainFrame.model.selectedPolygons))
                    % if the clicked line was already selected
                    if length(this.mainFrame.model.selectedPolygons) == 1
                        % if the clicked line was the only selected line, deselect it
                        this.mainFrame.model.selectedPolygons(strcmp(get(h,'tag'), this.mainFrame.model.selectedPolygons)) = [];
                    else
                        % if the clicked line wasn't the only selected line, set it as the only selected line
                        this.mainFrame.model.selectedPolygons = this.mainFrame.model.nameList(strcmp(get(h,'tag'), this.mainFrame.model.nameList));
                    end
                else
                    % if the line wasn't already selected, set it as the only selected line
                    this.mainFrame.model.selectedPolygons = this.mainFrame.model.nameList(strcmp(get(h,'tag'), this.mainFrame.model.nameList));
                end
            end
            %update the lines displayed
            updateSelectedPolygonsDisplay(this);

            % match the selection of the name list to the selection of the axis
            set(this.mainFrame.handles.list, 'value', find(ismember(this.mainFrame.model.nameList, this.mainFrame.model.selectedPolygons)));
        end
    end
    
% -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
% ---------------------------------------------------------------------------- DISPLAY METHODS ----------------------------------------------------------------------------------------------------
% -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    
    methods
        function displayPolygons(this, polygonArray)
            %DISPLAYPOLYGONS  Display the current polygons
            %
            %   Inputs :
            %       - obj : handle of the MainFrame
            %       - polygonArray : a N-by-1 cell array containing the polygons
            %       - axis : handle of the axis on which the lines will be drawn
            %   Outputs : none
            
            names = setupDisplay(this.mainFrame, 1, 2, 1, 'Polygons');
            axis = this.uiAxis;
            
            % reset the position of the cursor in the axis' colormap
            set(axis, 'colororderindex', 1);

            if length(this.colorMap) > length(names)
                % if there's less polygons than colors in the colormap
                % change the axis' colormap to get colors that are as different as
                % possible from eachother
                set(axis, 'colororder', this.colorMap(floor(1:length(this.colorMap)/(length(names)):length(this.colorMap)), :));
            end

            % delete all the lines already drawn on the axis and the legends
            delete(axis.Children(:));
            delete([this.uiLegend{:}]);
            

            hold(axis, 'on');
            for i = 1:length(polygonArray)
                % draw the polygon on the axis
                drawPolygon(polygonArray{i}, 'parent', axis, ...
                                      'ButtonDownFcn', @this.detectLineClick, ...
                                                'tag', names{i});
            end
            hold(axis, 'off');

            if ~isempty(this.mainFrame.model.selectedPolygons)
                % if at least one polygon was selected, update the view
                updateSelectedPolygonsDisplay(this);
            end
        end
        
        function displayPolygonsFactor(this, polygonArray)
            %DISPLAYPOLYGONSFACTOR  Display the current polygons colored by factors
            %
            %   Inputs :
            %       - obj : handle of the MainFrame
            %       - polygonArray : a N-by-1 cell array containing the polygons
            %       - axis : handle of the axis on which the lines will be drawn
            %   Outputs : none

            names = setupDisplay(this.mainFrame, 2, 1, 1, 'Polygons');
            axis = this.uiAxis;

            % reset the position of the cursor in the axis' colormap
            set(axis, 'colororderindex', 1);
            
            nbSelected = length(this.mainFrame.model.selectedFactor{2});

            % change the axis' colormap to get colors that are as different as
            % possible from eachother
            set(axis, 'colororder', this.colorMap(floor(1:length(this.colorMap)/nbSelected:length(this.colorMap)), :));

            % memory allocation for the array that'll contain the legend's lines
            lines = cell(1, length(names));
            lineHandles = cell(1, nbSelected);
            levels = cell(1, nbSelected);

            % delete all the lines already drawn on the axis
            delete(axis.Children(:));

            hold(axis, 'on');
            for i = 1:length(polygonArray)
                % draw the polygon on the axis
                lines{i} = drawPolygon(polygonArray{i, 2}, 'parent', axis, ...
                                                    'ButtonDownFcn', @this.detectLineClick, ...
                                                              'tag', names{i}, ...
                                                            'color', axis.ColorOrder(polygonArray{i, 1}, :));

                if cellfun('isempty',lineHandles(polygonArray{i, 1}))
                    % if the factor of the signature that was just drawn has never been
                    % encountered, create a copy of this line and save it, and add the
                    % level to the list of levels that'll be displayed in the legend
                    lineHandles{polygonArray{i, 1}} = copy(lines{i});
                    levels{polygonArray{i, 1}} = this.mainFrame.model.selectedFactor{2}{polygonArray{i, 1}};
                end
            end
            hold(axis, 'off');

            % remove all the empty cells of the levels list
            levels = levels(~cellfun('isempty',levels));

            if ~isempty(this.mainFrame.model.selectedPolygons)
                % if at least one signature was selected, update the view
                updateSelectedPolygonsDisplay(this);
            end

            if this.mainFrame.model.selectedFactor{3} == 0
                % if the legend must be displayed, display it
                this.uiLegend{1} = legend(axis, [lineHandles{:}], levels, ...
                                                      'location', 'best', ...
                                                 'uicontextmenu', []);
            end
        end

        function displayPolarSignature(this, signatureArray)
            %DISPLAYPOLARSIGNATURE  Display the current signatures
            %
            %   Inputs :
            %       - obj : handle of the MainFrame
            %       - signatureArray : a N-by-M cell array containing the polar signatures
            %       - axis : handle of the axis on which the lines will be drawn
            %   Outputs : none

            % get the list of all angles + 1 angle to make the last point match the
            % first
            angles = signatureArray.angleList;
            angles(end+1) = angles(end) + angles(2)-angles(1);

            names = setupDisplay(this.mainFrame, 1, 2, 2, 'Signatures');
            axis = this.uiAxis;
            
            % set the name of the tab

            % reset the position of the cursor in the axis' colormap
            set(axis, 'colororderindex', 1);

            if length(this.colorMap) > length(names)
                % if there's less signatures than colors in the colormap
                % change the axis' colormap to get colors that are as different as
                % possible from eachother
                set(axis, 'colororder', this.colorMap(floor(1:length(this.colorMap)/(length(names)) :length(this.colorMap)), :));
            end

            % set the axis' limits
            xlim(axis, [angles(1), angles(end)]);
            ylim(axis, [0 max(signatureArray.signatures(:))+.5]);

            % delete all the lines already drawn on the axis
            delete(axis.Children(:));
            delete([this.uiLegend{:}]);

            hold(axis, 'on');
            for i = 1:getPolygonNumber(signatureArray)
                % get the signature that will be drawn
                signature = getSignature(signatureArray, i);

                % make sure the last point matches the first
                signature(end+1) = signature(1);

                % draw the line
                plot(angles, signature, 'parent', axis, ...
                                 'ButtonDownFcn', @this.detectLineClick, ...
                                           'tag', names{i});
            end
            hold(axis, 'off');

            if ~isempty(this.mainFrame.model.selectedPolygons)
                % if at least one polygon was selected, update the view
                updateSelectedPolygonsDisplay(this);
            end
        end
        function displayPolarSignatureFactor(this, signatureArray)
            %DISPLAYPOLARSIGNATUREFACTOR  Display the current signatures colored by factors
            %
            %   Inputs :
            %       - obj : handle of the MainFrame
            %       - signatureArray : a N-by-M cell array containing the polar signatures
            %       - axis : handle of the axis on which the lines will be drawn
            %   Outputs : none

            % get the list of all angles + 1 angle to make the last point match the
            % first
            angles = this.mainFrame.model.PolygonArray.angleList;
            angles(end+1) = angles(end) + angles(2) - angles(1);

            names = setupDisplay(this.mainFrame, 2, 1, 2, 'Signatures');
            axis = this.uiAxis;

            nbSelected = length(this.mainFrame.model.selectedFactor{2});

            % reset the position of the cursor in the axis' colormap
            set(axis, 'colororderindex', 1);

            % change the axis' colormap to get colors that are as different as
            % possible from eachother
            set(axis, 'colororder', this.colorMap(floor(1:length(this.colorMap)/nbSelected:length(this.colorMap)), :));

            % memory allocation for the array that'll contain the legend's lines
            lines = cell(1, length(names));
            lineHandles = cell(1, nbSelected);
            levels = cell(1, nbSelected);

            % delete all the lines already drawn on the axis
            delete(axis.Children(:));

            hold(axis, 'on');
            for i = 1:length(signatureArray)
                % get the signature that will be drawn
                signature = signatureArray{i, 2};

                % make sure the last point matches the first
                signature(end+1) = signature(1);

                % draw the line
                lines{i} = plot(angles, signature, 'parent', axis, ...
                                            'ButtonDownFcn', @this.detectLineClick, ...
                                                      'tag', names{i}, ...
                                                    'color', axis.ColorOrder(signatureArray{i, 1}, :));

                if cellfun('isempty',lineHandles(signatureArray{i, 1}))
                    % if the factor of the signature that was just drawn has never been
                    % encountered, create a copy of this line and save it
                    lineHandles{signatureArray{i, 1}} = copy(lines{i});
                    levels{signatureArray{i, 1}} = this.mainFrame.model.selectedFactor{2}{signatureArray{i, 1}};
                end
            end
            hold(axis, 'off');
            
            levels = levels(~cellfun('isempty',levels));

            if ~isempty(this.mainFrame.model.selectedPolygons)
                % if at least one signature was selected, update the view
                updateSelectedPolygonsDisplay(this);
            end

            if this.mainFrame.model.selectedFactor{3} == 0
                % if the legend must be displayed, display it
                this.uiLegend{2} = legend(axis, [lineHandles{:}], levels, ...
                                                   'location', 'eastoutside', ...
                                              'uicontextmenu', []);
            end
        end
        
        function displayPca(this, x, y)

            names = setupDisplay(this.mainFrame, 1, 2, 1, this.type);
            
            delete([this.uiLegend{:}]);

            hold(this.uiAxis, 'on');
            for i = 1:length(x)
                plot(x(i), y(i), '.k', ...
                       'parent', this.uiAxis, ...
                'ButtonDownFcn', @this.detectLineClick, ...
                          'tag', names{i});
            end
            hold(this.uiAxis, 'off');

        end
    end
end