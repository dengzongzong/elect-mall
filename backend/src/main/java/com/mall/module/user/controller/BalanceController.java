package com.mall.module.user.controller;

import cn.dev33.satoken.annotation.SaCheckLogin;
import cn.dev33.satoken.stp.StpUtil;
import com.mall.module.user.service.UserCenterService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.Map;

/**
 * 用户余额控制器（需登录）
 */
@RestController
@RequestMapping("/api/balance")
@SaCheckLogin
public class BalanceController {

    @Autowired
    private UserCenterService userCenterService;

    /**
     * 获取用户余额
     *
     * @return 余额信息
     */
    @GetMapping
    public Map<String, Object> getBalance() {
        long userId = StpUtil.getLoginIdAsLong();
        BigDecimal balance = userCenterService.getBalance(userId);

        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("balance", balance);
        return result;
    }

    /**
     * 充值
     *
     * @param params 请求参数（amount）
     * @return 操作结果
     */
    @PostMapping("/recharge")
    public Map<String, Object> recharge(@RequestBody Map<String, Object> params) {
        long userId = StpUtil.getLoginIdAsLong();
        BigDecimal amount = new BigDecimal(params.get("amount").toString());
        userCenterService.recharge(userId, amount);

        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("message", "充值成功");
        return result;
    }
}