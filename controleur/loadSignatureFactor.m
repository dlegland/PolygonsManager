function loadSignatureFactor(obj)
%LOADSIGNATUREFACTOR  Prepare the datas to display the signatures colored by factors
%
%   Inputs :
%       - obj : handle of the MainFrame
%   Outputs : none


polygonList = getSignatureFromFactor(obj.model, obj.handles.axes{1}.UserData{1});

set(obj.handles.axes{2}, 'userdata', obj.handles.axes{1}.UserData);

displayPolarSignatureFactor(obj, polygonList);
end