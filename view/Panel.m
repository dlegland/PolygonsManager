classdef Panel < DisplayPanel
%PANEL Class that creates a panel and setup its contents
%
%   Creation: 
%   figure = Panel(PolygonsManagerMainFrame, index, equal);
%

%% Class Constants
properties(Constant)    
   default_colorMap = [56 , 58 , 255; 60 , 58 , 255; 63 , 59 , 254; 66 , 59 , 254; 69 , 60 , 253; 72 , 61 , 253; 75 , 61 , 252; 78 , 62 , 252; 81 , 62 , 251; 85 , 63 , 251; 88 , 63 , 250; 91 , 64 , 250; 94 , 64 , 249; 97 , 65 , 249;
                       100, 65 , 248; 103, 66 , 248; 106, 66 , 247; 110, 67 , 247; 113, 67 , 246; 116, 68 , 246; 119, 68 , 245; 122, 69 , 245; 125, 69 , 244; 128, 70 , 244; 131, 70 , 243; 135, 71 , 243; 138, 71 , 242; 141, 72 , 242;
                       144, 72 , 241; 147, 73 , 241; 150, 73 , 240; 153, 74 , 240; 156, 74 , 239; 160, 75 , 239; 163, 75 , 239; 166, 76 , 238; 169, 76 , 238; 172, 77 , 237; 175, 77 , 237; 178, 78 , 236; 181, 78 , 236; 185, 79 , 235;
                       188, 79 , 235; 191, 80 , 234; 194, 80 , 234; 197, 81 , 233; 200, 81 , 233; 203, 82 , 232; 207, 82 , 232; 210, 83 , 231; 213, 83 , 231; 216, 84 , 230; 219, 84 , 230; 222, 85 , 229; 225, 85 , 229; 228, 86 , 228;
                       232, 86 , 228; 235, 87 , 227; 238, 87 , 227; 241, 88 , 226; 244, 89 , 226; 247, 89 , 225; 250, 90 , 225; 253, 90 , 224; 255, 90 , 224; 255, 90 , 221; 255, 90 , 219; 255, 89 , 217; 255, 89 , 214; 255, 89 , 212;
                       255, 88 , 210; 255, 88 , 207; 255, 88 , 205; 255, 87 , 203; 255, 87 , 200; 255, 87 , 198; 255, 87 , 196; 255, 86 , 193; 255, 86 , 191; 255, 86 , 189; 255, 85 , 186; 255, 85 , 184; 255, 85 , 182; 255, 84 , 180;
                       255, 84 , 177; 255, 84 , 175; 255, 83 , 173; 255, 83 , 170; 255, 83 , 168; 255, 82 , 166; 255, 82 , 163; 255, 82 , 161; 255, 82 , 159; 255, 81 , 156; 255, 81 , 154; 255, 81 , 152; 255, 80 , 149; 255, 80 , 147;
                       255, 80 , 145; 255, 79 , 142; 255, 79 , 140; 255, 79 , 138; 255, 78 , 136; 255, 78 , 133; 255, 78 , 131; 255, 77 , 129; 255, 77 , 126; 255, 77 , 124; 255, 76 , 122; 255, 76 , 119; 255, 76 , 117; 255, 76 , 115;
                       255, 75 , 112; 255, 75 , 110; 255, 75 , 108; 255, 74 , 105; 255, 74 , 103; 255, 74 , 101; 255, 73 , 98 ; 255, 73 , 96 ; 255, 73 , 94 ; 255, 72 , 92 ; 255, 72 , 89 ; 255, 72 , 87 ; 255, 71 , 85 ; 255, 71 , 82 ;
                       255, 71 , 80 ; 255, 70 , 78 ; 255, 71 , 76 ; 255, 73 , 75 ; 255, 75 , 74 ; 255, 77 , 72 ; 255, 79 , 71 ; 255, 80 , 70 ; 255, 82 , 69 ; 255, 84 , 67 ; 255, 86 , 66 ; 255, 88 , 65 ; 255, 90 , 64 ; 255, 91 , 63 ;
                       255, 93 , 61 ; 255, 95 , 60 ; 255, 97 , 59 ; 255, 99 , 58 ; 255, 101, 57 ; 255, 102, 56 ; 255, 104, 54 ; 255, 106, 53 ; 255, 108, 52 ; 255, 110, 51 ; 255, 112, 49 ; 255, 113, 48 ; 255, 115, 47 ; 255, 117, 46 ;
                       255, 119, 45 ; 255, 121, 44 ; 255, 122, 42 ; 255, 124, 41 ; 255, 126, 40 ; 255, 128, 39 ; 255, 130, 38 ; 255, 132, 36 ; 255, 133, 35 ; 255, 135, 34 ; 255, 137, 33 ; 255, 139, 32 ; 255, 141, 30 ; 255, 143, 29 ;
                       255, 144, 28 ; 255, 146, 27 ; 255, 148, 25 ; 255, 150, 24 ; 255, 152, 23 ; 255, 154, 22 ; 255, 155, 21 ; 255, 157, 20 ; 255, 159, 18 ; 255, 161, 17 ; 255, 163, 16 ; 255, 165, 15 ; 255, 166, 13 ; 255, 168, 12 ;
                       255, 170, 11 ; 255, 172, 10 ; 255, 174, 9  ; 255, 176, 8  ; 255, 177, 6  ; 255, 179, 5  ; 255, 181, 4  ; 255, 183, 3  ; 255, 185, 1  ; 255, 187, 0  ; 254, 188, 1  ; 252, 189, 3  ; 250, 190, 5  ; 248, 191, 7  ;
                       246, 192, 9  ; 244, 193, 11 ; 242, 194, 13 ; 240, 195, 15 ; 238, 196, 17 ; 236, 198, 19 ; 234, 199, 21 ; 232, 200, 23 ; 230, 201, 25 ; 228, 202, 27 ; 226, 203, 29 ; 224, 204, 31 ; 222, 205, 33 ; 220, 206, 35 ;
                       218, 207, 37 ; 216, 208, 39 ; 214, 209, 41 ; 211, 210, 43 ; 209, 212, 45 ; 207, 213, 47 ; 205, 214, 49 ; 203, 215, 51 ; 201, 216, 53 ; 199, 217, 54 ; 197, 218, 56 ; 195, 219, 58 ; 193, 220, 60 ; 191, 221, 62 ;
                       189, 222, 64 ; 187, 223, 66 ; 185, 224, 68 ; 183, 226, 70 ; 181, 227, 72 ; 179, 228, 74 ; 177, 229, 76 ; 175, 230, 78 ; 173, 231, 80 ; 171, 232, 82 ; 169, 233, 84 ; 167, 234, 86 ; 165, 235, 88 ; 163, 236, 90 ;
                       161, 237, 92 ; 159, 239, 94 ; 157, 240, 96 ; 154, 241, 98 ; 152, 242, 100; 150, 243, 102; 148, 244, 104; 146, 245, 106; 144, 246, 108; 142, 247, 109; 140, 248, 111; 138, 249, 113; 136, 250, 115; 134, 251, 117; 
                       132, 253, 119; 130, 254, 121; 128, 255, 123; 126, 255, 125]/255
