%% Compute gradients of dynamics
addpath('dynamics')
generateMatlabFunctions()

%% Compute backup controller and gradients
generateBackup()
%% codegen dynamics
cfg = coder.config('lib');
cfg.GenCodeOnly = true;
cfg.TargetLang = 'C++';

codegen -config cfg UAVDynamics -args {zeros(17,1,'double'),zeros(4,1,'double')}
codegen -config cfg UAVDynamicsWithGrad -args {zeros(17,1,'double'),zeros(4,1,'double')}
codegen -config cfg UAVDynamicsGradient -args {zeros(17,1,'double')}

%% codegen backup
cfg = coder.config('lib');
cfg.GenCodeOnly = true;
cfg.TargetLang = 'C++';

codegen -config cfg BackupController -args {zeros(17,1,'double'),zeros(6,1,'double')}
%%
function generateMatlabFunctions()
clear all;
con = quad1_constants();

x = sym('x',[3,1],'real');
v = sym('v',[3,1],'real');
q = sym('q',[4,1],'real');
w = sym('w',[3,1],'real');
Omega = sym('Omega',[4,1],'real');
V=sym('V',[4,1],'real');
d = 0;
[dr, ddr, dxi_q, dw, dOmega] = full_eul(x,v,q,w,Omega,V*14.8,d,con.m,con.g,con.J_bod,con.D,con.J_rot, con.J_prop, con.K_v, con.R, con.k_f, con.k_t,true);
X = [x;q;v;w;Omega];
Xdot = [dr;dxi_q;ddr;dw;dOmega];
f = Xdot - jacobian(Xdot,V)*V;
g = jacobian(Xdot,V);
matlabFunction(f,'Vars',{X},'File','matf');
matlabFunction(g,'Vars',{X},'File','matg');
DFcl = jacobian(Xdot,X);
DF = jacobian(f,X);
DG = sym('DG', [length(X),length(V),length(X)],'real');

for i = 1:length(V)
    DG(:,i,:) = jacobian(g(:,i),X);
end
matlabFunction(DFcl,'Vars',{X,V},'File','matDFcl');
matlabFunction(DF,'Vars',{X},'File','matDF');
matlabFunction(DG,'Vars',{X},'File','matDG');
end

function generateBackup()
% define states
x = sym('x',[3,1],'real');
v = sym('v',[3,1],'real');
q = sym('q',[4,1],'real');
w = sym('w',[3,1],'real');
Omega = sym('Omega',[4,1],'real');
X = [x;q;v;w;Omega];
KpVxy = sym('KpVxy',[1,1],'real');
KpVz = sym('KpVz',[1,1],'real');
KpAtt = sym('KpAtt',[1,1],'real');
KdAtt = sym('KdAtt',[1,1],'real');
KpOmegaz = sym('KpOmegaz',[1,1],'real');
hoverT = sym('hoverT',[1,1],'real');
M = [KpVxy;KpVz;KpAtt;KdAtt;KpOmegaz;hoverT];

rotm(1,1) = 1-2*q(3)*q(3)-2*q(4)*q(4);
rotm(1,2) = 2*q(2)*q(3)-2*q(4)*q(1);
rotm(1,3) = 2*q(2)*q(4)+2*q(3)*q(1);
rotm(2,1) = 2*q(2)*q(3)+2*q(4)*q(1);
rotm(2,2) = 1-2*q(2)*q(2)-2*q(4)*q(4);
rotm(2,3) = 2*q(3)*q(4)-2*q(2)*q(1);
rotm(3,1) = 2*q(2)*q(4)-2*q(3)*q(1);
rotm(3,2) = 2*q(3)*q(4)+2*q(2)*q(1);
rotm(3,3) = 1-2*q(2)*q(2)-2*q(3)*q(3);

zBodyInWorld = rotm*[0;0;1];

% velocity
eul_tmp = 2.0 * (q(3) * q(3));
eulx = atan2(2*q(1)*q(2)+2*q(3)*q(4),(1-2*(q(2)*q(2))-eul_tmp));
euly = asin(2*(q(1)*q(3)-q(4)*q(2)));
eulz = atan2(2.0 * q(1) * q(4) + 2.0 * q(2) * q(3), (1.0 - eul_tmp) - 2.0 * (q(4) * q(4)));
vWorldNoYaw = [cos(eulz) -sin(eulz) 0; sin(eulz) cos(eulz) 0; 0 0 1]*v;

vDes = [0;0;0;0];
vxError = KpVxy*(vDes(1)-vWorldNoYaw(1));
vyError = KpVxy*(vDes(2)-vWorldNoYaw(2));
vzError = vDes(3)-vWorldNoYaw(3);

rollError = -vyError-eulx;
pitchError = vxError-euly;
rollErrorDot = -w(1);
pitchErrorDot = -w(2);
yawErrorDot = -w(3);

uz = KpVz*vzError+hoverT/zBodyInWorld(3);
uroll = KpAtt*rollError+KdAtt*rollErrorDot;
upitch = KpAtt*pitchError+KdAtt*pitchErrorDot;
uyaw = KpOmegaz*yawErrorDot;

U(1) = uz-uroll-upitch-uyaw;
U(2) = uz-uroll+upitch+uyaw;
U(3) = uz+uroll+upitch-uyaw;
U(4) = uz+uroll-upitch+uyaw;
U = transpose(U);
DU = jacobian(U,X);
matlabFunction(U,'Vars',{X,M},'File','backupU');
matlabFunction(DU,'Vars',{X,M},'File','backupDU');
end