function CC = mfcc(speech)

    fs = 8000; % El enunciado del trabajo practico nos solicito grabar audios con una frecuencia de 8 kHz.
    time_window = 20; % '[...]The frame length is set to 20ms (160 samples)[...]' An Efficient MFCC Extraction Method in Speech Recognition
    frame_shift = 10; % '[...]There is a 10ms overlap between the two adjacent frames[...]' An Efficient MFCC Extraction Method in Speech Recognition
    alpha = 0.97; % El filtro de pre-enfasis esta definido asi en 'An Efficient MFCC Extraction Method in Speech Recognition'
    R = [300, 3400]; % Espectro definido entre 0.3 kHz y 3.4 kHz. An Efficient MFCC Extraction Method in Speech Recognition
    M = 33; % Numero de filter banks. '[...]The filter bank consists of 33 triangular shapes[...]' An Efficient MFCC Extraction Method in Speech Recognition
    N = 26; % Cantidad de componentes para cada coeficiente cepstral. El enunciado solicita 26.
    L = 22; % Usado como parametro para la funcion cepstral sine lifter.

    % Calculo de la ventana de Hamming.
    hamming_window = @(N)0.54 - 0.46 * cos(2 * pi * [0 : N - 1].'/(N - 1));

    if(nargin ~= 1)
        error('Wrong amount of parameters. Must be 1: mfcc(speech), where speech = wavread("audio_path.wav")');
        return;
    end 

    if(max(abs(speech)) <= 1), speech = speech * 2^15; end;

    % Duracion de cada frame.
    Nw = round(1E-3 * time_window * fs);
    % Solapamiento de cada frame.
    Ns = round(1E-3 * frame_shift * fs);

    nfft = 2^nextpow2(Nw);
    K = nfft / 2 + 1;

    % Conversion de Hertz a escala Mel.
    mel_scale = @(hz)(1127 * log(1 + hz / 700));
    % Conversion de Mel a escala de Hertz.
    hz_scale = @(mel)(700 * exp(mel / 1127) - 700);

    dctm = @(N, M)(sqrt(2.0 / M) * cos(repmat([0:N-1].',1,M) ...
                                       .* repmat(pi * ([1 : M] - 0.5) / M, N, 1)));

    % Filtro de pre-enfasis.
    speech = filter([1 - alpha], 1, speech); % fvtool( [1 -alpha], 1 );

    % Division en frames y aplicacion de ventana de Hamming.
    frames = vec2frames(speech, Nw, Ns, 'cols', hamming_window, false);
    
    % Si la cantidad de frames es impar, completo con ceros para que quede par.
    % Ver http://practicalcryptography.com/miscellaneous/machine-learning/guide-mel-frequency-cepstral-coefficients-mfccs/
    if fmod(length(frames), 2) == 1
        disp('Padding uneven amount of frames with a column full of zeroes...');
        frames = [frames eye(size(frames, 1), 1)];
    end

    MAG = abs(fft(frames,nfft,1));

    % Filter banks triangulares con filtros en escala de mel uniformemente espaciados
    H = trifbank(M, K, R, fs, mel_scale, hz_scale);

    FBE = H * MAG(1 : K, :);

    % Calculo de la matriz de transformadas discretas (Discrete Cosine Transform)
    DCT = dctm(N, M);

    CC =  DCT * log(FBE);

    % Calculo del cepstral lifter
    ceplifter = @(N, L)(1 + 0.5 * L * sin(pi * [0 : N - 1] / L));
    lifter = ceplifter(N, L);

    CC = diag(lifter) * CC; % ~ HTK's MFCCs