end

%% Properties
properties
    % instance of PolygonsManagerMainFrame
    mainFrame;

    % N-by-3 numeric vector containing values of range 0 to 1
    colorMap;

    % uipanel instance
    uiPanel;
    % axes instance 
    uiAxis;
    % legend of the uiAxis
    uiLegend;

    % string containing the type of data displayed in the uiAxis
    % Can be one of:
    % * pcaLoadings
    % * pcaEigenValues
    % * pcaVector
    type;
end

%% Construction methods
methods
    function this = Panel(mainFrame, varargin)
    %Constructor for the PolygonsManagerMainFrame class
    %
    %   inputs : 
    %       - PolygonsManagerMainFrame : instance of PolygonsManagerMainFrame
    %       - index : index of the panel in the Panels array of the PolygonsManagerMainFrame
    %       - equal : defines id the uiAxis must be equalized
    %   ouputs : 
    %       - this : Panel instance

        this = this@DisplayPanel(mainFrame);
        
        % set the 'parent' of the panel
        this.mainFrame = mainFrame;

        %set the colormap of the panel
        this.colorMap = this.default_colorMap;

        % creation of the panel that'll contain the axis
        this.uiPanel = uipanel('parent', mainFrame.handles.tabs, ...
                          'bordertype', 'none', ...
                       'uicontextmenu', mainFrame.menuBar.contextPanel.handle);

        % creation of the axis on which the lines will be drawn
        this.uiAxis = axes('parent', this.uiPanel, ...
                   'ButtonDownFcn', @(~,~) this.reset, ...
                      'colororder', this.colorMap, ...
                             'tag', 'main', ...
                   'uicontextmenu', mainFrame.menuBar.contextPanel.handle);


        % save the new panel in the parent PolygonsManagerMainFrame
        mainFrame.handles.Panels{length(mainFrame.handles.Panels) + 1} = this;

        while length(varargin) > 1
            % get parameter name and value
            param = lower(varargin{1});
            value = varargin{2};

            switch param 
                case 'equal'
                    if strcmp(value, 'on')
                        axis(this.uiAxis, 'equal');
                    elseif strcmp(value, 'off')
                        axis(this.uiAxis, 'normal');
                    else
                        error('Invalid value');
                    end
                case 'title'
                    mainFrame.handles.tabs.TabTitles{length(mainFrame.handles.Panels)} = value;
                case 'type'
                    this.type = value;
                case 'colormap'
                    this.colorMap = value;
                    this.uiAxis.ColorOrder = value;
                otherwise
                    error('Panel:Panel', ...
                        ['Unknown parameter name: ' varargin{1}]);
            end
            varargin(1:2) = [];
        end

        if ~strcmp(this.type, 'pcaLoadings')
            % add a callback to the tabpanel to call when the tab selection change
            set(mainFrame.handles.tabs, 'selection', length(mainFrame.handles.Panels), ...
                              'SelectionChangedFcn', @(~,~) panelChange);
        end

        function panelChange
            %SELECT  update the view depending on the selection

            selectedTab = mainFrame.handles.tabs.Selection;
            selectedPanel = mainFrame.handles.Panels{selectedTab};
            updateSelectedPolygonsDisplay(selectedPanel);
            
            % toggle grid widgets
            gridFlag = get(selectedPanel.uiAxis, 'xgrid');
            set(mainFrame.menuBar.view.grid.handle, 'checked', gridFlag);
            set(mainFrame.menuBar.contextPanel.grid.handle, 'checked', gridFlag);
            
            % eventually update possibility to toggle markers
            if ~isempty(selectedPanel.uiAxis.Children)
                if strcmp(get(selectedPanel.uiAxis.Children(1), 'Marker'), '+')
                    set(mainFrame.menuBar.view.markers.handle, 'checked', 'on');
                    set(mainFrame.menuBar.contextPanel.markers.handle, 'checked', 'on');
                else
                    set(mainFrame.menuBar.view.markers.handle, 'checked', 'off');
                    set(mainFrame.menuBar.contextPanel.markers.handle, 'checked', 'off');
                end
            end
        end
    end
