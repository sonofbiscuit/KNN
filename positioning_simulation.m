load('data');
%% 数据说明
%fingerprint_sim:   指纹数据库,20m*15m, 6AP
%RSS_fp:    100组测试数据的RSS(dB)
%p_true:    100组测试数据的真实位置

%% KNN算法
n = 6;%使用AP的数目，这里使用全部6个（<=n_AP）
k = 4;%KNN算法中的K，随便调一调大小，关系不大
p_KNN = 0;%存定位结果
for i=1:size(p_true);   %按顺序分别给每一个数据定位
    [size_x, size_y, n_AP] = size(fingerprint_sim);
    %计算欧氏距离
    distance = 0;
    for j=1:n
        distance = distance + (fingerprint_sim(:,:,j)-RSS_fp(i,j)).^2;%这里同时计算所有参考点，结果是一个二维矩阵
    end
    distance = sqrt(distance);
    %将欧氏距离排序，选择k个最小的，得到位置
    d = reshape(distance,1,size_x*size_y);
    [whatever, index_d]=sort(d);
    knn_x = (mod(index_d(1:k),size_x));
    knn_y = (floor(index_d(1:k)./size_x)+1);
    p_KNN(i,1:2) = [mean(knn_x), mean(knn_y)];%k个位置求平均
end

%画一下图：蓝色的线b-o是真实路径，红星是定位算出的位置
plot(p_true(:,1),p_true(:,2),'b-o');
axis([0 20 0 15])
grid on;hold on;
plot(p_KNN(:,1),p_KNN(:,2),'r*');
for i=1:size(p_KNN)
    hold on;plot([p_KNN(i,1),p_true(i,1)],[p_KNN(i,2),p_true(i,2)],'g--');
end
error_KNN=sqrt((p_true(:,1)-p_KNN(:,1)).^2+(p_true(:,2)-p_KNN(:,2)).^2);
disp('KNN平均误差：')
disp(mean(error_KNN));
%%
%KNN算法是最简单实用的方法
%参数k可以自己稍微调一调
%另外所谓的WKNN（求k个位置平均的时候使用加权平均），改善效果忽略不计
%除了欧氏距离，我们也可以用其他的距离（曼哈顿距离啊什么的）
%这种算法本身没有一个严格的证明来反映定位精度，所有各种参数随便调，各种细节也能随便改，相要深入研究指纹法的话去看概率方法吧。
