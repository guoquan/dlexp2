clearvars
close all
clc
run('../include.m');

layers.input.layer = getMatInputLayer('data.mat');
layers.input.prec = {};

layers.gt.layer = getMatInputLayer('labels.mat');
layers.gt.prec = {};

layers.cnn.layer = getCNNLayer('num', 32, ...
                            'size', 7, ...
                            'stride', 2, ...
                            'pad',1);
layers.cnn.prec = {'input'};

layers.pool.layer = getPoolingLayer('func', getMeanPool(), ...
                                 'size', 5);
layers.pool.prec = {'cnn'};

layers.fc_1.layer = getFCLayer(1024);
layers.fc_1.prec = {'input'};

layers.fc_1_act.layer = getActLayer(getRelu());
layers.fc_1_act.prec = {'fc_1'};

layers.fc_2.layer = getFCLayer(1024);
layers.fc_2.prec = {'pool', 'fc_1_act'};

layers.fc_2_act.layer = getActLayer(getRelu());
layers.fc_2_act.prec = {'fc_2'};

layers.fc_3.layer = getFCLayer(256);
layers.fc_3.prec = {'fc_2_act'};

layers.fc_3_act.layer = getActLayer(getSigmoid());
layers.fc_3_act.prec = {'fc_3'};

layers.lstm.layer = getLSTMLayer('blocks', 12, ...
                              'cell', 8, ...
                              'gates', [true, true, true], ...
                              'g', getSigmoid(), ...
                              'h', getSigmoid());
layers.lstm.prec = {'fc_3_act'};

layers.fc_output.layer = getFCLayer(10);
layers.fc_output.prec = {'lstm'};

layers.output.layer = getActLayer(getSoftmax());
layers.output.prec = {'fc_output'};

layers.score.layer = getKLScoreLayer();
layers.score.prec = {'output', 'gt'};

network = scaffold(layers, 'J', {'score'});

network.init();

network.train();

network.test();

theta = network.theta();

network.set_theta(theta);

run('../uninclude.m');