end

%% Generic Methods
methods
    function reset(this)
        %RESET  set the current selection to void

        if ~ismember(this.mainFrame.handles.figure.SelectionType, {'alt', 'open'})
            % if the user is not pressing the 'ctrl' key or right-clicking

            %empty the selection lists and update the view
            this.mainFrame.model.selectedPolygons = {};
            set(this.mainFrame.handles.list, 'value', []);

            % update the view
            updateSelectedPolygonsDisplay(this);
        end
    end

    function updateSelectedPolygonsDisplay(this)
        %UPDATESELECTEDPOLYGONSDISPLAY  display the lines of the current axis differently if they're selected or not

        % get the nameList of selected polygons
        selected = this.mainFrame.model.selectedPolygons;

        % get all the objects drawn onto the axis
        allHandleList = findobj(this.uiAxis, '-not', 'type', 'text', '-and', '-not', 'type', 'axes');

        % get the tags of all these objects
        allTagList = get(allHandleList, 'tag');

        % if there's at least one object on drawn on the axis
        if ~isempty(allTagList)
            % get the objects whose tag is in the nameList
            neededHandle = allHandleList(ismember(allTagList, selected));

            if strcmp(allHandleList(1).LineStyle, '-')
                % if lines are displayed on the axis
                set(allHandleList, 'LineWidth', .5);
                set(neededHandle, 'LineWidth', 3.5);
                uistack(neededHandle, 'top');
            else    
                % if points are displayed on the axis
                set(allHandleList, 'Marker', '.');
                set(neededHandle, 'Marker', '*');
                uistack(neededHandle, 'top');
            end
        end

        %update the infobox
        if length(selected) == 1
            updateInfoBox(this.mainFrame, getInfoFromName(this.mainFrame.model, selected));
        else
            updateInfoBox(this.mainFrame);
        end
    end

    function detectLineClick(this, h,~)
        %DETECTLINECLICK  callback used when the user clicks on one of the axis' line
        %
        %   Inputs :
        %       - this : handle of the Panel
        %       - h : handle of the object that sent the callback 
        %       - ~ (not used) : input automatically send by matlab during a callback
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

    function detectVectorClick(this, h,~)
        %DETECTLINECLICK  callback used when the user clicks on one of the axis' line
        %
        %   Inputs :
        %       - h : handle of the object that sent the callback 
        %       - ~ (not used) : input automatically send by matlab during a callback
        %       - obj : handle of the MainFrame
        %   Outputs : none

        if ~iscell(h.UserData)
            poly = h.UserData;
        else
            poly = signatureToPolygon(h.UserData{1}, h.UserData{2});
        end

        %empty the selection lists and update the view
        this.mainFrame.model.selectedPolygons = {};
        set(this.mainFrame.handles.list, 'value', []);

        updateSelectedPolygonsDisplay(this);

        this.mainFrame.handles.infoFields{1}.String = abs(polygonArea(poly));
        this.mainFrame.handles.infoFields{2}.String = polygonLength(poly);
        this.mainFrame.handles.infoFields{3}.String = length(poly);
        this.mainFrame.handles.infoFields{4}.String = this.mainFrame.model.infoTable.levels{4}{(polygonArea(poly) < 0) + 1};
    end
