function view_ndt(ndt)
    scatter3(ndt(1,:),ndt(2,:),ndt(3,:),(ndt(4,:)+eps)*100,ndt(5,:));
end