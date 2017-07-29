function V3=rvr_compute_v3(V1,V2,intParam)
K=intParam.K;

w=inv((K*transpose(K)));

r=transpose(V2)*w;

syms x y
S = solve(r(1)*x + r(2)*y + r(3) == 0, ...
    x*(w(1,1)*V1(1)+w(1,2)*V1(2)+w(1,3)) +...
    y*(w(2,1)*V1(1)+w(2,2)*V1(2)+w(2,3))+...
    w(3,1)*V1(1) +w(3,2)*V1(2) + w(3,3)== 0);
S = [S.x S.y];

V3=[double(S(1));double(S(2));1];
