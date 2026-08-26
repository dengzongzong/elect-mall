package com.mall.module.bom.controller.admin;

import cn.dev33.satoken.annotation.SaCheckRole;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.mall.module.bom.entity.BomItem;
import com.mall.module.bom.entity.BomRecord;
import com.mall.module.bom.service.BomService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * BOM清单管理控制器（后台管理接口，需admin角色）
 */
@RestController
@RequestMapping("/admin/bom")
@SaCheckRole("admin")
public class AdminBomController {

    @Autowired
    private BomService bomService;

    /**
     * BOM清单分页列表
     *
     * @param params 查询参数（page, size, status）
     * @return 分页结果
     */
    @GetMapping("/page")
    public IPage<BomRecord> page(@RequestParam Map<String, Object> params) {
        int page = params.get("page") != null ? Integer.parseInt(params.get("page").toString()) : 1;
        int size = params.get("size") != null ? Integer.parseInt(params.get("size").toString()) : 10;
        Page<BomRecord> pageParam = new Page<>(page, size);
        return bomService.adminPage(pageParam, params);
    }

    /**
     * 回复BOM清单
     *
     * @param params 请求参数（id, reply）
     * @return 操作结果
     */
    @PostMapping("/reply")
    public Map<String, Object> reply(@RequestBody Map<String, Object> params) {
        Long id = Long.valueOf(params.get("id").toString());
        String reply = (String) params.get("reply");
        bomService.reply(id, reply);

        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("message", "回复成功");
        return result;
    }
}