%% Constants
global GENERATIONS_NUMBER REPRODUCTION_NUMBER MEMBERS_NUMBER MAX_CONTROL_POINTS MAX_CURVES;
GENERATIONS_NUMBER = 20;
MEMBERS_NUMBER = 40;
REPRODUCTION_NUMBER = 0.5 * MEMBERS_NUMBER;
MAX_CONTROL_POINTS = 15;
MAX_CURVES = 4;

%% Group by lines
curves=cell(max(vertcat(BasePoints.Line)),1);
for point=BasePoints
    curves(point.Line)= {[cell2mat(curves(point.Line, 1)) ;  [point.koords(1) point.koords(2)]]};
end

for i=1:length(curves)
    [~,IA,~] = unique(curves{i}(:, 1), 'stable');
    curves{i} = curves{i}(IA, :);
end

%% Run genetic algo for each line
splines = cell(length(curves), 1);
fitnesses = cell(length(curves), 1);
for i=1:min(MAX_CURVES, length(curves))
    fprintf('Curve: %i\n', i);
    % Check if curve has enough points to reduce
    if(length(curves{i, 1}) > MAX_CONTROL_POINTS)
        [splines{i}, fitnesses{i}] = geneticCurve(curves{i, 1});        
    end
end

%% Plot the results
hold on;
title('The change of the curve for every 5th dataset');
legend();
for i=1:length(splines)
    plt=fnplt(cscvn(splines{i}{end}'));
    plot(plt(1, :), plt(2, :));
end
% title('The change in fitness for each four dataset');
% xlabel('Generation number');
% ylabel('Average distance between curves (fitness)');
% legend({'Curve 1', 'Curve 2', 'Curve 3', 'Curve 4'});
% for i=1:MAX_CURVES
%     plt = 1:length(fitnesses{i});
%     for j=1:length(fitnesses{i})
%         plt(j) = mean(fitnesses{i}{j});
%     end
%     plot(1:length(fitnesses{i}), plt);
% end
hold off;

%% Genetic algorithm functions
function [final, fits]=geneticCurve(curve)
global GENERATIONS_NUMBER;
generation = generateFirstGen(curve);
final = cell(GENERATIONS_NUMBER, 1);
fits = cell(GENERATIONS_NUMBER, 1);
for g=1:GENERATIONS_NUMBER
    fprintf('Generation: %i\n', g);
    [generation, best, fit] = generateNextGen(generation, curve);
    final{g} = best;
    fits{g} = fit;
    disp(mean(fit));
end
end

function fit=fitness(generation, curve)
fit = zeros(length(generation), 1);
for i=1:length(generation)
    spl = spline(linspace(0, 1, length(curve(generation{i}, :))), curve(generation{i}, :)');
    yy = ppval(spl, linspace(0, 1, 100));
    [~, dist] = distance2curve([yy(1, :)', yy(2, :)'], curve, 'spline');
    fit(i) = mean(dist);
end
end

function child=reproduce(parent1, parent2)
genes = unique(sort([parent1; parent2]));
GENES_NUM = randi([min(length(parent1), length(parent2)), max(length(parent1), length(parent2))]);
child = chooseRandomSubsetInOrder(genes, GENES_NUM);
end

function newgen=generateFirstGen(curve)
global MEMBERS_NUMBER MAX_CONTROL_POINTS;
newgen = cell(MEMBERS_NUMBER, 1);
for i=1:MEMBERS_NUMBER
    POINTS_NUM = randi([3 MAX_CONTROL_POINTS]);
    % Choose random POINTS_NUM elements from curve
    newgen{i} = sort(randperm(length(curve), POINTS_NUM))';
end
end

function [newgen, best, fits]=generateNextGen(generation, curve)
global REPRODUCTION_NUMBER MEMBERS_NUMBER;
% Sort by fitness
fits = fitness(generation, curve);
[~, indices] = sort(fits);
% Get the upper REPRODUTION_RATIO of the generation
parents = generation(indices(1:REPRODUCTION_NUMBER));
best = curve(parents{1}, :);
newgen = cell(MEMBERS_NUMBER, 1);
for i=1:MEMBERS_NUMBER
    newgen{i} = reproduce(parents{randi(REPRODUCTION_NUMBER)}, parents{randi(REPRODUCTION_NUMBER)});
end
end

%% Sub functions
function subset=chooseRandomSubsetInOrder(array, num)
% Choose NUM random elements from ARRAY, maintaining the original order
subset = array(sort(randperm(length(array), num)), :);
end