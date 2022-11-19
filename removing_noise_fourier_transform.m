% Limpando o programa.
close all
clear all
clc

% Carregando o pacote de imagens.
pkg load image

% Acessando o diretorio das imagens.
cd('./images');

img = imread('ArquivoRuidoso.tif');

% Realizando a transformada discreta de Fourier.
img_fft = fft2(img);

% Obtendo a fase da transformada.
fase = arg(img_fft);

% Fazendo o deslocamento da transformada discreta de Fourier e obtendo a magnitude.
fft_shift = fftshift(img_fft);
magnitude = abs(fft_shift);

% Exibicao 2D.
##figure, plot(magnitude);

% Exibicao 3D.
figure, surf(magnitude);

% Aplicando o filtro na magnitude.
upper_limit = 155;
inferior_limit = 105;

for m = 1:256
  for n = 1:256
    if ((m < inferior_limit || m > upper_limit) || (n < inferior_limit || n > upper_limit))
      filtered(m, n) = 0;
    else
      filtered(m, n) = magnitude(m, n);
    end
  end
end

% Exibicao 2D.
##figure, plot(filtered);

% Exibicao 3D.
figure, surf(filtered);

% Desfazendo o deslocamento.
without_fftshift = ifftshift(filtered);

% Juntando a magnitude com a fase, na forma retangular.
for m = 1:256
  for n = 1:256
    rectangular_form(m, n) = without_fftshift(m,n)*cos(fase(m,n)) + without_fftshift(m,n)*sin(fase(m,n))*i;
  end
end

inverse_fft = ifft2(rectangular_form);

% Exibindo as imagens com e sem ruido no dominio da frequencia.
figure;
subplot(1, 2, 1);
imshow(magnitude, []);
title('Imagem com ru¨ªdo - Dom¨ªnio da frequ¨ºncia');

subplot(1, 2, 2);
imshow(filtered, []);

% Exibindo as imagens com e sem ru¨ªdo juntas.
figure;
subplot(1, 2, 1);
imshow(img);
title('Imagem com ru¨ªdo - Dom¨ªnio da frequ¨ºncia');

subplot(1, 2, 2);
imshow(inverse_fft, []);
title('Imagem com o ru¨ªdo filtrado');

% Exibindo as imagens com e sem ru¨ªdo separadas.
##figure, imshow(img);
##title('Imagem com ru¨ªdo');
##
##figure, imshow(inverse_fft, []);
##title('Imagem com o ru¨ªdo filtrado');

cd('..');
