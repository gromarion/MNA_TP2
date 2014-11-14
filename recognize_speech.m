function user_name = recognize_speech(audio_path)
	input = wavread(audio_path);
	cepstral_coefficient_input = mfcc(input);
	input_codebook = vq(cepstral_coefficient_input, 16);

	wavreads = {};
	codebooks = {};

	users = cellstr(['fede_roma.wav'; 'federelli.wav'; 'german.wav'; 'Juana.wav'; 'leonardo.wav'; 'mario.wav'; 'matias.wav'; 'milagros.wav'; 'sonia.wav'; 'stella.wav']);
	user_names = cellstr(['Federico Romarion'; 'Federico Elli'; 'German Romarion'; 'Juana Unamuno'; 'Leonardo Rivas'; 'Mario Romarion'; 'Matias Rivas'; 'Milagros Rivas'; 'Sonia Rivas'; 'Stella Giunta']);

	for i = 1 : length(users)
		filename = strcat('audios/samples_1/a_la_grande_le_puse_cuca_', users{i});
		wavreads{i} = wavread(filename);
		codebooks{i} = vq(mfcc(wavreads{i}), 16);
	end

	min_meandist = inf;
	min_codebook_index = -1;

	for i = 1 : length(users)
		meandist_value = meandist(input_codebook, codebooks{i});
		if meandist_value < min_meandist
			min_meandist = meandist_value;
			min_codebook_index = i;
		end
	end

	user_name = user_names{min_codebook_index};
end