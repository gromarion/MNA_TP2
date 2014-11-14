%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parametros de salida:
% * percentage = porcentaje de aciertos en
% 				 diferenciación de sexos.

function percentage = sex_test()
	disp('Sex recognition test program is running. Please be patient, this may take a while...');

	user_names = cellstr(['Male'; 'Male'; 'Male'; 'Male'; 'Female'; 'Male'; 'Male'; 'Female'; 'Female'; 'Female']);
	file_paths = cellstr(['audios/samples_2/que_mal_que_la_estoy_pasando_'; 'audios/samples_1/a_la_grande_le_puse_cuca_']);

	printf('Training speech recognizer...');
	fflush(stdout);
	codebooks = sex_train();;
	printf('DONE\n');

	total_files = length(user_names) * length(file_paths);
	files_tested = 0;
	printf('%d files will be used for testing...\n', total_files);
	fflush(stdout);

	[results_pasando, files_tested] = recognize_speaker(user_names, file_paths{1}, files_tested, total_files, 0, codebooks);
	[results_mancha, files_tested] = recognize_speaker(user_names, file_paths{2}, files_tested, total_files, results_pasando, codebooks);
	
	pasando_percentage = results_pasando / (total_files / 2)
	mancha_percentage = results_mancha / (total_files / 2)
	percentage = (results_pasando + results_mancha) / total_files
end

function [identification_amount, files_tested] = recognize_speaker(user_names, audio_path, files_tested, total_files, previous_results, codebooks)
	users = cellstr(['facundo.wav'; 'fede_roma.wav'; 'federelli.wav'; 'german.wav'; 'Juana.wav'; 'leonardo.wav'; 'matias.wav'; 'milagros.wav'; 'sonia.wav'; 'stella.wav']);
	identification_amount = 0;

	for i = 1 : length(users)
		audio_a_testear = strcat(audio_path, users{i});
		printf('- Testing %s\n\n', audio_a_testear);
		fflush(stdout);
		identification_amount = identification_amount + check_results(user_names, recognize_sex(audio_a_testear, codebooks), i);
		files_tested = files_tested + 1;
		show_progress(files_tested, total_files, identification_amount + previous_results);
	end
end

function result = check_results(user_names, user_name, supposed_user_name)
	result = 0;
	if strcmp(user_name, user_names{supposed_user_name}) == 1
		result = 1;
	end
end

function [] = show_progress(files_tested, total_files, assertions)
	progress = (files_tested / total_files) * 100;
	printf('\tFiles\t|(%%)\t|Right\t|Wrong\n\t%d\t|%d%%\t|%d\t|%d\n\n', files_tested, progress, assertions, files_tested - assertions);
	fflush(stdout);
end