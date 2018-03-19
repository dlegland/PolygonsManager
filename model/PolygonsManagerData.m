classdef PolygonsManagerData < handle
%POLYGONSMANAGERDATA Class that contains the data used by the PolygonsManager application
%
%   Creation : 
%   polygonArray = BasicPolygonArray(polygons, names);
    
    properties
        % PolygonArray that contains the polygons in various forms
        PolygonArray;
        
        % Table that contains the factor of the polygon array
        factorTable;
        
        % 1-by-N Cell array that contains the names of the polygons
        nameList;
        
        % Table that contains the informations concerning the current
        % polygons
        infoTable;
        
        % 1-by-N Cell array that contains the names of the polygons that have been
        % selected
        selectedPolygons = {};
        
        % 1-by-3 Cell array that contains informations neccessary to the
        % coloration of polygons
        % the cells contains :
        %   cell 1 : factor that is displayed
        %   cell 2 : factor's levels
        %   cell 3 : logical that determines if the legend must be
        %   displayed or not
        selectedFactor;
        
        % PCA containing the results of the PolygonArray's PCA
        pca;
        
        % cell array containing the process used in the treatments
        usedProcess = {};
        
    end
    
    methods
        function this = PolygonsManagerData(varargin)
        %Constructor for PolygonsManagerData class
        %
        %   polygonArray = PolygonsManagerData(polygonArray, nameArray)
        %   where polygonArray is a PolygonArray and nameArray is a 1-by-N
        %   cell array
        
            props = properties(this);
            for i = 1:length(props)
                if  find(strcmpi(props{i}, varargin))
                    ind = find(strcmpi(props{i}, varargin));
                    this.(props{i}) = varargin{ind+1};
                    varargin(ind+1) = [];
                    varargin(ind) = [];
                end
            end
            this.infoTable = loadPolygonInfos(this);
        end
        
        function index = getPolygonIndexFromName(this, name)
            % returns the index of the polygon that corresponds to the name input
            index = find(strcmp(name, this.nameList));
        end
        
        function polygon = getPolygonFromName(this, name)
            % returns the polygon that corresponds to the input name
            index = find(strcmp(name, this.nameList));
            polygon = getPolygon(this.PolygonArray, index);
        end
        
        function polygon = getPolygonRowFromName(this, name)
            index = find(strcmp(name, this.nameList));
            polygon = getPolygonRow(this.PolygonArray, index);
        end
        
        function polygons = getPolygonsFromFactor(this, factor)
            % returns all the polygons assossiated to their level iwt the
            % input factor
            
            % get the names of all the polygons
            names = this.nameList;
            
            % get all the values input factor's column
            factors = getColumn(this.factorTable, factor);
            
            % memory allocation
            polygons = cell(length(names), 2);
            for i = 1:length(names)
                polygons{i, 1} = factors(i);
                polygons{i, 2} = getPolygonFromName(this, names{i});
            end
        end
        
        function polygons = getPolygonsNameFromFactor(this, factor, level)
            % returns all the polygons assossiated to their level iwt the
            % input factor
            
            % get the names of all the polygons
            names = this.nameList;
            
            % get all the values input factor's column
            factors = getColumn(this.factorTable, factor);
            factorLevel = factorLevels(this.factorTable, factor);
            
