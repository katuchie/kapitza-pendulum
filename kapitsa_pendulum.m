clear; clc; close all;

g = 9.81;
l = 1.0;
m = 1.0;
A = 0.05;
omega = 50;

theta0 = pi/6;
theta_dot0 = 0;

tspan = [0 10];
y0 = [theta0; theta_dot0];

kapitsa_ode = @(t, y, omega_val) [y(2); -(g/l)*sin(y(1)) + (A*omega_val^2/l)*cos(omega_val*t)*sin(y(1))];

[t1, y1] = ode45(@(t, y) kapitsa_ode(t, y, 0), tspan, y0);
[t2, y2] = ode45(@(t, y) kapitsa_ode(t, y, omega), tspan, y0);

theta0_top = pi - 0.1;
y0_top = [theta0_top; 0];

[t3, y3] = ode45(@(t, y) kapitsa_ode(t, y, 0), tspan, y0_top);
[t4, y4] = ode45(@(t, y) kapitsa_ode(t, y, omega), tspan, y0_top);

figure('Position', [100, 100, 800, 600]);
plot(t3, y3(:,1)*180/pi, 'b-', 'LineWidth', 2); hold on;
plot(t4, y4(:,1)*180/pi, 'r-', 'LineWidth', 2);
yline(180, 'k--', 'LineWidth', 1.5);
xlabel('Время t [с]');
ylabel('Угол \theta [градусы]');
title('Стабилизация верхнего положения маятника Капицы');
legend('Без вибрации (падает)', 'С вибрацией (стабилизируется)', 'Верхнее положение (180°)');
grid on;

fprintf('Критическая частота: ω_crit = %.2f рад/с\n', sqrt(2*g/(A*l)));
fprintf('Используемая частота: ω = %.2f рад/с\n', omega);
fprintf('Среднее положение с вибрацией: %.2f°\n', mean(y4(end-100:end,1))*180/pi);
fprintf('Среднее положение без вибрации: %.2f°\n', mean(y3(end-100:end,1))*180/pi);
