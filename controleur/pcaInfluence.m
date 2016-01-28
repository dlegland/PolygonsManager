function pcaInfluence(obj)

fen = PolygonsManagerMainFrame;
setupNewFrame(fen, obj.model.nameList, obj.model.PolygonArray, ...
                        'factorTable', obj.model.factorTable, ...
                                'pca', obj.model.pca, ...
                   sqrt(sum(obj.model.pca.scores.data .^ 2, 2)), ...
                   min(abs(obj.model.pca.scores.data), [], 2), ...
                   'off');
if isa(obj.model.factorTable, 'Table')
    set(fen.handles.figure, 'name', ['Polygons Manager | factors : ' obj.model.factorTable.name ' | PCA - Influence']);
else
    set(fen.handles.figure, 'name', 'Polygons Manager | PCA - Influence');
end

% annotate graph
xlabel(fen.handles.axes{1}, 'Distance to origin');
ylabel(fen.handles.axes{1}, 'Distance to axis');

end