%             memory allocation
            polygons = {};
            for i = 1:length(names)
                if strcmp(level, factorLevel{factors(i)})
                    polygons{end+1} = names{i};
                end
            end
        end
        
        function signature = getSignatureFromName(this, name)
            % returns the signature that corresponds to the input name
            index = find(strcmp(name, this.nameList));
            signature = getSignature(this.PolygonArray, index);
        end
        
        function signatures = getSignatureFromFactor(this, factor)
            % returns all the signatures assossiated to their level iwt the
            % input factor
            
            % get the names of all the signatures
            names = this.nameList;
            
            % get all the values input factor's column
            factors = getColumn(this.factorTable, factor);
            
            % memory allocation
            signatures = cell(length(names), 2);
            for i = 1:length(names)
                signatures{i, 1} = factors(i);
                signatures{i, 2} = getSignatureFromName(this, names{i});
            end
        end
        
        function pca = getPcaFromFactor(this, factor, type, varargin)
            % returns all the signatures assossiated to their level iwt the
            % input factor
            
            % get the names of all the signatures
            names = this.nameList;
            
            % get all the values input factor's column
            factors = getColumn(this.factorTable, factor);
            
            if strcmp(type, 'pcaInfluence')
                x = sqrt(sum(this.pca.scores.data .^ 2, 2));
                y = min(abs(this.pca.scores.data), [], 2);
            else
                x = this.pca.scores(:, varargin{1}).data;
                y = this.pca.scores(:, varargin{2}).data;
            end
            
            % memory allocation
            pca = cell(length(names), 3);
            for i = 1:length(names)
                index = find(strcmp(names{i}, this.pca.scores.rowNames));
                pca{i, 1} = factors(i);
                pca{i, 2} = x(index);
                pca{i, 3} = y(index);
            end
        end
        
        function infoTable = loadPolygonInfos(this)
            infos = zeros(getPolygonNumber(this.PolygonArray), 3);
            for i = 1:getPolygonNumber(this.PolygonArray)
                poly = getPolygon(this.PolygonArray, i);
                infos(i, 1) = abs(polygonArea(poly));
                infos(i, 2) = polygonLength(poly);
                infos(i, 3) = length(poly);
                infos(i, 4) = (polygonArea(poly) < 0) + 1;
            end
            infoTable = Table.create(infos, 'rownames', this.nameList, 'colnames', {'Area', 'Perimeter', 'Vertices', 'Orientation'});
            setFactorLevels(infoTable, 4, {'CW', 'CCW'});
        end
        
        function updatePolygonInfos(this, name)
            index = getPolygonIndexFromName(this, name);
            poly = getPolygon(this.PolygonArray, index);
            this.infoTable.data(index, 1) = abs(polygonArea(poly));
            this.infoTable.data(index, 2) = polygonLength(poly);
            this.infoTable.data(index, 3) = length(poly);
            this.infoTable.data(index, 4) = (polygonArea(poly) < 0) + 1;
        end
        
        function infos = getInfoFromName(this, name)
            infos = getRow(this.infoTable, name);
        end
        
        function saveFactors(this)
        %SAVEFACTORS  Saves the current factors in a text file
        %
        %   Inputs :
        %       - obj : handle of the MainFrame
        %   Outputs : none

            % open the file save prompt and let the user select the name of the file in 
            % which the factor Table will be saved
            [fileName, dname] = uiputfile('*.txt', 'Save the current factors', this.factorTable.name);

            if fileName ~= 0
                % if the user did select a folder
                write(this.factorTable, fullfile(dname, fileName));

                % display a message to inform the user that the save worked
                msgbox('success');
            end
        end
        
        function savePca(this, field)
        %SAVEFACTORS  Saves the current factors in a text file
        %
        %   Inputs :
        %       - obj : handle of the MainFrame
        %   Outputs : none

            % open the file save prompt and let the user select the name of the file in 
            % which the factor Table will be saved
            [fileName, dname] = uiputfile('*.txt', 'Save the current factors', [field '.pca']);

            if fileName ~= 0

                if strcmp(field, 'means')
                    write(Table.create(this.pca.(field)), fullfile(dname, fileName));
                else
                    write(this.pca.(field), fullfile(dname, fileName));
                end

                % display a message to inform the user that the save worked
                msgbox('success');
            end
        end
        
        function saveMacro(this)
            [fileName, dname] = uiputfile('C:\Stage2016_Thomas\data_plos\slabs\Tests\*.txt');

            if fileName ~= 0
                fileID = fopen(fullfile(dname, fileName), 'w');
                temp = this.usedProcess';
                fprintf(fileID,'%s\n', temp{:});
                fclose(fileID);
            end
        end
    end
end