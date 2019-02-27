load('data');
%% ����˵��
%fingerprint_sim:   ָ�����ݿ�,20m*15m, 6AP
%RSS_fp:    100��������ݵ�RSS(dB)
%p_true:    100��������ݵ���ʵλ��

%% KNN�㷨
n = 6;%ʹ��AP����Ŀ������ʹ��ȫ��6����<=n_AP��
k = 4;%KNN�㷨�е�K������һ����С����ϵ����
p_KNN = 0;%�涨λ���
for i=1:size(p_true);   %��˳��ֱ��ÿһ�����ݶ�λ
    [size_x, size_y, n_AP] = size(fingerprint_sim);
    %����ŷ�Ͼ���
    distance = 0;
    for j=1:n
        distance = distance + (fingerprint_sim(:,:,j)-RSS_fp(i,j)).^2;%����ͬʱ�������вο��㣬�����һ����ά����
    end
    distance = sqrt(distance);
    %��ŷ�Ͼ�������ѡ��k����С�ģ��õ�λ��
    d = reshape(distance,1,size_x*size_y);
    [whatever, index_d]=sort(d);
    knn_x = (mod(index_d(1:k),size_x));
    knn_y = (floor(index_d(1:k)./size_x)+1);
    p_KNN(i,1:2) = [mean(knn_x), mean(knn_y)];%k��λ����ƽ��
end

%��һ��ͼ����ɫ����b-o����ʵ·���������Ƕ�λ�����λ��
plot(p_true(:,1),p_true(:,2),'b-o');
axis([0 20 0 15])
grid on;hold on;
plot(p_KNN(:,1),p_KNN(:,2),'r*');
for i=1:size(p_KNN)
    hold on;plot([p_KNN(i,1),p_true(i,1)],[p_KNN(i,2),p_true(i,2)],'g--');
end
error_KNN=sqrt((p_true(:,1)-p_KNN(:,1)).^2+(p_true(:,2)-p_KNN(:,2)).^2);
disp('KNNƽ����')
disp(mean(error_KNN));
%%
%KNN�㷨�����ʵ�õķ���
%����k�����Լ���΢��һ��
%������ν��WKNN����k��λ��ƽ����ʱ��ʹ�ü�Ȩƽ����������Ч�����Բ���
%����ŷ�Ͼ��룬����Ҳ�����������ľ��루�����پ��밡ʲô�ģ�
%�����㷨����û��һ���ϸ��֤������ӳ��λ���ȣ����и��ֲ�������������ϸ��Ҳ�����ģ���Ҫ�����о�ָ�Ʒ��Ļ�ȥ�����ʷ����ɡ�
