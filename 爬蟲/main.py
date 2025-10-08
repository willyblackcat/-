import requests
from bs4 import BeautifulSoup
import pandas as pd
from datetime import datetime
import time
import json
import re


def scrape_pchome_api(keyword='電視', max_pages=3):
    """使用 API 方式爬取"""
    headers = {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
        'Accept': 'application/json',
        'Referer': 'https://24h.pchome.com.tw/',
    }

    products = []

    # 嘗試不同版本的 API
    api_versions = [
        'https://ecshweb.pchome.com.tw/search/v4.3/all/results',
        'https://ecshweb.pchome.com.tw/search/v3.3/all/results',
        'https://ecapi.pchome.com.tw/fsm/v1/search'
    ]

    for page in range(1, max_pages + 1):
        print(f"正在爬取第 {page} 頁...")

        for api_url in api_versions:
            try:
                params = {'q': keyword, 'page': page, 'sort': 'rnk/dc'}
                response = requests.get(api_url, headers=headers, params=params, timeout=10)

                if response.status_code == 200:
                    data = response.json()
                    if 'prods' in data and data['prods']:
                        print(f"  使用 API: {api_url}")

                        for item in data['prods']:
                            product_id = item.get('Id', 'N/A')
                            title = item.get('name', 'N/A')
                            price = item.get('price', 'N/A')
                            original_price = item.get('originPrice', price)
                            description = item.get('describe', '')

                            link = f"https://24h.pchome.com.tw/prod/{product_id}" if product_id != 'N/A' else 'N/A'
                            image = item.get('picS', 'N/A')
                            if image != 'N/A' and not image.startswith('http'):
                                image = f"https://cs-e.ecimg.tw{image}"

                            products.append({
                                '商品編號': product_id,
                                '商品名稱': title,
                                '價格': price,
                                '原價': original_price,
                                '尺寸': '',
                                '商品描述': description,
                                '連結': link,
                                '圖片': image
                            })

                        print(f"  第 {page} 頁: 找到 {len(data['prods'])} 個商品")
                        time.sleep(1)
                        break
            except Exception as e:
                continue

        if not products and page == 1:
            print("  API 方式失敗，改用網頁解析...")
            return None

    return products


def scrape_pchome_html(keyword='電視', max_pages=3):
    """使用 HTML 解析方式爬取"""
    headers = {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
        'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
        'Accept-Language': 'zh-TW,zh;q=0.9',
        'Referer': 'https://24h.pchome.com.tw/',
    }

    products = []

    for page in range(1, max_pages + 1):
        print(f"正在爬取第 {page} 頁...")

        url = f"https://24h.pchome.com.tw/search/?q={keyword}&page={page}"

        try:
            response = requests.get(url, headers=headers, timeout=10)
            response.encoding = 'utf-8'

            if response.status_code != 200:
                print(f"  請求失敗，狀態碼: {response.status_code}")
                continue

            soup = BeautifulSoup(response.text, 'html.parser')

            # 嘗試從 HTML 中找到商品資料的 JSON
            scripts = soup.find_all('script')
            for script in scripts:
                if script.string and 'productListData' in script.string:
                    # 提取 JSON 資料
                    match = re.search(r'productListData\s*=\s*(\{.*?\});', script.string, re.DOTALL)
                    if match:
                        try:
                            data = json.loads(match.group(1))
                            if 'prods' in data:
                                items = data['prods']
                                print(f"  從 HTML 中找到 {len(items)} 個商品")

                                for item in items:
                                    product_id = item.get('Id', 'N/A')
                                    title = item.get('name', 'N/A')
                                    price = item.get('price', 'N/A')
                                    original_price = item.get('originPrice', price)
                                    description = item.get('describe', '')

                                    link = f"https://24h.pchome.com.tw/prod/{product_id}" if product_id != 'N/A' else 'N/A'
                                    image = item.get('picS', 'N/A')
                                    if image != 'N/A' and not image.startswith('http'):
                                        image = f"https://cs-e.ecimg.tw{image}"

                                    products.append({
                                        '商品編號': product_id,
                                        '商品名稱': title,
                                        '價格': price,
                                        '原價': original_price,
                                        '尺寸': '',
                                        '商品描述': description,
                                        '連結': link,
                                        '圖片': image
                                    })
                                break
                        except json.JSONDecodeError:
                            continue

            if not products and page == 1:
                print("  無法從 HTML 提取資料")

            time.sleep(1)

        except Exception as e:
            print(f"  發生錯誤: {e}")
            continue

    return products


def extract_size_from_title(title):
    """從商品名稱中提取尺寸"""
    # 匹配常見的尺寸格式：50吋、55"、65 吋等
    patterns = [
        r'(\d+)\s*吋',
        r'(\d+)\s*"',
        r'(\d+)\s*inch',
        r'(\d+)型'
    ]

    for pattern in patterns:
        match = re.search(pattern, title, re.IGNORECASE)
        if match:
            return int(match.group(1))
    return None


