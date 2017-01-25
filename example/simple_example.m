clearvars
close all
clc
%run('include.m');
run('../include.m');

[X, Y] = meshgrid(-2:.1:2);
R = X.^2 + Y.^2;
%R = sin(X) + sin(Y);
%R = X + Y;
%R = (R - min(R(:))) ./ (max(R(:)) - min(R(:)));

samp = randi(numel(X), 1, 300);

layers.input.layer = getMemoryInputLayer([X(samp); Y(samp)]);

layers.gt.layer = getMemoryInputLayer(R(samp));

layers.fc.layer = getFCLayer(2, 30);
layers.fc.prec = {'input'};

layers.fc_act.layer = getActLayer(getRelu());
layers.fc_act.prec = {'fc'};

layers.output.layer = getFCLayer(30, 1);
layers.output.prec = {'fc_act'};

%layers.output_act.layer = getActLayer(getRelu());
%layers.output_act.prec = {'output'};

layers.score.layer = getEuclideanScoreLayer();
layers.score.prec = {'output', 'gt'};

network = scaffold(layers, 'maxIter', 3000, 'alpha', 0.1);

network.init();
tic
network.train();
toc
network.test();

theta = network.theta();

layers.input.layer = getMemoryInputLayer([X(:)'; Y(:)']);
layers = rmfield(layers, 'gt');
layers = rmfield(layers, 'score');
network2 = scaffold(layers);
network2.set_theta(theta);
R2 = network2.forward();
R2 = R2.output;

subplot(1,2,1);
mesh(X, Y, R);
hold on;
plot3(X(samp), Y(samp), R(samp), '.');
plot3(X(samp), Y(samp), R2(samp), 'r.');

subplot(1,2,2);
mesh(X, Y, reshape(R2, size(R)));
hold on;
plot3(X(samp), Y(samp), R(samp), '.');
plot3(X(samp), Y(samp), R2(samp), 'r.');

%run('../uninclude.m');
