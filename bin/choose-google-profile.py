#!/usr/bin/env python3
import subprocess
import sys

name2profile = {
    "private1": "Default",
    "private2": "Profile 1",
    "pixelplex": "Profile 2",
    "bare": "Profile 4",
}

fuzzel = subprocess.Popen(
    ["fuzzel", "--dmenu"], stdin=subprocess.PIPE, stdout=subprocess.PIPE
)
stdout, stderr = fuzzel.communicate(input="\n".join(name2profile.keys()).encode())

status = fuzzel.wait()

if status != 0:
    subprocess.run(["notify-send", "Failed to select Google profile"])
    sys.exit(status)

name = stdout.decode("utf-8").strip()
profile = name2profile[name]
print(profile)

# subprocess.run(["google-chrome-stable", f"--profile-directory='{profile}'"])
