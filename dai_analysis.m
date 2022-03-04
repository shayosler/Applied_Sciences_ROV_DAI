%% 
clc
clear
close all

%% Load
log = '20220128002145_10x_psi_step_30';
load(['scripts/' log '/' log '_ADAPTIVE_CTRL_STAT.mat']);

%% Analyze
t = UNIX_timestamp - UNIX_timestamp(1);
t_start = 0;
t_end = 26;
to_use = t > t_start & t < t_end;
t = t(to_use);
psi = polar_correct(PSI(to_use), -180, 180);
psi_dot = PSI_DOT(to_use);
psi_trajectory = polar_correct(PSI_TRAJ(to_use), -180, 180);
setpoint = polar_correct(UC(to_use), -180, 180);

%% stats for first/last steps
first_start = 1.25;
first_end = 6;
first_step = t > first_start & t < first_end;
first_step_info = stepinfo(psi(first_step), t(first_step) - first_start, 'RiseTimeLimits', [0, .999], 'SettlingTimeThreshold', .001)
first_traj = psi_trajectory(first_step);
first_traj(1) = 0;
first_psi = psi(first_step);
first_error = first_traj - first_psi;
first_rms_error = sqrt(mean(first_error .^2))
first_max_error = max(abs(first_error))

last_start = 21.8;
last_end = 26;
last_step = t > last_start & t < last_end;
last_step_info = stepinfo(psi(last_step), t(last_step) - last_start, 'RiseTimeLimits', [0, .999], 'SettlingTimeThreshold', .001)
last_traj = psi_trajectory(last_step);
last_psi = psi(last_step);
last_error = last_traj - last_psi;
last_rms_error = sqrt(mean(last_error .^2))
last_max_error = max(abs(last_error))
%% Plots
label_fontsize = 24;
axis_fontsize = 18;
linewidth = 1.25;
ax = [t_start t_end 0 31];

% Plot step response
figure
subplot(2, 1, 1)
plot(t, psi, 'blue', 'linewidth', 2)
title 'Yaw Step Response'
ylabel('$\psi$ (deg)', 'Interpreter', 'Latex', 'FontSize', axis_fontsize)
xlabel('Time (sec)')
hold on
plot(t, setpoint, 'red', 'linewidth', 2)
plot(t, psi_trajectory, '--c', 'linewidth', 2)
legend({'$\psi$', 'Setpoint', 'Trajectory'}, 'Interpreter', 'latex', 'FontSize', 22);
set(gca,'FontSize', axis_fontsize)
axis(ax);

% Plot error
subplot(2, 1, 2)
plot(t, psi_trajectory - psi,  'blue', 'linewidth', 2);
title 'Yaw Error'
ylabel('$\psi$ Error (deg)', 'Interpreter', 'Latex');
xlabel 'Time (sec)'
set(gca,'FontSize', axis_fontsize)
axis([t_start t_end -0.1 0.15])

figure
plot(psi, psi_dot)
axis equal
%axis square