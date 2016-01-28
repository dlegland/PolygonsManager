function pcaInfluence(obj)

fen = PolygonsManagerMainFrame;

% set the new polygon array as the current polygon array
model = PolygonsManagerData('PolygonArray', obj.model.PolygonArray, ...
                                'nameList', obj.model.nameList, ...
                             'factorTable', obj.model.factorTable, ...
                                     'pca', obj.model.pca);

setupNewFrame(fen, model, ...
              sqrt(sum(obj.model.pca.scores.data .^ 2, 2)), ...
              min(abs(obj.model.pca.scores.data), [], 2), ...
              'off', 'pcaInfluence');
          
if isa(obj.model.factorTable, 'Table')
    set(fen.handles.figure, 'name', ['Polygons Manager | factors : ' obj.model.factorTable.name ' | PCA - Influence']);
else
    set(fen.handles.figure, 'name', 'Polygons Manager | PCA - Influence');
end
    
% annotate graph
xlabel(fen.handles.Panels{1}.uiAxis, 'Distance to origin');
ylabel(fen.handles.Panels{1}.uiAxis, 'Distance to axis');

end