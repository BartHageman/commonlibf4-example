import json
import os

# This is just a small script to remove the rc.exe entry from the compile
# commands file generated by ninja. If we leave this in, clangd will not
# recognize the F4SE dependencies as C++. It interprets them as C instead. This
# quick and dirty fix python script should really be run after configuring,
# But I've had to attach it to the post-build event, because cmake doesn't have
# a post-configure event from what I can tell.

def filter_rc_entries(file_path):
    print(f"Checking for compile_commands.json in {file_path}")
    if not os.path.exists(file_path):
        print(f"File not found: {file_path}")
        return

    with open(file_path, "r") as f:
        data = json.load(f)

    filtered_data = [entry for entry in data if "rc.exe" not in entry["command"]]

    with open(file_path, "w") as f:
        json.dump(filtered_data, f, indent=4)

# Define possible locations
possible_locations = [
    "../compile_commands.json",
    "../debug/compile_commands.json",
    "../release/compile_commands.json",
]

# Attempt to filter rc entries in each possible location
for loc in possible_locations:
    filter_rc_entries(loc)
