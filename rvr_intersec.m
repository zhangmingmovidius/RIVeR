function [X]=intersec(eq_1,eq_2);
% [x y]=intersec(eq_1,eq_2);
%calcula el punto de interseción de la dos lineas
%eq_1: parametros de la equación de la linea 1
%eq_2: parametros de la equación de la linea 2
x=(eq_2(2)-eq_1(2))/(eq_1(1)-eq_2(1));
y=eq_1(1)*x+eq_1(2);
X=[x y];

