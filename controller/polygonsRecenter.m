function polygonsRecenter(frame)
%POLYGONSRECENTER  Recenter the contour
%
%   Inputs :
%       - obj : handle of the MainFrame
%   Outputs : none

% preallocating memory
polygonList = cell(1, length(frame.model.nameList));

% save the name of the function in the log variable
frame.model.usedProcess{end+1} = 'polygonsRecenter';

for i = 1:length(polygonList)
    % get the name of the contours that will be centered
    name = frame.model.nameList{i};
    
    % get the polygon from its name
    poly = getPolygonFromName(frame.model, name);
    
    % recenter the polygon
    center  = polygonCentroid(poly);
    poly = bsxfun(@minus, poly, center);
    
    % update the polygon
    setPolygon(frame.model.polygonList, i, poly);
    updatePolygonInfos(frame.model, name)
end

% update GUI
refreshDisplay(getActivePanel(frame));
updateMenus(frame);
