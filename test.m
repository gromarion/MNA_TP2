function name_result = test()
	% input = wavread(audio_path);
	% cepstral_coefficient_input = mfcc(input);
	% input_codebook = vq(cepstral_coefficient_input, 16);

	% wavreads = {};
	% codebooks = {};

	users = cellstr(['fede_roma.wav'; 'federelli.wav'; 'german.wav'; 'Juana.wav'; 'leonardo.wav'; 'mario.wav'; 'matias.wav'; 'milagros.wav'; 'sonia.wav'; 'stella.wav']);
	user_names = cellstr(['Federico Romarion'; 'Federico Elli'; 'German Romarion'; 'Juana Unamuno'; 'Leonardo Rivas'; 'Mario Romarion'; 'Matias Rivas'; 'Milagros Rivas'; 'Sonia Rivas'; 'Stella Giunta']);


	for i = 1 : length(users)
		cuca = strcat('audios/samples_1/a_la_grande_le_puse_cuca_', users{i});
		audio_a_testear = cuca
		recognize_speech(cuca);
	end

	for i = 1 : length(users)
		pasando = strcat('audios/samples_2/que_mal_que_la_estoy_pasando_', users{i});
		audio_a_testear = pasando
		recognize_speech(pasando);
	end

	for i = 1 : length(users)
		mancha = strcat('audios/samples_3/esta_mancha_no_se_queta_', users{i});
		audio_a_testear = mancha
		recognize_speech(mancha);
	end

end