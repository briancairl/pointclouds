function a  = u2a( U )
    a       = zeros(2,size(U,2));
    a(2,:)  = asin( U(3,:) );
    a(1,:)  =-atan2( U(1,:), U(2,:) );
    a(:)    = real(a(:));
end

