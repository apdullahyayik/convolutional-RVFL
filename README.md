# Convolutional Random Vector Functional Link Network+

## Architecture

<img width="500" src="https://github.com/apdullahyayik/convolutional-RVFL/blob/master/conv%2B.png">

The framework of the proposed convolutional RVFL network consists of several convolutional layers stacked on top of each other whose parameters are randomly generated and kept fixed during the training. Following a fully-connected layer linked with a direct output layer with a dropout probability of 0.5 whose parameters are randomly generated and kept fixed during the training. In the end, another fully-connected layer with RELU transfer function whose parameters are analytically computed via pseudoinverse learning. The output layer is fed with original input data and output of designed fully-connected layers.
