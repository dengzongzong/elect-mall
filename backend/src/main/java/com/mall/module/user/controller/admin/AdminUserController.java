package com.mall.module.user.controller.admin;

import cn.dev33.satoken.annotation.SaCheckRole;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.mall.module.auth.entity.User;
import com.mall.module.auth.mapper.UserMapper;
import com.mall.module.user.service.UserCenterService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.Map;

/**
 * 用户管理控制器（后台管理接口，需admin角色）
 */
@RestController
@RequestMapping("/admin/user")
@SaCheckRole("admin")
public class AdminUserController {

    @Autowired
    private UserMapper userMapper;

    @Autowired
    private UserCenterService userCenterService;

    /**
     * 用户分页列表
     *
     * @param params 查询参数（page, size, keyword）
     * @return 分页结果
     */
    @GetMapping("/page")
    public IPage<User> page(@RequestParam Map<String, Object> params) {
        int page = params.get("page") != null ? Integer.parseInt(params.get("page").toString()) : 1;
        int size = params.get("size") != null ? Integer.parseInt(params.get("size").toString()) : 10;
        String keyword = (String) params.get("keyword");

        Page<User> pageParam = new Page<>(page, size);
        LambdaQueryWrapper<User> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(User::getDeleted, 0);
        if (keyword != null && !keyword.isEmpty()) {
            wrapper.and(w -> w.like(User::getPhone, keyword)
                    .or().like(User::getNickname, keyword));
        }
        wrapper.orderByDesc(User::getCreatedAt);
        return userMapper.selectPage(pageParam, wrapper);
    }

    /**
     * 禁用/启用用户
     *
     * @param params 请求参数（id, status）
     * @return 操作结果
     */
    @PostMapping("/disable")
    public Map<String, Object> disable(@RequestBody Map<String, Object> params) {
        Long id = Long.valueOf(params.get("id").toString());
        Integer status = Integer.valueOf(params.get("status").toString());

        User user = userMapper.selectById(id);
        if (user != null) {
            user.setStatus(status);
            user.setUpdatedAt(java.time.LocalDateTime.now());
            userMapper.updateById(user);
        }

        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("message", status == 0 ? "用户已禁用" : "用户已启用");
        return result;
    }

    /**
     * 调整用户余额
     *
     * @param params 请求参数（id, amount）
     * @return 操作结果
     */
    @PostMapping("/adjust-balance")
    public Map<String, Object> adjustBalance(@RequestBody Map<String, Object> params) {
        Long id = Long.valueOf(params.get("id").toString());
        BigDecimal amount = new BigDecimal(params.get("amount").toString());

        // 调用充值方法（正数为增加，负数为扣除）
        if (amount.compareTo(BigDecimal.ZERO) > 0) {
            userCenterService.recharge(id, amount);
        } else {
            User user = userMapper.selectById(id);
            if (user != null) {
                BigDecimal newBalance = user.getBalance() != null
                        ? user.getBalance().add(amount) : BigDecimal.ZERO;
                if (newBalance.compareTo(BigDecimal.ZERO) < 0) {
                    newBalance = BigDecimal.ZERO;
                }
                user.setBalance(newBalance);
                user.setUpdatedAt(java.time.LocalDateTime.now());
                userMapper.updateById(user);
            }
        }

        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("message", "余额调整成功");
        return result;
    }

    /**
     * 审核注销申请
     *
     * @param params 请求参数（id, approved）
     * @return 操作结果
     */
    @PostMapping("/logout-audit")
    public Map<String, Object> logoutAudit(@RequestBody Map<String, Object> params) {
        Long id = Long.valueOf(params.get("id").toString());
        boolean approved = Boolean.parseBoolean(params.get("approved").toString());

        if (approved) {
            User user = userMapper.selectById(id);
            if (user != null) {
                user.setDeleted(1);
                user.setUpdatedAt(java.time.LocalDateTime.now());
                userMapper.updateById(user);
            }
        }

        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("message", approved ? "注销申请已通过" : "注销申请已拒绝");
        return result;
    }
}