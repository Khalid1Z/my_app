# -*- coding: utf-8 -*-
import csv
import re
import unicodedata
from pathlib import Path

def slugify(text):
    normalized = unicodedata.normalize('NFKD', text or '')
    ascii_text = ''.join(ch for ch in normalized if not unicodedata.combining(ch))
    ascii_text = ascii_text.encode('ascii', 'ignore').decode('ascii')
    ascii_text = ascii_text.lower()
    ascii_text = re.sub(r"[^a-z0-9]+", '_', ascii_text)
    return ascii_text.strip('_')

subs = set()
with Path('my_app/offre.csv').open(encoding='latin-1') as handle:
    reader = csv.DictReader(handle)
    for row in reader:
        subs.add(slugify(row.get('subcategory', '')))

print(subs)
