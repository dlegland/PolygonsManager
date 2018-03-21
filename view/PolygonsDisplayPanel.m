classdef PolygonsDisplayPanel < DisplayPanel
%POLYGONSDISPLAYPANEL A panel for display of a collection of polygons
%
%   Class PolygonsDisplayPanel
%
%   Example
%   PolygonsDisplayPanel
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@nantes.inra.fr
% Created: 2018-03-20,    using Matlab 9.3.0.713579 (R2017b)
% Copyright 2018 INRA - BIA-BIBS.


%% Properties
properties
    % N-by-3 numeric vector containing values of range 0 to 1
    colorMap;

    handles;
%     % uipanel instance
%     uiPanel;
%     % axes instance 
%     uiAxis;
%     % legend of the uiAxis
%     uiLegend;

end % end properties


%% Constructor
methods
    function this = PolygonsDisplayPanel(frame, varargin)
    % Constructor for PolygonsDisplayPanel class
    
        % call constructor of parent class
        this = this@DisplayPanel(frame);
    
%         % set the 'parent' of the panel
%         this.mainFrame = mainFrame;

        % set the colormap of the panel
        this.colorMap = Panel.default_colorMap;

        % creation of the panel that will contain the axis
        this.handles.uiPanel = uipanel('parent', frame.handles.tabs, ...
                          'bordertype', 'none', ...
                       'uicontextmenu', frame.menuBar.contextPanel.handle);

        % creation of the axis on which the lines will be drawn
        this.handles.uiAxis = axes('parent', this.handles.uiPanel, ...
                   'ButtonDownFcn', @(~,~) this.reset, ...
                      'colororder', this.colorMap, ...
                             'tag', 'main', ...
                   'uicontextmenu', frame.menuBar.contextPanel.handle);


        % save the new panel in the parent PolygonsManagerMainFrame
        frame.handles.Panels{length(frame.handles.Panels) + 1} = this;

        % setup specific to polygons display panel
        axis(this.handles.uiAxis, 'equal');
          
        while length(varargin) > 1
            % get parameter name and value
            param = lower(varargin{1});
            value = varargin{2};

            switch param 
                case 'title'
                    frame.handles.tabs.TabTitles{length(frame.handles.Panels)} = value;
                case 'colormap'
                    this.colorMap = value;
                    this.uiAxis.ColorOrder = value;
                otherwise
                    error('Panel:Panel', ...
                        ['Unknown parameter name: ' varargin{1}]);
            end
            varargin(1:2) = [];
        end

        % add a callback to the tabpanel to call when the tab selection changes
        set(frame.handles.tabs, 'selection', length(frame.handles.Panels), ...
            'SelectionChangedFcn', @(~,~) panelChange);
        
        function panelChange
            %SELECT  update the view depending on the selection

            % TODO: replace by this
            selectedTab = this.frame.handles.tabs.Selection;
            selectedPanel = this.frame.handles.Panels{selectedTab};
            updateSelectedPolygonsDisplay(selectedPanel);
            
            % toggle grid widgets
            gridFlag = get(selectedPanel.handles.uiAxis, 'xgrid');
            set(this.frame.menuBar.view.grid.handle, 'checked', gridFlag);
            set(this.frame.menuBar.contextPanel.grid.handle, 'checked', gridFlag);
            
            % eventually update possibility to toggle markers
            if ~isempty(selectedPanel.handles.uiAxis.Children)
                if strcmp(get(selectedPanel.handles.uiAxis.Children(1), 'Marker'), '+')
                    set(mainFrame.menuBar.view.markers.handle, 'checked', 'on');
                    set(mainFrame.menuBar.contextPanel.markers.handle, 'checked', 'on');
                else
                    set(mainFrame.menuBar.view.markers.handle, 'checked', 'off');
                    set(mainFrame.menuBar.contextPanel.markers.handle, 'checked', 'off');
                end
            end
        end
    end

end % end constructor methods

