classdef Model
    
    properties
        
        PolygonArray;
        factorTable;
        nameList;
        selectedPolygons = {};
        
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
        
%         function polygons = getPolygonsByFactor(obj, factor, value)
%             polygons = {};
%             x = getColumn(obj.factorTable, factor);
%             levels = obj.factorTable.levels{x};
%             for i = 1:length(obj.factorTable)
%                 if levels{x(i)} == value
%                     polygons{end+1} = getPolygonFromName(obj, obj.factorTable.rowNames{i});
%                 end
%             end 
%         end
        
        function polygons = getPolygonsFromFactors(obj, factor)
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
    end
end