end

% -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
% ---------------------------------------------------------------------------- DISPLAY METHODS ----------------------------------------------------------------------------------------------------
% -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

%% Display methods
methods

% ---------------------------------------------------------------------------- POLYGONS -------------------------------------------------------------------------------------------------------

    function displayPolygons(this, polygonArray)
        %DISPLAYPOLYGONS  Display polygons
        %
        %   Inputs :
        %       - obj : handle of the MainFrame
        %       - polygonArray : a N-by-1 cell array containing the polygons
        %   Outputs : none

        % get the names of all the polygons loaded and prepare the
        % panel/axis that'll be used to draw
        names = setupDisplay(this.mainFrame);
        axis = this.uiAxis;

        % reset the position of the cursor in the axis' colormap
        set(axis, 'colororderindex', 1);

        if length(this.colorMap) > length(names)
            % if there's less polygons than colors in the colormap
            % change the axis' colormap to get colors that are as different as
            % possible from each other
            nColors = length(this.colorMap);
            set(axis, 'colororder', this.colorMap(floor(1:nColors/(length(names)):nColors), :));
        else
            set(axis, 'colororder', this.colorMap);
        end
        
        % delete all the lines already drawn on the axis and the legends
        delete(axis.Children(:));
        this.uiLegend = [];

        hold(axis, 'on');
        for i = 1:length(polygonArray)
            % draw the polygon on the axis
            line = drawPolygon(polygonArray{i}, 'parent', axis);

            set(line, 'tag', names{i}, ...
            'ButtonDownFcn', @this.detectLineClick);
            uistack(line,'bottom');
        end
        uistack(axis.Children(:), 'bottom');
        hold(axis, 'off');
    end

    function displayPolygonsFactor(this, polygonArray)
        %DISPLAYPOLYGONSFACTOR  Display polygons colored by factors
        %
        %   Inputs :
        %       - obj : handle of the MainFrame
        %       - polygonArray : a N-by-1 cell array containing the polygons
        %   Outputs : none

        % get the names of all the polygons loaded and prepare the
        % panel/axis that'll be used to draw
        names = setupDisplay(this.mainFrame);
        axis = this.uiAxis;

        % reset the position of the cursor in the axis' colormap
        set(axis, 'colororderindex', 1);

        % get the number of levels of the selected factor
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
        if iscell(this.uiLegend)
            delete(this.uiLegend{1});
            this.uiLegend = [];
        end

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
        lineHandles = lineHandles(~cellfun('isempty',levels));
        levels = levels(~cellfun('isempty',levels));
        if this.mainFrame.model.selectedFactor{3} == 0
            % if the legend must be displayed, display it
            [this.uiLegend{1:4}] = legend(axis, [lineHandles{:}], levels, ...
                                                      'location', 'best', ...
                                                 'uicontextmenu', []);
        end
    end

