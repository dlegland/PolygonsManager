classdef PolygonsManagerMainFrame < handle
%POLYGONSMANAGERMAINFRAME Class that creates the main frame of the application
%
%   Creation : 
%   figure = PolygonsManagerMainFrame;
%

%% Properties
properties
    % PolygonsManagerData that contains all the data of the application
    model;

    % struct containing the handles of all the objects used in the
    % application
    handles;
    
    % a struct arborescence containing handles of menu items
    menuBar;
end

%% Construction methods
methods
    function this = PolygonsManagerMainFrame(varargin)
    %POLYGONSMANAGERMAINFRAME Constructor for the PolygonsManagerMainFrame class
    %
    %   inputs: 
    %       - none, or an instance of PolygonsManagerData
    %   ouputs: 
    %       - this: PolygonsManagerMainFrame instance

        % create the widgets, without initialisation
        setupLayout(this);
        setupMenuPolygonsManager(this);
        setupOptionsPanelPolygonsManager(this);
    
        if ~isempty(varargin) && isa(varargin{1}, 'PolygonsManagerData')
            model = varargin{1};
            setupNewFrame(this, model)
        end
    end
    
    function setupLayout(this, varargin)
        % Create the different widgets that populate the main frame
        
        % creation of the main figure
        fen = figure('units', 'normalized', ...
             'outerposition', [0.25 0.25 0.5 0.5], ...
                   'menubar', 'none', ...
               'numbertitle', 'off', ...
                      'name', 'Polygons Manager');
        % the units properties of the figure is set to pixel so that it
        % can be used to position other elements later
        fen.Units = 'pixel';

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

        options_box =  uix.TabPanel('parent', left_box, ...
                                  'tabwidth', 89);

        % box containing the panels on which the polygons are drawn
        tab_box = uix.TabPanel('parent', main_box, ...
                             'tabwidth', 100, ...
                             'SelectionChangedFcn', @(i1,i2) onSelectedTabChanged(this, i1, i2));

        main_box.Widths = [200 -1];
        left_box.Heights = [-1 162];

        % add created handles to the list of handles
        this.handles.main = main_box;
        this.handles.left = left_box;
        this.handles.tabs = tab_box;
        this.handles.list = list_box;
        this.handles.options{1} = options_box;
        this.handles.infoFields = {};

        % create spaces that will be used by other elements later
        this.handles.Panels = {};
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
                             'callback', @(~,~) onListSelectionUpdated(this), ...
                        'uicontextmenu', this.menuBar.contextList.handle);

        if ~isempty(varargin)
            this.handles.figure.Name = varargin{1};
            varargin(1) = [];
        end

        if isempty(varargin)
            % creation of a panel on which the polygons will be drawn
%             panel1 = Panel(this, 'equal', 'on', ...
%                                  'title', 'Polygons');
            panel1 = PolygonsDisplayPanel(this, 'title', 'Polygons');
            refreshDisplay(panel1);

%             % draw the polygons on the new PolygonsManagerMainFrame
%             displayPolygons(panel1, getAllPolygons(this.model.PolygonArray));
            
            if isa(this.model.PolygonArray, 'PolarSignatureArray')
                % if the polygons are saved as polar signature, display
                % the polar signatures
