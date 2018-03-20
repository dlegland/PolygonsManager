function pcaInfluence(obj)
%PCAINFLUENCE Creates a new MainFrame and displays influence of each polygon
%
%   Inputs :
%       - obj : handle of the MainFrame
%   Outputs : none

% create a new PolygonsManagerMainFrame
fen = PolygonsManagerMainFrame;

% create the PolygonsManagerData that'll be used as the new
% PolygonsManagerMainFrame's model
model = PolygonsManagerData('PolygonArray', obj.model.PolygonArray, ...
                                'nameList', obj.model.nameList, ...
                             'factorTable', obj.model.factorTable, ...
                                     'pca', obj.model.pca);

% prepare the the new PolygonsManagerMainFrame's name
if isa(obj.model.factorTable, 'Table')
    fenName = ['Polygons Manager | factors : ' obj.model.factorTable.name ' | PCA - Influence'];
else
    fenName = 'Polygons Manager | PCA - Influence';
end

% prepare the new PolygonsManagerMainFrame and display the graph
setupNewFrame(fen, model, fenName, ...
              'pcaInfluence', 'off', ...
              sqrt(sum(obj.model.pca.scores.data .^ 2, 2)), ...
              min(abs(obj.model.pca.scores.data), [], 2));

% annotate graph
xlabel(fen.handles.Panels{1}.uiAxis, 'Distance to origin');
ylabel(fen.handles.Panels{1}.uiAxis, 'Distance to axis');

end