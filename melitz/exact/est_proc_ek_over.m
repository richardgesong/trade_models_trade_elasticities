%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Step 1 Compute Data moments of interest. 
% Here we will just compute the data moments for you as there are issues
% regarding the sharing of the data set.

clear
load('../../data/estimation_mat_30.mat')
% load estimation_KF
straps = 500;

[mme]=thetaest_est_exact(pmat_30,tradeshare,istraded);
load('../../data/trade_grav_est_30.mat')
obs_char(pmat_30,tradeshare,grav_distance,b,istraded);

sample = sum(istraded);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is the main routine that searches for the theta that mathches the
% observed moments to the moments implied by the model. See est_fun_exact
% for the details.

% matlabpool 12

options = optimset('TolFun',10^-5,'TolX',10^-3,'Display','iter');

mone = mme(:,1);
mtwo = mme(:,2:end);% define parameter first
boot = 150;

nruns = 12;
nsubs = 200;

tic
[theta_ek, fval_ek] = fminbnd(@(x) est_fun_over(x,mtwo,sample,nruns,nsubs,boot,1),log(3),log(7),options);
toc

theta = exp(theta_ek);
Jstat = length(mone).*fval_ek;

disp('Estimate of Theta')
disp(theta)
disp('J-statistic')
disp(Jstat)

save ek_results theta Jstat sample

standard_error


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
