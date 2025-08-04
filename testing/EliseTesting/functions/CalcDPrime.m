function [Dprime] = CalcDPrime(i, j, n, dMeanresults, stdevresults)

%This function calculates d' between one folder, subject, or electrode and
%all others input

%Works best for only two folders

%Can be adjusted to do comparisons between electrodes and subjects too by
%exchanging j's for i's or n's

%Information for the first mean - j
%Change these variables to match the subject, folder, and electrode you
%would like to look at
i_1 = i-1;
j_1 = j-1;
n_1 = n-1;

%Information for max bounds
i_max = i + 1;
j_max = j + 1;
n_max = n + 1;

%Prints means and corresponding subject and channel
%fprintf(append('Mean of ', channel{i_1}, ' in subject ', subject{n_1}, ' is '));
dMeanresults(i,j_1)

%fprintf(append('Mean of ', channel{i_2}, ' in subject ', subject{n_2}, ' is ' ));
%meanresults(1, 2, 1)

%Defining N - change j to n or i if needed
N = j - 1;

%Standard deviation for each mean - this might be wrong
stdev_1 = stdevresults(i,j_1);
%stddev_2 = stdevresults(1, 2, 1);

%Reset i, j, and n for looping
%i = 1;
j = j_1;
%n = 1;

%Sets m for loop
m = 0;

%This is currently set to compare across folders (change j's to n's or i's
%to change to comparing across subjects or electrodes

%First loop goes from 1 to folder selected
while j ~= j_1 && j < j_max
    m = 0;
    m = m + dMeanresults(i, j);
    j = j + 1;
end
%Second loop makes sure selected folder isn't included in sum
while j == j_1
    j = j + 1;
end
%Last loop goes from selected folder to the end
while j ~= j_1 && j < j_max 
    m = m + dMeanresults(i, j);
    j = j + 1;
end

%Calculates the numerator
numerator = dMeanresults(i, j_1) - ((1/N)*m);


%Reset i, j, and n for looping again
%i = 1;
j = j_1;
%n = 1;

%Sets s for loops
s = 0;

%First loop goes from 1 to folder selected
while j ~= j_1 && j < j_max
    s = 0;
    s = s + ((stdevresults(i, j)));
    j = j + 1;
end
%Second loop makes sure selected folder isn't included in sum
while j == j_1
    j = j + 1;
end
%Last loop goes from selected folder to the end
while j ~= j_1 && j < j_max
    s = s + ((stdevresults(i, j)));
    j = j + 1;
end

denominator = sqrt(0.5*(((stdev_1)) + (1/N)*s));

%This calculates the values of d'
Dprime = numerator/denominator;
Dprime