%% GUI methods
methods
    function detectLineClick(this, h, ~)
        %DETECTLINECLICK  callback used when the user clicks on one of the axis' line
        %
        %   Inputs :
        %       - this : handle of the Panel
        %       - h : handle of the object that sent the callback 
        %       - ~ (not used) : input automatically send by matlab during a callback
        %   Outputs : none

        model = this.frame.model;
        
        if ismember(this.frame.handles.figure.SelectionType, {'alt', 'open'})
            % if the user is pressing the 'ctrl' key or using the right
            % mouse-button
            if find(strcmp(get(h,'tag'), this.frame.model.selectedPolygons))
                % if the clicked line was already selected, deselect it
                model.selectedPolygons(strcmp(get(h,'tag'), model.selectedPolygons)) = [];
            else
                % if the clicked line wasn't selected, add it to the list of
                % selected lines
                model.selectedPolygons{end+1} = model.nameList{strcmp(get(h,'tag'), model.nameList)};
            end
        else
            % if the user didn't press 'ctrl' or click the right mouse-button
            if find(strcmp(get(h,'tag'), model.selectedPolygons))
                % if the clicked line was already selected
                if length(model.selectedPolygons) == 1
                    % if the clicked line was the only selected line, deselect it
                    model.selectedPolygons(strcmp(get(h,'tag'), model.selectedPolygons)) = [];
                else
                    % if the clicked line wasn't the only selected line, set it as the only selected line
                    model.selectedPolygons = model.nameList(strcmp(get(h,'tag'), model.nameList));
                end
            else
                % if the line wasn't already selected, set it as the only selected line
                model.selectedPolygons = model.nameList(strcmp(get(h,'tag'), model.nameList));
            end
        end
        %update the lines displayed
        updateSelectedPolygonsDisplay(this);

        % match the selection of the name list to the selection of the axis
        set(this.frame.handles.list, 'value', find(ismember(model.nameList, model.selectedPolygons)));
    end
    
    function reset(this)
        %RESET  set the current selection to void
        
        if ~ismember(this.frame.handles.figure.SelectionType, {'alt', 'open'})
            % if the user is not pressing the 'ctrl' key or right-clicking

            %empty the selection lists and update the view
            this.frame.model.selectedPolygons = {};
            set(this.frame.handles.list, 'value', []);

            % update the view
            updateSelectedPolygonsDisplay(this);
        end
    end
end

%% Methods
methods
    function displayPolygons(this, polygonArray)
        %DISPLAYPOLYGONS  Display polygons
        %
        %   Inputs :
        %       - obj : handle of the MainFrame
        %       - polygonArray : a N-by-1 cell array containing the polygons
        %   Outputs : none

        polygonArray = this.frame.model.PolygonArray;
        
        % get the names of all the polygons loaded and prepare the
        % panel/axis that'll be used to draw
%         names = setupDisplay(this.mainFrame);
        names = getPolygonNames(this.frame.model);
        nPolys = length(names);
        
        
        % reset the position of the cursor in the axis' colormap
        axis = this.handles.uiAxis;
        set(axis, 'colororderindex', 1);

        if length(this.colorMap) > nPolys
            % if there's less polygons than colors in the colormap
            % change the axis' colormap to get colors that are as different as
            % possible from each other
            nColors = length(this.colorMap);
            set(axis, 'colororder', this.colorMap(floor(1:nColors/nPolys:nColors), :));
        else
            set(axis, 'colororder', this.colorMap);
        end
        
        % delete all the lines already drawn on the axis and the legends
        delete(axis.Children(:));
        this.handles.uiLegend = [];

        hold(axis, 'on');
        for i = 1:getPolygonNumber(polygonArray)
            % draw the polygon on the axis
%             line = drawPolygon(polygonArray{i}, 'parent', axis);
            poly = getPolygon(polygonArray, i);
            line = drawPolygon(poly, 'parent', axis);

            set(line, 'tag', names{i}, ...
            'ButtonDownFcn', @this.detectLineClick);
            uistack(line,'bottom');
        end
        uistack(axis.Children(:), 'bottom');
        hold(axis, 'off');
    end

    function updateSelectedPolygonsDisplay(this)
        %UPDATESELECTEDPOLYGONSDISPLAY  display the lines of the current axis differently if they're selected or not

        % get the nameList of selected polygons
        selected = this.frame.model.selectedPolygons;

        % get all the objects drawn onto the axis
        allHandleList = findobj(this.handles.uiAxis, '-not', 'type', 'text', '-and', '-not', 'type', 'axes');

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
            updateInfoBox(this.frame, getInfoFromName(this.frame.model, selected));
        else
            updateInfoBox(this.frame);
        end
    end


end % end methods

%% Methods implementing the DisplayPanel interface
methods
    function refreshDisplay(this)
        disp('Refresh polygons display panel');
        displayPolygons(this);
%         updateSelectedPolygonsDisplay(this);
    end
end

end % end classdef

