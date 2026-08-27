import requests
import json
import sys

BASE_URL = "http://localhost:9000"
TOKEN = None

def login():
    global TOKEN
    resp = requests.post(f"{BASE_URL}/admin/auth/login", json={
        "username": "admin",
        "password": "admin123"
    })
    data = resp.json()
    print(f"[登录] 状态码={resp.status_code}, 结果={json.dumps(data, ensure_ascii=False, indent=2)}")
    if data.get("success"):
        TOKEN = data["token"]
        print(f"[登录] token={TOKEN}")
        return True
    return False

def headers():
    return {"Authorization": f"Bearer {TOKEN}", "Content-Type": "application/json"}

def test(name, method, url, json_data=None, expect_success=True, desc=""):
    print(f"\n{'='*60}")
    print(f"[测试] {name} | {method} {url}")
    if desc:
        print(f"[说明] {desc}")
    try:
        if method == "GET":
            resp = requests.get(f"{BASE_URL}{url}", headers=headers())
        elif method == "POST":
            resp = requests.post(f"{BASE_URL}{url}", headers=headers(), json=json_data or {})
        elif method == "PUT":
            resp = requests.put(f"{BASE_URL}{url}", headers=headers(), json=json_data or {})
        elif method == "DELETE":
            resp = requests.delete(f"{BASE_URL}{url}", headers=headers())
        else:
            print(f"[失败] 未知方法 {method}")
            return None
        
        if resp.status_code >= 200 and resp.status_code < 300:
            try:
                data = resp.json()
                print(f"[成功] 状态码={resp.status_code}")
                if isinstance(data, dict):
                    print(f"[数据] {json.dumps(data, ensure_ascii=False, indent=2)[:500]}")
                elif isinstance(data, list):
                    print(f"[数据] 返回列表, 共{len(data)}条")
                    if len(data) > 0:
                        print(f"[数据] 首条: {json.dumps(data[0], ensure_ascii=False, indent=2)[:200]}")
                else:
                    print(f"[数据] {str(data)[:300]}")
                return data
            except:
                print(f"[成功] 状态码={resp.status_code}, 响应文本={resp.text[:200]}")
                return resp.text
        else:
            print(f"[失败] 状态码={resp.status_code}, 响应={resp.text[:300]}")
            return None
    except Exception as e:
        print(f"[异常] {e}")
        return None

