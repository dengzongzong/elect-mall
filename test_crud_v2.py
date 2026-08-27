import requests
import json
import sys

BASE_URL = "http://localhost:9000"
TOKEN = None

def login():
    global TOKEN
    print("="*60)
    print("步骤1: 管理员登录")
    print("="*60)
    resp = requests.post(f"{BASE_URL}/admin/auth/login", json={
        "username": "admin", "password": "admin123"
    })
    data = resp.json()
    if data.get("success"):
        TOKEN = data["token"]
        print(f"✓ 登录成功!")
        return True
    print(f"✗ 登录失败: {data.get('message')}")
    return False

def headers():
    return {"token": TOKEN, "Content-Type": "application/json"}

def test(name, method, url, json_data=None, desc=""):
    print(f"\n{'='*60}")
    print(f"[测试] {name} | {method} {url}")
    if desc:
        print(f"[说明] {desc}")
    try:
        h = headers()
        if method == "GET":
            resp = requests.get(f"{BASE_URL}{url}", headers=h, params=json_data)
        elif method == "POST":
            resp = requests.post(f"{BASE_URL}{url}", headers=h, json=json_data or {})
        elif method == "PUT":
            resp = requests.put(f"{BASE_URL}{url}", headers=h, json=json_data or {})
        elif method == "DELETE":
            resp = requests.delete(f"{BASE_URL}{url}", headers=h, json=json_data)
        else:
            print(f"[失败] 未知方法 {method}")
            return None
        
        ok = resp.status_code >= 200 and resp.status_code < 300
        status = "✓" if ok else "✗"
        print(f"{status} 状态码={resp.status_code}")
        if not ok:
            print(f"[响应] {resp.text[:200]}")
        else:
            try:
                data = resp.json()
                if isinstance(data, dict):
                    s = json.dumps(data, ensure_ascii=False, indent=2)
                    print(f"[数据] {s[:400]}")
                elif isinstance(data, list):
                    print(f"[数据] 列表, 共{len(data)}条")
                    if data:
                        print(f"[首条] {json.dumps(data[0], ensure_ascii=False, indent=2)[:200]}")
                else:
                    print(f"[数据] {str(data)[:200]}")
            except:
                print(f"[响应] {resp.text[:200]}")
        return resp
    except Exception as e:
        print(f"✗ 异常: {e}")
        return None

