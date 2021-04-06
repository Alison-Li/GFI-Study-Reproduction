import matplotlib.pyplot as plt
import numpy as np
import csv
import os
from scipy import stats

x = []
y = []

dir = os.path.dirname(__file__)
csv_filepath = os.path.join(dir, '../csv/filtered_projects_popularity_gfi_correlation.csv')

with open(csv_filepath, 'r') as csvfile:
    plots = csv.reader(csvfile, delimiter=',')
    next(plots)
    for row in plots:
        x.append(int(row[1]))
        y.append(int(row[2]))

print(stats.spearmanr(x, y))

csfont = {'fontname':'Times New Roman'}
plt.scatter(x, y, edgecolors='white', linewidth=0.1, alpha=0.7)
m, b = np.polyfit(x, y, 1)
plt.xlabel('GitHub Stars', **csfont)
plt.ylabel('Good First Issues (GFIs)', **csfont)
plt.plot(np.unique(x), np.poly1d(np.polyfit(x, y, 1))(np.unique(x)))
plt.show()