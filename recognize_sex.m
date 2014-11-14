%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parametros de entrada:
% * audio_path = ruta del archivo de audio a reconocer.
% * nvector = codebooks de individuos obtenidos durante
%			  el entrenamiento.
%
% Parametros de salida:
% * user_name = nombre del usuario identificado por el
%				programa de reconocimiento.

function user_name = recognize_sex(audio_path, codebooks)
	input = wavread(audio_path);
	cepstral_coefficient_input = mfcc(input);
	input_codebook = vq(cepstral_coefficient_input, 16);

	users = cellstr(['Male'; 'Female']);

	min_meandist = inf;
	min_codebook_index = -1;

	for i = 1 : length(users)
		meandist_value = meandist(input_codebook, codebooks{i});
		if meandist_value < min_meandist
			min_meandist = meandist_value;
			min_codebook_index = i;
		end
	end

	user_name = users{min_codebook_index};
	printf('\t* User has been identified as %s\n\n', user_name);
	fflush(stdout);
end