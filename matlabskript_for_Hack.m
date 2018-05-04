
% matlabskript_for_Hack

%% Def
schwarz_max = 160;
min_Pixels = 200;
max_Pixels = 6000;

%% Hole Daten:
% Get Pfad
[dateiname, pfad] = uigetfile('*.jpeg', 'Imaginaerteil (Q) auswaehlen', 'C:\Users\Manu\Documents\Hackathon_TestPisc\');
% Get Data
new_img = imread(strcat(pfad, dateiname));

%% finde Teile
greyimg = rgb2gray(new_img);
[howmuch, sizesofTeile, where, Matrix_detekt] = FindWhites(greyimg, schwarz_max, min_Pixels, max_Pixels);

%% Mittelwert, Varianz
[Mittelwert, Varianz] = Mittelwert_Varianz(sizesofTeile);


%% Plot Datas
% urspruengliches Bild
image(new_img);

% RGB 3D Bilder
for col = 1:1:3
    Img3D(new_img,col)
end

% 3D graues Bild
I_grey=rgb2gray(new_img);
I_grey_1 = I_grey;
I_grey_1(:,:,2)=I_grey;
I_grey_1(:,:,3)=I_grey;
Img3D(I_grey_1,1)

% detektierte Flaechen
I_grey = Matrix_detekt*255;
I_grey_1 = I_grey;
I_grey_1(:,:,2)=I_grey;
I_grey_1(:,:,3)=I_grey;
figure
image(I_grey_1)

% groesse der einzelnen Flaechen
figure
plot(sizesofTeile)
figure
histogram(sizesofTeile)

%% ============== foos ===========================================

%% Mittelwert_Varianz
function [Mittelwert, Varianz] = Mittelwert_Varianz(Data)

sum1=0;
for i=1:length(Data)
  sum1=sum1+Data(i);
end
Mittelwert=sum1/length(Data); %the mean
sum2=0;
for i=1:length(Data)
    sum2=sum2+ (Data(i)-Mittelwert)^2;
end
Varianz=sum2/length(Data); %Varaince

end

%% FindWhites

function [howmuch, sizesofTeile, where, Matrix_detekt_real] = FindWhites(greyimg,schwarz_max, min_Pixels, max_Pixels)
%Nur schwarz-weiss Bild
% findet Flecken die weiser sind, als schwarz_max
% --howmuch-- gibt die Anzahl der Flecken an
% --sizes-- ist ein Array der Groesse howmuch und gibt die PixelAnzahl der
% jeweiligen Flecken an.
% --where-- ist ein Array der Groesse howmuch und gibt an, wo der
% Mittelpunkt der jeweiligen Flecken liegt

%% Defs und Inits:
[y_max, x_max] = size(greyimg);
Matrix_detekt = zeros(y_max, x_max);
Matrix_detekt_real = zeros(y_max, x_max);

howmuch = 0;
sizesofTeile = [];
where = [];

Pixel_done = [];    % Pixel, die schon in registrierten Teilen enthalten sind

% Def, ob es ein Teil ist:
if(0>min_Pixels)
    min_Pixels = 0;
end
if(y_max*x_max<max_Pixels)
    max_Pixels = y_max*x_max;
end
if(max_Pixels<min_Pixels)
    max_Pixels = min_Pixels;
end

%% Search:
y_search = 0;
while (y_search < y_max)
    y_search = y_search + 1;
    %% Test
    if(0 == mod(y_search,20))
        y_search
    end
    %% 
    x_search = 0;
    while(x_search < x_max)
        x_search = x_search + 1;
        
        %% Test Pixel:
        Test_Pix = greyimg(y_search,x_search);
        
        %% Teil ist detektiert
        if(Test_Pix > schwarz_max)
            % Teil ist detektiert
            
            %% TODO ist dieses Pix schon ein Teil eines Teils?
            % in --Pixel_done-- enthalten?
            % Dann ist an dieser Stelle in --Matrix_detekt-- eine 1
            Teil_wurde_schon_detektiert = Matrix_detekt(y_search,x_search);
            
            %% gesamtes Teil wird gesucht
            if(0 == Teil_wurde_schon_detektiert)
                % Suche gesamtes Teil
                [this_Pixels, this_size, this_where, this_Matrix_detekt] = FindGesamtesTeil(y_search, x_search, greyimg, schwarz_max);
                % res: Bsp:
%                 this_Pixels = [y1 x1; y2 x2];
%                 this_size = pixs;
%                 this_where = [y x];
                
                %% verarbeite die Pixel
                Pixel_done = [Pixel_done; this_Pixels];
                Matrix_detekt = Matrix_detekt + this_Matrix_detekt;
                
                % Falls es wirklich ein Teil ist:
                % (nicht zu klein oder zu gross) Kann auch noch ausgebaut
                % werden
                if((min_Pixels <= this_size) && (max_Pixels >= this_size))
                    howmuch = howmuch + 1;
                    sizesofTeile(howmuch)= this_size;
                    where(howmuch,:)= this_where;
                    Matrix_detekt_real = Matrix_detekt_real + this_Matrix_detekt;
                end
                
            end
        end
    end
end



end

%% FindGesamtesTeil

function [Pixels, size_ofthis, where, Matrix_detekt] = FindGesamtesTeil(y_start, x_start, greyimg, schwarz_max)
%y_start,x_start ist der erste detektierte Punkt

%% Def und Init
[y_max, x_max] = size(greyimg);

Matrix_detekt = zeros(y_max, x_max);

Pixels = [y_start x_start];    % welche wurden detektiert
Matrix_detekt(y_start, x_start) = 1;

size_ofthis = 1;       % wie viele Pixel wurden detektiert
% where = [0 0];     % wo ist der Schwerpunkt

%        x_min x_max y_min y_max
Merker = [true false true false];
% true: Hier wurde schon gesucht
% false: hier muss noch gesucht werden

%% Suchalgorithmus
% Merker jedes Pixel muss in allen Richtungen auf true gesetzt werden
Pixelnummer = 1;
while(size_ofthis >= Pixelnummer)
    % Die vier Richtungen werden ueberprueft:
    % 1: x_min
    % 2: x_max
    % 3: y_min
    % 4: y_max
    Richtungsnummer = 1;
    while(4 >= Richtungsnummer)
        % Falls noch nicht erledigt:
        if(false == Merker(Pixelnummer,Richtungsnummer))
            %% nebenliegendes Pixel:
            if(2 < Richtungsnummer)
                x_add = 0;
                if(3 == Richtungsnummer)
                    y_add = -1;
                else
                    y_add = 1;
                end
            else
                y_add = 0;
                if(1 == Richtungsnummer)
                    x_add = -1;
                else
                    x_add = 1;
                end
            end
            y_search = Pixels(Pixelnummer,1)+ y_add;
            x_search = Pixels(Pixelnummer,2)+ x_add;
            
            
            %% Teste ob das Pixel ueberprueft werden darf
            % Pixel im Bild:
            X_gross_genug = x_search > 0;
            Y_gross_genug = y_search > 0;
            X_klein_genug = x_search <= x_max;
            Y_klein_genug = y_search <= y_max;
            Pixel_im_Bild = X_gross_genug && Y_gross_genug && X_klein_genug && Y_klein_genug;
            
            if(Pixel_im_Bild)
                noch_nicht_detektiertes_Pixel = (0 == Matrix_detekt(y_search, x_search));
                
                Pixel_nicht_alt = (y_search > y_start) || ((y_search == y_start) && x_search > x_start);
                
                Pixel_erlaubt_zum_Testen = noch_nicht_detektiertes_Pixel && Pixel_nicht_alt;
                if(Pixel_erlaubt_zum_Testen)
                    %% Teste das Pixel
                    Test_Pix = greyimg(y_search,x_search);
                    if(Test_Pix > schwarz_max)
                        % Pixel des Teils ist detektiert
                        % Es wird hinzugefuegt
                        Pixels = [Pixels; y_search x_search];
                        Matrix_detekt(y_search, x_search) = 1;
                        size_ofthis = size_ofthis + 1;
                        
                        %% Merker fuer dieses neue Pixel
                        
                        Merker = [Merker; false false false false];
                        
                    end
                end
            end
            
            %%
            % Richtung dieses Pixels wurde ueberprueft:
            Merker(Pixelnummer,Richtungsnummer) = true;
        end
        Richtungsnummer = Richtungsnummer + 1;
    end
    Pixelnummer = Pixelnummer + 1;
end
%% Schwerpunktberechnung:

where = [0 0];
for i_temp = 1:1:size_ofthis
    where = where + Pixels(size_ofthis,:);
end
where = where/size_ofthis;

end

%% Img3D

function [] = Img3D(image, color) %, schwarz_max)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

[y_max, x_max, colors] = size(image);

y = 1:1:y_max;
x = 1:1:x_max;
[X,Y]= meshgrid(x,y);

if(1>color || 3<color)
    color = 1;
end
Z = image(:,:,color);

figure
surf(X, Y, Z, Z)
grid on
shading flat 
if(1 == color)
    cmap = [ones(1,256); 1:-1/255:0; 1:-1/255:0; ]';
else
    if(2==color)
        cmap = [1:-1/255:0; ones(1,256); 1:-1/255:0; ]';
    else
        cmap = [1:-1/255:0; 1:-1/255:0; ones(1,256);]';
    end
end

% if(1>schwarz_max)
%     schwarz_max = 1;
% end
% if(256<schwarz_max)
%     schwarz_max = 256;
% end
% cmap = [zeros(schwarz_max,3); cmap((schwarz_max+1):256,:)];
% cmap = [1:-1/255:0; ones(1,256); 1:-1/255:0; ]';
% cmap = [ones(1,256); ones(1,256); 1:-1/255:0;]';   % ein grau. Oder z.B. [1,0,0] für rot.
colormap(cmap)


end





