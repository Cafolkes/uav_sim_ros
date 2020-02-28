function f = matf(in1)
%MATF
%    F = MATF(IN1)

%    This function was generated by the Symbolic Math Toolbox version 8.3.
%    27-Feb-2020 15:18:07

Omega1 = in1(14,:);
Omega2 = in1(15,:);
Omega3 = in1(16,:);
Omega4 = in1(17,:);
q1 = in1(4,:);
q2 = in1(5,:);
q3 = in1(6,:);
q4 = in1(7,:);
v1 = in1(8,:);
v2 = in1(9,:);
v3 = in1(10,:);
w1 = in1(11,:);
w2 = in1(12,:);
w3 = in1(13,:);
t2 = Omega1.^2;
t3 = Omega2.^2;
t4 = Omega3.^2;
t5 = Omega4.^2;
t6 = q1.^2;
t7 = q2.^2;
t8 = q3.^2;
t9 = q4.^2;
t10 = sqrt(2.0);
t11 = t6+t7+t8+t9;
t13 = t2.*9.900990099009901e-6;
t14 = t3.*9.900990099009901e-6;
t15 = t4.*9.900990099009901e-6;
t16 = t5.*9.900990099009901e-6;
t12 = 1.0./t11;
t17 = t13+t14+t15+t16;
f = [v1;v2;v3;q2.*w1.*(-1.0./2.0)-(q3.*w2)./2.0-(q4.*w3)./2.0;(q1.*w1)./2.0+(q3.*w3)./2.0-(q4.*w2)./2.0;(q1.*w2)./2.0-(q2.*w3)./2.0+(q4.*w1)./2.0;(q1.*w3)./2.0+(q2.*w2)./2.0-(q3.*w1)./2.0;t17.*(q1.*q3.*t12.*2.0+q2.*q4.*t12.*2.0);-t17.*(q1.*q2.*t12.*2.0-q3.*q4.*t12.*2.0);t17.*(t6.*t12-t7.*t12-t8.*t12+t9.*t12)-9.806649999999999;t2.*t10.*(-1.351148476204774e-4)-t3.*t10.*1.351148476204774e-4+t4.*t10.*1.351148476204774e-4+t5.*t10.*1.351148476204774e-4-w2.*w3.*6.487764599909924e-1;t2.*t10.*(-1.231611358193637e-4)+t3.*t10.*1.231611358193637e-4+t4.*t10.*1.231611358193637e-4-t5.*t10.*1.231611358193637e-4+w1.*w3.*6.798494697228875e-1;t2.*(-9.674090635480264e-6)+t3.*9.674090635480264e-6-t4.*9.674090635480264e-6+t5.*9.674090635480264e-6-w1.*w2.*5.559377418522657e-2;Omega1.*(-2.642285714285714e+1)-t2.*6.428571428571428e-3;Omega2.*(-2.642285714285714e+1)-t3.*6.428571428571428e-3;Omega3.*(-2.642285714285714e+1)-t4.*6.428571428571428e-3;Omega4.*(-2.642285714285714e+1)-t5.*6.428571428571428e-3];
