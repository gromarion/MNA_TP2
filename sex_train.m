%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parametros de salida:
% * codebooks = codebooks asociados a cada locutor
%				involucrado en el entrenamiento.

function codebooks = sex_train()
	codebooks = {};
	wavreads = {};
	users = cellstr(['federelli.wav'; 'Juana.wav']);
	user_names = cellstr(['Male'; 'Female']);

	total_files = length(users);

	printf('\n%d files will be used for trainig...\nProgress:\n', total_files);
	fflush(stdout);

	for i = 1 : length(users)
		filename = strcat('audios/samples_3/esta_mancha_no_se_quita_', users{i});
		wavreads{i} = wavread(filename);
		codebooks{i} = vq(mfcc(wavreads{i}), 16);
		progress = (i / total_files) * 100;
		printf('%d%%\n', progress);
		fflush(stdout);
	end
end