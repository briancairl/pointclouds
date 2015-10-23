function Sub = subset(S,sel)
    Sub.timestamp = S.timestamp;
    Sub.points    = S.points(:,sel);
end