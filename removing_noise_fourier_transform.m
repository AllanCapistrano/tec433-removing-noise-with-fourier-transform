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
magnitude = abs(img_fft);

% Exibicao 2D.
##figure, plot(magnitude);

% Exibicao 3D.
figure, surf(magnitude);

% Aplicando o filtro na magnitude.
limit = 105;

for u = 1:256
  for v = 1:256
    c = sqrt(u^2 + v^2);

    if (c > limit)
      filtered(u, v) = 0;
    else
      filtered(u, v) = magnitude(u, v);
    end
  end
end

matrix_final = filtered;

% Espelhando 2 quadrante
for u = 1:256
  for v = 1:256
    if (filtered(u, v) == 0)
      matrix_final(u, v) = filtered(u, 1 + columns(filtered) - v);
    end
  end
end

% Espelhando 3 e 4 quadrante
for u = 1:256
  for v = 1:256
    if (matrix_final(u, v) == 0)
      matrix_final(u, v) = matrix_final(1 + columns(filtered) - u, v);
    end
  end
end

figure, imshow(log(matrix_final), [])

% Exibicao 2D.
figure, plot(filtered);

% Exibicao 3D.
figure, surf(filtered);

% Juntando a magnitude com a fase, na forma retangular.
for m = 1:256
  for n = 1:256
    rectangular_form(m, n) = matrix_final(m,n)*cos(fase(m,n)) + matrix_final(m,n)*sin(fase(m,n))*i;
  end
end

inverse_fft = ifft2(rectangular_form);

% Exibindo as imagens com e sem ruido no dominio da frequencia.
figure;
subplot(2, 2, 1);
imshow(log(magnitude), []);
title('Imagem com ruido- Dominio da frequencia');

subplot(2, 2, 2);
imshow(fftshift(matrix_final), []);
title('Imagem com ruido- Dominio da frequencia');

subplot(2, 2, 3);
imshow(log(fftshift(magnitude)), []);

subplot(2, 2, 4);
imshow(log(fftshift(matrix_final)), []);

% Exibindo as imagens com e sem ruido juntas.
figure;
subplot(1, 2, 1);
imshow(img);
title('Imagem com ruiddo Dominio da frequencia');

subplot(1, 2, 2);
imshow(inverse_fft, []);
title('Imagem com o ruido filtrado');

% Exibindo as imagens com e sem ruido separadas.
##figure, imshow(img);
##title('Imagem com ruido);
##
##figure, imshow(inverse_fft, []);
##title('Imagem com o ruido filtrado');

cd('..');