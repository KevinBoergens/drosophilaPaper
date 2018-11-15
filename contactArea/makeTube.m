function zze = makeTube(v1,v2,r1,r2)
N = 6;
t = (0:(N-1))/N*2*pi;

h=norm(v1-v2);

f=@(rx,cx,hx)[0,0,hx;sin(t'+cx)*rx, cos(t'+cx)*rx, zeros(N,1)+hx];

zze.vertices = [f(r1,0,0); f(r2,pi/N,h)];
phi = atan((v2(2)-v1(2))/(v2(1)-v1(1)));
if v2(1)<v1(1)
    phi=phi+pi;
end

rho = atan((v1(3)-v2(3))/norm(v1(1:2)-v2(1:2)))+pi/2;
r = 1: N-1;

zze.faces = [r+1,N+1,    r+N+2,2*N+2 ,       r+1,N+1,        r+N+2,2*N+2  
             r+2, 2,     r+N+3,N+3   ,       r+2,2,          r+N+3,N+3
             ones(1,N),  ones(1,N)+N+1,      r+N+2, 2*N+2,   r+2,2]';
Ry= [cos(rho) 0 -sin(rho)
    0 1 0
    sin(rho) 0 cos(rho)];
Rz = [cos(phi) sin(phi) 0
    -sin(phi) cos(phi) 0
    0, 0, 1];
zze.vertices=zze.vertices*Ry;
zze.vertices = zze.vertices*Rz;
zze.vertices = zze.vertices+repmat(v1,2*N+2,1);