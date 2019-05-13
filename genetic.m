%% Constants
global GENERATIONS_NUMBER REPRODUCTION_NUMBER MEMBERS_NUMBER MAX_CONTROL_POINTS MAX_CURVES;
GENERATIONS_NUMBER = 20;
MEMBERS_NUMBER = 100;
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
for i=1:min(MAX_CURVES, length(curves))
    fprintf('Curve: %i\n', i);
    % Check if curve has enough points to reduce
    if(length(curves{i, 1}) > MAX_CONTROL_POINTS)
        splines{i} = geneticCurve(curves{i, 1});
    end
end

%% Plot the results
for i=1:length(splines)
    plt=fnplt(cscvn(splines{i}'));
    plot(plt(1, :), plt(2, :));
end

%% Genetic algorithm functions
function final=geneticCurve(curve)
global GENERATIONS_NUMBER;
generation = generateFirstGen(curve);
for g=1:GENERATIONS_NUMBER
    fprintf('Generation: %i\n', g);
    [generation, best] = generateNextGen(generation, curve);
    final = best;
end
figure();
end

function fit=fitness(generation, curve)
fit = zeros(length(generation), 1);
x=curve(:, 1);
for i=1:length(generation)
    spl=spline(curve(generation{i}, 1), curve(generation{i}, 2), x);
    [~, dist] = distance2curve([x spl], curve, 'spline');
    fit(i) = sum(dist.^2);
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
    POINTS_NUM = randi([2 MAX_CONTROL_POINTS]);
    % Choose random POINTS_NUM elements from curve
    newgen{i} = sort(randperm(length(curve), POINTS_NUM))';
end
end

function [newgen, best]=generateNextGen(generation, curve)
global REPRODUCTION_NUMBER MEMBERS_NUMBER;
% Sort by fitness
[~, indices] = sort(fitness(generation, curve));
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