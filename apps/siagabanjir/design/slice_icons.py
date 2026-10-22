"""Extract the owner's SVG icons; run manually with Python and Playwright."""

from copy import deepcopy
from pathlib import Path
import argparse
import xml.etree.ElementTree as ET

from playwright.sync_api import sync_playwright


ICONS = {
    0: 'brand', 1: 'notifications', 2: 'home', 3: 'report',
    4: 'history', 5: 'profile', 8: 'water', 9: 'arrow',
    10: 'monitor', 11: 'contacts', 12: 'bag', 13: 'guides',
    14: 'document_badge', 15: 'documents', 16: 'chevron',
    17: 'ai_badge', 18: 'camera',
}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--browser', help='Path to an installed Chromium browser')
    args = parser.parse_args()
    base = Path(__file__).resolve().parent
    root = ET.parse(base / 'app_beranda.svg').getroot()
    ns = '{http://www.w3.org/2000/svg}'
    ET.register_namespace('', ns[1:-1])
    vectors = base / 'icons'
    output = base.parent / 'assets/icons/home'
    vectors.mkdir(exist_ok=True)
    output.mkdir(parents=True, exist_ok=True)
    with sync_playwright() as playwright:
        browser = playwright.chromium.launch(
            headless=True, executable_path=args.browser,
        )
        page = browser.new_page(device_scale_factor=3)
        for index, name in ICONS.items():
            mask_id = f'mask{index}_72_7522'
            mask = next(
                e for e in root.iter(ns + 'mask') if e.get('id') == mask_id
            )
            group = next(
                e for e in root.iter(ns + 'g')
                if e.get('mask') == f'url(#{mask_id})'
            )
            x, y, width, height = [mask.get(k) for k in ('x', 'y', 'width', 'height')]
            svg = ET.Element(ns + 'svg', {
                'width': width, 'height': height,
                'viewBox': f'{x} {y} {width} {height}', 'fill': 'none',
            })
            defs = ET.SubElement(svg, ns + 'defs')
            defs.append(deepcopy(mask))
            svg.append(deepcopy(group))
            markup = ET.tostring(svg, encoding='unicode')
            (vectors / f'{name}.svg').write_text(
                markup + '\n', encoding='utf-8', newline='\n',
            )
            page.set_viewport_size({'width': int(width), 'height': int(height)})
            page.set_content('<style>body{margin:0;background:transparent}</style>' + markup)
            page.screenshot(path=str(output / f'{name}.png'), omit_background=True)
        browser.close()
    print(f'Extracted {len(ICONS)} SVG icons and transparent 3x PNG assets.')


if __name__ == '__main__':
    main()
