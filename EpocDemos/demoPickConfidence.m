% Contains actions carried out to train and pick a classifier for a simple dataset.
% Afterwards, an attempt is made to determine a good confidence level setting using the trainset only
% Some summary will be printed.

% Requires p3tr and p3te to be defined. Theese could be obtained by loading a dump for another experiment
% [epocXp.adhoc.decim8ted.oct, epocXp2nduser.decim8ted.oct] and performing necessary assignments


% operates directly on the trainset, using xvalidation-like splits
[gaps conf_scores conf_conf] = pickConfidence(p3tr, modelCell);

[output confidence flashesUsed] = askAndConfide(model, p3te, 0.53, 3);