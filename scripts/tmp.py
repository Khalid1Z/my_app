import re
from pathlib import Path
text = Path("node_modules/prisma/build/index.js").read_text()
match = re.search("Could not resolve @prisma/client despite the installation that we just tried", text)
if match:
    start = match.start()
    print(text[start-200:start+200])
