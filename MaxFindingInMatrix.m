MAX=R(1,2);
for i=1:237
	for j=2:237
		if i == j
			continue
		end
		if MAX <= R(i, j)
			MAX = R(i, j);
			i1 = i;
			j1 = j;
		end
	end
end
MAX = 0;
for j=2:237
	if j == 236
		continue
	end
	if MAX <= abs(R(236, j))
		MAX = abs(R(236, j));
		j1 = j;
	end
end
