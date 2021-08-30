function [P_at_1,error_at_1] = produce_unstable_data_from_angle_NLS(angle,extra_dim)

% Input: angle for the eigenvector

% NLS: pt1
load eigenpair_NLS_proof
M = 150; scaling = 20*exp(1i*angle);
% M = 60; scaling = 75*exp(1i*angle);

% NLS: pt2
% load eigenpair_pt2_NLS_proof
% M = 40; scaling = 55*exp(1i*angle);

% CGL: pt1
% load eigenpair_CGL_pi_4_pt1_proof.mat
% load eigenpair_CGL_0_pt1_proof.mat
% m = (length(x)-1)/2; a = x(2:m+1);
% lambda = x(1); b = x(m+2:2*m+1);
% M = 150; scaling = 20*exp(1i*angle); nu = 1;

% CGL: pt2
% load eigenpair_CGL_pi_4_pt2.mat
% load eigenpair_CGL_0_pt2.mat
% m = (length(x)-1)/2; a = x(2:m+1);
% lambda = x(1); b = x(m+2:2*m+1);
% M = 50; scaling = 20*exp(1i*angle);


% m = (length(x)-1)/2; a = x(2:m+1); plot_periodic_complex(a)
% lambda = x(1);
% b = x(m+2:2*m+1);

a = [a;zeros(extra_dim,1)]; b = [b;zeros(extra_dim,1)];
% M = 150; scaling = 20; nu = 1; n_ext = 10;  % gives end_points_proof2_NLS


N = length(a) - 1 ; % Fourier projection

p = zeros(N+1,M+1);

p(:,1) = a; % The fixed point
p(:,2) = scaling*b; % The eigenvector

% % Verify that we have a correct eigenfunction
% b_test = p(:,2);
% ab = quadraticFFT(a,b_test);
% m = length(b_test);
% k = (0:m-1)';
% omega = 2*pi;
% mu = -k.^2*omega^2;
% test_eigs = norm(exp(1i*theta)*(mu.*b_test + 2*ab) - lambda*b_test);
% 
% if test_eigs>1e-8
%     disp('problem with first order data')
%     return
% end

par = zeros(2*N+6,1);

par(1) = N; par(2) = M;
par(3:N+3) = a;
par(N+4) = lambda;
par(N+5:2*N+5) = p(:,2);
par(2*N+6) = theta;

p = reshape(p,(N+1)*(M+1),1);

p = newton(p,par); %p = reshape(p,N+1,M+1);

% plot_manifold(p,M,N)

%%% We impose that the first order data are exact
p = reshape(p,N+1,M+1);
p(:,1) = a;
p(:,2) = scaling*b;

p = reshape(p,(N+1)*(M+1),1);
p = clean_p(p);
[I,success] = rad_poly_1d_unstable_NLS(p,par,r0,nu);
disp(['Success (Manifolds) = ',num2str(success)])

rmin = I(1);
p = reshape(p,N+1,M+1);
P_at_1 = sum(intval(p),2);
error_at_1 = rmin + norma(rad(P_at_1),nu);
%plot_periodic_complex(P_at_1)
%hold on
% P_at_minus_1 = sum(intval(p).*(repmat((-1).^(0:M),N+1,1)),2); 
% error_at_minus_1 = rmin + norma(rad(P_at_minus_1),nu);
%plot_periodic_complex(P_at_minus_1)


% p = reshape(p,N+1,M+1);
% P_at_1 = sum(p,2);
% P_at_minus_1 = sum(p.*(repmat((-1).^(0:M),N+1,1)),2);

end