def filter_by_size(products, target_size=None):
    """篩選特定尺寸的商品"""
    if not target_size:
        return products

    filtered = []
    for product in products:
        size = extract_size_from_title(product['商品名稱'])
        if size == target_size:
            product['尺寸'] = f"{size}吋"
            filtered.append(product)

    return filtered


def sort_products_by_price(products, descending=True):
    """依價格排序"""

    def get_price_value(product):
        price_str = str(product['價格'])
        # 移除逗號和非數字字元
        price_str = re.sub(r'[^\d.]', '', price_str)
        try:
            return float(price_str) if price_str else 0
        except:
            return 0

    sorted_products = sorted(products, key=get_price_value, reverse=descending)
    return sorted_products


def scrape_pchome_search(keyword='電視', max_pages=3, target_size=None, sort_by_price=True):
    """
    主要爬取函數

    參數:
        keyword: 搜尋關鍵字
        max_pages: 爬取頁數
        target_size: 指定尺寸（例如: 50, 55, 65），None 表示不篩選
        sort_by_price: 是否依價格排序（由大到小）
    """
    print("嘗試使用 API 方式...")
    products = scrape_pchome_api(keyword, max_pages)

    if not products:
        print("\n改用網頁解析方式...")
        products = scrape_pchome_html(keyword, max_pages)

    if not products:
        return []

    # 篩選尺寸
    if target_size:
        print(f"\n篩選 {target_size} 吋的商品...")
        original_count = len(products)
        products = filter_by_size(products, target_size)
        print(f"  篩選後: {len(products)} 個商品 (原本 {original_count} 個)")

    # 價格排序
    if sort_by_price and products:
        print("\n依價格由大到小排序...")
        products = sort_products_by_price(products, descending=True)

    return products


def save_to_excel(products, filename=None):
    """儲存結果到Excel檔案"""
    if not products:
        print("沒有資料可儲存！")
        return

    if filename is None:
        timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
        filename = f'pchome_products_{timestamp}.xlsx'

    df = pd.DataFrame(products)

    # 調整欄位順序
    column_order = ['商品編號', '商品名稱', '尺寸', '價格', '原價', '商品描述', '連結', '圖片']
    df = df[column_order]

    # 儲存到 Excel
    with pd.ExcelWriter(filename, engine='openpyxl') as writer:
        df.to_excel(writer, index=False, sheet_name='商品列表')

        # 調整欄位寬度
        worksheet = writer.sheets['商品列表']
        worksheet.column_dimensions['A'].width = 15
        worksheet.column_dimensions['B'].width = 50
        worksheet.column_dimensions['C'].width = 10
        worksheet.column_dimensions['D'].width = 12
        worksheet.column_dimensions['E'].width = 12
        worksheet.column_dimensions['F'].width = 40
        worksheet.column_dimensions['G'].width = 60
        worksheet.column_dimensions['H'].width = 60

    print(f"\n{'=' * 50}")
    print(f"✓ 資料已儲存到: {filename}")
    print(f"✓ 共 {len(products)} 筆商品資料")
    print(f"{'=' * 50}")


def print_results(products):
    """列印結果摘要"""
    if not products:
        print("\n沒有爬取到任何商品！")
        print("\n可能的原因:")
        print("1. 網路連線問題")
        print("2. PChome 網站結構已改變")
        print("3. 被網站阻擋（請稍後再試）")
        return

    print(f"\n{'=' * 50}")
    print(f"爬取結果摘要")
    print(f"{'=' * 50}")
    print(f"總商品數: {len(products)}\n")

    print("前 5 個商品:")
    for i, product in enumerate(products[:5], 1):
        size_info = f" ({product['尺寸']})" if product.get('尺寸') else ""
        print(f"\n{i}. {product['商品名稱']}{size_info}")
        print(f"   價格: ${product['價格']}")
        print(f"   編號: {product['商品編號']}")


if __name__ == '__main__':
    print("=" * 50)
    print("PChome 24h 購物網爬蟲")
    print("=" * 50)

    # ========== 設定參數 ==========
    keyword = '電視'
    max_pages = 3
    target_size = 55  # 指定尺寸（例如: 50, 55, 65），設為 None 不篩選
    # ==============================

    print(f"\n搜尋關鍵字: {keyword}")
    print(f"爬取頁數: {max_pages}")
    if target_size:
        print(f"篩選尺寸: {target_size} 吋")
    print(f"排序方式: 價格由大到小\n")

    products = scrape_pchome_search(
        keyword=keyword,
        max_pages=max_pages,
        target_size=target_size,
        sort_by_price=True
    )

    print_results(products)

    if products:
        save_to_excel(products)
        print("\n✓ 爬取完成！")
    else:
        print("\n建議:")
        print("- 檢查網路連線")
        print("- 稍後再試")
        print("- 或改用 Selenium 方式")