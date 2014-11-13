function CC = mfcc(speech)

    fs = 8000;
    time_window = 20;
    frame_shift = 10;
    alpha = 0.97;
    R = [0, 4000];
    M = 33; % Filterbanks number. It's ok to be 20.
    N = 26; % Amount of components in Cepstral Coefficients. 26 beacause MNA_TP2 says so.
    L = 22;

    hamming_window = @(N)0.54 - 0.46 * cos(2 * pi * [0 : N - 1].'/(N - 1));

    if(nargin ~= 1)
        error('Wrong amount of parameters. Must be 1: mfcc(speech), where speech = wavread("audio_path.wav")');
        return;
    end 

    % Explode samples to the range of 16 bit shorts
    if(max(abs(speech)) <= 1), speech = speech * 2^15; end;

    Nw = round(1E-3 * time_window * fs);     % frame duration (samples)
    Ns = round(1E-3 * frame_shift * fs);     % frame shift (samples)

    nfft = 2^nextpow2(Nw);          % length of FFT analysis 
    K = nfft / 2 + 1;               % length of the unique part of the FFT 

    mel_scale = @(hz)(1127 * log(1 + hz / 700));     % Hertz to mel warping function
    hz_scale = @(mel)(700 * exp(mel / 1127) - 700); % mel to Hertz warping function

    % Type III DCT matrix routine (see Eq. (5.14) on p.77 of [1])
    dctm = @(N, M)(sqrt(2.0 / M) * cos(repmat([0:N-1].',1,M) ...
                                       .* repmat(pi * ([1 : M] - 0.5) / M, N, 1)));

    % Cepstral lifter routine (see Eq. (5.12) on p.75 of [1])
    ceplifter = @(N, L)(1 + 0.5 * L * sin(pi * [0 : N - 1] / L));


    %% FEATURE EXTRACTION

    % Preemphasis filtering (see Eq. (5.1) on p.73 of [1])
    speech = filter([1 - alpha], 1, speech); % fvtool( [1 -alpha], 1 );

    % Framing and windowing (frames as columns)
    frames = vec2frames(speech, Nw, Ns, 'cols', hamming_window, false);
    if fmod(length(frames), 2) == 1
        disp('Padding uneven amount of frames with a column full of zeroes...');
        frames = [frames eye(size(frames, 1), 1)];
    end

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