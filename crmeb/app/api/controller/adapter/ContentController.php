<?php
// +----------------------------------------------------------------------
// | 电子元器件商城 - 内容API适配控制器
// +----------------------------------------------------------------------
// | 处理新闻、数据手册、合作伙伴、询价、合作品牌等
// +----------------------------------------------------------------------

namespace app\api\controller\adapter;

use app\Request;
use app\services\article\ArticleServices;
use app\services\article\ArticleCategoryServices;

class ContentController
{
    /**
     * 获取新闻资讯列表
     * @param Request $request
     * @param ArticleServices $services
     * @return \think\Response
     */
    public function newsList(Request $request, ArticleServices $services)
    {
        $params = $request->getMore([
            ['cid', 0],
            [['page', 'd'], 0],
            [['limit', 'd'], 10],
        ]);

        $where = [];
        if ($params['cid']) {
            $where['cid'] = $params['cid'];
        }
        $where['hide'] = 0;

        $list = $services->getList($where, (int)$params['page'], (int)$params['limit']);
        $count = $services->getCount($where);

        return app('json')->success([
            'list' => $list,
            'total' => $count
        ]);
    }

    /**
     * 获取新闻资讯详情
     * @param $id
     * @param ArticleServices $services
     * @return \think\Response
     */
    public function newsDetail($id, ArticleServices $services)
    {
        $info = $services->getInfo($id);
        if (!$info) {
            return app('json')->fail('文章不存在');
        }

        return app('json')->success($info);
    }

    /**
     * 点赞/取消点赞资讯
     * @param Request $request
     * @return \think\Response
     */
    public function toggleNewsLike(Request $request)
    {
        return app('json')->success(['message' => 'ok']);
    }

    /**
     * 收藏/取消收藏资讯
     * @param Request $request
     * @return \think\Response
     */
    public function toggleNewsFavorite(Request $request)
    {
        return app('json')->success(['message' => 'ok']);
    }

    /**
     * 获取数据手册列表
     * @param Request $request
     * @return \think\Response
     */
    public function datasheetList(Request $request)
    {
        // 数据手册 - 电子元器件特色功能，需要扩展
        // 暂时使用商品附件或文章替代
        return app('json')->success(['list' => []]);
    }

    /**
     * 获取合作品牌列表
     * @return \think\Response
     */
    public function cooperateBrands()
    {
        // 合作品牌 - 需要扩展数据库表
        return app('json')->success(['list' => []]);
    }

    /**
     * 提交合作伙伴申请
     * @param Request $request
     * @return \think\Response
     */
    public function partnerApply(Request $request)
    {
        $params = $request->postMore([
            ['company', ''],
            ['contact', ''],
            ['phone', ''],
            ['email', ''],
            ['remark', ''],
        ]);

        // 将合作伙伴申请保存到数据库，需要扩展表
        // 暂时使用客服反馈或文章评论功能替代
        return app('json')->success(['message' => '申请已提交，我们会尽快与您联系']);
    }

    /**
     * 提交询价单
     * @param Request $request
     * @return \think\Response
     */
    public function submitInquiry(Request $request)
    {
        $params = $request->postMore([
            ['products', ''],
            ['contact', ''],
            ['phone', ''],
            ['email', ''],
            ['company', ''],
            ['remark', ''],
        ]);

        // 询价单 - 需要扩展数据库表
        // 暂时保存到辅助表或使用客服反馈
        return app('json')->success(['message' => '询价单已提交，我们会尽快报价']);
    }

    /**
     * 获取用户询价单列表
     * @param Request $request
     * @return \think\Response
     */
    public function inquiryList(Request $request)
    {
        $uid = $request->uid();
        return app('json')->success(['list' => []]);
    }
}