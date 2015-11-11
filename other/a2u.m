function U = a2u( a )
    U       = zeros(3,size(a,2));
    U(1,:)  =-sin(a(1,:)).*cos(a(2,:));
    U(2,:)  = cos(a(1,:)).*cos(a(2,:));
    U(3,:)  = sin(a(2,:));
end