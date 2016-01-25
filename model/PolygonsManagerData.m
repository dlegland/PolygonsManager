classdef PolygonsManagerData
%POLYGONSMANAGERDATA Class that contains the datas used by the polygons
%manager application
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
        
        % 1-by-N Cell array that contains the names of the polygons that have been
        % selected
        selectedPolygons = {};
        
        % 1-by-3 Cell array that contains informations neccessary to the
        % coloration of polygons
        selectedFactor;
        
    end
    
    methods
        function obj = PolygonsManagerData(polygons, nameArray)
        %Constructor for PolygonsManagerData class
        %
        %   polygonArray = PolygonsManagerData(polygonArray, nameArray)
        %   where polygonArray is a PolygonArray and nameArray is a 1-by-N
        %   cell array
            obj.PolygonArray = polygons;
            obj.nameList = nameArray;
        end
        
        function index = getPolygonIndexFromName(obj, name)
            % returns the index of the polygon that corresponds to the name input
            index = find(strcmp(name, obj.nameList));
        end
        
        function polygon = getPolygonFromName(obj, name)
            % returns the polygon that corresponds to the input name
            index = find(strcmp(name, obj.nameList));
            polygon = getPolygon(obj.PolygonArray, index);
        end
        
        function polygons = getPolygonsFromFactor(obj, factor)
            % returns all the polygons assossiated to their level iwt the
            % input factor
            
            % get the names of all the polygons
            names = obj.nameList;
            
            % get all the values input factor's column
            factors = getColumn(obj.factorTable, factor);
            
            % memory allocation
            polygons = cell(length(names), 2);
            h = waitbar(0,'Début de l''affichage...', 'name', 'Affichage des contours');
            for i = 1:length(names)
                polygons{i, 1} = factors(i);
                polygons{i, 2} = getPolygonFromName(obj, names{i});
                
                waitbar(i / length(names), h, ['process : ' names{i}]);
            end
            close(h)
        end
        
        function signature = getSignatureFromName(obj, name)
            % returns the signature that corresponds to the input name
            index = find(strcmp(name, obj.nameList));
            signature = getSignature(obj.PolygonArray, index);
        end
        
        
        function signatures = getSignatureFromFactor(obj, factor)
            % returns all the signatures assossiated to their level iwt the
            % input factor
            
            % get the names of all the signatures
            names = obj.nameList;
            
            % get all the values input factor's column
            factors = getColumn(obj.factorTable, factor);
            
            % memory allocation
            signatures = cell(length(names), 2);
            h = waitbar(0,'Début de l''affichage...', 'name', 'Affichage des contours');
            for i = 1:length(names)
                signatures{i, 1} = factors(i);
                signatures{i, 2} = getSignatureFromName(obj, names{i});
                
                waitbar(i / length(names), h, ['process : ' names{i}]);
            end
            close(h)
        end
        
    end
end