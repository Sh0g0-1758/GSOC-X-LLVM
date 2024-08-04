import json

def generate_step_function_graph(final_results_arr, all_stats):
    json_data = {
        "stats": all_stats,
        "stats_per_knob_val": final_results_arr,
    }

    with open(f'./website_files_results/capture-tracking-max-uses-to-explore.json', 'w') as file:
        json.dump(json_data, file, indent=4)

def process(data):
    stats = data.get('stats')
    stats_per_file = data.get('stats_per_knob_val')
    filtered_stats = {}
    for stat in stats:
        flag = False
        for stats_dict in stats_per_file:
            if stats_dict[stat][2] != 10000:
                flag = True
                break
        if flag:
            filtered_stats[stat] = True
    
    final_filtered_results_arr = []
    for i in range(13):
        final_filtered_results_arr.append({})
    for i, stats_dict in enumerate(stats_per_file):
        for key, value in stats_dict.items():
            if key in filtered_stats:
                final_filtered_results_arr[i][key] = value

    generate_step_function_graph(final_filtered_results_arr, list(filtered_stats.keys()))

    print("Processing data...")

def read_json_file(file_path):
    try:
        with open(file_path, 'r') as file:
            data = json.load(file)
            process(data)
    except Exception as e:
        print(f"An error occurred: {e}")

file_path = 'website_files_results/capture-tracking-max-uses-to-explore.json'
read_json_file(file_path)
