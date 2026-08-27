<?php
// +----------------------------------------------------------------------
// | 电子元器件商城 - 产品API适配控制器
// +----------------------------------------------------------------------
// | 将现有前端产品相关API映射到CRMEB后端服务
// +----------------------------------------------------------------------

namespace app\api\controller\adapter;

use app\Request;
use app\services\product\product\StoreCategoryServices;
use app\services\product\product\StoreProductServices;
use app\services\pc\ProductServices;
use app\services\product\brand\BrandServices;

class ProductController
{
    /**
     * 获取商品分类列表
     * @param Request $request
     * @param StoreCategoryServices $services
     * @return \think\Response
     */
    public function categories(Request $request, StoreCategoryServices $services)
    {
        $list = $services->getCategoryList();
        return app('json')->success([
            'list' => $list
        ]);
    }

    /**
     * 获取分类树
     * @param Request $request
     * @param StoreCategoryServices $services
     * @return \think\Response
     */
    public function categoryTree(Request $request, StoreCategoryServices $services)
    {
        $list = $services->getCategoryList();
        $tree = $this->buildTree($list, 0);
        return app('json')->success([
            'list' => $tree
        ]);
    }

    /**
     * 分页查询商品
     * @param Request $request
     * @param StoreProductServices $services
     * @return \think\Response
     */
    public function page(Request $request, StoreProductServices $services)
    {
        $where = $request->getMore([
            ['keyword', '', '', 'store_name'],
            [['cid', 'd'], 0],
            [['sid', 'd'], 0],
            ['priceOrder', ''],
            ['salesOrder', ''],
            [['page', 'd'], 0],
            [['limit', 'd'], 20],
        ]);

        $where['is_show'] = 1;
        $where['is_del'] = 0;

        $list = $services->getSearchList($where, (int)$where['page'], (int)$where['limit']);
        $count = $services->getCount($where);

        return app('json')->success([
            'list' => $list,
            'total' => $count
        ]);
    }

    /**
     * 获取商品详情
     * @param Request $request
     * @param $id
     * @param StoreProductServices $services
     * @return \think\Response
     */
    public function detail(Request $request, $id, StoreProductServices $services)
    {
        $data = $services->getProductDetail($id, $request->uid());
        return app('json')->success($data);
    }

    /**
     * 获取推荐商品
     * @param Request $request
     * @param StoreProductServices $services
     * @return \think\Response
     */
    public function recommend(Request $request, StoreProductServices $services)
    {
        $params = $request->getMore([
            ['productId', 0],
            ['limit', 8],
        ]);

        $uid = $request->uid();
        $list = $services->getRecommendProduct($uid, 'is_hot', 0, 'mid');
        $list = array_slice($list, 0, (int)$params['limit']);

        return app('json')->success([
            'list' => $list
        ]);
    }

    /**
     * 获取品牌列表
     * @return \think\Response
     */
    public function brands()
    {
        // CRMEB没有品牌表，从系统配置获取或返回空
        return app('json')->success([
            'list' => []
        ]);
    }

    /**
     * 获取品牌商品
     * @param Request $request
     * @param $brandId
     * @param StoreProductServices $services
     * @return \think\Response
     */
    public function brandProducts(Request $request, $brandId, StoreProductServices $services)
    {
        $where = $request->getMore([
            [['page', 'd'], 0],
            [['limit', 'd'], 20],
        ]);

        $where['is_show'] = 1;
        $where['is_del'] = 0;
        // 品牌筛选需要额外扩展，先返回全部商品
        $list = $services->getSearchList($where, (int)$where['page'], (int)$where['limit']);
        $count = $services->getCount($where);

        return app('json')->success([
            'list' => $list,
            'total' => $count
        ]);
    }

    /**
     * 构建分类树
     * @param array $list
     * @param int $pid
     * @return array
     */
    private function buildTree(array $list, int $pid): array
    {
        $tree = [];
        foreach ($list as $item) {
            if ($item['pid'] == $pid) {
                $children = $this->buildTree($list, $item['id']);
                if ($children) {
                    $item['children'] = $children;
                }
                $tree[] = $item;
            }
        }
        return $tree;
    }
}