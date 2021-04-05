import matplotlib.pyplot as plt
import numpy as np
import csv
import os

x = []
y = []

dir = os.path.dirname(__file__)
csv_filepath = os.path.join(dir, '../csv/gfi_label_distribution_raw.csv')

with open(csv_filepath, 'r') as csvfile:
    plots = csv.reader(csvfile, delimiter=',')
    next(plots)
    for row in plots:
        x.append(row[0])
        y.append(int(row[1]))

csfont = {'fontname':'Times New Roman'}
indexes = np.arange(len(x))
plt.bar(indexes, y)
plt.xticks(indexes, x, rotation=45, ha="right", **csfont)
plt.ylabel('Issues', **csfont)
plt.tight_layout()
plt.show()