%                 panel2 = Panel(this, 'equal', 'off', ...
%                                      'title', 'Signature');
%                 displayPolarSignature(panel2, this.model.PolygonArray.signatures, this.model.PolygonArray.angleList);
                panel2 = SignatureDisplayPanel(this, 'title', 'Signatures');
                displayPolarSignature(panel2);
            end
        else
            % if the mainframe must display one of the results of a PCA
            % creation of a panel on which the polygons will be drawn

            if strcmp(varargin{1}, 'pcaVector')
                this.handles.list.Callback =  @(~,~) draw;

                panel1 = Panel(this, 'equal', 'on', ...
                                     'title', 'Polygon', ...
                                      'type', varargin{1}, ...
                                  'colormap', varargin{4});


                displayPolygons(panel1, varargin{2});
                panel1.colorMap = panel1.default_colorMap;

                for j = 1:length(panel1.uiAxis.Children)
                    panel1.uiAxis.Children(j).UserData = [varargin{2}{j}];
                end

                set(panel1.uiAxis.Children(:),'handlevisibility', 'off', ...
                                                     'linewidth', 2, ...
                                                 'ButtonDownFcn', @panel1.detectVectorClick);

                if isa(this.model.PolygonArray, 'PolarSignatureArray')
                    panel2 = Panel(this, 'equal', 'off', ...
                                         'title',  'Signature', ...
                                          'type', varargin{1}, ...
                                      'colormap', varargin{4});

                    displayPolarSignature(panel2, varargin{3}, this.model.PolygonArray.angleList);
                    panel2.colorMap = panel2.default_colorMap;

                    for j = 1:length(panel2.uiAxis.Children)
                        panel2.uiAxis.Children(j).UserData = [varargin{2}{j}];
                    end

                    set(panel2.uiAxis.Children(:),'handlevisibility', 'off', ...
                                                         'linewidth', 2, ...
                                                     'ButtonDownFcn', @panel2.detectVectorClick);

                end

                panel3 = Panel(this, 'equal' , 'off', ...
                                      'title', 'Proper vector');
                plot(panel3.uiAxis, 1:length(varargin{5}), varargin{5}, 'linewidth', 2, 'color', 'k');
                xlim(panel3.uiAxis, [1 length(varargin{5})]);

            elseif strcmp(varargin{1}, 'pcaLoadings')
                panel1 = Panel(this, 'equal', varargin{2}, ...
                                     'title', varargin{1}(4:end), ...
                                      'type', varargin{1});

                delete(this.handles.left);
                displayPca(panel1, varargin{3}, varargin{4});

            elseif strcmp(varargin{1}, 'pcaEigenValues')
                Panel(this, 'equal',  varargin{2}, ...
                            'title', 'Eigen values', ...
                             'type', varargin{1});

                delete(this.handles.left);
                this.handles.tabs.SelectionChangedFcn = '';

            else
                panel1 = Panel(this, 'equal', varargin{2}, ...
                                     'title', varargin{1}(4:end), ...
                                      'type', varargin{1});
                displayPca(panel1, varargin{3}, varargin{4});
            end
        end

        updateMenus(this);

        function draw
        %DRAW  draw polygons depending on the current selection

        disp('draw');
        
            % get the list of selected polygons
            list = cellstr(this.handles.list.String);
            selVal = this.handles.list.Value;
            this.model.selectedPolygons = list(selVal);

            % memory allocation
            polygons = cell(length(this.model.selectedPolygons), 1);
            if isa(this.model.PolygonArray, 'PolarSignatureArray')
                signatures = zeros(length(this.model.selectedPolygons), length(this.model.PolygonArray.angleList));
            end

            % get the polygons using the names got earlier
            for i = 1:length(this.model.selectedPolygons)
                polygons{i} = getPolygonFromName(this.model, this.model.selectedPolygons{i});
                if isa(this.model.PolygonArray, 'PolarSignatureArray')
                    signatures(i, :) = getSignatureFromName(this.model, this.model.selectedPolygons{i});
                end
            end

            % display the polygons
            displayPolygons(this.handles.Panels{1}, polygons);
            if isa(this.model.PolygonArray, 'PolarSignatureArray')
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
end

