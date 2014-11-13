%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parametros de entrada:
% * data = dataset
% * code = code vectors de un individuo
%
% Parametros de salida:
% * dist = distorsion media
function dist = meandist(data, code)
	[dim, n] = size(data);
	[dim, nvector] = size(code);
	dist = 0;
	min_value = intmax;
	min_value_position = -1;
	for l = 1 : n
	% busco la minima distancia/distorsion de cada columna
    	distances = norm(repmat(data(:, l), 1, nvector) - code, 2, 'columns');
    	[m, i] = min(distances);
    	if (m < min_value)
    		min_value = m;
    		min_value_position = i;
    	end
    	dist = dist + m;
	end
	dist = dist / n;
end