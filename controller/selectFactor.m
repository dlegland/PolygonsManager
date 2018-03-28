function selectFactor(obj, varargin)
%SELECTFACTOR  Prepare the datas to display the axes' lines colored by factors
%
%   Inputs :
%       - obj : handle of the MainFrame
%   Outputs : none

% select the factor that will determine the coloration and if the legend of
% the axis must be displayed
    
if ~strcmp(varargin{1}, 'none')
    % get the levels of the selected factor
    x = columnIndex(obj.model.factors, varargin{1});
    levels = obj.model.factors.levels{x};
else
    levels = 0;
end

% save the selected factor, it's levels, and the legend display option
obj.model.selectedFactor = {varargin{1} levels varargin{2} varargin{4} varargin{5}, varargin{6}};

panel1 = obj.handles.Panels{1};

if isempty(panel1.type) || ismember(panel1.type, {'polygons', 'signatures'})
    % display the colored polygons
    displayPolygonsFactor(panel1, getPolygonsFromFactor(obj.model, varargin{1}));
    if isa(obj.model.PolygonArray, 'PolarSignatureArray')
        % if the polygon array is a signature array, also display the
        % colored polar signatures
        displayPolarSignatureFactor(obj.handles.Panels{2}, getSignatureFromFactor(obj.model, varargin{1}));
    end
    
else
    % Display PCA results by factor
    
    if ~strcmp(varargin{1}, 'none')
        if ~strcmp(obj.handles.Panels{1}.type, 'pcaInfluence')
            ud = obj.handles.Panels{1}.uiAxis.UserData;
            displayPcaFactor(obj.handles.Panels{1}, getPcaFromFactor(obj.model, varargin{1}, obj.handles.Panels{1}.type, ud{1}, ud{2}), varargin{3});
        else
            displayPcaFactor(obj.handles.Panels{1}, getPcaFromFactor(obj.model, varargin{1}, obj.handles.Panels{1}.type), varargin{3});
        end
    else
        if ~strcmp(obj.handles.Panels{1}.type, 'pcaInfluence')
            ud = obj.handles.Panels{1}.uiAxis.UserData;
            displayPcaFactor(obj.handles.Panels{1}, getPcaFromFactor(obj.model, varargin{3}, obj.handles.Panels{1}.type, ud{1}, ud{2}), varargin{3});
        else
            displayPcaFactor(obj.handles.Panels{1}, getPcaFromFactor(obj.model, varargin{3}, obj.handles.Panels{1}.type), varargin{3});
        end
    end
end
