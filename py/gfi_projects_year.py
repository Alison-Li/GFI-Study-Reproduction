import matplotlib.pyplot as plt
import numpy as np
import csv
import os

x = []
y = []

dir = os.path.dirname(__file__)
csv_filepath = os.path.join(dir, '../csv/gfi_projects_year.csv')

with open(csv_filepath, 'r') as csvfile:
    plots = csv.reader(csvfile, delimiter=',')
    next(plots)
    for row in plots:
        x.append(int(row[0]))
        y.append(int(row[1]))

plt.plot(x, y, label='Number of projects', color='green', marker='+')
plt.xticks(x)
plt.legend()
plt.show()