"""Regenerate local launcher and splash assets from the owner's sliced logo."""
from pathlib import Path
import xml.etree.ElementTree as ET
from playwright.sync_api import sync_playwright

BASE = Path(__file__).resolve().parent
APP = BASE.parent
RES = APP / 'android/app/src/main/res'


def write(path, text):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(text + '\n', encoding='utf-8', newline='\n')


def main():
    root = ET.parse(BASE / 'icons/brand.svg').getroot()
    glyph = root.find('.//{http://www.w3.org/2000/svg}g/{http://www.w3.org/2000/svg}path')
    data = glyph.attrib['d']
    # Center the original glyph; keep its silhouette inside adaptive safe zones.
    transform = 'translate(-70.8 -52.48) scale(3.2)'
    svg = (f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 108 108">'
        f'<rect width="108" height="108" fill="#EFF6FF"/>'
        f'<path transform="{transform}" d="{data}" fill="#2563EB"/></svg>')
    write(BASE / 'launcher.svg', svg)
    write(APP / 'web/icons/brand.svg', svg)
    vector = f'''<vector xmlns:android="http://schemas.android.com/apk/res/android"
    android:width="108dp" android:height="108dp"
    android:viewportWidth="108" android:viewportHeight="108">
    <group android:translateX="-70.8" android:translateY="-52.48"
        android:scaleX="3.2" android:scaleY="3.2">
        <path android:fillColor="#2563EB" android:pathData="{data}" />
    </group>
</vector>'''
    write(RES / 'drawable/ic_launcher_foreground.xml', vector)
    write(RES / 'drawable/splash_logo.xml', vector.replace('108dp', '288dp'))
    for qualifier, monochrome in [('v26', ''), ('v33',
            '    <monochrome android:drawable="@drawable/ic_launcher_foreground" />\n')]:
        write(RES / f'mipmap-anydpi-{qualifier}/ic_launcher.xml',
            '<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android">\n'
            '    <background android:drawable="@color/launcher_background" />\n'
            '    <foreground android:drawable="@drawable/ic_launcher_foreground" />\n'
            + monochrome + '</adaptive-icon>')
    targets = [(RES / f'mipmap-{density}/ic_launcher.png', size)
            for density, size in [('mdpi', 48), ('hdpi', 72), ('xhdpi', 96),
                                    ('xxhdpi', 144), ('xxxhdpi', 192)]]
    targets += [(APP / 'web/icons' / name, size) for name, size in [
        ('Icon-192.png', 192), ('Icon-512.png', 512),
        ('Icon-maskable-192.png', 192), ('Icon-maskable-512.png', 512)]]
    targets += [(APP / 'web/favicon.png', 32)]
    with sync_playwright() as playwright:
        browser = playwright.chromium.launch(channel='chrome', headless=True)
        page = browser.new_page(device_scale_factor=1)
        for path, size in targets:
            page.set_viewport_size({'width': size, 'height': size})
            page.set_content('<style>body{margin:0}svg{display:block;width:100%}</style>' + svg)
            page.screenshot(path=str(path))
        browser.close()
    print('Generated Android/Web icons and splash vectors from brand.svg.')


if __name__ == '__main__':
    main()
