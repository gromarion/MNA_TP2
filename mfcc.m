function CC = mfcc(speech)

    fs = 8000;
    Tw = 25;
    Ts = 10;
    alpha = 31/32;
    hamming_window = 0.54 - 0.46 * cos(2 * pi * [0 : 160 - 1].'/(160 - 1));
    R = [300, 3400];
    M = 20;
    N = 13;
    L = 22;

    if(nargin ~= 1)
        error('Wrong amount of parameters. Must be 1: mfcc(speech), where speech = wavread("audio_path.wav")');
        return;
    end 

    % Explode samples to the range of 16 bit shorts
    if(max(abs(speech)) <= 1), speech = speech * 2^15; end;

    Nw = round(1E-3 * Tw * fs);     % frame duration (samples)
    Ns = round(1E-3 * Ts * fs);     % frame shift (samples)

    nfft = 2^nextpow2(Nw);          % length of FFT analysis 
    K = nfft / 2 + 1;               % length of the unique part of the FFT 

    mel_scale = @(hz)(1127 * log(1 + hz / 700));     % Hertz to mel warping function
    hz_scale = @(mel)(700 * exp(mel / 1127) - 700); % mel to Hertz warping function

    % Type III DCT matrix routine (see Eq. (5.14) on p.77 of [1])
    dctm = @(N, M)(sqrt(2.0 / M) * cos(repmat([0:N-1].',1,M) ...
                                       .* repmat(pi * ([1 : M] - 0.5) / M, N, 1)));

    % Cepstral lifter routine (see Eq. (5.12) on p.75 of [1])
    ceplifter = @(N, L)(1+ 0.5 * L * sin(pi * [0 : N - 1] / L));


    %% FEATURE EXTRACTION

    % Preemphasis filtering (see Eq. (5.1) on p.73 of [1])
    speech = filter([1 - alpha], 1, speech); % fvtool( [1 -alpha], 1 );

    % Framing and windowing (frames as columns)
    frames = vec2frames(speech, Nw, Ns, 'cols', hamming_window, false);

    % Magnitude spectrum computation (as column vectors)
    MAG = abs(fft(frames,nfft,1)); 

    % Triangular filterbank with uniformly spaced filters on mel scale
    H = trifbank(M, K, R, fs, mel_scale, hz_scale); % size of H is M x K 

    % Filterbank application to unique part of the magnitude spectrum
    FBE = H * MAG(1 : K, :); % FBE( FBE<1.0 ) = 1.0; % apply mel floor

    % DCT matrix computation
    DCT = dctm(N, M);

    % Conversion of logFBEs to cepstral coefficients through DCT
    CC =  DCT * log(FBE);

    % Cepstral lifter computation
    lifter = ceplifter(N, L);

    % Cepstral liftering gives liftered cepstral coefficients
    CC = diag(lifter) * CC; % ~ HTK's MFCCs