% ---------------------------------------------------------------------------- SIGNATURES -------------------------------------------------------------------------------------------------------

    function displayPolarSignature(this, signatures, angles)
        %DISPLAYPOLARSIGNATURE  Display polar signatures
        %
        %   Inputs :
        %       - obj : handle of the MainFrame
        %       - signatureArray : a N-by-M cell array containing the polar signatures
        %   Outputs : none

        % get the list of all angles + 1 angle to make the last point match the
        % first
%             angles = angles([1:end 1]);
        angles(end+1) = angles(end) + angles(2)-angles(1);

        % get the names of all the polygons loaded and prepare the
        % panel/axis that'll be used to draw
        names = setupDisplay(this.mainFrame);
        axis = this.uiAxis;

        % reset the position of the cursor in the axis' colormap
        set(axis, 'colororderindex', 1);

        if length(this.colorMap) > length(names)
            % if there's less signatures than colors in the colormap
            % change the axis' colormap to get colors that are as different as
            % possible from eachother
            set(axis, 'colororder', this.colorMap(floor(1:length(this.colorMap)/(length(names)) :length(this.colorMap)), :));
        end

        if ~isempty(signatures)
            % set the axis' limits
            xlim(axis, [angles(1), angles(end)]);
            ylim(axis, [0 max([max(signatures(:))+.5, 10])]);
        end

        % delete all the lines already drawn on the axis
        delete(axis.Children(:));
        this.uiLegend = [];

        hold(axis, 'on');
        for i = 1:size(signatures, 1)
            % get the signature that will be drawn
            signature = signatures(i, [1:end 1]);

%                 % make sure the last point matches the first
%                 signature(end+1) = signature(1);

            % draw the line
            line = plot(angles, signature, 'parent', axis);

            set(line, 'tag', names{i}, ...
            'ButtonDownFcn', @this.detectLineClick);
            uistack(line,'bottom');
        end
        uistack(axis.Children(:), 'bottom');
        hold(axis, 'off');
    end

    function displayPolarSignatureFactor(this, signatureArray)
    %DISPLAYPOLARSIGNATUREFACTOR  Display polar signatures
    %
    %   Inputs :
    %       - obj : handle of the MainFrame
    %       - signatureArray : a N-by-M cell array containing the polar signatures
    %   Outputs : none

        % get the list of all angles + 1 angle to make the last point match the
        % first
        angles = this.mainFrame.model.PolygonArray.angleList;
        angles(end+1) = angles(end) + angles(2) - angles(1);

        % get the names of all the polygons loaded and prepare the
        % panel/axis that'll be used to draw
        names = setupDisplay(this.mainFrame);
        axis = this.uiAxis;

        % get the number of levels of the selected factor
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
        if iscell(this.uiLegend)
            delete(this.uiLegend{1});
            this.uiLegend = [];
        end

        hold(axis, 'on');
        for i = 1:length(signatureArray)
            % get the signature that will be drawn
            signature = signatureArray{i, 2};

            % make sure the last point matches the first
