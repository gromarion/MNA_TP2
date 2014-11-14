function percentage = test()

	fflush(stdout);
	users = cellstr(['fede_roma.wav'; 'federelli.wav'; 'german.wav'; 'Juana.wav'; 'leonardo.wav'; 'matias.wav'; 'milagros.wav'; 'sonia.wav'; 'stella.wav']);
	results_pasando = 0;
	results_mancha = 0;

	for i = 1 : length(users)
		pasando = strcat('audios/samples_2/que_mal_que_la_estoy_pasando_', users{i});
		audio_a_testear = pasando
		results_pasando = results_pasando + check_results(recognize_speech(pasando), i);
	end

	for i = 1 : length(users)
		mancha = strcat('audios/samples_3/esta_mancha_no_se_quita_', users{i});
		audio_a_testear = mancha
		results_mancha = results_mancha + check_results(recognize_speech(mancha), i);
	end

	results_pasando
	results_mancha

	pasando_percentage = results_pasando /9
	mancha_percentage = results_mancha / 9
	percentage = (results_pasando + results_mancha) / 18

end

function result = check_results(user_name, supposed_user_name)
	user_names = cellstr(['Federico Romarion'; 'Federico Elli'; 'German Romarion'; 'Juana Unamuno'; 'Leonardo Rivas'; 'Matias Rivas'; 'Milagros Rivas'; 'Sonia Rivas'; 'Stella Giunta']);

	result = 0
	if strcmp(user_name, user_names{supposed_user_name}) == 1
		result = 1
	end
end