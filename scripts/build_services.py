# -*- coding: utf-8 -*-
import csv
import json
import re
import unicodedata
from pathlib import Path

SOURCE = Path('my_app/offre.csv')
OUTPUT = Path('my_app/assets/services.json')

CATEGORY_MAP = {
    'esthetique': 'Beauty',
    'esthatique': 'Beauty',
    'beauty': 'Beauty',
    'coiffure': 'Hair'
}
SUBCATEGORY_PREFIX = {
    'epilation': ('Waxing', 'Waxing'),
    'apilation': ('Waxing', 'Waxing'),
    'manucure': ('Manicure', 'Manicure'),
    'vernis': ('Nail Polish', 'Manicure'),
    'faux_ongles': ('Artificial Nails', 'Manicure'),
    'beaute_des_pieds': ('Foot Care', 'Manicure'),
    'beauta_des_pieds': ('Foot Care', 'Manicure'),
    'maquillage': ('Makeup', 'Beauty Services'),
    'extensions_de_cils': ('Lash Extensions', 'Beauty Services'),
    'teinture_des_cils_et_sourcils': ('Tinting', 'Beauty Services'),
    'soins_du_visage': ('Facial Treatments', 'Beauty Services'),
    'soins_du_corps': ('Body Treatments', 'Beauty Services'),
    'actes_coiffure': ('Hair Styling', 'Hair Services'),
    'soins_des_cheveux': ('Hair Care', 'Hair Services'),
    'coloration': ('Color Services', 'Hair Services'),
    'extensions': ('Hair Extensions', 'Hair Services'),
    'coiffures_de_ceremonie': ('Event Styling', 'Hair Services'),
    'coiffures_de_caramonie': ('Event Styling', 'Hair Services')
}

def normalize_text(text: str) -> str:
    normalized = unicodedata.normalize('NFKD', text or '')
    ascii_text = ''.join(ch for ch in normalized if not unicodedata.combining(ch))
    ascii_text = ascii_text.encode('ascii', 'ignore').decode('ascii')
    return ascii_text.strip()

def slugify(text: str) -> str:
    ascii_text = normalize_text(text).lower()
    ascii_text = ascii_text.replace('&', ' and ')
    ascii_text = re.sub(r"[^a-z0-9]+", '_', ascii_text)
    return ascii_text.strip('_')

def parse_float(value: str):
    if value is None:
        return None
    value = value.strip()
    if not value:
        return None
    value = value.replace(',', '.').replace(' ', '')
    try:
        return float(value)
    except ValueError:
        return None

def preferred_price(row):
    rec = parse_float(row.get('price_recommended_mad'))
    if rec is not None and rec > 0:
        return rec
    low = parse_float(row.get('price_avg_min_mad'))
    high = parse_float(row.get('price_avg_max_mad'))
    if low is not None and high is not None:
        return round((low + high) / 2, 2)
    if low is not None:
        return low
    if high is not None:
        return high
    return 0.0

def estimate_duration(name: str) -> int:
    n = name.lower()
    if any(keyword in n for keyword in ['peach fuzz', 'nostrils', 'chin', 'brow', 'lash', 'toe']):
        return 15
    if any(keyword in n for keyword in ['bikini', 'half', 'underarm', 'stomach', 'back', 'buttocks']):
        return 30
    if any(keyword in n for keyword in ['manicure', 'pedicure', 'polish', 'gel', 'nail']):
        return 60
    if 'massage' in n:
        return 60
    if 'makeup' in n and ('wedding' in n or 'bridal' in n):
        return 120
    if 'makeup' in n:
        return 60
    if 'facial' in n or 'treatment' in n:
        return 75
    if 'extensions' in n:
        return 120
    if any(keyword in n for keyword in ['blowout', 'trim', 'haircut', 'styling']):
        return 45
    if any(keyword in n for keyword in ['color', 'highlight', 'balayage', 'bleach']):
        return 120
    return 60

sections = {}
with SOURCE.open(encoding='latin-1') as handle:
    reader = csv.DictReader(handle)
    for row in reader:
        service_name = row.get('service')
        if not service_name or not service_name.strip():
            continue
        title = normalize_text(row.get('service', ''))
        category_key = slugify(row.get('category', ''))
        category = CATEGORY_MAP.get(category_key, normalize_text(row.get('category', '')) or 'General')
        sub_key = slugify(row.get('subcategory', ''))
        prefix, subcategory = SUBCATEGORY_PREFIX.get(sub_key, ('Other Services', normalize_text(row.get('subcategory', '')) or 'Other Services'))
        final_title = f"{prefix} - {title}" if prefix else title
        base_price = preferred_price(row)
        service_id = f"svc_{slugify(category)}_{slugify(final_title)}"
        record = {
            'id': service_id[:60],
            'title': final_title,
            'category': category,
            'subcategory': subcategory,
            'durationMin': estimate_duration(final_title),
            'basePrice': round(base_price, 2),
            'thumbUrl': f"https://picsum.photos/seed/{slugify(final_title)}/400/280"
        }
        sections.setdefault(category, {}).setdefault(subcategory, []).append(record)

for category, subs in sections.items():
    for subcategory, items in subs.items():
        items.sort(key=lambda item: item['title'])

OUTPUT.write_text(json.dumps(sections, indent=2, ensure_ascii=False), encoding='utf-8')
print(f"Wrote services grouped into {len(sections)} categories to {OUTPUT}")
