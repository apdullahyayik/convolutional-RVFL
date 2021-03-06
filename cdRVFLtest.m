function out=cdRVFLtest(input,net)
% cdRVFLtest: ConvNET Random Vector Functional Link testing function
%
%Output Parameters
%         out: actul output
%
%Input Parameters
%         net: structure that includes network parameters.
%         fcweights, stride, convkernelflipped, poolkernel
%         outputlayerweights, fclayerstructure, numberofconvlayer
%
% Example Usage
% clearvars,
% input=rand(18,50);
% target=[ones(1,6), ones(1,6)*2, ones(1,6)*3]';
% net=cdRVFLtrain(input, target, 5, [8,3]);
% out=cdRVFLtest(input, net) % check target and y values
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %                           TEST                               %
% %           ConvNET Random Vector Functional Link              %
% %                       (Avaraging)                            %
% %                  Apdullah Yayik, 2019                        %
% %                  apdullahyayik@gmail.com                     %
% %                                                              %
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

input=normDadapt(input, net.normparameters.minn, net.normparameters.maxx);
convlayerouts=input;
for p=1:net.numberofconvlayer-1
    convlayerouts=conv2(convlayerouts, net.conv.kernelflipped, 'same'); % convolution
    convlayerouts=trans(batchN(convlayerouts), 'ReLU'); % Batch Normalization & ReLU
    temp = conv2(convlayerouts, net.pool.kernel, 'valid'); % pooling
    convlayerouts = temp(1:net.pool.stride:end, 1:net.pool.stride:end);
end

fclayerouts1=batchN(convlayerouts*net.fcweights{1,1}); % FC, Batch Normalization & ReLU
fclayerouts1=trans(fclayerouts1, 'ReLU'); 
fclayerouts1(:,net.dropoutlayers)=[]; % dropout layer
fclayerouts2=trans(batchN(fclayerouts1*net.fcweights{1,2}), 'ReLU'); % FC, Batch Normalization & softmax
D=[input, fclayerouts1,fclayerouts2];
y=D*net.outputlayerweights;
out=outCreate(y);
end

function out=outCreate(y)
% create output

outtemp=[];
for p=1:size(y,1)
    outtemp=[outtemp; y(p,:)==max(y(p,:))];
end
clear y

out=zeros(size(outtemp,1), 1);
for pp=1:size(outtemp,2)
    out=out+outtemp(:,pp)*pp;
end
end

function X=normDadapt(X, minn, maxx)
% adapt norm

sizeX=size(X);
for ii=1:sizeX(1)
    for j=1:sizeX(2)
        X(ii,j)=(((X(ii,j)-minn(j))/(maxx(j)-minn(j))))*2-1;
    end
end
end

















