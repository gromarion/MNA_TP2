waveFile='a_la_grande_le_puse_cuca_federelli.wav';
[y, fs, nbits]=wavread(waveFile);
a=0.97;
y2 = filter([1, -a], 1, y);
wavwrite(y2, fs, nbits, 'a_la_grande_le_puse_cuca_federelli_preEmphasis.wav'); 