%% Processing methods
methods
    function updateMenus(this)
    %UPDATEMENUS update the menus depending on the current state of the datamodel
    %
    %   inputs:
    %       - this: handle of the PolygonsManagerMainFrame
    %   ouputs: none

        % check if frame contains a valid data model
        if ~isa(this.model, 'PolygonsManagerData')
            return;
        end
        
        mb = this.menuBar;
        
        set(mb.edit.extractSelection.handle, 'enable', 'on');
        set(mb.edit.clearSelection.handle, 'enable', 'on');
        set(mb.edit.duplicate.handle, 'enable', 'on');
        if ~isempty(this.model.usedProcess)
            set(mb.file.saveMacro.handle, 'enable', 'on');
        end
        set(mb.file.saveMacro.handle, 'enable', 'on');
        set(mb.file.loadMacro.handle, 'enable', 'on');
        set(mb.file.exportToWorkspace.handle, 'enable', 'on');
        
        set(mb.factors.handle, 'enable', 'on');
        set(mb.view.handle, 'enable', 'on');
        set(mb.process.handle, 'enable', 'on');
        
        % some features are not available if polygons are not normalized
        if ~isNormalized(this.model.PolygonArray)
            set(mb.file.savePolygons.handle, 'enable', 'off');
        else
            set(mb.process.handle, 'visible', 'on');
            set(mb.pca.handle, 'visible', 'on');
            set(mb.file.savePolygons.handle, 'enable', 'on');
        end
        
        % enables or not menu items depending on the factor table
        if isa(this.model.factors, 'Table')
            if ~isempty(this.handles.Panels{1}.type)
                if ismember(this.handles.Panels{1}.type, {'pcaScores', 'pcaInfluence', 'pcaScoresProfiles'})
                    this.handles.options{1}.TabEnables{2} = 'on';
                    this.handles.options{2}.TabEnables{2} = 'on';
                    set(findobj(this.handles.options{1}, 'tag', 'factor'), 'string', ['none' this.model.factors.colNames]);
                end
            else
                this.handles.options{1}.TabEnables{2} = 'on';
                this.handles.options{2}.TabEnables{2} = 'on';
                set(findobj(this.handles.options{1}, 'tag', 'factor'), 'string', ['none' this.model.factors.colNames]);
            end
            
            % update the 'factors submenus'
            set(mb.factors.import.handle, 'checked', 'on');
            set(mb.factors.create.handle, 'enable', 'on');
            set(mb.factors.save.handle, 'enable', 'on');
            set(mb.factors.display.handle, 'enable', 'on');
            set(mb.edit.showInfo.handle, 'enable', 'on');
            set(this.handles.figure, 'name', ['Polygons Manager | factors : ' this.model.factors.name]);
        end
        
        % enables or not menu items depending on PCA
        if isa(this.model.pca, 'Pca')
            set(mb.pca.computePCA.handle, 'checked', 'on');
            set(mb.pca.computePCA.handle, 'enable', 'on');
            set(mb.pca.displayEigenValues.handle, 'enable', 'on');
            set(mb.pca.displayScores.handle, 'enable', 'on');
            set(mb.pca.displayLoadings.handle, 'enable', 'on');
            set(mb.pca.influencePlot.handle, 'enable', 'on');
            set(mb.pca.displayProfiles.handle, 'enable', 'on');
            set(mb.pca.displayScoresAndProfiles.handle, 'enable', 'on');
            set(mb.pca.savePca.handle, 'enable', 'on');
            
            if ~isempty(this.handles.Panels{1}.type)
                % disable display of markers
                set([mb.view.markers.handle], 'enable', 'off');
                set([mb.contextPanel.markers.handle], 'enable', 'off');
                
                if ismember(this.handles.Panels{1}.type, {'pcaScores', 'pcaInfluence', 'pcaScoresProfiles'})
                    this.handles.options{3}.TabEnables{2} = 'on';
                    if isa(this.model.factors, 'Table')
                        set(findobj(this.handles.options{3}, 'tag', 'group'), 'enable', 'on');
                    end
                end
            end
            
            if isa(this.model.factors, 'Table')
                set(this.handles.figure, 'name', ['Polygons Manager | factors : ' this.model.factors.name ' | PCA']);
            else
                set(this.handles.figure, 'name', 'Polygons Manager | PCA');
            end
        end
    end

    function names = setupDisplay(this, varargin)
    %SETUPDISPLAY  set the name of the panel and updates the menus
    %
    %   inputs :
    %       - this : handle of the PolygonsManagerMainFrame
    %       - i1 : index of the menus thet must be checked
    %       - i2 : index of the menus thet must be unchecked
    %   ouputs : 
    %       - names : list of all the polygons names
        if nargin > 3
            % set the name of the tab
            this.handles.tabs.TabTitles{varargin{1}} = varargin{2};
        end

        names = this.model.nameList;
    end

    function names = getPolygonNames(this)
        % Returns the names of the polygons stored in this frame
        warning('deprecated: use PolygonsManagerData methods instead')
        names = this.model.nameList;
    end

    function updatePolygonInfoPanel(this)
        
        selected = getSelectedPolygonNames(this.model);
        
        if length(selected) == 1
            % if there's only one polygon selected display its
            % informations
            infos = getInfoFromName(this.model, selected);
            this.handles.infoFields{1}.String = infos(1);
            this.handles.infoFields{2}.String = infos(2);
            this.handles.infoFields{3}.String = infos(3);
            this.handles.infoFields{4}.String = this.model.infoTable.levels{4}{infos(4)};

            if isa(this.model.factors, 'Table')
                val = this.handles.infoFields{5}.Value;
                maps = this.handles.infoFields{5}.String;
                factor = maps{val};
                if ~strcmp(factor, 'none')
                    levels = getLevel(this.model.factors, this.model.selectedPolygons, factor);
                    this.handles.infoFields{6}.String = levels;
                else
                    this.handles.infoFields{6}.String = '';
                end
            end
        else
            %if there's multiple/no polygons selected display nothing
            this.handles.infoFields{1}.String = '';
            this.handles.infoFields{2}.String = '';
            this.handles.infoFields{3}.String = '';
            this.handles.infoFields{4}.String = '';

            this.handles.infoFields{6}.String = '';
        end
    end
    
    function updateInfoBox(this, varargin)
    %UPDATEINFOBOX  update the informations concerning the selected polygon
    %
    %   Replaced by "updatePolygonInfoPanel"
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

            if isa(this.model.factors, 'Table')
                val = this.handles.infoFields{5}.Value;
                maps = this.handles.infoFields{5}.String;
                factor = maps{val};
                if ~strcmp(factor, 'none')
                    levels = getLevel(this.model.factors, this.model.selectedPolygons, factor);
                    this.handles.infoFields{6}.String = levels;
                else
                    this.handles.infoFields{6}.String = '';
                end
            end
        else
            %if there's multiple/no polygons selected display nothing
            this.handles.infoFields{1}.String = '';
            this.handles.infoFields{2}.String = '';
            this.handles.infoFields{3}.String = '';
            this.handles.infoFields{4}.String = '';

            this.handles.infoFields{6}.String = '';
        end
    end
