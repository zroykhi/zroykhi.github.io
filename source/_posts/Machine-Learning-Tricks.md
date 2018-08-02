---
title: Machine Learning Notes
date: 2018-06-05 11:54:50
tags:
- machine learning
categories:
- 阅读笔记
---
> Preface: Some note collections about machine learning
### Is it possible to specify different batch sizes for train and validation?
for train data, there are reasons to keep batches relatively small (batch size can effect training results), however for the validation set, using a single reasonably big batch

### Why mini batch size is better than one single “batch” with all training data?
[Answer1](http://hp.stuhome.net/index.php/2016/09/20/tensorflow_batch_minibatch/):
> 深度学习的优化算法，说白了就是梯度下降。每次的参数更新有两种方式。
>
> 第一种，遍历全部数据集算一次损失函数，然后算函数对各个参数的梯度，更新梯度。这种方法每更新一次参数都要把数据集里的所有样本都看一遍，计算量开销大，计算速度慢，不支持在线学习，这称为Batch gradient descent，批梯度下降。
>
> 另一种，每看一个数据就算一下损失函数，然后求梯度更新参数，这个称为随机梯度下降，stochastic gradient descent。这个方法速度比较快，但是收敛性能不太好，可能在最优点附近晃来晃去，hit不到最优点。两次参数的更新也有可能互相抵消掉，造成目标函数震荡的比较剧烈。
>
> 为了克服两种方法的缺点，现在一般采用的是一种折中手段，mini-batch gradient decent，小批的梯度下降，这种方法把数据分为若干个批，按批来更新参数，这样，一个批中的一组数据共同决定了本次梯度的方向，下降起来就不容易跑偏，减少了随机性。另一方面因为批的样本数与整个数据集相比小了很多，计算量也不是很大。

[Answer2](https://datascience.stackexchange.com/questions/16807/why-mini-batch-size-is-better-than-one-single-batch-with-all-training-data):
>The key advantage of using minibatch as opposed to the full dataset goes back to the fundamental idea of stochastic gradient descent1.
>
>In batch gradient descent, you compute the gradient over the entire dataset, averaging over potentially a vast amount of information. It takes lots of memory to do that. But the real handicap is the batch gradient trajectory land you in a bad spot (saddle point).
>
>In pure SGD, on the other hand, you update your parameters by adding (minus sign) the gradient computed on a single instance of the dataset. Since it's based on one random data point, it's very noisy and may go off in a direction far from the batch gradient. However, the noisiness is exactly what you want in non-convex optimization, because it helps you escape from saddle points or local minima(Theorem 6 in [2]). The disadvantage is it's terribly inefficient and you need to loop over the entire dataset many times to find a good solution.
>
>The minibatch methodology is a compromise that injects enough noise to each gradient update, while achieving a relative speedy convergence.
>
>1 Bottou, L. (2010). Large-scale machine learning with stochastic gradient descent. In Proceedings of COMPSTAT'2010 (pp. 177-186). Physica-Verlag HD.
>
>[2] Ge, R., Huang, F., Jin, C., & Yuan, Y. (2015, June). Escaping From Saddle Points-Online Stochastic Gradient for Tensor Decomposition. In COLT (pp. 797-842).

### Train loss 为 nan　的可能原因
 + learning rate太大，导致loss无法converge而趋近无穷
 + 检查计算过程是否有除以0的情况
 + input data含有nan情况，使用 assert not np.any(np.isnan(x))确保不含有nan情况，同时也保证output data全为有效数据

### 神经网络的预测值为常数，不符合实际情况
 + 神经元麻木，检查是否是因为没有batch normalization

### RNN神经网络添加batch normalization?

### 防止过拟合
 + 修改合适的weight_decay
 + 减小学习速度
 + 增加数据
