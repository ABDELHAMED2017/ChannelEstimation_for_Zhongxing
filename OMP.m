Noise = 1;  %�Ƿ��������
noise_power = 1;
N = 250;  %���Ӷ���
K = 6;   %ϡ���
%���층��Ҷ�任����
for i = 0 : N-1
    for j = 0 : N-1
        DFT_matrix(i+1, j +1) = exp(-1j * 2 * pi * i * j / N);
    end
end

index = randi([1,25], K, 1);  % ����Ԫ������������
td_channel = zeros(N,1);
td_channel(index) = complex(randn(K,1),randn(K,1));  %����ϡ���ʱ���ŵ�
fd_channel = DFT_matrix *td_channel;
pilot_step = 8;   %ÿ��4��������һ��pilot
pilot_index = 1 : pilot_step : N;
y = fd_channel(pilot_index);  %��Ӧ��ѹ����֪�е�y
if Noise
    y = y + complex(randn(length(y),1),randn(length(y),1)) * sqrt(noise_power);
end
x = td_channel(1:25);  %��Ӧ��ѹ����֪�е�x
phi_matrix = DFT_matrix(pilot_index, 1:25);  %��Ӧ��x,y��phi
%��֤��
sum(y - phi_matrix * x)  
%����ѹ����֪�ع���
rebuild_x = CS_OMP( y,phi_matrix,K);
rebuild_y = phi_matrix * rebuild_x;
diff1 = (rebuild_y - y);
norm(diff1, 'fro')^2
rebuild_fd_channel = DFT_matrix(:, 1:25) * rebuild_x;
diff = (rebuild_fd_channel - fd_channel);
C = norm(diff, 'fro')^2   %���Ƶ����ģ��ƽ����
Ea = C / norm(fd_channel, 'fro')^2
Eb = length(pilot_index)/2500
E = Ea + Eb