end

%% Management of panels
methods
    function nPanels = getPanelNumber(this)
        nPanels = length(this.handles.Panels);
    end
    
    function setActivePanelIndex(this, index)
        set(this.handles.tabs, 'Selection', index);
    end
    
    function panel = getActivePanel(this)
        % Returns the active panel, or empty if there is no panel
        panel = this.handles.Panels{this.handles.tabs.Selection};
    end
    
    function addPanel(this, panel, title)
        index = length(this.handles.Panels) + 1;
        this.handles.Panels{index} = panel;
        this.handles.tabs.TabTitles{index} = title;
    end
end


%% Utility methods
methods
    function pos = getMiddle(this, width, height)
    %GETMIDDLE  get the position where a figure must be to be at the exact center of a figure
    %
    %   inputs :
    %       - figure : handle of a figure 
    %       - width : width of the figure that must be centered
    %       - height : height of the figure that must be centered
    %   ouputs : 
    %       - pos : result of the computation

        % get the position of the figure
        pos = get(this.handles.figure, 'outerposition');

        % compute the position
        pos(1) = pos(1) + (pos(3)/2) - (width/2);
        pos(2) = pos(2) + (pos(4)/2) - (height/2);
        pos(3) = width;
        pos(4) = height;
    end
    
    function refreshDisplay(this)
        % refresh the display of visible panels
        
        panel = getActivePanel(this);
        if ~isempty(panel)
            refreshDisplay(panel);
            updateSelectionDisplay(panel);
        end
        
        updateMenus(this);

        set(this.handles.list, 'string', getPolygonNames(this.model));
    end
    
    function updateSelectedPolygonsDisplay(this)
        panel = getActivePanel(this);
        if ~isempty(panel)
            updateSelectionDisplay(panel);
        end
        
        % match the selection of the name list to the selection of the axis
        if strcmp(get(this.handles.list, 'visible'), 'on')
            indices = getSelectedPolygonIndices(this.model);
            set(this.handles.list, 'value', indices);
        end
        
        % update the panel containing info about current polygon
        updatePolygonInfoPanel(this);
    end
end

%% GUI callbacks
methods
    function onListSelectionUpdated(this, varargin)
        %SELECT  change the display depending on the selected polygons
        
        %get the list of selected polygons
        list = cellstr(this.handles.list.String);
        selVal = this.handles.list.Value;
        this.model.selectedPolygons = list(selVal);
        
        %update the displayed polygons
        updateSelectionDisplay(getActivePanel(this));
    end

    function onSelectedTabChanged(this, varargin)
        % called when the current tab is changed
        disp('change selected tab.');
       
        if ~isfield(this.handles, 'Panels')
            return;
        end
        if isempty(this.handles.Panels)
            return;
        end
            
        selectedTab = this.handles.tabs.Selection;
        panel = this.handles.Panels{selectedTab};
        updateSelectionDisplay(panel);
        
        % get handle to panel axis
        if  isprop(panel, 'handles')
            axis = panel.handles.uiAxis;
        else
            axis = panel.uiAxis;
        end
        
        % toggle grid widgets
        gridFlag = get(axis, 'xgrid');
        set(this.menuBar.view.grid.handle, 'checked', gridFlag);
        set(this.menuBar.contextPanel.grid.handle, 'checked', gridFlag);
        
        % eventually update possibility to toggle markers
        if ~isempty(axis.Children)
            if strcmp(get(axis.Children(1), 'Marker'), '+')
                set(this.menuBar.view.markers.handle, 'checked', 'on');
                set(this.menuBar.contextPanel.markers.handle, 'checked', 'on');
            else
                set(this.menuBar.view.markers.handle, 'checked', 'off');
                set(this.menuBar.contextPanel.markers.handle, 'checked', 'off');
            end
        end

    end
end

end