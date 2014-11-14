function codebooks = train()

	codebooks = {};
	wavreads = {};
	users = cellstr(['facundo.wav'; 'fede_roma.wav'; 'federelli.wav'; 'german.wav'; 'Juana.wav'; 'leonardo.wav'; 'matias.wav'; 'milagros.wav'; 'sonia.wav'; 'stella.wav']);
	user_names = cellstr(['Facundo Alderete'; 'Federico Romarion'; 'Federico Elli'; 'German Romarion'; 'Juana Unamuno'; 'Leonardo Rivas'; 'Matias Rivas'; 'Milagros Rivas'; 'Sonia Rivas'; 'Stella Giunta']);

	total_files = length(users);

	printf('\n%d files will be used for trainig...\nProgress:\n', total_files);
	fflush(stdout);

	for i = 1 : length(users)
		filename = strcat('audios/samples_1/a_la_grande_le_puse_cuca_', users{i});
		wavreads{i} = wavread(filename);
		codebooks{i} = vq(mfcc(wavreads{i}), 16);
		progress = (i / total_files) * 100;
		printf('%d%%\n', progress);
		fflush(stdout);
	end
end