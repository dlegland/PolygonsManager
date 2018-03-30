classdef SignatureDisplayPanel < DisplayPanel
%SIGNATUREDISPLAYPANEL A panel for displaying a collection of polar signatures 
%
%   Class SignatureDisplayPanel
%
%   Example
%   SignatureDisplayPanel
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

    signatureArray;
    
    handles;
end % end properties


%% Constructor
methods
    function this = SignatureDisplayPanel(frame, varargin)
    % Constructor for SignatureDisplayPanel class
     
        % call constructor of parent class
        this = this@DisplayPanel(frame);
    
        polygonArray = frame.model.polygonList;
        if ~isa(polygonArray, 'PolarSignatureArray')
            error('Requires the main frame to contains a polar signature array');
        end
        this.signatureArray = polygonArray;
        
        % set the colormap of the panel
        this.colorMap = Panel.default_colorMap;
        this.type = 'signatures';
        
        % default title
        title = 'signatures';

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

        % setup specific to signature display panel
        axis(this.handles.axis, 'normal');
          
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

end % end constructors

%% GUI methods
methods
    function onSignatureObjectClicked(this, hObj, ~)
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
    function displayPolarSignatures(this)
    %DISPLAYPOLARSIGNATURE  Display polar signatures
    %
    %   Inputs :
    %       - obj : handle of the MainFrame
    %       - signatureArray : a N-by-M cell array containing the polar signatures
    %   Outputs : none
        
        % get the list of all angles + 1 angle to make the last point match the
        % first
        angles = getSignatureAngles(this.signatureArray);
        angles(end+1) = angles(end) + angles(2)-angles(1);
        
        % get the names of all the polygons loaded and prepare the
        % panel/axis that'll be used to draw
        names = getPolygonNames(this.frame.model);
        nPolys = length(names);
        
        % check if a factor is used for display
        model = this.frame.model;
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

        % determine max signature value
        maxValue = 0;
        for i = 1:nPolys
            maxValue = max(maxValue, max(getPolarSignature(this.signatureArray, i)));
        end
        
        % set the axis' limits
        xlim(axis, [angles(1) angles(end)]);
        ylim(axis, [0 maxValue+.5]);
        
        % delete all the lines already drawn on the axis
        delete(axis.Children(:));
        this.handles.uiLegend = [];
        
        hold(axis, 'on');
        
        if ~useFactor
            % display polygons with one color per polygon
            for i = 1:nPolys
                % get the signature that will be drawn
                signature = getPolarSignature(this.signatureArray, i);
                signature = signature([1:end 1]);
                
                % draw the line
                line = plot(angles, signature, 'parent', axis);
                
                set(line, 'tag', names{i}, ...
                    'ButtonDownFcn', @this.onSignatureObjectClicked);
            end
        else
            % display polygons with one color per factor

            % memory allocation for the array that'll contain the legend's lines
            levels = factorLevels(model.factors, model.groupingFactorName);
            nLevels = length(levels);
            
            lines = cell(1, nLevels);
            levelHandles = cell(1, nLevels);

            for i = 1:nPolys
                % get the signature that will be drawn
                signature = getPolarSignature(this.signatureArray, i);
                signature = signature([1:end 1]);
                
                % draw the polygon on the axis
                levelIndex = model.factors(i, model.groupingFactorName).data;
                color = axis.ColorOrder(levelIndex, :);
                
                lines{i} = plot(angles, signature, ...
                    'parent', axis, ...
                    'ButtonDownFcn', @this.onSignatureObjectClicked, ...
                    'tag', names{i}, ...
                    'color', color);
                
                levelHandles{levelIndex} = lines{i};
            end
            
            % if the legend must be displayed, display it
            this.handles.legend = legend(axis, [levelHandles{:}], levels, ...
                'location', 'best', ...
                'uicontextmenu', []);
        end
        
        uistack(axis.Children(:), 'bottom');
        hold(axis, 'off');
    end
    
end % end methods

%% Methods Implementing the DisplayPanel interface
methods
    function refreshDisplay(this)
        disp('Refresh polygons display panel');
        displayPolarSignatures(this);
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
    end

end

end % end classdef