if __name__ == "__main__":
    # 1. 登录
    if not login():
        # 尝试其他密码
        for pwd in ["admin", "123456", "password", "admin@123", "admin123456"]:
            resp = requests.post(f"{BASE_URL}/admin/auth/login", json={
                "username": "admin", "password": pwd
            })
            data = resp.json()
            if data.get("success"):
                TOKEN = data["token"]
                print(f"[登录成功] 密码={pwd}, token={TOKEN}")
                break
        else:
            print("[错误] 无法登录，所有密码尝试失败")
            sys.exit(1)
    
    # 测试管理API访问
    print("\n\n===== 1. 测试管理API可访问性 =====")
    test("获取管理员信息", "GET", "/admin/auth/info", desc="验证token是否有效")
    
    # 2. 品牌管理 CRUD
    print("\n\n===== 2. 品牌管理 CRUD =====")
    # 2.1 查询品牌列表
    brands = test("品牌列表", "POST", "/admin/brand/page", 
                  json_data={"page": 1, "limit": 10, "key": ""},
                  desc="查询品牌分页列表")
    
    brand_id = None
    if brands and isinstance(brands, dict):
        records = brands.get("records", [])
        if records:
            brand_id = records[0].get("id")
            print(f"[信息] 获取到品牌ID={brand_id} 用于后续测试")
    
    # 2.2 新增品牌
    new_brand = test("新增品牌", "POST", "/admin/brand/save",
                     json_data={
                         "name": f"测试品牌_{sys.platform}",
                         "logo": "https://example.com/logo.png",
                         "description": "这是一个通过API自动创建的测试品牌",
                         "sort": 99,
                         "status": 1
                     },
                     desc="测试新增品牌功能")
    
    # 2.3 获取新增的品牌ID
    brands2 = test("品牌列表(验证新增)", "POST", "/admin/brand/page",
                   json_data={"page": 1, "limit": 50, "key": ""},
                   desc="验证新增的品牌已存在")
    new_id = None
    if brands2 and isinstance(brands2, dict):
        for r in brands2.get("records", []):
            if "测试品牌" in r.get("name", ""):
                new_id = r["id"]
                print(f"[信息] 找到新增的品牌ID={new_id}")
                break
    
    # 2.4 更新品牌
    if new_id:
        test("更新品牌", "PUT", "/admin/brand/update",
             json_data={
                 "id": new_id,
                 "name": f"测试品牌_已更新",
                 "logo": "https://example.com/logo_updated.png",
                 "description": "已通过API更新的测试品牌",
                 "sort": 88,
                 "status": 1
             },
             desc="测试更新品牌功能")
    
    # 2.5 删除品牌
    if new_id:
        test("删除品牌", "DELETE", f"/admin/brand/{new_id}",
             desc="测试删除品牌功能")
    
    # 3. 分类管理 CRUD
    print("\n\n===== 3. 分类管理 CRUD =====")
    categories = test("分类列表", "GET", "/admin/category/list",
                      desc="查询所有分类")
    
    # 3.1 新增分类
    new_cat = test("新增分类", "POST", "/admin/category/save",
                   json_data={
                       "name": "测试分类_传感器",
                       "parent_id": None,
                       "sort": 99,
                       "status": 1
                   },
                   desc="测试新增分类")
    
    # 3.2 更新分类（需要先获取新分类ID）
    cats2 = test("分类列表(验证新增)", "GET", "/admin/category/list",
                 desc="验证新增分类")
    new_cat_id = None
    if cats2 and isinstance(cats2, list):
        for c in cats2:
            if "测试分类" in c.get("name", ""):
                new_cat_id = c["id"]
                print(f"[信息] 找到新增的分类ID={new_cat_id}")
                break
    
    if new_cat_id:
        test("更新分类", "PUT", f"/admin/category/update",
             json_data={
                 "id": new_cat_id,
                 "name": "测试分类_传感器_已更新",
                 "sort": 88,
                 "status": 1
             },
             desc="测试更新分类")
        test("删除分类", "DELETE", f"/admin/category/{new_cat_id}",
             desc="测试删除分类")

    # 4. 资讯管理 CRUD
    print("\n\n===== 4. 资讯管理 CRUD =====")
    news = test("新闻列表", "POST", "/admin/news/page",
                json_data={"page": 1, "limit": 10},
                desc="查询新闻分页列表")
    
    news_id = None
    if news and isinstance(news, dict):
        records = news.get("records", [])
        if records:
            news_id = records[0].get("id")
            print(f"[信息] 获取到新闻ID={news_id}")
    
    # 4.1 新增新闻
    new_news = test("新增新闻", "POST", "/admin/news/save",
                    json_data={
                        "title": "测试新闻_API自动创建",
                        "summary": "这是通过API自动创建的测试新闻摘要",
                        "content": "这是测试新闻的详细内容，通过API自动创建。",
                        "cover": "https://example.com/news_cover.png",
                        "status": 1
                    },
                    desc="测试新增新闻")
    
    # 4.2 更新新闻
    news_list2 = test("新闻列表(验证新增)", "POST", "/admin/news/page",
                      json_data={"page": 1, "limit": 50},
                      desc="验证新增新闻")
    new_news_id = None
    if news_list2 and isinstance(news_list2, dict):
        for r in news_list2.get("records", []):
            if "测试新闻" in r.get("title", ""):
                new_news_id = r["id"]
                print(f"[信息] 找到新增的新闻ID={new_news_id}")
                break
    
    if new_news_id:
        test("更新新闻", "PUT", f"/admin/news/update",
             json_data={
                 "id": new_news_id,
                 "title": "测试新闻_已更新",
                 "summary": "已更新的测试新闻摘要",
                 "content": "已更新的测试新闻详细内容。",
                 "status": 1
             },
             desc="测试更新新闻")
        test("删除新闻", "DELETE", f"/admin/news/{new_news_id}",
             desc="测试删除新闻")
    
    # 5. 合作品牌管理 CRUD
    print("\n\n===== 5. 合作品牌管理 CRUD =====")
    test("合作品牌列表", "POST", "/admin/cooperate/page",
         json_data={"page": 1, "limit": 10},
         desc="查询合作品牌分页列表")
    
    test("新增合作品牌", "POST", "/admin/cooperate/save",
         json_data={
             "name": "测试合作品牌_API",
             "logo": "https://example.com/coop_logo.png",
             "description": "通过API自动创建的合作品牌",
             "sort": 99,
             "status": 1
         },
         desc="测试新增合作品牌")
    
    # 查询合作品牌列表确认
    coop_list = test("合作品牌列表(验证)", "POST", "/admin/cooperate/page",
                     json_data={"page": 1, "limit": 50},
                     desc="验证新增合作品牌")
    new_coop_id = None
    if coop_list and isinstance(coop_list, dict):
        for r in coop_list.get("records", []):
            if "测试合作品牌" in r.get("name", ""):
                new_coop_id = r["id"]
                print(f"[信息] 找到新增的合作品牌ID={new_coop_id}")
                break
    if new_coop_id:
        test("删除合作品牌", "DELETE", f"/admin/cooperate/{new_coop_id}",
             desc="测试删除合作品牌")
    
    # 6. 产品管理 CRUD (如果存在)
    print("\n\n===== 6. 产品管理 CRUD =====")
    test("产品列表", "POST", "/admin/product/page",
         json_data={"page": 1, "limit": 10},
         desc="查询产品分页列表")
    
    # 7. 订单管理 CRUD (如果存在)
    print("\n\n===== 7. 订单管理 CRUD =====")
    test("订单列表", "POST", "/admin/order/page",
         json_data={"page": 1, "limit": 10},
         desc="查询订单分页列表")
    
    # 8. 用户管理 CRUD (如果存在)
    print("\n\n===== 8. 用户管理 CRUD =====")
    test("用户列表", "POST", "/admin/user/page",
         json_data={"page": 1, "limit": 10},
         desc="查询用户分页列表")
    
    # 9. 广告管理 CRUD (如果存在)
    print("\n\n===== 9. 广告管理 CRUD =====")
    test("广告列表", "POST", "/admin/ad/page",
         json_data={"page": 1, "limit": 10},
         desc="查询广告分页列表")
    
    print("\n\n" + "="*60)
    print("全部测试完成！")
    print("="*60)