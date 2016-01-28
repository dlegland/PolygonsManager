function displayPca(obj, axis, x, y)

delete([obj.handles.legends{:}]);

hold on;
for i = 1:length(x)
    plot(x(i), y(i), '.k', ...
           'parent', axis, ...
    'ButtonDownFcn', {@detectLineClick, obj}, ...
              'tag', obj.model.nameList{i});
end
hold off;

end