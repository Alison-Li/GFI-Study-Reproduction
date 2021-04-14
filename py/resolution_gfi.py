import matplotlib.pyplot as plt
import numpy as np
import csv
import os

dir = os.path.dirname(__file__)

# Notation used in this CSV file:
# 'a' -> issue solved by a newcomer
# 'b' -> issue that attracted a newcomer's attention but was not resolved by a newcomer
# 'c' -> issue that did not attract a newcomer's attention

a = b = c = 0

csv_filepath = os.path.join(dir, '../csv/random-60-closed-gfi-issues.csv')

with open(csv_filepath, 'r') as csvfile:
    plots = csv.reader(csvfile, delimiter=',')
    next(plots)
    for row in plots:
        label = str(row[11])
        if label == 'a':
            a += 1
        elif label == 'b':
            b += 1
        elif label == 'c':
            c += 1
        else:
            print("Label not recognized.")

counts = [a, b, c]
categories = ["#issues solved\nby newcomers", "#issues that attracted\nnewcomers' attention but were\nnot solved by newcomers", "#issues that did not\nattract newcomers' attention"]
colors = [ "#ff6666", "#ffcc99", "#66b3ff"]
explode = [0.01, 0.01, 0.01]

plt.rcParams["font.family"] = "Times New Roman"
plt.pie(counts, colors=colors, explode=explode, labels=categories, autopct='%1.1f%%', startangle=180)
plt.axis('equal')
plt.tight_layout()
plt.show()