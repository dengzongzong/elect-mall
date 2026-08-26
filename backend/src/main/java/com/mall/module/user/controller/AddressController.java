package com.mall.module.user.controller;

import cn.dev33.satoken.annotation.SaCheckLogin;
import cn.dev33.satoken.stp.StpUtil;
import com.mall.module.user.entity.UserAddress;
import com.mall.module.user.service.UserCenterService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 用户地址控制器（需登录）
 */
@RestController
@RequestMapping("/api/address")
@SaCheckLogin
public class AddressController {

    @Autowired
    private UserCenterService userCenterService;

    /**
     * 获取用户地址列表
     *
     * @return 地址列表
     */
    @GetMapping("/list")
    public List<UserAddress> list() {
        long userId = StpUtil.getLoginIdAsLong();
        return userCenterService.listAddress(userId);
    }

    /**
     * 新增地址
     *
     * @param address 地址实体
     * @return 操作结果
     */
    @PostMapping("/save")
    public Map<String, Object> save(@RequestBody UserAddress address) {
        long userId = StpUtil.getLoginIdAsLong();
        address.setUserId(userId);
        userCenterService.saveAddress(address);

        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("message", "地址添加成功");
        return result;
    }

    /**
     * 更新地址
     *
     * @param address 地址实体
     * @return 操作结果
     */
    @PutMapping("/update")
    public Map<String, Object> update(@RequestBody UserAddress address) {
        long userId = StpUtil.getLoginIdAsLong();
        address.setUserId(userId);
        userCenterService.updateAddress(address);

        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("message", "地址更新成功");
        return result;
    }

    /**
     * 删除地址
     *
     * @param id 地址ID
     * @return 操作结果
     */
    @DeleteMapping("/{id}")
    public Map<String, Object> delete(@PathVariable Long id) {
        userCenterService.deleteAddress(id);

        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("message", "地址删除成功");
        return result;
    }
}