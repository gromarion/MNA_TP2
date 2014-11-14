function user_name = recognize_speech(audio_path, codebooks)
	input = wavread(audio_path);
	cepstral_coefficient_input = mfcc(input);
	input_codebook = vq(cepstral_coefficient_input, 16);

	users = cellstr(['facundo.wav'; 'fede_roma.wav'; 'federelli.wav'; 'german.wav'; 'Juana.wav'; 'leonardo.wav'; 'matias.wav'; 'milagros.wav'; 'sonia.wav'; 'stella.wav']);
	user_names = cellstr(['Facundo Alderete'; 'Federico Romarion'; 'Federico Elli'; 'German Romarion'; 'Juana Unamuno'; 'Leonardo Rivas'; 'Matias Rivas'; 'Milagros Rivas'; 'Sonia Rivas'; 'Stella Giunta']);

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
	printf('\t* User has been identified as %s\n\n', user_name);
	fflush(stdout);
end