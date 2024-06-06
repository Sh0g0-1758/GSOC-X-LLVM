import json
import numpy as np
from scipy.stats import pearsonr
import matplotlib.pyplot as plt
import matplotlib.patches as mpatches

def json_to_dict_with_arrays(file_path):
    with open(file_path, 'r') as file:
        data = json.load(file)
    
    result = {}
    for key, value in data.items():
        result[key] = value
    return result

file_path = 'stats_result.json'
converted_dict = json_to_dict_with_arrays(file_path)

x = []
for i in range(50,1050,50):
    x.append(i)
x = np.array(x)

keys = list(converted_dict.keys())
Pearson_correlation_coefficients = []
P_Value = []

for key, value in converted_dict.items():
    y = np.array(value)
    correlation_coefficient, p_value = pearsonr(x, y)
    Pearson_correlation_coefficients.append(correlation_coefficient)
    P_Value.append(p_value)

# Plotting
fig, ax = plt.subplots()

bar_width = 0.35
index = np.arange(len(keys))

bars1 = ax.bar(index, Pearson_correlation_coefficients, bar_width, label='Pearson Correlation Coefficient', color='b')
bars2 = ax.bar(index + bar_width, P_Value, bar_width, label='P-Value', color='r')

ax.set_xlabel('Stats')
ax.set_ylabel('Values')
ax.set_title('Correlation Analysis by Modifying cl_limit from 50 to 1000')
ax.set_xticks(index + bar_width / 2)
ax.set_xticklabels(keys, rotation=45, ha='right')
ax.legend()

# Adding vertical lines
for i in range(len(keys)):
    plt.axvline(x=i + bar_width / 2, color='gray', linestyle='--', linewidth=0.5)

ax.yaxis.grid(True, color='gray', linestyle='--', linewidth=0.5)

plt.subplots_adjust(bottom=0.30)
plt.show()
