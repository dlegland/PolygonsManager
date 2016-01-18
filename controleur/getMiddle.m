function pos = getMiddle(obj, height, width)

    pos = get(obj, 'outerposition');
    
    pos(1) = pos(1) + (pos(3)/2) - (height/2);
    pos(2) = pos(2) + (pos(4)/2) - (width/2);
    pos(3) = height;
    pos(4) = width;
    
end