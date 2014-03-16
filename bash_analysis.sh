# calculate average number of shopping points for training set and test set per customer
cut -d, -f1 train.csv |uniq -c|sed 's/^[\ \t]*//'|cut -d$' ' -f1|awk '{sum += $0} END {print sum/NR}'
cut -d, -f1 test_v2.csv|uniq -c|sed 's/^[\ \t]*//'|cut -d$' ' -f1|awk '{sum += $0} END {print sum/NR}'
# state-wide number of shoppers in training set and test set
cut -d, -f6 train.csv |sort|uniq -c
cut -d, -f6 test_v2.csv |sort|uniq -c
# all purchase point lines in train.csv
cat train.csv |grep -E '^[0-9]+,[0-9]+,1.*'
