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
% e-mail: david.legland@inra.fr
% Created: 2018-03-20,    using Matlab 9.3.0.713579 (R2017b)
% Copyright 2018 INRA - BIA-BIBS.


%% Properties
properties
    % N-by-3 numeric vector containing values of range 0 to 1
    colorMap;

    handles;
end % end properties


%% Constructor
methods
    function this = PolygonsDisplayPanel(frame, varargin)
    % Constructor for PolygonsDisplayPanel class
    
        % call constructor of parent class
        this = this@DisplayPanel(frame);
    
        % set the colormap of the panel
        this.colorMap = Panel.default_colorMap;
        this.type = 'polygons';
        
        % default title
        title = 'polygons';

        % creation of the panel that will contain the axis
        this.handles.panel = uipanel('parent', frame.handles.tabs, ...
                          'bordertype', 'none', ...
                       'uicontextmenu', frame.menuBar.contextPanel.handle);

        % creation of the axis on which the lines will be drawn
        this.handles.axis = axes('parent', this.handles.panel, ...
                   'ButtonDownFcn', @(~,~) this.onAxisClicked, ...
                      'colororder', this.colorMap, ...
                             'tag', 'main', ...
                   'uicontextmenu', frame.menuBar.contextPanel.handle);

        % setup specific to polygons display panel
        axis(this.handles.axis, 'equal');
          
        while length(varargin) > 1
            % get parameter name and value
            param = lower(varargin{1});
            value = varargin{2};

            switch param 
                case 'title'
                    title = value;
                case 'colormap'
                    this.colorMap = value;
                    this.handles.axis.ColorOrder = value;
                otherwise
                    error('Panel:Panel', ...
                        ['Unknown parameter name: ' varargin{1}]);
            end
            varargin(1:2) = [];
        end

        % save the new panel in the parent PolygonsManagerMainFrame
        addPanel(frame, this, title);

        % add a callback to the tabpanel to call when the tab selection changes
        set(frame.handles.tabs, 'selection', length(frame.handles.Panels));
        
    end

end % end constructor methods

%% GUI methods
methods
    function onPolygonObjectClicked(this, hObj, ~)
        %DETECTLINECLICK  callback used when the user clicks on one of the axis' line
        %
        %   Inputs :
        %       - this : handle of the Panel
        %       - h : handle of the object that sent the callback 
        %       - ~ (not used) : input automatically send by matlab during a callback
        %   Outputs : none


        % get the tag of the clicked object, to identify its name
        tag = get(hObj, 'tag');
        model = this.frame.model;
        
        if ismember(this.frame.handles.figure.SelectionType, {'alt', 'open'})
            % if the user is pressing the 'ctrl' key or using the right
            % mouse-button
            if isSelectedPolygon(model, tag)
                % if the clicked line was already selected, deselect it
                removePolygonsFromSelection(model, tag);
            else
                % if the clicked line wasn't selected, add it to the list of
                % selected lines
                addPolygonsToSelection(model, tag);
            end
        else
            % if the user didn't press 'ctrl' or click the right mouse-button
            % set the clicked line as the only one selected
            clearPolygonSelection(model);
            addPolygonsToSelection(model, tag);
        end
        
        updateSelectedPolygonsDisplay(this.frame);
    end
    
    function onAxisClicked(this)
        %RESET  set the current selection to void
        
        if ~ismember(this.frame.handles.figure.SelectionType, {'alt', 'open'})
            % if the user is not pressing the 'ctrl' key or right-clicking

            % empty the selection lists
            clearPolygonSelection(this.frame.model);
            
            % update the views
            updateSelectedPolygonsDisplay(this.frame);
        end
    end
end

%% Methods
methods
    function displayPolygons(this)
        %DISPLAYPOLYGONS  Display polygons
        %
        %   Inputs :
        %       - obj : handle of the MainFrame
        %       - polygonArray : a N-by-1 cell array containing the polygons
        %   Outputs : none

        model = this.frame.model;
        polygonArray = model.polygonList;
        
        % get the names of all the polygons loaded and prepare the
        % panel/axis that'll be used to draw
        names = getPolygonNames(this.frame.model);
        nPolys = length(names);
                
        % check if a factor is used for display
        useFactor = ~(isempty(model.groupingFactorName) || strcmp(model.groupingFactorName, 'none'));

        if useFactor
            levels = factorLevels(model.factors, model.groupingFactorName);
            nLevels = length(levels);
        else
            nLevels = nPolys;
        end

        % reset the position of the cursor in the axis colormap
        axis = this.handles.axis;
        set(axis, 'colororderindex', 1);

        % resample the color map
        nColors = length(this.colorMap);
        inds = floor(1:nColors/nLevels:nColors);
        set(axis, 'colororder', this.colorMap(inds, :));

        % delete all the lines already drawn on the axis and the legends
        delete(axis.Children(:));
        this.handles.uiLegend = [];

        hold(axis, 'on');
        
        if ~useFactor
            % display polygons with one color per polygon
            for i = 1:nPolys
                % draw the polygon on the axis
                poly = getPolygon(polygonArray, i);
                line = drawPolygon(poly, 'parent', axis);

                set(line, 'tag', names{i}, ...
                    'ButtonDownFcn', @this.onPolygonObjectClicked);
            end
        else
            % display polygons with one color per factor

            % memory allocation for the array that'll contain the legend's lines
            levels = factorLevels(model.factors, model.groupingFactorName);
            nLevels = length(levels);
            
            lines = cell(1, nLevels);
            levelHandles = cell(1, nLevels);

            for i = 1:nPolys
                % draw the polygon on the axis
                poly = getPolygon(polygonArray, i);
                levelIndex = model.factors(i, model.groupingFactorName).data;
                color = axis.ColorOrder(levelIndex, :);
                
                lines{i} = drawPolygon(poly, 'parent', axis, ...
                    'ButtonDownFcn', @this.onPolygonObjectClicked, ...
                    'tag', names{i}, ...
                    'color', color);
                
                levelHandles{levelIndex} = lines{i};
            end
            
            % if the legend must be displayed, display it
            this.handles.legend = legend(axis, [levelHandles{:}], levels, ...
                'location', 'best', ...
                'uicontextmenu', []);
        end
        
        hold(axis, 'off');
    end

    function updateSelectedPolygonsDisplay(this)
        updateSelectionDisplay(this);
    end
    
    function updateSelectionDisplay(this)
        %UPDATESELECTEDPOLYGONSDISPLAY  display the lines of the current axis differently if they're selected or not

        % get the nameList of selected polygons
        selected = getSelectedPolygonNames(this.frame.model);

        % get all the objects drawn onto the axis
        allHandleList = findobj(this.handles.axis, '-not', 'type', 'text', '-and', '-not', 'type', 'axes');

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

%         % update the infobox
%         if length(selected) == 1
%             updateInfoBox(this.frame, getInfoFromName(this.frame.model, selected));
%         else
%             updateInfoBox(this.frame);
%         end
    end


end % end methods

%% Methods implementing the DisplayPanel interface
methods
    function refreshDisplay(this)
        disp('Refresh polygons display panel');
        displayPolygons(this);
    end
end

end % end classdef

