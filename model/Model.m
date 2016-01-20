classdef Model
    
    properties
        
        PolygonArray;
        factorTable;
        nameList;
        selectedPolygons = {};
        selectedFactors;
        
    end
    
    methods
        function obj = Model(polygons, nameArray)
            obj.PolygonArray = polygons;
            obj.nameList = nameArray;
        end
        
        function index = getPolygonIndexFromName(obj, name)
            index = find(strcmp(name, obj.nameList));
        end
        
        function polygon = getPolygonFromName(obj, name)
            index = find(strcmp(name, obj.nameList));
            polygon = getPolygon(obj.PolygonArray, index);
        end
        
        function polygons = getPolygonsFromFactor(obj, factor)
            names = obj.nameList;
            factors = getColumn(obj.factorTable, factor);
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
            index = find(strcmp(name, obj.nameList));
            signature = getSignature(obj.PolygonArray, index);
        end
        
        
        function signatures = getSignatureFromFactor(obj, factor)
            names = obj.nameList;
            factors = getColumn(obj.factorTable, factor);
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