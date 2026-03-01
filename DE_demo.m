clear all;clc;close all;warning off;
Pathr = '.\data\';
Pathw = '.\results\';
if ~exist(Pathw,'dir');mkdir(Pathw);end
Files = dir(strcat(Pathr,'*.png')); 
LengthFiles = length(Files);
factor = 4;

%================= 预分配保存每张图的 PSNR / SSIM =================%
psnr_all = zeros(LengthFiles,1);
ssim_all = zeros(LengthFiles,1);
%==================================================================%

for ii = 1:LengthFiles
    tic
    disp(ii);
    disp(strcat('Now is processing the image named:',Files(ii).name));
    image=double(imread(strcat(Pathr,Files(ii).name)));
    outimg1=image(:,:,1);
    outimg2=image(:,:,2);
    outimg3=image(:,:,3);
    
    %% using Metropolis theorem to get H1
    H1_outimg1=ARDE_main(outimg1);             
    H1_outimg2=ARDE_main(outimg2); 
    H1_outimg3=ARDE_main(outimg3);
    
    %% get details
    Details=zeros(size(image,1),size(image,2),3);
    Details(:,:,1)=imresize(H1_outimg1,[size(image,1),size(image,2)],'bilinear');
    Details(:,:,2)=imresize(H1_outimg2,[size(image,1),size(image,2)],'bilinear');
    Details(:,:,3)=imresize(H1_outimg3,[size(image,1),size(image,2)],'bilinear');
    
    %% add details to the original images
    outimg1=outimg1+Details(:,:,1)*factor;
    outimg2=outimg2+Details(:,:,2)*factor;
    outimg3=outimg3+Details(:,:,3)*factor;
    outimg(:,:,1)=outimg1;
    outimg(:,:,2)=outimg2;
    outimg(:,:,3)=outimg3;
    imwrite(uint8(outimg),strcat('./results/',Files(ii).name(1:end-4),'_X4_ARDE.png'));
    disp(strcat(Files(ii).name,' is finished!!'));

    %================= 计算并保存该图像的 PSNR / SSIM =====================%
    orig_uint8 = uint8(image);
    enh_uint8  = uint8(outimg);
    orig_ycrcb = rgb2ycbcr(orig_uint8);
    enh_ycrcb  = rgb2ycbcr(enh_uint8);
    orig_y = im2double(orig_ycrcb(:,:,1));
    enh_y  = im2double(enh_ycrcb(:,:,1));
    psnr_val = psnr(enh_y, orig_y);
    ssim_val = ssim(enh_y, orig_y);
    fprintf('PSNR (Y channel): %.4f dB  |  SSIM (Y channel): %.4f\n', psnr_val, ssim_val);
    psnr_all(ii) = psnr_val;
    ssim_all(ii) = ssim_val;
    %=====================================================================%

    toc
    clear outimg;
end

%================= 循环后输出平均值 =============================%
mean_psnr = mean(psnr_all);
mean_ssim = mean(ssim_all);
fprintf('=================================================\n');
fprintf('Total images: %d\n', LengthFiles);
fprintf('Average PSNR (Y channel): %.4f dB\n', mean_psnr);
fprintf('Average SSIM (Y channel): %.4f\n', mean_ssim);
fprintf('=================================================\n');

%================= 保存 CSV 文件 ===========================%
csv_name = './results/psnr_ssim.csv';
fid = fopen(csv_name,'w');
fprintf(fid,'ImageName,PSNR_Y,SSIM_Y\n');
for k=1:LengthFiles
    fprintf(fid,'%s,%.4f,%.6f\n',Files(k).name,psnr_all(k),ssim_all(k));
end
fprintf(fid,'AVERAGE,%.4f,%.6f\n',mean_psnr,mean_ssim);
fclose(fid);
fprintf('Metrics CSV saved: %s\n', csv_name);
%================================================================%