def main():
    if not login():
        return
    
    # ====== 1. 仪表盘 ======
    print("\n\n" + "="*60)
    print("===== 1. 仪表盘 =====")
    print("="*60)
    test("仪表盘统计", "GET", "/admin/dashboard/stats")
    test("仪表盘(根路径)", "GET", "/admin/dashboard")
    
    # ====== 2. 品牌管理 ======
    print("\n\n" + "="*60)
    print("===== 2. 品牌管理 =====")
    print("="*60)
    test("品牌列表(GET)", "GET", "/admin/brand/list")
    test("品牌分页(POST)", "POST", "/admin/brand/page", {"page": 1, "limit": 5})
    test("新增品牌(POST /add)", "POST", "/admin/brand/add", {
        "name": "API测试品牌",
        "logo": "https://example.com/b.png",
        "description": "测试品牌",
        "sort": 99, "status": 1
    })
    # 获取新增的品牌ID
    r = test("品牌列表确认", "GET", "/admin/brand/list")
    new_id = None
    if r and r.ok:
        data = r.json()
        for b in data:
            if "API测试品牌" in b.get("name", ""):
                new_id = b["id"]
                print(f"\n[信息] 找到新增品牌ID={new_id}")
                break
    if new_id:
        test("更新品牌", "PUT", "/admin/brand/update", {
            "id": new_id, "name": "API测试品牌_已更新",
            "logo": "https://example.com/b2.png",
            "description": "已更新", "sort": 88, "status": 1
        })
        test("删除品牌(DELETE /delete)", "DELETE", "/admin/brand/delete", {"id": new_id})
    
    # ====== 3. 分类管理 ======
    print("\n\n" + "="*60)
    print("===== 3. 分类管理 =====")
    print("="*60)
    test("分类列表(GET)", "GET", "/admin/category/list")
    test("新增分类(POST /add)", "POST", "/admin/category/add", {
        "name": "API测试分类", "parentId": None, "sort": 99, "status": 1
    })
    r = test("分类列表确认", "GET", "/admin/category/list")
    new_cat_id = None
    if r and r.ok:
        for c in r.json():
            if "API测试分类" in c.get("name", ""):
                new_cat_id = c["id"]
                print(f"\n[信息] 找到新增分类ID={new_cat_id}")
                break
    if new_cat_id:
        test("更新分类", "PUT", "/admin/category/update", {
            "id": new_cat_id, "name": "API测试分类_已更新", "sort": 88, "status": 1
        })
        test("删除分类(DELETE /delete)", "DELETE", "/admin/category/delete", {"id": new_cat_id})
    
    # ====== 4. 资讯管理 ======
    print("\n\n" + "="*60)
    print("===== 4. 资讯管理 =====")
    print("="*60)
    test("新闻列表(GET)", "GET", "/admin/news/list")
    test("新闻分页(POST)", "POST", "/admin/news/page", {"page": 1, "size": 10})
    test("新增新闻(POST /add)", "POST", "/admin/news/add", {
        "title": "API测试新闻",
        "content": "测试内容",
        "image": "https://example.com/n.jpg",
        "status": 1
    })
    r = test("新闻列表确认", "GET", "/admin/news/list")
    new_news_id = None
    if r and r.ok:
        for n in r.json():
            if "API测试新闻" in n.get("title", ""):
                new_news_id = n["id"]
                print(f"\n[信息] 找到新增新闻ID={new_news_id}")
                break
    if new_news_id:
        test("更新新闻", "PUT", "/admin/news/update", {
            "id": new_news_id, "title": "API测试新闻_已更新", "content": "已更新内容", "status": 1
        })
        test("删除新闻(DELETE /delete)", "DELETE", "/admin/news/delete", {"id": new_news_id})
    
    # ====== 5. 合作品牌管理 ======
    print("\n\n" + "="*60)
    print("===== 5. 合作品牌管理 =====")
    print("="*60)
    test("合作品牌列表", "GET", "/admin/cooperate/list")
    test("新增合作品牌(POST /add)", "POST", "/admin/cooperate/add", {
        "brandName": "API测试合作品牌",
        "logo": "https://example.com/c.png",
        "description": "测试合作品牌",
        "sort": 99, "status": 1
    })
    r = test("合作品牌列表确认", "GET", "/admin/cooperate/list")
    new_coop_id = None
    if r and r.ok:
        for c in r.json():
            if "API测试合作品牌" in c.get("brandName", ""):
                new_coop_id = c["id"]
                print(f"\n[信息] 找到新增合作品牌ID={new_coop_id}")
                break
    if new_coop_id:
        test("更新合作品牌", "PUT", "/admin/cooperate/update", {
            "id": new_coop_id, "brandName": "API测试合作品牌_已更新", "sort": 88, "status": 1
        })
        test("删除合作品牌", "DELETE", "/admin/cooperate/delete", {"id": new_coop_id})
    
    # ====== 6. 商品管理 ======
    print("\n\n" + "="*60)
    print("===== 6. 商品管理 =====")
    print("="*60)
    test("商品分页(POST)", "POST", "/admin/product/page", {"page": 1, "size": 10})
    test("新增商品(POST /add)", "POST", "/admin/product/add", {
        "categoryId": 1, "brandId": 1,
        "partNo": "API-TEST-002", "name": "API测试商品",
        "description": "测试商品", "stock": 100, "price": 1.00,
        "minOrder": 1, "unit": "pcs", "status": 1, "attrs": {}
    })
    r = test("商品列表确认", "POST", "/admin/product/page", {"page": 1, "size": 50, "keyword": "API-TEST-002"})
    new_prod_id = None
    if r and r.ok:
        data = r.json()
        for p in data.get("records", []):
            if p.get("partNo") == "API-TEST-002":
                new_prod_id = p["id"]
                print(f"\n[信息] 找到新增商品ID={new_prod_id}")
                break
    if new_prod_id:
        test("更新商品", "PUT", "/admin/product/update", {
            "id": new_prod_id, "categoryId": 1, "brandId": 1,
            "partNo": "API-TEST-002", "name": "API测试商品_已更新",
            "stock": 200, "price": 1.50, "status": 1, "attrs": {}
        })
        test("删除商品(DELETE /delete)", "DELETE", "/admin/product/delete", {"id": new_prod_id})
    
    # ====== 7. 订单管理 ======
    print("\n\n" + "="*60)
    print("===== 7. 订单管理 =====")
    print("="*60)
    test("订单分页(GET)", "GET", "/admin/order/page", {"page": 1, "size": 10})
    test("订单分页(POST)", "POST", "/admin/order/page", {"page": 1, "size": 10})
    
    # ====== 8. 其他管理 ======
    print("\n\n" + "="*60)
    print("===== 8. 其他管理 =====")
    print("="*60)
    test("BOM列表(GET)", "GET", "/admin/bom/list", {"page": 1, "size": 10})
    test("询价列表(GET)", "GET", "/admin/inquiry/page", {"page": 1, "size": 10})
    test("用户列表(GET)", "GET", "/admin/user/list", {"page": 1, "size": 10})
    test("财务列表(GET)", "GET", "/admin/finance/list", {"page": 1, "size": 10})
    test("财务数据(GET /data)", "GET", "/admin/finance/data", {"page": 1, "size": 10})
    test("反馈列表(GET)", "GET", "/admin/feedback/list", {"page": 1, "size": 10})
    test("消息列表(GET)", "GET", "/admin/message/list", {"page": 1, "size": 10})
    test("合作伙伴列表(GET)", "GET", "/admin/partner/list")
    test("数据手册列表(GET)", "GET", "/admin/datasheet/list", {"page": 1, "size": 10})
    test("短信配置(GET)", "GET", "/admin/setting/sms")
    test("系统配置(GET /list)", "GET", "/admin/setting/list")
    
    # ====== 总结 ======
    print("\n\n" + "="*60)
    print("所有测试完成!")
    print("="*60)

if __name__ == "__main__":
    main()