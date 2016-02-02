function [poly, values] = pcaVector(obj)

index = 1;

coef = 1;

% compute eigen vector with appropriate coeff
ld = obj.model.pca.loadings(:, index).data';
lambda = obj.model.pca.eigenValues(index, 1).data;
values = obj.model.pca.means + coef * sqrt(lambda) * ld;

% resulting polygon
if strcmp(class(obj.model.PolygonArray), 'PolarSignatureArray')
    poly = signatureToPolygon(values, obj.model.PolygonArray.angleList);
else
    poly = rowToPolygon(values, 'packed');
end
end