%                 signature(end+1) = signature(1);
            signature = signature([1:end 1]);

            % draw the line
            lines{i} = plot(angles, signature, ...
                'parent', axis, ...
                'ButtonDownFcn', @this.detectLineClick, ...
                'tag', names{i}, ...
                'color', axis.ColorOrder(signatureArray{i, 1}, :));

            if cellfun('isempty',lineHandles(signatureArray{i, 1}))
                % if the factor of the signature that was just drawn has never been
                % encountered, create a copy of this line and save it
%                 lineHandles{signatureArray{i, 1}} = copy(lines{i});
                lineHandles{signatureArray{i, 1}} = lines{i};
                levels{signatureArray{i, 1}} = this.mainFrame.model.selectedFactor{2}{signatureArray{i, 1}};
            end
        end
        hold(axis, 'off');

        levels = levels(~cellfun('isempty',levels));

        if this.mainFrame.model.selectedFactor{3} == 0
            % if the legend must be displayed, display it
%             this.uiLegend{1:4} = legend(axis, lineHandles{:}, levels, ...
%                 'location', 'eastoutside', ...
%                 'uicontextmenu', []);
            this.uiLegend = legend([lineHandles{:}], levels, ...
                'location', 'northeast');
        end
    end

% ---------------------------------------------------------------------------- PCA RESULTS -------------------------------------------------------------------------------------------------------

    function displayPca(this, x, y)
    %DISPLAYPCA  Display points
    %
    %   Inputs :
    %       - obj : handle of the MainFrame
    %       - x : the coordiantes of the points on the x-axis
    %       - y : the coordiantes of the points on the y-axis
    %   Outputs : none

        % get the names of all the polygons loaded and prepare the
        % panel/axis that'll be used to draw
        names = setupDisplay(this.mainFrame, 1, this.type(4:end));

        % delete all the lines/points and legend already drawn on the axis
        delete(allchild(this.uiAxis));
        if iscell(this.uiLegend)
            delete(this.uiLegend{1});
            this.uiLegend = [];
        end

        % memory allocation
        points = cell(length(x), 1);

        %draw the points on the axis
        hold(this.uiAxis, 'on');
        for i = 1:length(x)
            points{i} = plot(x(i), y(i), '.k', ...
                         'parent', this.uiAxis, ...
                     'markersize', 10);
            %set the tags of the points
            if ~strcmp(this.type(4:end), 'Loadings')
                text(x(i), y(i), ['  ' names{i}], ...
                       'parent', this.uiAxis, ...
                        'color', 'k', ...
                'PickableParts', 'none');
                set(points{i}, 'tag', names{i}, ...
                     'ButtonDownFcn', @this.detectLineClick);
            end
        end
        hold(this.uiAxis, 'off');

    end

    function displayPcaFactor(this, pca, factor)

        % get the names of all the polygons loaded and prepare the
        % panel/axis that'll be used to draw
        names = setupDisplay(this.mainFrame, 1, this.type(4:end));
        axis = this.uiAxis;

        if ~strcmp(this.mainFrame.model.selectedFactor{1}, 'none')
            % get the number of levels of the selected factor
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

            % delete all the lines/points and legend already drawn on the axis
            delete(allchild(axis));
            if iscell(this.uiLegend)
                delete(this.uiLegend{1});
                this.uiLegend = [];
            end

            hold(axis, 'on');
            for i = 1:length(pca)
                lines{i} = plot(pca{i, 2}, pca{i, 3}, ...
                                  'marker', '.', ...
                              'markersize', this.mainFrame.model.selectedFactor{5}, ...
                               'linestyle', 'none', ...
                                  'parent', axis, ...
                           'ButtonDownFcn', @this.detectLineClick, ...
                                     'tag', names{i}, ...
                                   'color', axis.ColorOrder(pca{i, 1}, :));

                if cellfun('isempty',lineHandles(pca{i, 1}))
                    % if the factor of the signature that was just drawn has never been
                    % encountered, create a copy of this line and save it
                    lineHandles{pca{i, 1}} = copy(lines{i});
                    levels{pca{i, 1}} = this.mainFrame.model.selectedFactor{2}{pca{i, 1}};
                end
            end
            levels = levels(~cellfun('isempty',levels));

            if this.mainFrame.model.selectedFactor{3} == 0
                % if the legend must be displayed, display it
                [this.uiLegend{1:4}] = legend(axis, [lineHandles{:}], levels, ...
                                                          'location', 'westoutside', ...
                                                     'uicontextmenu', []);
            end
        else
            if ~strcmp(factor, 'none')
                set(axis, 'colororder', this.colorMap(floor(1:length(this.colorMap)/max(unique(getColumn(this.mainFrame.model.factorTable, factor))):length(this.colorMap)), :));
            end
            lines = findobj(allchild(axis), '-not', 'linestyle', 'none');
            points = findobj(allchild(axis), 'marker', '.');

            set(points, 'color', 'k', 'markersize', this.mainFrame.model.selectedFactor{5});
            delete(lines);
            if iscell(this.uiLegend)
                delete(this.uiLegend{1});
                this.uiLegend = [];
            end
            hold(axis, 'on');
        end

        points = findobj(allchild(axis), '-not', 'marker', 'none');
        if this.mainFrame.model.selectedFactor{6} == 0
            for i = 1:length(points)
                text(points(i).XData, points(i).YData, ['  ' points(i).Tag], ...
                                 'parent', axis, ...
                                  'color', points(i).Color, ...
                          'PickableParts', 'none');
            end
        end
        if ~strcmp(factor, 'none')
            set(axis, 'colororderindex', 1);

            % get the datas of the factor that'll be used to group the
            % points
            factors = getColumn(this.mainFrame.model.factorTable, factor);

            % get the list of uniques values
            uniques = unique(factors);
            for i = 1:length(uniques)
                inds = find(factors == uniques(i));
                xdata = [pca{inds, 2}];
                ydata = [pca{inds, 3}];
                switch lower(this.mainFrame.model.selectedFactor{4})
                    case 'none'
                        % do nothing more...

                    case 'convex hull'
                        if length(xdata') > 2
                            inds2   = convhull([xdata' ydata']);
                            plot(xdata(inds2), ydata(inds2), ...
                                           'parent', axis, ...
                                           'marker', 'none', ...
                                        'linestyle', '-', ...
                                            'color', axis.ColorOrder(pca{inds(1), 1}, :), ...
                                    'PickableParts', 'none', ...
                                 'handlevisibility', 'off');
                        else
                            plot(xdata', ydata', ...
                                           'parent', axis, ...
                                           'marker', 'none', ...
                                        'linestyle', '-', ...
                                            'color', axis.ColorOrder(pca{inds(1), 1}, :), ...
                                    'PickableParts', 'none', ...
                                 'handlevisibility', 'off');
                        end

                    case 'ellipse'
                        center  = mean([xdata' ydata']);
                        sigma   = std([xdata' ydata']) * 1.96; 
                        drawEllipse([center sigma 0],...
                                            'parent', axis, ...
                                            'marker', 'none', ...
                                         'linestyle', '-', ...
                                             'color', axis.ColorOrder(pca{inds(1), 1}, :), ...
                                     'PickableParts', 'none', ...
                                  'handlevisibility', 'off');

                    case 'inertia ellipse'
                        elli    = inertiaEllipse([xdata' ydata']);
                        drawEllipse(elli,...
                                'parent', axis, ...
                                'marker', 'none', ...
                             'linestyle', '-',  ...
                                 'color', axis.ColorOrder(pca{inds(1), 1}, :), ...
                         'PickableParts', 'none', ...
                      'handlevisibility', 'off');
                end
            end
            hold(axis, 'off');
        end
        updateSelectedPolygonsDisplay(this);
    end
end

%% Implementation of Panel methods
methods
    function refreshDisplay(this) %#ok<MANU>
        disp('refresh Panel');
    end
end
end